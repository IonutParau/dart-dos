import '../kernel.dart' show drive;

void changeName(String newName) {
  if (newName.toLowerCase() == 'luados user' ||
      newName.toLowerCase() == 'ldos user') {
    newName = 'DartDOS User';
  }
  drive['name'] = newName;
}
