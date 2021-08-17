import '../kernel.dart';
import 'dart:io' show stdin;

void paint(String path) {
  if (drive[path] == null) return error('File does not exist.');
  if (drive[path]['type'] != 'file') return error('Path is not file');
  print('[ Painter ]');
  print('Welcome to Painter!');
  print('We currently need you to input the width and height.');

  write('Width > ');
  final width = int.tryParse(stdin.readLineSync() ?? '');
  if (width == null) return error('Not a number.');
  write('Height > ');
  final height = int.tryParse(stdin.readLineSync() ?? '');
  if (height == null) return error('Not a number.');
  final imageData = List.generate(
    width * height,
    (i) => Color('000000'),
  );
  var renderStrings = <String>[''];
  var x = 0;
  var y = 0;

  while (true) {
    clear();
    renderStrings = [''];
    for (var i = 0; i < imageData.length; i++) {
      final char = imageData[i];
      if (renderStrings.last.length < width) {
        renderStrings[renderStrings.length - 1] += '@';
        write(colored('︎  ', char, char));
      }
      if (renderStrings.last.length == width) {
        renderStrings.add('');
        write('\n');
      }
    }
    final input = stdin.readLineSync();
    if (input == null) return;
    final cmd = input.split(' ').first;
    final args = input.split(' ').sublist(1);

    if (cmd == 'exit') {
      return print('Bye!');
    } else if (cmd == 'mv' || cmd == 'move') {
      x += int.parse(args[0]);
      x = (x + width) % width;
      y += int.parse(args[1]);
      y = (y + height) % height;
    } else if (cmd == 'd' || cmd == 'draw') {
      final i = x + y * width;
      imageData[i] = Color(args[0]);
    } else if (cmd == 's' || cmd == 'save' || cmd == 'export') {
      var export = '';

      var widthStr = width.toRadixString(16);
      while (widthStr.length < 6) {
        widthStr = (widthStr.split('')..insert(0, '0')).join();
      }
      export += widthStr;
      for (var data in imageData) {
        export += data.hex;
      }
      drive[path]['content'] = export;
      saveDrive();
    }
  }
}
