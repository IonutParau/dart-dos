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
    if (drive['settings']['always_save_drive'] == true) saveDrive();
  } else {
    print('Download failed. Error code: ${downloaded.statusCode}');
  }
}
