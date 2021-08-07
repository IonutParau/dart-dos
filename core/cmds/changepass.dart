import 'dart:io';

import '../kernel.dart';

void changepass(String pass) {
  print(
    drive['password'] == ''
        ? 'Confirm adding password protection? Press y and then enter if you agree.'
        : (pass == ''
            ? 'Confirm removing password protection? Press y and then enter if you agree.'
            : 'Confirm changing password to $pass? Press y and then enter if you agree.'),
  );
  final answer = stdin.readLineSync();
  if (answer == 'y') drive['password'] = pass;
  saveDrive();
}
