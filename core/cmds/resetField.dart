import '../kernel.dart' show blankDrive, drive, error, saveDrive;

void resetField(String field) {
  final blank = blankDrive;
  if (field == '*') {
    blank.forEach((k, v) => drive[k] = v);
  }
  if (blank[field] == null) {
    return error('Field is not resettable.');
  }
  print('Resetting $field...');
  drive[field] = blank[field];
  if (drive['settings']['always_save_drive'] == true) saveDrive();
}
