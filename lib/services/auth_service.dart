import 'dart:async';
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
  static const Duration _timeout = Duration(seconds: 15);

  // =========================
  // SIGNUP
  // =========================

  Future<AuthResult> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.signup),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name.trim(),
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(_timeout);

      return await _handleAuthResponse(response);
    } on TimeoutException {
      throw AuthException('Request timed out. Please try again.');
    } on http.ClientException {
      throw AuthException('Unable to connect to the server.');
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.login),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(_timeout);

      return await _handleAuthResponse(response);
    } on TimeoutException {
      throw AuthException('Request timed out. Please try again.');
    } on http.ClientException {
      throw AuthException('Unable to connect to the server.');
    }
  }

  // =========================
  // GET CURRENT USER
  // =========================

  Future<AuthUser> getCurrentUser() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw AuthException('Please log in again.');
    }

    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.me),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      final body = _decodeResponse(response);

      if (response.statusCode == 401) {
        await TokenStorage.deleteToken();
        throw AuthException('Your session has expired. Please log in again.');
      }

      if (!_isSuccessful(response, body)) {
        throw AuthException(_errorMessage(body));
      }

      final data = _asMap(body['data']);

      return AuthUser.fromJson(data);
    } on TimeoutException {
      throw AuthException('Request timed out. Please try again.');
    } on http.ClientException {
      throw AuthException('Unable to connect to the server.');
    }
  }

  // =========================
  // COMMON AUTH RESPONSE
  // =========================

  Future<AuthResult> _handleAuthResponse(http.Response response) async {
    final body = _decodeResponse(response);

    if (!_isSuccessful(response, body)) {
      throw AuthException(_errorMessage(body));
    }

    final data = _asMap(body['data']);

    final token =
        (data['token'] ??
                data['accessToken'] ??
                body['token'] ??
                body['accessToken'])
            ?.toString();

    if (token == null || token.isEmpty) {
      throw AuthException('The server did not return an authentication token.');
    }

    final userData = data['user'] is Map ? _asMap(data['user']) : data;

    final user = AuthUser.fromJson(userData);

    if (user.id.isEmpty || user.email.isEmpty) {
      throw AuthException('The server returned incomplete user information.');
    }

    await TokenStorage.saveToken(token);

    return AuthResult(user: user, token: token);
  }

  // =========================
  // RESPONSE STATUS
  // =========================

  bool _isSuccessful(http.Response response, Map<String, dynamic> body) {
    return response.statusCode >= 200 &&
        response.statusCode < 300 &&
        body['success'] != false;
  }

  // =========================
  // ERROR MESSAGE
  // =========================

  String _errorMessage(Map<String, dynamic> body) {
    return body['message']?.toString() ??
        body['error']?.toString() ??
        'Something went wrong. Please try again.';
  }

  // =========================
  // DECODE JSON
  // =========================

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.body.trim().isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }

      throw AuthException('Invalid server response.');
    } on FormatException {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        throw AuthException('Server returned invalid JSON.');
      }

      return {};
    }
  }

  // =========================
  // SAFE MAP CONVERSION
  // =========================

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw AuthException('Invalid response data.');
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await TokenStorage.deleteToken();
  }
}
