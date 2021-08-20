import 'dart:io' show stdin;
import '../cmd.dart';
import '../kernel.dart' show drive, writeToFile, error;

void editfile(String path, [String content = '']) {
  var file = drive[path];
  if (file == null) return error('File does not exist');
  var input = content;
  if (input == '') input = stdin.readLineSync() ?? '';
  file['content'] = input;
  writeToFile(path, file);
  final ran = [];
  for (var i = 0; i < drive['oncontent_scripts'].length; i++) {
    final str = drive['oncontent_scripts'][i];
    if (ran.contains(str) == false) {
      ran.add(str);
      run(str, [path, drive[path]['content']], true);
    }
  }
}
