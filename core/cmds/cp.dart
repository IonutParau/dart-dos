import '../kernel.dart';

void cp(String place1, String place2) {
  final used = <String>[];
  drive.forEach(
    (key, value) {
      if (key.startsWith('$place1/') || key == place1) used.add(key);
    },
  );
  used.forEach(
    (key) {
      drive[key.replaceFirst(place1, place2)] = drive[key];
    },
  );

  if (drive['settings']['always-save-drive'] == true) saveDrive();
}
