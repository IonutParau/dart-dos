import 'package:http/http.dart' as http;

import '../kernel.dart';

Future httpcmd(String request, String location, [String headers = '']) async {
  final headersMap = <String, String>{};

  headers.split(' ').forEach(
    (element) {
      final yeets = element.split('-');
      headersMap[yeets[0]] = yeets[1];
    },
  );

  switch (request) {
    case 'get':
      final getMe =
          await http.get(Uri.dataFromString(location), headers: headersMap);
      print('Information');
      print('Status Code - ${getMe.statusCode}');
      print('Body - ${getMe.body}');
      if (getMe.isRedirect) print('Was redirect');
      break;
    case 'post':
      final getMe =
          await http.post(Uri.dataFromString(location), headers: headersMap);
      print('Information');
      print('Status Code - ${getMe.statusCode}');
      print('Body - ${getMe.body}');
      if (getMe.isRedirect) print('Was redirect');
      break;
    case 'delete':
      final getMe =
          await http.delete(Uri.dataFromString(location), headers: headersMap);
      print('Information');
      print('Status Code - ${getMe.statusCode}');
      print('Body - ${getMe.body}');
      if (getMe.isRedirect) print('Was redirect');
      break;
    case 'head':
      final getMe =
          await http.head(Uri.dataFromString(location), headers: headersMap);
      print('Information');
      print('Status Code - ${getMe.statusCode}');
      print('Body - ${getMe.body}');
      if (getMe.isRedirect) print('Was redirect');
      break;
    case 'put':
      final getMe =
          await http.put(Uri.dataFromString(location), headers: headersMap);
      print('Information');
      print('Status Code - ${getMe.statusCode}');
      print('Body - ${getMe.body}');
      if (getMe.isRedirect) print('Was redirect');
      break;
    default:
      return error('Unknwon request type');
  }
}
