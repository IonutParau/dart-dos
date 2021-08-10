import 'dart:io';
import '../kernel.dart' show drive, encodedDrive, error;

void backup(String fileName, {bool silent = false}) {
  if (fileName ==
          Platform.script
              .toFilePath(windows: Platform.isWindows)
              .split(Platform.isWindows ? r'\' : '/')
              .last &&
      drive['settings']['unsafe'] == false) {
    return error("Can't override critical system files.");
  }
  var backup = File(fileName);
  if (!backup.existsSync()) backup.createSync();
  backup.writeAsStringSync(encodedDrive);
  if (!silent) print('Backup done!');
}
