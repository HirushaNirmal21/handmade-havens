import 'package:bead_beauty/models/ordermodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  final String baseUrl = "https://bread-backend-vc53.onrender.com";

  Future<void> fetchAllOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/orders/all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        print("🎯 Backend එකෙන් ආපු Orders ගණන: ${data.length}");
        _orders = data.map((json) => OrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Order fetch error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> placeNewOrder(OrderModel order) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/orders/place'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(order.toJson()),
      );
      if (response.statusCode == 200) {
        await fetchAllOrders();
        return true;
      }
    } catch (error) {
      print("Order placing error: $error");
    }
    return false;
  }

  Future<void> completeOrder(int orderId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/orders/$orderId/complete'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        await fetchAllOrders();
      } else {
        throw Exception(
          "Failed to complete order. Status code: ${response.statusCode}",
        );
      }
    } catch (error) {
      print("Order completion error in Provider: $error");
      rethrow;
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/orders/$orderId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchAllOrders();
      } else {
        throw Exception(
          "Failed to delete order. Status code: ${response.statusCode}",
        );
      }
    } catch (error) {
      print("Order deletion error in Provider: $error");
      rethrow;
    }
  }
}
