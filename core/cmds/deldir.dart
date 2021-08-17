import '../kernel.dart';

void deldir(String path) {
  if (path.endsWith('/*')) {
    path = (path.split('')..removeLast()).join('');
    final slashes = path.split('/').length;
    drive.removeWhere((k, _) {
      if (k.split('.').first == path) {
        return false;
      }
      if (k.split('/').length > slashes) {
        print('Deleting $k');
        return true;
      }
      if (k.split('/').contains('.')) return false;
      var deleted = k.startsWith(path);
      if (deleted) print('Deleting $k');
      return deleted;
    });
  } else {
    deleteFolder(path);
  }
  if (drive['settings']['always-save-drive'] == true) saveDrive();
}
