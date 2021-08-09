//import 'package:path/path.dart';

import 'dart:convert' show JsonEncoder, jsonDecode;
import 'dart:io' show File, Platform, ProcessSignal, sleep, stdin, stdout;
import 'package:ansicolor/ansicolor.dart' show AnsiPen;
import 'package:dart_console/dart_console.dart' show Console;
import 'cmd.dart' show run;
import 'utils/disky.dart' show healthCheck, realTimeLDOSDriveTranslation;

final _errorPen = AnsiPen()..red();
final _succesPen = AnsiPen()..green();

final buildString = 'DartDOS v1.0 Beta Build 6';

String get encodedDrive => JsonEncoder.withIndent('  ').convert(drive);

void showCrashScreen(String errorMessage, String errorSource) {
  print('[ Crash Screen Beta ]');
  error('A critical error has occured!');
  print(
      'Your system has detected a critical error somewhere. Depending on the source of the problem, the system might be attempting to fix it.');
  print('Error Message - $errorMessage | Error Source - $errorSource');
  write('Press enter to continue');
  stdin.readLineSync();
}

Map<String, dynamic> get blankDrive => {
      'settings': {
        'autosave': true,
        'diskcheck_on_boot': true,
        'unsafe': true,
        'tabspacing': 2,
      },
      'filesync': {},
      'onboot_scripts': <String>[],
      'name': 'DartDOS User',
      'password': '',
    };

void fixDrive() {
  final goodDrive = blankDrive;
  goodDrive.forEach(
    (key, value) {
      if (drive[key] == null) drive[key] = value;
    },
  );
}

void saveDrive() {
  var file = File('drive.json');
  file.writeAsStringSync(encodedDrive);
}

void error(String msg) {
  print(_errorPen(msg));
}

void succes(String msg) {
  print(_succesPen(msg));
}

class Color {
  double r = 0;
  double g = 0;
  double b = 0;
  String hex;

  Color(this.hex) {
    r = int.parse(hex.substring(0, 2), radix: 16) / 255;
    g = int.parse(hex.substring(2, 4), radix: 16) / 255;
    b = int.parse(hex.substring(4, 6), radix: 16) / 255;
  }
}

String colored(String msg, Color color) {
  var pen = AnsiPen()..rgb(r: color.r, g: color.g, b: color.b);
  return pen(msg);
}

void write(String msg) {
  stdout.write(msg);
}

void clear() {
  Console().clearScreen();
}

void loadDrive(String fileName) {
  final driveFile = File(fileName);
  try {
    final data = driveFile.readAsStringSync();
    drive = jsonDecode(data);
    fixDrive();
    saveDrive();
  } catch (e) {
    if (fileName == 'drive.json') return loadDrive('backup.json');

    error(
      'Drive is not valid JSON! Please specify backup drive to load from. You can press enter directly to load a blank drive.',
    );
    error(
      'Your auto-backup is also not valid JSON',
    );
    write('Name of backup drive > ');
    var input = stdin.readLineSync() ?? '';
    if (input.split('.').length == 1) input += '.json';
    if (input == '.json') {
      drive = blankDrive;
      saveDrive();
    } else {
      loadDrive(input);
    }
    saveDrive();
  }
}

late Map<String, dynamic> drive;

Future onboot_scripts() async {
  for (final str in drive['onboot_scripts']) {
    await run(str);
  }
}

Future bootKernel() async {
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    return error(
      'You are using an unsupported parent operating system. Please use either Windows, Linux or MacOS to boot this DOS VM.',
    );
  }
  if (stdout.hasTerminal == false) {
    return error(
      "Couldn't find a terminal.... you know you need a terminal to use DOS right?",
    );
  }
  final driveFile = File('drive.json');
  if (driveFile.existsSync()) {
    loadDrive('drive.json');
  } else {
    print("Couldn't find virtual drive.");
    print('Creating virtual drive...');
    driveFile.createSync();
    drive = blankDrive;
    saveDrive();
  }
  if (drive['filesync'] is List) {
    drive['filesync'] = <String, dynamic>{};
  }
  realTimeLDOSDriveTranslation(); // To make L.U.A. useless
  await onboot_scripts();
  if (drive['settings']['diskcheck_on_boot'] == true) healthCheck(silent: true);
  succes('Booted up Kernel');
  checkPassword();
  ProcessSignal.sigint.watch().listen((event) {});
}

bool guestMode = false;

void checkPassword() {
  if (drive['password'] == '') {
    return;
  } else {
    print('Password protection detected. Please input password');
    while (true) {
      final input = stdin.readLineSync() ?? '';
      if (input == drive['password']) break;
      if (input == 'ldos') {
        print('Blendi... is this you making some kind of joke?');
      } else if (input == 'ddos') {
        print('Oh nooooo u guna ddos mi nooooo');
      } else if (input == 'dartdos') {
        print('Admin-tier password detected...');
        sleep(const Duration(milliseconds: 1000));
        print('Signing you in...');
        sleep(const Duration(milliseconds: 1000));
        print('Activating admin-restricted commands....');
        sleep(const Duration(milliseconds: 1000));
        print('Signing you in...');
        sleep(const Duration(milliseconds: 1000));
        print(
          'Wait.... you thought you just found the cheat-code for signing in as admin? We do not even have admin-only features!',
        );
      }
      error('Incorrect password.');
    }
    print('Password is correct.');
  }
}

void fileSyncInit() {
  final filesync = drive['filesync'];
  filesync.forEach(
    (k, v) {
      if (k.contains('/') == false) return;
      if (k.split('/').last.split('.').length <= 1) return;
      if (v.endsWith(Platform.script
          .toFilePath(windows: Platform.isWindows)
          .split(Platform.isWindows ? r'\' : '/')
          .last)) {
        return error(
          'FileSync attempted to sync with a critical system file and was blocked.',
        );
      }
      final f = File(v);
      if (f.existsSync() == false) return;
      if (drive[k] == null) drive[k] = {'type': 'file', 'content': ''};
      drive[k]['content'] = f.readAsStringSync();
    },
  );
  saveDrive();
}

void writeToFile(String path, Map<String, dynamic> newFile) {
  if (drive[path] == null) {
    return error('An error has occured while writing to the file.');
  }
  drive[path] = newFile;
  if (drive['filesync'][path] != null) {
    final f = File(drive['filesync'][path]);
    if (f.existsSync()) {
      f.writeAsStringSync(newFile['content']);
    }
  }
  return saveDrive();
}

final unsupportedFileNames = <String>{
  '',
  '/',
  '..',
};

void createFile(String path, Map<String, dynamic> file) {
  if (unsupportedFileNames.contains(path.split('/').last)) {
    return error('Unsupported file name');
  }
  if (path.split('/').last.split('.').length <= 1) {
    return error('Files must have file extensions');
  }
  if (drive[path] == null) {
    drive[path] = file;
    drive[path]['type'] = 'file';
    return saveDrive();
  }
  return error('Error: File already exists');
}

void deleteFile(String path) {
  if (path.split('/').last.split('.').length <= 1) {
    return error('File path is invalid. File names need file extensions');
  }
  if (drive[path] == null) return error('File does not exist');
  if (drive[path]['type'] == 'file') {
    drive.remove(path);
    saveDrive();
  } else {
    return error('Path is not file');
  }
}

String readFile(String path) {
  if (path.split('/').last.split('.').length <= 1) {
    error(
      'File path is invalid. File names need file extensions',
    );
    return '';
  }
  if (drive[path] == null) {
    error('File does not exist');
    return '';
  }
  if (drive[path]['type'] != 'file') {
    error('You did not specify a file.');
    return '';
  }
  return drive[path]['content'] as String;
}

void createFolder(String path) {
  if (unsupportedFileNames.contains(path.split('/').last)) {
    return error('Illegal Folder name');
  }
  if (drive[path] == null) {
    drive[path] = {'type': 'folder'};
    saveDrive();
  } else {
    return error('Folder already exists');
  }
}

void deleteFolder(String path) {
  if (drive[path] == null) return error('Folder does not exist');
  if (drive[path]['type'] != 'folder') return error('$path is not a folder.');
  drive.remove(path);
  print('Deleting $path');
  drive.removeWhere(
    (key, value) {
      var deleted = key.startsWith(path);
      if (deleted) print('Deleting $key.');
      return deleted;
    },
  );
  saveDrive();
}
