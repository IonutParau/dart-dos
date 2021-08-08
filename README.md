# What is DartDOS
It is a application that acts as if it was a version of DOS running in a VM. It is written in Dart, thus the name "DartDOS".

# Are there any more applications like DartDOS?
DartDOS does have 1 competitor, LuaDOS.

# What is the latest version?
1.0.0

# How is it installed?
You can download the executable and then run it, it will perform all first install actions by itself.
I recommend putting the executable into a special folder and then running it, as it will create 2 files, drive.json and backup.json
containing information about the virtual drives.

# How does it work?
The special part about it is that is stores the information about the virtual drives
as json files. Tho, using the backup command you can specify another file to be filled
with a backup. It doesn't have to be a json file.

DartDOS also comes with Disk Utilities. Even tho it can detect if the main drive is invalid JSON and
then prompt you to specify another drive to boot from until the main one gets fixed manually,
it also comes with a utility known as "Disky", which can fix a broken FileSystem drive,
such as files being numbers and not objects, which would cause system crashes when trying
to access them.