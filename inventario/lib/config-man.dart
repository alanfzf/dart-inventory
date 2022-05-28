import 'dart:convert';
import 'package:flutter/services.dart';

class Config {
  Config._();

  static Map<String, dynamic> _config = {};

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getImgurCID() {
    return _config['imgur-key'] as String;
  }

  static Uri getAPIurl(String append) {
    var baseUrl = _config['api-url'] as String;
    var uri = Uri.parse(baseUrl + append);
    return uri;
  }
}
