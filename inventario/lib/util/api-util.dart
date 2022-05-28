import 'dart:io';
//http
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config-man.dart';

class ApiUtil {

  ApiUtil._();

  static Future<String?> uploadImage(File img) async {

    var url = Uri.parse('https://api.imgur.com/3/image/');
    var image = base64.encode(await img.readAsBytes());
    var response = await http.post(url,
        headers: {'Authorization': 'Client-ID ${Config.getImgurCID()}'},
        body: {'image': image});

    var json = response.statusCode == 200
        ? jsonDecode(response.body) as Map<String, dynamic>
        : null;

    return json?['data']?['link'];

  }
}
