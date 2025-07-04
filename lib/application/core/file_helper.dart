import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'di.dart';

class FileHelper {
  static Future<File?> getFileToURL(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      var s = url.split("?");
      s = s.last.split("&");
      String? fileName;
      for (var element in s) {
        if (element.contains("hmac")) {
          fileName = element.substring(5);
        }
      }
      if (fileName == null) throw "File Not Found";
      final path = "${dir.path}/$fileName.jpg";
      final res = await getIt.get<Dio>().download(url, path);
      print("===========> " + res.data);
      return null;
      /*var file = File(path);
      file.openWrite();
      file = await file.writeAsString(res.data);
      if (await file.exists()) {
        return file;
      } else {
        throw "File does not exist";
      }*/
    } catch (e) {
      rethrow;
    }
  }
}
