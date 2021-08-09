import 'dart:io' show FileSystemException, exit;
import 'kernel.dart' show bootKernel, showCrashScreen;
import 'cmd.dart' show bootCommander;
import 'package:ansicolor/ansicolor.dart' show AnsiPen;

void main() {
  final bootPen = AnsiPen()..cyan();
  print('Initiating Boot routine');
  print(bootPen('> ') + 'Booting Kernel');
  try {
    bootKernel();
  } catch (e) {
    if (e is FileSystemException) {
      showCrashScreen('Kernel FileSystem Interace Failure', 'DartDOS Kernel');
      print(e.message);
      exit(0);
    }
    showCrashScreen('Kernel Booting Routine Failed', 'DartDOS Kernel');
    print('Known stack trace');
    print(e.toString());
    exit(0);
  }
  print(bootPen('> ') + 'Booting Commander');
  try {
    bootCommander();
  } catch (e) {
    if (e is FileSystemException) {
      showCrashScreen(
        'Commander broke File Interface',
        'DartDOS Command Manager / Commander',
      );
      print(e.toString());
      exit(0);
    }
    showCrashScreen(
      'Commander failed to boot',
      'DartDOS Command Manager / Commander',
    );
    print(e.toString());
    exit(0);
  }
}
