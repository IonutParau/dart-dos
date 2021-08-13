import 'dart:io' show stdin;
import '../cmd.dart' show path;
import '../kernel.dart' show drive, error, tmpMode;

void filesync(String action, List<String> args) {
  if (tmpMode == true) {
    return print(
      'Temporary users cannot manage FileSync links',
    );
  }
  if (drive['unsafe'] != true && action != 'show') {
    print('Confirm FileSync action? [y/n]');
    final input = stdin.readLineSync();
    if (input != 'y') return;
  }
  switch (action) {
    case 'add':
      if (args.length > 1) {
        var dirPath = args[0];
        if (!dirPath.startsWith('/')) {
          dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
        }
        drive['filesync'][dirPath] = args[1];
      } else {
        return error('Not enough arguments');
      }
      break;
    case 'remove':
      if (args.isNotEmpty) {
        var dirPath = args[0];
        if (!dirPath.startsWith('/')) {
          dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
        }
        drive['filesync'].remove(dirPath);
      } else {
        return error('Not enough arguments');
      }
      break;
    case 'show':
      if (drive['filesync'].isEmpty) return print('No FileSync Links found!');
      print('Host OS File - DartDOS File');
      drive['filesync'].forEach(
        (k, v) {
          print('$v - $k');
        },
      );
      break;
    default:
      return error('Unknown action to perform');
  }
}
