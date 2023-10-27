import 'dart:typed_data';
import 'package:http/http.dart' as http;

class DownloadFile {
  static Future<Uint8List> downloadFile(String url) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      final Uint8List bytes = response.bodyBytes;
      return bytes;
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }
}
