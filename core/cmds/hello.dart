import '../kernel.dart' show drive, buildString;
import 'dart:math';

void hello() {
  print('Hello ${drive['name']} and welcome to $buildString!');
  print('Use the command "help" for a list of commands!');
  if (buildString.toLowerCase().contains('beta')) {
    print(
      'Warning: Any non-permitted leakage could lead to termination of allowed access to beta builds.',
    );
    print(
      'In other words, you will not resieve any more beta builds if you leak this to non-permitted users.',
    );
  }
  if (Random().nextDouble() > 0.99) {
    print(
      '(also... please try out LuaDOS, it is good competition. Also try out Flicko it cool)',
    );
  }
}
