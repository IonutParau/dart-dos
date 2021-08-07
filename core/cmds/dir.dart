import '../kernel.dart' show drive;

void dir(String path) {
  var wantedLength = path.split('/').length + (path == '/' ? 0 : 1);

  drive.forEach(
    (key, _) {
      if (key.split('/').length == wantedLength &&
          key.startsWith(path) &&
          key != path) {
        print(key.replaceFirst('$path/', ''));
      }
    },
  );
}
