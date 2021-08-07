import '../kernel.dart' show drive, buildString;

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
}
