import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String baseUrl = kIsWeb
      ? 'http://localhost:3000/api'
      : 'http://10.0.2.2:3000/api';

  static const String signup = '$baseUrl/auth/signup';
  static const String login = '$baseUrl/auth/login';
  static const String me = '$baseUrl/auth/me';
  static const String restaurants = '$baseUrl/restaurants';
}
// configuration of the data here we are doing
