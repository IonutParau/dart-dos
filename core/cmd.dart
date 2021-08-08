import 'dart:io' show stdin;
import 'dart:io' as dio show exit;
import 'kernel.dart' hide readFile;
import 'cmds/cmds.dart';
import 'utils/utils.dart';

var path = '/';

void bootCommander() async {
  hello();
  if (drive['settings']['autosave'] == true) {
    backup('backup.json', silent: true);
  }
  try {
    while (true) {
      await terminal();
    }
  } catch (e) {
    showCrashScreen(
      'Terminal Execution Failure',
      'DartDOS Command Processor / Terminal',
    );
    print(e.toString());
    dio.exit(0);
  }
}

Future terminal() async {
  fileSyncInit();
  write(
    '${colored(path, Color('12AFE3'))} ${colored('>', Color('14E07A'))} ',
  );
  final input = stdin.readLineSync();
  if (input == null) return error('^C');
  final splitInput = input.split(' ');
  final cmd = splitInput.first.toLowerCase();
  final args = splitInput.sublist(1);
  if (cmd == 'hello') return hello();
  if (cmd == 'exit' ||
      cmd == 'shutdown' ||
      cmd == 'sd' ||
      cmd == 'shut' ||
      cmd == 'stop') return exit();
  if (cmd == 'help') return help();
  if (cmd == 'echo') return echo(args.join(' '));
  if (cmd == 'cls' || cmd == 'clear') return clear();
  if (cmd == 'backup') {
    if (args.isNotEmpty) return backup(args[0]);
    return error('Not enough arguments.');
  }
  if (cmd == 'restore') {
    if (args.isNotEmpty) return restore(args[0]);
    return error('Not enough arguments.');
  }
  if (cmd == 'cd') {
    if (args.isNotEmpty) return cd(args[0]);
    return error('Not enough arguments.');
  }
  if (cmd == 'changepass') {
    if (args.isNotEmpty) return changepass(args[0]);
    return changepass('');
  }
  if (cmd == 'mkdir') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return mkdir(dirPath);
    }
    return error('Not enough arguments.');
  }
  if (cmd == 'deldir') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return deldir(dirPath);
    }
    return error('Not enough arguments.');
  }
  if (cmd == 'mkfile') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return mkfile(dirPath);
    }
    return error('Not enough arguments.');
  }
  if (cmd == 'delfile') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return delfile(dirPath);
    }
    return error('Not enough arguments.');
  }
  if (cmd == 'editfile' || cmd == 'edit') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return editfile(dirPath);
    }
    return error('Not enough arguments.');
  }
  if (cmd == 'crash') {
    showCrashScreen('Self-Initiated Crash', 'Command Manager / Commander');
    dio.exit(0);
  }
  if (cmd == 'disky') {
    return disky();
  }
  if (cmd == 'dir') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return dir(dirPath);
    }
    return dir(path);
  }
  if (cmd == 'read' || cmd == 'readfile') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return readFile(dirPath);
    }
    return error('Not enough arguments');
  }
  if (cmd == 'changename' || cmd == 'rename') {
    if (args.isNotEmpty) {
      var newname = args.join(' ');
      return changeName(newname);
    }
    return error('Not enough arguments.');
  }
  if (cmd == 'tree') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return tree(dirPath);
    }
    return tree(path);
  }
  if (cmd == 'image' || cmd == 'render') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return image(dirPath);
    }
    return error('Not enough arguments');
  }
  if (cmd == 'settings') {
    return settings();
  }
  if (cmd == 'paint' || cmd == 'painter') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return paint(dirPath);
    }
    return error('Not enough arguments');
  }
  if (cmd == 'download') {
    if (args.length > 1) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return download(dirPath, args[1]);
    }
    return error('Not enough arguments.');
  }
  if (cmd == 'paper') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return paper(dirPath);
    }
    return error('Not enough arguments.');
  }
  if (cmd == 'bananafix' || cmd == 'bananasync' || cmd == 'bananadrives') {
    return print(
      'Do you think this is LuaDOS? No, this is not LuaDOS. We have Disky for that. Just use Disky.',
    );
  }
  if (cmd == 'luados') {
    return print(
      'LuaDOS is just like DartDOS exept made by someone else and written entirely in Lua. It also copies most of the ideas discussed by the creator of DartDOS.',
    );
  }
  if (cmd == 'apps') {
    apps();
  }
  error('Invalid command.');
}
