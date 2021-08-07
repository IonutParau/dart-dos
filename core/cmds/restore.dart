import 'dart:io' show File, Platform;
import 'dart:convert' show jsonDecode;
import '../kernel.dart' show drive, saveDrive, error;

void restore(String fileName) {
  if (fileName ==
      Platform.script
          .toFilePath(windows: Platform.isWindows)
          .split(Platform.isWindows ? r'\' : '/')
          .last) {
    return error("Can't restore from critical system files.");
  }

  final backup = File(fileName);

  if (backup.existsSync()) {
    print('Backup drive found.');
    print('Decoding backup....');
    var tmpDrive = <String, dynamic>{};
    try {
      tmpDrive = jsonDecode(backup.readAsStringSync());
    } catch (e) {
      return error('Drive is not valid JSON or is not decodable.');
    }
    drive = tmpDrive;
    saveDrive();
    print('Restored the backup!');
  } else {
    error('Backup not found!');
  }
}
