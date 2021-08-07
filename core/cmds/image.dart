import '../kernel.dart' show Color, colored, error, readFile, write;

void image(String path) {
  final content = readFile(path);

  if (content != '') {
    // Render the image
    if (content.length % 6 != 0) return error('Invalid file');

    renderImage(content);
  }
}

void renderImage(String content) {
  if (content != '') {
    // Render the image
    if (content.length % 6 != 0) return error('Invalid data');

    final entries = <String>[
      '',
    ];

    for (var char in content.split('')) {
      if (entries.last.length < 6) {
        entries[entries.length - 1] += char;
      } else {
        entries.add(char);
      }
    }
    final width = int.tryParse(entries[0], radix: 16);
    if (width == null) return error('Invalid characters');
    //print(width);

    entries.removeAt(0);

    final textureRows = <String>[''];

    for (var i = 0; i < entries.length; i++) {
      final char = entries[i];
      if (textureRows.last.length < width) {
        textureRows[textureRows.length - 1] += '@';
        write(colored('@', Color(char)));
      }
      if (textureRows.last.length == width) {
        textureRows.add('');
        write('\n');
      }
    }
  }
  write('\n');
}
