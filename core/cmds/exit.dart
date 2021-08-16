import 'dart:io' as dio show exit, stdin;
import '../kernel.dart' show drive, saveDrive, succes, tmpMode, write;
import 'backup.dart';

void exit() {
  void leave() {
    if (drive['settings']['autosave'] == true && tmpMode == false) {
      backup('backup.json', silent: true);
    }
    saveDrive();
    succes('Goodbye!');
    dio.exit(0);
  }

  if (drive['settings']['unsafe'] == true) leave();
  write(
    'Are you sure you want to leave? Type y and then press enter to confirm exit!\n> ',
  );
  final response = dio.stdin.readLineSync() ?? '';
  if (response.startsWith('y')) {
    leave();
  } else {
    print('Ok!');
  }
}
