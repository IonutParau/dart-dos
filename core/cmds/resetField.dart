import '../kernel.dart' show blankDrive, drive, error, saveDrive;

void resetField(String field) {
  final blank = blankDrive;
  if (blank[field] == null) {
    return error('Field is not resettable.');
  }
  print('Resetting $field...');
  drive[field] = blank[field];
  saveDrive();
}
