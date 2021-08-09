import 'dart:io';
import '../utils/utils.dart' show disky, paper;
import '../utils/paint.dart';
import '../cmd.dart' show path;

void apps() {
  print('[ DartDOS Integrated Applications ]');
  print('');
  print('< Applications >');
  print('Disky Integrated Disk Utility [1]');
  print('Paper Integrated File Editing Application [2]');
  print('Painter Integrated Image Painting Application [3]');
  print('These can also be accessed via commands.');
  print('Please input the number associated to these apps.');
  final input = stdin.readLineSync() ?? '';
  if (input == '1') {
    disky();
  } else if (input == '2') {
    print('Please input a file path.');
    var dirPath = stdin.readLineSync();
    if (dirPath == null) return;
    if (!dirPath.startsWith('/')) {
      dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
    }
    paper(dirPath);
  } else if (input == '3') {
    print('Please input a file path.');
    var dirPath = stdin.readLineSync();
    if (dirPath == null) return;
    if (!dirPath.startsWith('/')) {
      dirPath = path == '/' ? '/$dirPath' : '$path/$dirPath';
    }
    paint(dirPath);
  }
}
