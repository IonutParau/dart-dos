import '../kernel.dart';

void mkfile(String path) {
  createFile(
    path,
    {'type': 'file', 'content': ''},
  );
}
