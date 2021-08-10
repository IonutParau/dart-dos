import '../kernel.dart' show drive, saveDrive;

void changeName(String newName) {
  if (newName.toLowerCase() == 'luados user' ||
      newName.toLowerCase() == 'ldos user') {
    newName = 'DartDOS User';
  }
  drive['name'] = newName;
  saveDrive();
}
