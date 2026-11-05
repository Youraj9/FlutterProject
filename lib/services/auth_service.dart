import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/auth_user.dart';
import 'token_storage.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthResult {
  final AuthUser user;
  final String token;

  const AuthResult({required this.user, required this.token});
}

class AuthService {
  // SIGNUP
  Future<AuthResult> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse(ApiConfig.signup),

          headers: {'Content-Type': 'application/json'},

          body: jsonEncode({
            'name': name.trim(),
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 15));

    return _handleAuthResponse(response);
  }

  // LOGIN
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse(ApiConfig.login),

          headers: {'Content-Type': 'application/json'},

          body: jsonEncode({'email': email.trim(), 'password': password}),
        )
        .timeout(const Duration(seconds: 15));

    return _handleAuthResponse(response);
  }

  // GET CURRENT LOGGED-IN USER
  Future<AuthUser> getCurrentUser() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw AuthException('Please log in again.');
    }

    final response = await http
        .get(
          Uri.parse(ApiConfig.me),

          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    final body = _decodeResponse(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(
        body['message']?.toString() ?? 'Unable to fetch user information.',
      );
    }

    final data = _asMap(body['data']);

    return AuthUser.fromJson(data);
  }

  // COMMON AUTH RESPONSE HANDLER
  Future<AuthResult> _handleAuthResponse(http.Response response) async {
    final body = _decodeResponse(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(
        body['message']?.toString() ?? 'Authentication failed.',
      );
    }

    final data = _asMap(body['data']);

    // Supports data.token or data.accessToken.
    final token =
        (data['token'] ??
                data['accessToken'] ??
                body['token'] ??
                body['accessToken'])
            ?.toString();

    if (token == null || token.isEmpty) {
      throw AuthException('The server did not return an authentication token.');
    }

    // Some APIs return data.user.
    // Others return the user fields directly inside data.
    final userData = data['user'] is Map ? _asMap(data['user']) : data;

    final user = AuthUser.fromJson(userData);

    if (user.id.isEmpty || user.email.isEmpty) {
      throw AuthException('The server returned incomplete user information.');
    }

    // Store token securely.
    await TokenStorage.saveToken(token);

    return AuthResult(user: user, token: token);
  }

  // DECODE JSON RESPONSE
  Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw AuthException('Invalid server response.');
    } on FormatException {
      throw AuthException('Server returned invalid JSON.');
    }
  }

  // SAFELY CONVERT JSON MAP
  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw AuthException('Invalid response data.');
  }

  // LOGOUT
  Future<void> logout() async {
    await TokenStorage.deleteToken();
  }
}
