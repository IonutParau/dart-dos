import '../cmd.dart' show path;
import '../kernel.dart' show drive, error;

void cd(String dir) {
  if (dir == '.') {
    return;
  }
  if (dir == '..') {
    final paths = path.split('/');
    paths.removeLast();
    path = paths.join('/') == '' ? '/' : paths.join('/');
  }
  if (dir.startsWith('/')) {
    if (drive[dir] != null) {
      if (drive[dir]['type'] == 'folder') {
        path = dir;
      } else {
        return error("Couldn't find directory");
      }
    }
  } else {
    dir = path == '/' ? '/$dir' : '$path/$dir';
    if (drive[dir] != null) {
      if (drive[dir]['type'] == 'folder') {
        path = dir;
      } else {
        return error("Couldn't find directory");
      }
    }
  }
}
