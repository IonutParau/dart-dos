import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show File, Platform, stdin;
import '../cmd.dart';
import '../kernel.dart'
    show blankDrive, createFile, drive, error, saveDrive, write;

void disky() {
  print('[ Disky Integrated Disk Utility ]');
  print(
      'Which tool do you want to use? Select by typing the number next to the tool and hitting enter.');
  print('< Tools >');
  print('> Disk Health-Check Utility [1]');
  print('> Disk Healing Utility [2]');
  print(
    '> Disky Artificial Retro-Translator [3]',
  );
  print(
    '> Disky Drive Merging Utility [4]',
  );
  print('> Setup FileSync [5]');

  final input = stdin.readLineSync();

  if (input == '1') {
    healthCheck();
  } else if (input == '2') {
    heal();
  } else if (input == '3') {
    translator();
  } else if (input == '4') {
    overrideDrive();
  } else if (input == '5') {
    setupFileSync();
  }
}

void healthCheck({bool silent = false}) {
  if (!silent) print('Scanning...');
  var scanned = 0;
  var problems = 0;
  drive.forEach((key, value) {
    if (!silent) print('Checking $key');
    scanned++;
    if (key == 'password') {
      if (!(value is String)) {
        if (!silent) print('Password is invalid!');
        problems++;
      }
    } else if (key == 'name') {
      if (!(value is String)) {
        if (!silent) print('Name is invalid!');
        problems++;
      }
    } else if (key == 'settings') {
      if (!(value is Map)) {
        if (!silent) print('Settings is invalid!');
        problems++;
      }
    } else if (key == 'filesync') {
      if (!(value is Map)) {
        if (!silent) print('FileSync is invalid!');
        problems++;
      } else {
        drive['filesync'].forEach((_, v) {
          if (v ==
              Platform.script
                  .toFilePath(windows: Platform.isWindows)
                  .split(Platform.isWindows ? r'\' : '/')
                  .last) {
            print(
              'FileSync links lead to system files, making them useless.',
            );
            problems++;
          }
        });
      }
    } else if (key == 'onboot_scripts') {
      if (!(value is List)) {
        drive[key] = <String>[];
      }
      final listOfRemovals = [];
      drive[key].forEach(
        (v) {
          if (drive[v] == null) {
            print('$v is a onboot script that does not exist.');
            listOfRemovals.add(v);
          }
        },
      );
      listOfRemovals.forEach(
        (element) {
          drive[key].remove(element);
        },
      );
    } else {
      if (value is Map) {
        if (value['type'] != 'file' && value['type'] != 'folder') {
          if (!silent) print('$key has a unsupported type.');
          problems++;
        } else if (key.split('/').last.split('.').length > 1) {
          if (!silent) print('Assuming $key is a file...');
          if (value['type'] != 'file') {
            print("$key is a file but isn't listed as one!");
            problems++;
          }
          if (value['content'] == null) {
            if (!silent) print('$key is a file with no content!');
            problems++;
          }
        } else if (key.split('/').last.split('.').length <= 1) {
          if (!silent) print('Assuming $key is a folder...');
          value.forEach(
            (k, v) {
              if (k != 'type') {
                if (!silent) {
                  print(
                    '$key is a folder with more properties than it should.',
                  );
                }
                problems++;
              }
            },
          );
        }
      } else {
        if (!silent) print('$key is not even a valid type!');
        problems++;
      }
    }
  });
  if (problems == 0) {
    if (!silent) {
      print(
        "No problems found! As far as I'm aware this disk is perfectly healthy!",
      );
    }
  } else {
    if (!silent) {
      print(
        'Oh no.... found $problems problems out of $scanned scans. (${problems / scanned * 100}%)',
      );
    }
    if (silent) {
      print(
        'Disk problems found! This might make the FileSystem unstable or some files unusable. Run disky and its Disk Healing Utility to attempt a filesystem repair (files getting their content back is not guaranteed)',
      );
    }
  }
}

void heal() {
  var healed = 0;
  drive.forEach((key, value) {
    if (key == 'settings') {
      // Settings healing utility
      if (!(value is Map)) {
        drive[key] = blankDrive['settings'];
        healed++;
      }
    } else if (key == 'password') {
      // Password healing utility
      if (!(value is String)) {
        drive[key] = blankDrive['password'];
        healed++;
      }
    } else if (key == 'name') {
      // Password healing utility
      if (!(value is String)) {
        drive[key] = blankDrive['name'];
        healed++;
      }
    } else if (key == 'filesync') {
      if (!(value is Map)) {
        drive[key] = blankDrive['filesync'];
        healed++;
      }
      drive['filesync'].forEach(
        (k, v) {
          if (v ==
              Platform.script
                  .toFilePath(windows: Platform.isWindows)
                  .split(Platform.isWindows ? r'\' : '/')
                  .last) {
            print(
                'FileSync Link $k-$v is syncing with a system file. Removing it...');
            drive['filesync'].remove(k);
          }
        },
      );
    } else {
      if (value is Map) {
        if (key.split('/').last.split('.').length > 1) {
          // File healing
          print('Assuming $key is a file as it has a file extension');
          if (value['type'] != 'file') {
            drive[key]['type'] = 'file';
            print(
                '$key should be a file but is not listed as one, listing it as file...');
            healed++;
          }
          if (value['content'] == null) {
            drive[key]['content'] = '';
            print('$key is a file with no content. Giving it empty content...');
            healed++;
          }
        } else {
          // Folder healing
          print('Assuming $key is a folder as it has no file extension');
          if (value['type'] != 'folder') {
            drive[key]['type'] = 'folder';
            print(
              '$key should be a folder but is not listed as one, listing it as folder...',
            );
            healed++;
          }
          var excessiveData = <String>[];
          value.forEach((k, v) {
            if (k != 'type') excessiveData.add(k);
          });
          for (var data in excessiveData) {
            print('Removing $data property of $key, it was excessive data');
            drive[key].remove(data);
            healed++;
          }
        }
      } else {
        if (key.split('/').last.split('.').length > 1) {
          print('$key was not a valid type, converting it to an empty file...');
          drive[key] = {
            'type': 'file',
            'content': '',
          };
          healed++;
        } else {
          print(
            '$key was not a valid type, converting it to an empty folder...',
          );
          drive[key] = {
            'type': 'folder',
            'content': '',
          };
          healed++;
        }
      }
    }
  });
  print('Saving changes...');
  saveDrive();
  if (healed == 0) {
    print('The disk seems to be healthy!');
  } else {
    print(
      'Healed $healed problems with the disk! Please do not break the disk ever again!',
    );
  }
}

void translator() {
  write('Output file name > ');
  var outputDisk = stdin.readLineSync();
  if (outputDisk == null) return;
  if (outputDisk.contains('.') == false) outputDisk += '.json';
  print('Translating disk...');
  var disk = <String, dynamic>{};
  disk['working'] = 'banana';
  disk['password'] = drive['password'];
  disk['settings'] = drive['settings'];
  disk['filesync'] = drive['filesync'];
  disk['files'] = <String, Map>{};

  drive.forEach(
    (key, value) {
      if (key.startsWith('/')) {
        disk['files'][key] = value;
      }
    },
  );

  var outputFile = File(outputDisk);

  outputFile.writeAsStringSync(jsonEncode(disk));
}

void overrideDrive() {
  write('Drive to merge >');
  final mergedDriveName = stdin.readLineSync();
  if (mergedDriveName == null) return;
  final file = File(mergedDriveName);
  if (!(file.existsSync())) return error('Drive not found');
  late Map<String, dynamic> mergedDrive;
  try {
    mergedDrive = jsonDecode(file.readAsStringSync());
  } catch (e) {
    error('Drive is not valid JSON!');
    return overrideDrive();
  }
  print('Override all merged files? [y/n]');
  final overrideAll = (stdin.readLineSync() == 'y');
  mergedDrive.forEach(
    (key, value) {
      if (key.startsWith('/')) {
        if (overrideAll || drive[key] == null) {
          drive[key] = value;
        } else if (drive[key] != null) {
          print('Override $key? [y/n]');
          if (stdin.readLineSync() == 'y') {
            drive[key] = value;
          }
        }
      }
    },
  );
  print('Merging complete! Saving changes...');
  saveDrive();
}

void setupFileSync() {
  print('Welcome to Disky FileSync!');
  print('It can sync files from the Host OS to the FileSystem!');
  print('Actions: ');
  print('Create FileSync Link [1]');
  print('Remove FileSync Link [2]');
  print('Show all FileSync Links [3]');
  final answer = stdin.readLineSync();

  String fixPath(String thispath) {
    var dirPath = thispath;
    if (!dirPath.startsWith('/')) {
      dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
    }
    return dirPath;
  }

  if (answer == '1') {
    write('Please input name of file in Host OS to sync ');
    var hostFile = stdin.readLineSync();
    if (hostFile == null) return;
    write('Please input name of file in DartDOS to sync ');
    var localFile = stdin.readLineSync();
    if (localFile == null) return;
    if (hostFile.endsWith(Platform.script
        .toFilePath(windows: Platform.isWindows)
        .split(Platform.isWindows ? r'\' : '/')
        .last)) {
      return error(
        "Can't create FileSync link wtih critical system files.",
      );
    }
    //hostFile = fixPath(hostFile);
    localFile = fixPath(localFile);

    if (drive['filesync'] == null) {
      drive['filesync'] = <String, dynamic>{};
    }
    drive['filesync'][localFile] = hostFile;
    if (drive[localFile] == null) {
      createFile(
        localFile,
        {
          'type': 'file',
          'content': '',
        },
      );
    }
    saveDrive();
  } else if (answer == '2') {
    write('Please input name of DartDOS file to no longer sync ');
    var localFile = stdin.readLineSync();
    if (localFile == null) return;
    if (drive['filesync'] == null) {
      drive['filesync'] = <String, dynamic>{};
    }
    localFile = fixPath(localFile);
    drive['filesync'].remove(localFile);
    saveDrive();
  } else if (answer == '3') {
    if (drive['filesync'].isEmpty) return print('No FileSync Links found!');
    print('Host OS File - DartDOS File');
    drive['filesync'].forEach((k, v) {
      print('$v - $k');
    });
  }
}

void realTimeLDOSDriveTranslation() {
  if (drive['files'] is Map) {
    drive['files'].forEach((k, v) {
      var fPath = k;
      if (fPath.endsWith('/')) fPath = (fPath.split('')..removeLast()).join();
      drive[fPath] = v;
    });
    drive.remove('files');
  }
}
