import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  static final String baseUrl = configuredBaseUrl.isNotEmpty
      ? configuredBaseUrl
      : kIsWeb
      ? 'http://localhost:3000/api'
      : 'http://10.0.2.2:3000/api';

  static final String signup = '$baseUrl/auth/signup';
  static final String login = '$baseUrl/auth/login';
  static final String me = '$baseUrl/auth/me';
  static final String restaurants = '$baseUrl/restaurants';
  static final String orders = '$baseUrl/orders';
}
// configuration of the data here we are doing
