import '../kernel.dart';

void mkfile(String path) {
  createFile(
    path,
    {'type': 'file', 'content': ''},
  );
  if (drive['settings']['always-save-drive'] == true) saveDrive();
}
