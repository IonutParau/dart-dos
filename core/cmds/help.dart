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
    'paper <file> - Uses paper to open the file <file>. Paper is a more complex but also more powerfull file editor.',
  );
  print(
    'paint <file> - If <file> exists, opens it to write to it with a custom image format. It is very complex, and thus, advanced.',
  );
  print(
    'render <file> - If <file> exists, it will render the file to the screen using the custom image format.',
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
  print('run <filepath> - Allows you to run a script using DartDOS Runnables');
  print(
      'filesync [add/remove/show] <path> - Manages FileSync. In the show action it is optional to put path, it would do nothing if you put it.');
  print(
    'mv <path1> <path2> - Moves fies and folders around.',
  );
  print(
    'cp <path1> <path2> - Moves fies and folders around.',
  );
  print(
      'download <path> <url> - Downloads the result given by the url, if it was successfull.');
  print('cd <path> - Goes into the folder at path');
  print(
    'http [get/post/delete/head/put] <url> <headers as name-value pairs> - Makes http request and prints the result.',
  );
  print(
    'echo [message] - Prints to the console the [message], this message can even be split in multiple arguments.',
  );
  print(
    'write [message] - Writes to the console the [message], this message can even be split in multiple arguments.',
  );
  print(
    'cecho <color> [message] - Works just like echo, except it will print it colored with <color>, <color> must be a valid hexcode.',
  );
  print(
    'cwrite <color> [message] - Works just like write, except it will write it colored with <color>, <color> must be a valid hexcode.',
  );
  print('about - Says information about DartDOS!');
  print(
    'fieldedit - Opens up the Field Editor, allowing you to set fields to certain values. If the value is the word null, the field will be removed. If the field does not exist, it will be created.',
  );
  print('setfield <field> <value> - Sets the field <field> to <value>');
  print('resetfield <field> - Resets the field <field> to its default value.');
  print('save/savedrive/sd - Saves the current drive to the drive.json file.');
}
