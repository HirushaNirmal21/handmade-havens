import 'package:bead_beauty/widgets/cartpage/cartitem.dart';
import 'package:flutter/material.dart';

Widget buildCartItemsList(CartController cart) {
  return ListView.builder(
    itemCount: cart.cartItems.length,
    itemBuilder: (context, index) {
      final item = cart.cartItems[index];

      bool isStockLimitReached = item.quantity >= item.product.stockQuantity;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9), // Glassmorphic look
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.product.imageUrl ?? 'https://via.placeholder.com/100',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Name & Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rs. ${item.product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Color(0xFFFF1493),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Controls (+ / -)
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.grey,
                  ),
                  onPressed: () => cart.removeFromCart(item.product),
                ),
                Text(
                  "${item.quantity}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: isStockLimitReached
                        ? Colors.grey.withOpacity(0.4)
                        : const Color(0xFFFF1493),
                  ),
                  onPressed: () {
                    if (!isStockLimitReached) {
                      cart.addToCart(item.product);
                    } else {
                      // Stock එක ඉවර නම් Alert එකක් දෙනවා
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Sorry, only ${item.product.stockQuantity} items available in stock!",
                          ),
                          backgroundColor: Colors.amber[800],
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
