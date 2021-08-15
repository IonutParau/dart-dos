import '../kernel.dart' show Color, clear, colored, drive, error, saveDrive;
import 'dart:io' show stdin;

void paper(String path) {
  if (drive[path] == null) {
    return error('File does not exist');
  }
  if (drive[path]['type'] != 'file') {
    return error('$path is not a file.');
  }
  var content = drive[path]['content'] as String;
  var i = content.length - 1;
  if (i < 0) i = 0;
  while (true) {
    clear();
    print('[ Paper file editor ]');
    print('');
    if (content != '') {
      var vcontent = content;
      final vcontentSplit = vcontent.split('');
      if (i >= 0 || i < vcontentSplit.length) {
        vcontentSplit[i] = colored(vcontent[i], Color('00FF00'));
      }
      vcontent = vcontentSplit.join();
      print(vcontent);
    }
    final input = stdin.readLineSync() ?? '';
    final cmd = input.split(' ')[0];
    final args = input.split(' ').sublist(1);

    if (cmd.startsWith('.') && cmd.length > 1) {
      if (cmd == '.e') {
        return;
      } else if (cmd == '.save') {
        drive[path]['content'] = content;
        if (drive['settings']['always-save-drive'] == true) saveDrive();
      } else if (cmd == '.set') {
        i = int.parse(args[0]);
      } else if (cmd == '.m') {
        i += int.parse(args[0]);
      } else if (cmd == '.d') {
        final contentList = content.split('');
        contentList.removeAt(i);
        content = contentList.join();
        i--;
      } else if (cmd == '.n') {
        final contentList = content.split('');
        contentList.insert(i + 1, '\n');
        content = contentList.join();
        i++;
      } else if (cmd == '.t') {
        final contentList = content.split('');
        var tabSpacing = '';
        for (var i = 0; i < drive['settings']['tabspacing']; i++) {
          tabSpacing += ' ';
        }
        contentList.insert(i + 1, tabSpacing);
        content = contentList.join();
        i++;
      }
    } else {
      final contentList = content.split('');
      final mI = (content.isEmpty ? input.length - 1 : input.length) +
          (content.isEmpty && input.isEmpty ? 1 : 0);
      if (content == '') {
        content = input;
      } else {
        if (contentList.length > i) {
          contentList.insert(i + 1, input);
        } else {
          contentList.add(input);
        }
        content = contentList.join();
      }
      i += mI;
    }
  }
}
