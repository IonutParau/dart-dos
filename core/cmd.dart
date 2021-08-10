import 'dart:io' show stdin;
import 'dart:io' as dio show exit;
import 'dart:math';
import 'kernel.dart' hide readFile;
import 'kernel.dart' as kernel show readFile;
import 'games/games.dart';
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
      write(
        '${colored(path, Color('12AFE3'))} ${colored('>', Color('14E07A'))} ',
      );
      final input = stdin.readLineSync();
      if (input == null) return error('^C');
      final splitInput = input.split(' ');
      final cmd = splitInput.first.toLowerCase();
      final args = splitInput.sublist(1);
      await terminal(cmd, args);
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

Future run(String path) async {
  final cmdsStr = kernel.readFile(path);
  final cmds = cmdsStr.split('\n');
  final waypoints = <String, int>{};
  final vars = <String, dynamic>{};
  final loops = <int, int>{};
  var latestLoop = <int>{};

  for (var i = 0; i < cmds.length; i++) {
    final cmd = cmds[i].split(' ').first;
    final args = cmds[i].split(' ').sublist(1);

    for (var i = 0; i < args.length; i++) {
      while (args[i].contains('%read%')) {
        args[i] = args[i].replaceFirst('%read%', stdin.readLineSync() ?? '');
      }
      while (args[i].contains('%input%')) {
        args[i] = args[i].replaceFirst('%input%', stdin.readLineSync() ?? '');
      }
      while (args[i].contains('%random%')) {
        args[i] =
            args[i].replaceFirst('%random%', Random().nextInt(10).toString());
      }
      args[i] = args[i]
          .replaceAll('%unsafe%', drive['settings']['unsafe'].toString());
      args[i] = args[i].replaceAll('%scriptname%', path.split('/').last);
      args[i] = args[i].replaceAll('%scriptpath%', path);
      args[i] = args[i].replaceAll('%name%', drive['name']);
    }
    vars.forEach((key, value) {
      for (var i = 0; i < args.length; i++) {
        args[i] = args[i].replaceAll('%nil%', '');
        args[i] = args[i].replaceAll('%null%', '');
        args[i] = args[i].replaceAll('%space%', ' ');
        args[i] = args[i].replaceAll('{$key}', value.toString());
      }
    });
    if (cmd == 'here') {
      waypoints[args[0]] = i;
    } else if (cmd == 'goto') {
      i = waypoints[args[0]] ?? 0;
    } else if (cmd == 'if') {
      final v1 = args[0];
      final comparison = args[1];
      final v2 = args[2];
      var correct = false;
      switch (comparison) {
        case 'is':
          correct = (v1 == v2);
          break;
        case 'not':
          correct = (v1 != v2);
          break;
        case 'greater':
          correct = (num.parse(v1) > num.parse(v2));
          break;
        case 'less':
          correct = (num.parse(v1) < num.parse(v2));
          break;
        case 'has':
          correct = (v1.contains(v2));
          break;
        default:
          error('Incorrect syntax');
          break;
      }
      var depth = 1;
      if (correct == false) {
        while (depth > 0) {
          i++;
          if (cmds[i].split(' ')[0] == 'if') depth++;
          if (cmds[i].split(' ')[0] == 'endif') depth--;
        }
      }
    } else if (cmd == 'endif') {
    } else if (cmd == 'loop') {
      latestLoop.add(i);
      loops[i] = int.parse(args.first);
      if (loops[i] == 0) {
        var depth = 1;
        while (depth > 0) {
          i++;
          if (cmds[i] == '') continue;
          if (cmds[i].split(' ')[0] == 'loop') depth++;
          if (cmds[i].split(' ')[0] == 'endloop') depth--;
        }
      }
    } else if (cmd == 'endloop') {
      if ((loops[latestLoop.last] ?? 0) > 1) {
        i = latestLoop.last;
        loops[i] = (loops[i] ?? 0) - 1;
      } else {
        latestLoop.remove(latestLoop.last);
      }
    } else if (cmd == 'var') {
      final name = args[0];
      final action = args[1];
      if (action == 'set') {
        dynamic value = args[2];
        if (num.tryParse(args[2]) != null) value = num.tryParse(args[2]);
        if (args[2] == 'true' || args[2] == 'false') {
          value = (args[2] == 'true');
        }
        vars[name] = value;
      }
      if (action == 'add') {
        dynamic value = args[2];
        if (num.tryParse(args[2]) != null) value = num.tryParse(args[2]);
        if (args[2] == 'true' || args[2] == 'false') {
          value = (args[2] == 'true');
        }
        if (value is num) vars[name] += value;
        if (value is String) vars[name] += value;
        if (value is bool) vars[name] += value;
      }
      if (action == 'sub') {
        dynamic value = args[2];
        if (num.tryParse(args[2]) != null) value = num.tryParse(args[2]);
        if (args[2] == 'true' || args[2] == 'false') {
          value = (args[2] == 'true');
        }
        if (value is num) vars[name] -= value;
        if (value is String) vars[name] -= value;
        if (value is bool) vars[name] -= value;
      }
      if (action == 'readfile') {
        var dirPath = args[2];
        if (!dirPath.startsWith('/')) {
          dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
        }
        final file = drive[dirPath];
        if (file['type'] != 'file') return error('$dirPath is not file');
        if (file['content'] == null) {
          return error('File does not have any content what-so-ever');
        }
        vars[name] = file['content'];
      }
    } else if (cmd == 'stop') {
      return;
    } else if (cmd == 'onboot') {
      if (drive['settings']['unsafe'] == true) {
        await terminal(cmd, args);
      } else {
        return print('Script attempted to perform forbitten activity.');
      }
    } else if (cmd == 'backup' || cmd == 'restore') {
      if (drive['settings']['unsafe'] == true) {
        await terminal(cmd, args);
      } else {
        return print('Script attempted to perform forbitten activity.');
      }
    } else {
      await terminal(cmd, args);
    }
  }
}

Future terminal(String cmd, List<String> args) async {
  fileSyncInit();
  if (cmd == 'hello') return hello();
  if (cmd == 'exit' ||
      cmd == 'shutdown' ||
      cmd == 'sd' ||
      cmd == 'shut' ||
      cmd == 'stop') return exit();
  if (cmd == 'help') return help();
  if (cmd == 'echo') return echo(args.join(' '));
  if (cmd == 'write') return write(args.join(' '));
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
  if (cmd == 'run') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      return run(dirPath);
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
      if (args.length == 1) {
        return editfile(dirPath);
      } else {
        return editfile(dirPath, args.sublist(1).join(' '));
      }
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
  if (cmd == 'bananafix' ||
      cmd == 'bananasync' ||
      cmd == 'bananadrives' ||
      cmd == 'bananafixy') {
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
    return apps();
  }
  if (cmd == 'drivey' || cmd == 'drivy') {
    return print('What did you say? Its Disky, not $cmd');
  }
  if (cmd == 'onboot') {
    if (args.isNotEmpty) {
      if (args[0] == 'show') {
        drive['onboot_scripts'].forEach(print);
        return;
      } else if (args[0] == 'add') {
        var dirPath = args[1];
        if (!dirPath.startsWith('/')) {
          dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
        }
        drive['onboot_scripts'].add(dirPath);
        saveDrive();
        return;
      } else if (args[0] == 'remove') {
        var dirPath = args[1];
        if (!dirPath.startsWith('/')) {
          dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
        }
        drive['onboot_scripts'].remove(dirPath);
        saveDrive();
        return;
      }
    } else {
      return error('Not enough arguments');
    }
  }
  if (cmd == 'filesync') {
    if (args.isNotEmpty) {
      return filesync(args[0], args.sublist(1));
    }
    return error('Not enough arguments');
  }
  if (cmd == 'http') {
    if (args.length > 1) {
      if (args.length == 2) return httpcmd(args[0], args[1]);
      if (args.length > 2) {
        return httpcmd(args[0], args[1], args.sublist(2).join(' '));
      }
    }
    return error('Not enough arguments');
  }
  if (cmd == 'tictactoe') {
    tictactoe();
  }
  error('Invalid command.');
}
