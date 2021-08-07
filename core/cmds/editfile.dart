import 'dart:io' show stdin;
import '../kernel.dart' show drive, writeToFile, error;

void editfile(String path) {
  var file = drive[path];
  if (file == null) return error('File does not exist');
  final input = stdin.readLineSync() ?? '';
  file['content'] = input;
  writeToFile(path, file);
}
