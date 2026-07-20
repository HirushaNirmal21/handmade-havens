import 'package:flutter/material.dart';
import '../../models/productmodel.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    product: Product.fromJson(json['product']),
    quantity: json['quantity'],
  );
}

class CartController extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  // Getter
  List<CartItem> get cartItems => _cartItems;
  CartController() {
    loadCartFromDisk();
  }
  void toggleLikeProduct(Product product) {
    if (product.isLiked) {
      product.isLiked = false;
      product.likeCount--;
    } else {
      product.isLiked = true;
      product.likeCount++;
    }
    notifyListeners();
  }

  Future<void> loadCartFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartDataString = prefs.getString('user_cart');

      if (cartDataString != null) {
        final List<dynamic> decodedJson = jsonDecode(cartDataString);
        _cartItems = decodedJson
            .map((item) => CartItem.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading cart from disk: $e");
    }
  }

  Future<void> _saveCartToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedJson = jsonEncode(
        _cartItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('user_cart', encodedJson);
    } catch (e) {
      debugPrint("Error saving cart to disk: $e");
    }
  }

  int get totalItemsCount {
    int count = 0;
    for (var item in _cartItems) {
      count += item.quantity;
    }
    return count;
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      total += (item.product.price * item.quantity);
    }
    return total;
  }

  void addToCart(Product product) {
    if (product.stockQuantity <= 0) return;

    int index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      if (_cartItems[index].quantity < product.stockQuantity) {
        _cartItems[index].quantity++;
      }
    } else {
      _cartItems.add(CartItem(product: product.copyWith(), quantity: 1));
    }

    notifyListeners();
    _saveCartToDisk();
  }

  void incrementQuantity(Product product) {
    int index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      if (_cartItems[index].quantity <
          _cartItems[index].product.stockQuantity) {
        _cartItems[index].quantity++;
        notifyListeners();
        _saveCartToDisk();
      }
    }
  }

  void removeFromCart(Product product) {
    int index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
      _saveCartToDisk();
    }
  }

  Future<void> checkoutOrPlaceOrder() async {
    for (var item in _cartItems) {
      int newStock = item.product.stockQuantity - item.quantity;
      item.product = item.product.copyWith(stockQuantity: newStock);
    }

    _cartItems.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_cart');
  }

  void clearCart() async {
    _cartItems.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_cart');
  }

  void placeOrderAndReduceStock() {
    for (var cartItem in _cartItems) {
      if (cartItem.product.stockQuantity >= cartItem.quantity) {
        cartItem.product.stockQuantity -= cartItem.quantity;
      } else {
        cartItem.product.stockQuantity = 0;
      }
    }

    _cartItems.clear();
    _saveCartToDisk();
    notifyListeners();
  }
}
