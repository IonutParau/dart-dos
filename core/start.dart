import 'dart:io' show exit;
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
    showCrashScreen('Kernel Booting Routine Failed', 'DartDOS Kernel');
    print('Known stack trace');
    print(e.toString());
    exit(0);
  }
  print(bootPen('> ') + 'Booting Commander');
  try {
    bootCommander();
  } catch (e) {
    showCrashScreen(
      'Commander failed to boot',
      'DartDOS Command Manager / Commander',
    );
    print(e.toString());
    exit(0);
  }
}
