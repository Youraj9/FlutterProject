import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/food_item.dart';
import '../models/restaurant.dart';

class RestaurantApiException implements Exception {
  const RestaurantApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RestaurantService {
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await _get(Uri.parse(ApiConfig.restaurants));
    final data = _dataMap(response);
    return _parseList(data['restaurants'], Restaurant.fromJson);
  }

  Future<Restaurant> fetchRestaurant(String restaurantId) async {
    final uri = Uri.parse(
      '${ApiConfig.restaurants}/${Uri.encodeComponent(restaurantId)}',
    );
    final response = await _get(uri);
    final restaurant = _dataMap(response)['restaurant'];
    if (restaurant is! Map) {
      throw const RestaurantApiException(
        'The server returned invalid restaurant data.',
      );
    }
    return Restaurant.fromJson(Map<String, dynamic>.from(restaurant));
  }

  Future<List<FoodItem>> fetchMenu(
    String restaurantId, {
    String? category,
  }) async {
    final uri =
        Uri.parse(
          '${ApiConfig.restaurants}/${Uri.encodeComponent(restaurantId)}/menu',
        ).replace(
          queryParameters: category == null || category.trim().isEmpty
              ? null
              : {'category': category.trim()},
        );
    final response = await _get(uri);
    final data = _dataMap(response);
    return _parseList(data['foods'], FoodItem.fromJson);
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final response = await http
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(_timeout);
      final body = _decodeResponse(response);

      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          body['success'] == false) {
        throw RestaurantApiException(
          body['message']?.toString() ??
              'Could not load restaurant information.',
        );
      }

      return body;
    } on TimeoutException {
      throw const RestaurantApiException(
        'The restaurant request timed out. Please try again.',
      );
    } on http.ClientException {
      throw const RestaurantApiException(
        'Unable to connect to the restaurant server.',
      );
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.body.trim().isEmpty) return {};

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        throw const RestaurantApiException(
          'The restaurant server returned invalid JSON.',
        );
      }
      return {};
    }

    throw const RestaurantApiException(
      'The restaurant server returned an invalid response.',
    );
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const RestaurantApiException(
      'The restaurant server returned invalid data.',
    );
  }

  List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      throw const RestaurantApiException(
        'The restaurant server returned an invalid list.',
      );
    }

    return value.map((item) {
      if (item is! Map) {
        throw const RestaurantApiException(
          'The restaurant server returned an invalid list item.',
        );
      }
      return fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }
}
