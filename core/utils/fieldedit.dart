import 'dart:convert';
import 'dart:io';

import '../kernel.dart';

void fieldedit() {
  if (tmpMode == true) return error('Temporary users cannot use Field Editor');
  print('[ Field Editor ]');
  print('Current system fields:');
  drive.forEach(
    (k, v) {
      if (k.startsWith('/') == false) {
        if (v is Map) {
          print('$k - ${jsonEncode(v)}');
        } else {
          print('$k - $v');
        }
      }
    },
  );
  while (true) {
    print(
      'Which field do you wish to edit? Type exit to save & exit. Type save to save changes.',
    );
    final input = stdin.readLineSync();
    if (input == null) return;
    if (input == 'exit') {
      if (drive['settings']['always_save_drive'] == true) saveDrive();
      return print('Hopefully you did not break anything!');
    }
    if (input == 'save') {
      saveDrive();
    }
    print('What value should it have? This can be any value!');
    final value = stdin.readLineSync();
    if (value == null) return;
    if (num.tryParse(value) != null) {
      drive[input] = num.parse(value);
    } else if (value == 'true' || value == 'false') {
      drive[input] = (input == 'true');
    } else if ((value.startsWith('{') && value.endsWith('}')) ||
        (value.startsWith('[') && value.endsWith(']'))) {
      try {
        drive[input] = jsonDecode(value);
      } catch (e) {
        drive[input] = value;
      }
    } else if (value == 'null') {
      drive.remove(input);
    } else {
      drive[input] = value;
    }
  }
}

void setfield(String field, String value) {
  if (num.tryParse(value) != null) {
    drive[field] = num.parse(value);
  } else if (value == 'true' || value == 'false') {
    drive[field] = (field == 'true');
  } else if ((value.startsWith('{') && value.endsWith('}')) ||
      (value.startsWith('[') && value.endsWith(']'))) {
    try {
      drive[field] = jsonDecode(value);
    } catch (e) {
      drive[field] = value;
    }
  } else if (value == 'null') {
    drive.remove(field);
  } else {
    drive[field] = value;
  }
  if (drive['settings']['always-save-drive'] == true) saveDrive();
}
