import '../kernel.dart' as kernel show readFile;

void readFile(String path) {
  var val = kernel.readFile(path);
  if (val != '') print(val);
}
