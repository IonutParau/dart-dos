import '../kernel.dart';

void mkdir(String path) {
  createFolder(path);
  if (drive['settings']['always-save-drive'] == true) saveDrive();
}
