import '../kernel.dart';

void delfile(String path) {
  if (path.endsWith('/*')) {
    //print(path);
    var slashCount =
        (path.split('/')..removeWhere((element) => element == '')).length +
            (path == '/*' ? 1 : 1);
    //print(slashCount);
    drive.removeWhere((k, v) {
      final deleted =
          ((k.split('/')).length == slashCount) && drive[k]['type'] == 'file';
      if (deleted) print('Deleting $k');
      return deleted;
    });
  } else {
    deleteFile(path);
  }
  saveDrive();
}
