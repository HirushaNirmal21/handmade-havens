import 'dart:convert';
import 'package:bead_beauty/models/productmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  static const String apiBaseUrl =
      "https://bread-backend-vc53.onrender.com/api/products";

  List<Product> _products = [];
  bool _isLoading = false;
  bool _isSyncing = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;

  // 🔄 1. Fetch All Products
  Future<void> fetchAllProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(apiBaseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        _products = data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load products: Status ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ➕ 2. Add New Product
  Future<void> addNewProduct(Product product) async {
    _isSyncing = true;
    notifyListeners();

    try {
      // දැන් URL එක නිවැරදියි (POST /api/products)
      final response = await http.post(
        Uri.parse(apiBaseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final savedProduct = Product.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
        _products.add(savedProduct);
        notifyListeners();
      } else {
        throw Exception('Failed to add product: Status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    _isSyncing = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('$apiBaseUrl/${product.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        final updatedProduct = Product.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
        int index = _products.indexWhere((p) => p.id == updatedProduct.id);
        if (index != -1) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      } else {
        throw Exception(
          'Failed to update product: Status ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // Delete Product
  Future<void> deleteProduct(int productId) async {
    _isSyncing = true;
    notifyListeners();

    try {
      final response = await http.delete(Uri.parse('$apiBaseUrl/$productId'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        _products.removeWhere((p) => p.id == productId);
        notifyListeners();
      } else {
        throw Exception(
          'Failed to delete product: Status ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // Stock Reducer
  void reduceProductQuantity(dynamic productId, int quantityToReduce) {
    final int parsedId = productId is String
        ? int.tryParse(productId) ?? 0
        : productId as int;
    final productIndex = _products.indexWhere((p) => p.id == parsedId);

    if (productIndex != -1) {
      if (_products[productIndex].stockQuantity >= quantityToReduce) {
        _products[productIndex].stockQuantity -= quantityToReduce;
        notifyListeners();
      }
    }
  }
}
