import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/order.dart';
import 'token_storage.dart';

class OrderApiException implements Exception {
  const OrderApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OrderItemRequest {
  const OrderItemRequest({required this.foodItemId, required this.quantity});

  final String foodItemId;
  final int quantity;

  Map<String, dynamic> toJson() => {
    'foodItemId': foodItemId,
    'quantity': quantity,
  };
}

class OrderService {
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<Order>> fetchMyOrders() async {
    final response = await _request(
      (headers) =>
          http.get(Uri.parse('${ApiConfig.orders}/mine'), headers: headers),
    );
    final data = _dataMap(response);
    final orders = data['orders'];
    if (orders is! List) {
      throw const OrderApiException(
        'The server returned an invalid order list.',
      );
    }

    return orders.map((order) {
      if (order is! Map) {
        throw const OrderApiException('The server returned an invalid order.');
      }
      return Order.fromJson(Map<String, dynamic>.from(order));
    }).toList();
  }

  Future<Order> createOrder({
    required String restaurantId,
    required List<OrderItemRequest> items,
  }) async {
    final response = await _request(
      (headers) => http.post(
        Uri.parse(ApiConfig.orders),
        headers: headers,
        body: jsonEncode({
          'restaurantId': restaurantId,
          'items': items.map((item) => item.toJson()).toList(),
        }),
      ),
      jsonBody: true,
    );
    final order = _dataMap(response)['order'];
    if (order is! Map) {
      throw const OrderApiException('The server returned an invalid order.');
    }
    return Order.fromJson(Map<String, dynamic>.from(order));
  }

  Future<Map<String, dynamic>> _request(
    Future<http.Response> Function(Map<String, String> headers) send, {
    bool jsonBody = false,
  }) async {
    final token = await TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const OrderApiException('Please log in to access your orders.');
    }

    try {
      final response = await send({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        if (jsonBody) 'Content-Type': 'application/json',
      }).timeout(_timeout);
      final body = _decodeResponse(response);
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          body['success'] == false) {
        throw OrderApiException(
          body['message']?.toString() ?? 'Could not load order information.',
        );
      }
      return body;
    } on TimeoutException {
      throw const OrderApiException(
        'The order request timed out. Please try again.',
      );
    } on http.ClientException {
      throw const OrderApiException('Unable to connect to the order server.');
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.body.trim().isEmpty) return {};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        throw const OrderApiException(
          'The order server returned invalid JSON.',
        );
      }
      return {};
    }
    throw const OrderApiException(
      'The order server returned an invalid response.',
    );
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const OrderApiException('The order server returned invalid data.');
  }
}
