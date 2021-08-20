import '../cmd.dart' show run;
import '../kernel.dart';
import 'package:http/http.dart' as http;

Future<void> download(String path, String url) async {
  if (drive[path] != null) {
    if (drive[path]['type'] != 'file') {
      return error('$path is not a file.');
    }
  }
  if (url.startsWith(',')) url = url.split('').sublist(1).join();
  final downloaded = await http.get(Uri.parse(url));
  if (downloaded.statusCode == 200) {
    if (drive[path] == null) drive[path] = {'type': 'file', 'content': ''};
    drive[path]['content'] = downloaded.body;
    drive[path]['content'] = drive[path]['content'].replaceAll('\r\n', '\n');
    final ran = [];
    for (var i = 0; i < drive['oncontent_scripts'].length; i++) {
      final str = drive['oncontent_scripts'][i];
      if (ran.contains(str) == false) {
        ran.add(str);
        await run(str, [path, drive[path]['content']], true);
      }
    }
    if (drive['settings']['always_save_drive'] == true) saveDrive();
  } else {
    print('Download failed. Error code: ${downloaded.statusCode}');
  }
}
