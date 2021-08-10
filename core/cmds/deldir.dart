import '../kernel.dart';

void deldir(String path) {
  if (path.endsWith('/*')) {
    path = (path.split('')..removeLast()).join('');
    final slashes = path.split('/').length;
    drive.removeWhere((k, _) {
      if (k.split('/').length > slashes) {
        print('Deleting $k');
        return true;
      }
      if (k.split('/').last.split('.').length > 1) return false;
      var deleted = k.startsWith(path);
      if (deleted) print('Deleting $k');
      return deleted;
    });
  } else {
    deleteFolder(path);
  }
  saveDrive();
}
