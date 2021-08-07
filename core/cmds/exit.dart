import 'dart:io' as dio show exit, stdin;
import '../kernel.dart' show write, succes;
import 'backup.dart';

void exit() {
  write(
    'Are you sure you want to leave? Type y and then press enter to confirm exit!\n> ',
  );
  final response = dio.stdin.readLineSync() ?? '';
  if (response.startsWith('y')) {
    backup('backup.json', silent: true);
    succes('Goodbye!');
    dio.exit(0);
  } else {
    print('Ok!');
  }
}
