import 'dart:io' show stdin;
import 'dart:io' as dio show exit;
import 'dart:math';
import 'kernel.dart' hide readFile;
import 'kernel.dart' as kernel show readFile;
import 'games/games.dart';
import 'cmds/cmds.dart';
import 'utils/utils.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:http/http.dart' as http show get, post, delete;

var path = '/';

void bootCommander() async {
  hello();
  if (drive['settings']['autosave'] == true && tmpMode == false) {
    backup('backup.json', silent: true);
  }
  try {
    while (true) {
      write(
        '${colored(path, Color('12AFE3'))} ${colored('>', Color('14E07A'))} ',
      );
      final input = stdin.readLineSync();
      if (input == null) {
        error('^C');
        continue;
      }
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

Future run(String _path) async {
  final cmdsStr = kernel.readFile(_path);
  final cmdsStrSplit = cmdsStr.split('\n');
  final cmds = <String>[];
  for (var str in cmdsStrSplit) {
    cmds.addAll(str.split(';'));
  }
  for (var i = 0; i < cmds.length; i++) {
    if (cmds[i].startsWith(' ')) {
      cmds[i] = (cmds[i].split('')..removeAt(0)).join();
    }
    if (cmds[i].startsWith('\t')) {
      cmds[i].replaceFirst('\t', '');
    }
  }
  final permissions = <String, bool>{
    'network': false,
  };
  final vars = <String, dynamic>{};
  final loops = <int, int>{};
  var latestLoop = <int>{};
  for (var i = 0; i < cmds.length; i++) {
    final cmd = cmds[i].split(' ').first;
    final args = cmds[i].split(' ').sublist(1);

    try {
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
        while (args[i].contains('%path%')) {
          args[i] = args[i].replaceFirst('%path%', path);
        }
        while (args[i].contains('%space%')) {
          args[i] = args[i].replaceFirst('%space%', ' ');
        }
        while (args[i].contains('%version%')) {
          args[i] = args[i].replaceFirst('%version%', buildString);
        }
        while (args[i].contains('%tab%')) {
          args[i] = args[i].replaceFirst('%tab%', '\t');
        }
        while (args[i].contains('%newline%')) {
          args[i] = args[i].replaceFirst('%newline%', '\n');
        }
        while (args[i].contains('%semicolon%') ||
            args[i].contains('%sc%') ||
            args[i].contains('%smcl%')) {
          args[i] = args[i].replaceFirst('%semicolon%', ';');
          args[i] = args[i].replaceFirst('%sc%', ';');
          args[i] = args[i].replaceFirst('%smcln%', ';');
        }
        while (args[i].contains('%users%')) {
          final usersList = [];
          for (var user in users) {
            usersList.add(user);
          }
          args[i] = args[i].replaceFirst('%users%', usersList.join('\n'));
        }
        args[i] = args[i]
            .replaceAll('%unsafe%', drive['settings']['unsafe'].toString());
        args[i] = args[i].replaceAll('%scriptname%', path.split('/').last);
        args[i] = args[i].replaceAll('%scriptpath%', _path);
        args[i] = args[i].replaceAll('%name%', drive['name']);
        // args[i] = args[i].replaceAll('%nil%', '');
        // args[i] = args[i].replaceAll('%null%', '');
      }
      vars.forEach(
        (key, value) {
          for (var i = 0; i < args.length; i++) {
            while (args[i].contains('{$key}')) {
              if (value is List) {
                args[i] = args[i].replaceFirst('{$key}', value.join(' '));
                args[i] =
                    args[i].replaceFirst('<$key>', value.length.toString());
              } else {
                args[i] = args[i].replaceFirst('{$key}', value.toString());
              }
            }
          }
        },
      );
      if (cmd == 'here') {
      } else if (cmd == 'goto') {
        i = cmds.indexOf('here ${args[0]}');
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
          case 'hasnt':
            correct = (v1.contains(v2) == false);
            break;
          case 'listhas':
            correct = (v1.split(' ').contains(v2));
            break;
          case 'listhasnt':
            correct = (v1.split(' ').contains(v2) == false);
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
        if (action == 'set' || action == 'is' || action == '=') {
          dynamic value = args[2];
          if (num.tryParse(args[2]) != null) value = num.tryParse(args[2]);
          if (args[2] == 'true' || args[2] == 'false') {
            value = (args[2] == 'true');
          }
          vars[name] = value;
        }
        if (action == 'add' || action == '+') {
          dynamic value = args[2];
          if (num.tryParse(args[2]) != null) value = num.tryParse(args[2]);
          if (args[2] == 'true' || args[2] == 'false') {
            value = (args[2] == 'true');
          }
          if (value is num) vars[name] += value;
          if (value is String) vars[name] += value;
          if (value is bool) vars[name] += value;
        }
        if (action == 'sub' || action == '-') {
          dynamic value = args[2];
          if (num.tryParse(args[2]) != null) value = num.tryParse(args[2]);
          if (args[2] == 'true' || args[2] == 'false') {
            value = (args[2] == 'true');
          }
          if (value is num) vars[name] -= value;
          if (value is String) vars[name] -= value;
          if (value is bool) vars[name] -= value;
        }
        if (action == 'readfile' || action == 'readf') {
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
        if (action == 'math') {
          final p = Parser();
          final vpi = Variable('pi');
          final cm = ContextModel();
          cm.bindVariable(vpi, Number(pi));
          final exp = p.parse(args.sublist(2).join(' '));
          var val = (exp.evaluate(EvaluationType.REAL, cm) as num).toString();
          if (val.endsWith('.0')) val = val.replaceAll('.0', '');
          vars[name] = val;
        }
        if (action == 'list') {
          List value = args.sublist(2);
          vars[name] = value;
        }
        if (action == 'http') {
          if (drive['settings']['unsafe'] != true &&
              permissions['network'] != true) {
            print(
              '$path is trying to make a network request, do you give it permission to? [y/n]',
            );
            final answer = stdin.readLineSync();
            if (answer != 'y') {
              vars[name] = '';
              continue;
            }
            permissions['network'] = (answer == 'y');
          }
          final req = args[3].toLowerCase();
          final address = args[4];
          final headers = args.length > 5 ? args[5] : '';
          final headersMap = <String, String>{};

          if (headers != '') {
            headers.split(' ').forEach(
              (element) {
                final yeets = element.split('-');
                headersMap[yeets[0]] = yeets[1];
              },
            );
          }
          final uri = Uri.parse(address);
          switch (req) {
            case 'get':
              final resp = await http.get(uri, headers: headersMap);
              vars[name] = resp.body;
              break;
            case 'post':
              final resp = await http.post(uri, headers: headersMap);
              vars[name] = resp.body;
              break;
            case 'delete':
              final resp = await http.delete(uri, headers: headersMap);
              vars[name] = resp.body;
              break;
            default:
              throw 'Unsupported request type';
          }
        }
      } else if (cmd == 'unsaferun') {
        if (drive['settings']['unsafe'] == true) {
          await terminal(cmd, args);
        } else {
          return error('Script attempted to perform illegal operation.');
        }
      } else if (cmd == 'http') {
        if (drive['settings']['unsafe'] != true &&
            permissions['network'] != true) {
          print(
            '$path is trying to make a network request, do you give it permission to? [y/n]',
          );
          final answer = stdin.readLineSync();
          if (answer != 'y') {
            continue;
          }
          permissions['network'] = (answer == 'y');
        } else {
          await terminal(cmd, args);
        }
      } else if (cmd == 'list') {
        var name = args[0];
        var action = args[1];
        switch (action) {
          case 'add':
            vars[name].add(args[2]);
            break;
          case 'addall':
            vars[name].addAll(args.sublist(2));
            break;
          case 'remove':
            vars[name].remove(args[2]);
            break;
          case 'removeat':
            vars[name].removeAt(int.parse(args[2]));
            break;
          case 'split':
            vars[name] = args.sublist(3).join(' ').split(args[2]);
            break;
          case 'shift':
            vars[name] = vars[name].sublist(int.parse(args[2]));
            break;
          case 'indexof':
            vars[name] = args[2].split(' ').indexOf(args[3]);
            break;
          case 'at':
            vars[name] = args[2].split(' ')[int.parse(args[3])];
            break;
        }
      } else if (cmd == 'stop') {
        return;
      } else if (cmd == 'onboot') {
        if (drive['settings']['unsafe'] == true) {
          await terminal(cmd, args);
        } else {
          return print('Script attempted to perform forbitten activity.');
        }
      } else if (cmd == 'deluser') {
        if (drive['settings']['unsafe'] == true) {
          return await terminal(cmd, args);
        } else {
          return print('Script attempted to perform forbitten activity.');
        }
      } else if (cmd == 'logout') {
        if (drive['settings']['unsafe'] == true) {
          return await terminal(cmd, args);
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
    } catch (e) {
      error('An error has occured while running your script.');
      print('Debug information: ');
      print('- Error occured at line $i');
      print('- Error was of type ${e.runtimeType}');
      print('- Error stack was');
      print('> ${e.toString()}');
      return;
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
  if (cmd == 'unsaferun') {
    if (args.isNotEmpty) {
      var dirPath = args[0];
      if (!dirPath.startsWith('/')) {
        dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
      }
      final unsafe = drive['settings']['unsafe'];
      drive['settings']['unsafe'] = true;
      await run(dirPath);
      drive['settings']['unsafe'] = unsafe;
      return;
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
  if (cmd == 'logout') {
    clear();
    checkPassword(true);
    fileSyncInit();
    await onboot_scripts();
    hello();
    return saveDrive();
  }
  if (cmd == 'deluser') {
    print(
        'Are you sure you want to delete the user you are currently in? [y/n]');
    final answer = stdin.readLineSync();
    if (answer == 'y') {
      clear();
      return removeCurrentUser();
    }
    return;
  }
  error('Invalid command.');
}
