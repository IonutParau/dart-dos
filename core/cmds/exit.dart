import 'dart:io' as dio show exit, stdin;
import '../kernel.dart' show drive, succes, write;
import 'backup.dart';

void exit() {
  void leave() {
    if (drive['settings']['autosave'] == true) {
      backup('backup.json', silent: true);
    }
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
