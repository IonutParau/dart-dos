import 'dart:io';
import '../kernel.dart';

bool _quickIntro = false;

void slowPrint(String msg) {
  if (_quickIntro) return print(msg);
  for (var char in msg.split('')) {
    write(char);
    sleep(Duration(milliseconds: 50));
  }
  write('\n');
}

void intro() {
  print('You you like to make the introduction quickly? [y/n]');
  _quickIntro = (stdin.readLineSync() == 'y');
  slowPrint(
    '$buildString introduction screen.\nWe will introduce you to the basic usage of DartDOS.',
  );
  slowPrint('Lesson 1: Files');
  slowPrint(
    'To create files you can use the command mkfile <filename>. Replace <filename> with whatever name you want your file to have.',
  );
  slowPrint(
    'Please note all files must have file extensions, like hello.txt. The file extension in hello.txt is txt, and that . is essential.',
  );
  slowPrint(
    'To make sure you learned this, please type the command to create a file named hello with a file extention of epic',
  );

  while (true) {
    final input = stdin.readLineSync();
    if (input == null) return;
    if (input == 'mkfile hello.epic') {
      print('Correct!');
      break;
    }
    error('Wrong');
  }

  slowPrint('Lesson 2: Folders');
  slowPrint(
    'Files must always be in folders, folders can also be in folders. Unlike files, folders do not need a file extension and are crated with the mkdir <foldername> command. Replace <foldername> with the name of the folder you want to create.',
  );
  slowPrint(
    'To make sure you learned this, please type the command to create a folder named myDirectory',
  );
  while (true) {
    final input = stdin.readLineSync();
    if (input == null) return;
    if (input == 'mkdir myDirectory') {
      print('Correct!');
      break;
    }
    error('Wrong');
  }
  slowPrint('Lesson 3: Changing directories.');
  slowPrint(
    'You can see whats inside a directory with the dir command. But you can navigate in directories.',
  );
  slowPrint(
    'To navigate directories, simply use cd <directory>. You can use cd .. to go in the parent directory.',
  );
  slowPrint(
    'Now, please type the command to go into the directory myDirectory',
  );
  while (true) {
    final input = stdin.readLineSync();
    if (input == null) return;
    if (input == 'cd myDirectory') {
      print('Correct!');
      break;
    }
    error('Wrong');
  }

  slowPrint('Lesson 4: Editing files.');
  slowPrint(
      'Files can contain data known as content. To see this content you can use read <filename>, and to change it you can use edit <filename> <content>');
  slowPrint(
    'Now, please type the command to edit a file named epic.txt to have its content be I am epic',
  );
  while (true) {
    final input = stdin.readLineSync();
    if (input == null) return;
    if (input == 'edit epic.txt I am epic') {
      print('Correct!');
      break;
    }
    error('Wrong');
  }

  slowPrint('Lesson 5: Images');
  slowPrint(
    'You can turn a file into an image by using painter <filename>. It will open up Painter.',
  );
  slowPrint('In there, you can specify the width and height.');
  slowPrint(
    'After that, you can use the quite complex commands d, mv, save and exit to edit the file.',
  );
  slowPrint(
    'But, this is a simple introduction, so I will just show you how to see one of these images.',
  );
  slowPrint('Simply use render <filename>');
  slowPrint(
    'Now, type the command to render a image stored in a file named hello.png',
  );
  while (true) {
    final input = stdin.readLineSync();
    if (input == null) return;
    if (input == 'render hello.png') {
      print('Correct!');
      break;
    }
    error('Wrong');
  }

  slowPrint('Lesson 6: Other utilities');
  slowPrint('DartDOS has some integrated utilities to help you.');
  slowPrint('These utilities are: Painter, Paper, Disky and Field Editor.');
  slowPrint(
    'We will talk a bit about all of them (except Painter because we already talked about it.)',
  );
  slowPrint(
    'But we will only teach you about Disky as it is the most useful.',
  );
  slowPrint(
    'So, Paper. It is kind of like NotePad from Windows. It contains some commands and is pretty advanced.',
  );
  slowPrint(
    'So, Disky. It is a simple way of managing the virtual disk DartDOS stores your files and folders in.',
  );
  slowPrint(
    'So, Field Editor. There are these things called "System Fields", they store values essential to the system. Field Editor gives you complete control over them, but use it at your own risk.',
  );

  slowPrint(
    'Anyways, if you ever use the disky command to call Disky, he will ask you what you want it to do.',
  );
  slowPrint(
    'The most common thing you would want it to do is perform a Health check, or a disk heal.',
  );
  slowPrint(
    'To tell Disky to use them, simply type the number next to the thing you want it to do and press enter, Disky will do the rest.',
  );
  slowPrint('In the case of a health check, the number is 1');
  slowPrint('In the case of a disk heal, the number is 2');
  slowPrint(
    'Now, there is more stuff Disky can do, such as Disky Artifical Retro-Translator that can turn your disk into a format used by LuaDOS, one of DartDOSs competitors.',
  );
  slowPrint(
    'There is also Disky Drive Merging Utility, it can merge 2 DartDOS disks.',
  );
  slowPrint(
    'There is also FileSync. It can syncronise a DartDOS file with a real file on the host operating system.',
  );
  slowPrint(
    'To see if you have learned how to use disky, type the 2 things you need to type to perform a health check on the virtual drive.',
  );
  while (true) {
    final input = stdin.readLineSync();
    if (input == null) return;
    if (input == 'disky') {
      print('Correct!');
      break;
    }
    error('Wrong');
  }
  while (true) {
    final input = stdin.readLineSync();
    if (input == null) return;
    if (input == '1') {
      print('Correct!');
      break;
    }
    error('Wrong');
  }

  slowPrint('You are all set!');
  print(
    'Oh, and do not worry, all messages from now on will be printed a lot faster. Just like this one!',
  );
  print('We only slowed it down so you can have time to read it.');
}
