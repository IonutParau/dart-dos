import 'dart:io' show File, Platform;
import 'dart:convert' show jsonDecode;
import '../kernel.dart' show drive, error, saveDrive, tmpMode, userID, users;

void restore(String fileName) {
  if (tmpMode == true) {
    return error('Temporary users cannot restore from backups');
  }
  if (fileName ==
          Platform.script
              .toFilePath(windows: Platform.isWindows)
              .split(Platform.isWindows ? r'\' : '/')
              .last &&
      drive['settings']['unsafe'] == true) {
    return error("Can't restore from critical system files.");
  }

  final backup = File(fileName);

  if (backup.existsSync()) {
    print('Backup drive found.');
    print('Decoding backup....');
    var tmpDrive;
    try {
      tmpDrive = jsonDecode(backup.readAsStringSync());
    } catch (e) {
      return error('Drive is not valid JSON or is not decodable.');
    }
    final id = userID;
    if (id >= users.length) {
      return print(
        'This drive does not have a user with the same ID as this user.',
      );
    } else if (tmpDrive.length == 0) {
      print('This drive does not have any users');
    }
    drive = tmpDrive[id];
    saveDrive();
    print('Restored the backup!');
  } else {
    error('Backup not found!');
  }
  saveDrive();
}
