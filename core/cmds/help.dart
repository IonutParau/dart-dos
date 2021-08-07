void help() {
  print('List of all user commands!');
  print('   Sorted by: Developer   ');
  print('--------------------------');
  print('help - Shows this amazing 10/10 would render again menu');
  print('exit - Closes the program. Ctrl + C does not work.');
  print(
    'disky - Sends you to the Disky Integrated Disk Utility screen. Disky is usefull for setting up FileSync and fixing broken or unstable drives.',
  );
  print(
    'backup <filename> - Backs up the entire drive to a file in the host OS named after the first parameter given to this command.',
  );
  print(
    'restore <filename> - Restores the drive from a backup file in the host OS named after the first parameter given to this command.',
  );
  print('mkdir <dir> - Creates folder!');
  print(
    'deldir <dir> - Deletes the folder and all of its contents!',
  );
  print(
    'mkfile <file> - Creates the file!',
  );
  print(
    'delfile <file> - Deletes the file!',
  );
  print(
    'editfile <file> - Edits the file! You can write to it the basic text!',
  );
  print('cd <path> - Changes the current directory to be towards that path!');
  print('dir - Shows everything in the current directory.');
  print(
    'tree - Shows everything in the current directory and its subdirectories.',
  );
  print(
    'changepass <pass> - Changes your password to changepass. If you do not put a password in it will remove password protection. If you did not have a password before it adds password protection.',
  );
  print(
    'rename <name> - Changes username! The default username is DartDOS User',
  );
  print(
    'settings - Allows you to change settings. ! Disclaimer ! changing some critical settings to random values might make DartDOS unbootable, or cause system instability.',
  );
  print('hello - Welcomes you! This is called when the commander boots!');
}
