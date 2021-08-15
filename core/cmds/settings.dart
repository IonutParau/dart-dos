import 'dart:io' show stdin;
import '../kernel.dart' show drive, saveDrive, error;

void settings() {
  print('Which settings do you want to edit?');

  drive['settings'].forEach(
    (k, v) {
      print('$k - $v');
    },
  );
  final input = stdin.readLineSync();

  if (drive['settings'].containsKey(input) == false) {
    return error('Invalid setting');
  }
  print('Please import new value');
  final setting = stdin.readLineSync();
  if (setting == null) return;
  if (drive['settings'][input] is bool) {
    drive['settings'][input] = (setting == 'true');
  } else if (drive['settings'][input] is num) {
    final n = num.tryParse(setting);
    if (n == null) return error('Invalid number');
    drive['settings'][input] = n;
  } else if (drive['settings'][input] is String) {
    drive['settings'][input] = setting;
  }

  if (drive['settings']['always-save-drive'] == true) saveDrive();
}
