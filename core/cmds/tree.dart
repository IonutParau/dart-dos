import '../kernel.dart' show drive;

void tree(String path) {
  drive.forEach(
    (key, value) {
      if (key.startsWith(path)) print('$key');
    },
  );
}
