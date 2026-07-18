import 'package:bead_beauty/models/productmodel.dart';
import 'package:bead_beauty/screens/mainpages/cartscreen.dart';
import 'package:bead_beauty/utils/backgroundgradient.dart';
import 'package:bead_beauty/widgets/cartpage/cartitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktopOrTablet = screenWidth > 768;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: gradientColors),
        child: SafeArea(
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isDesktopOrTablet ? 1100 : double.infinity,
              ),
              padding: const EdgeInsets.all(16.0),
              child: isDesktopOrTablet
                  ? _buildDesktopLayout(context, product)
                  : _buildMobileLayout(context, product),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Product product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(product, height: 350),
          const SizedBox(height: 20),
          _buildDetailsCard(context, product),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Product product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildProductImage(product, height: 500)),
        const SizedBox(width: 24),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: _buildDetailsCard(context, product),
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage(Product product, {required double height}) {
    return Hero(
      tag: product.id,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(
              product.imageUrl ?? 'https://via.placeholder.com/400',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, Product product) {
    int stock = product.stockQuantity;
    bool isAvailable = stock > 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rs. ${product.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF1493),
                ),
              ),

              // ⚡ Detail Page Stock Badge
              _buildDetailedPageStockBadge(stock),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          const Text(
            "Description",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),

          Row(
            children: [
              // 1. Add to Cart Button
              Expanded(
                child: OutlinedButton(
                  onPressed: isAvailable
                      ? () {
                          Provider.of<CartController>(
                            context,
                            listen: false,
                          ).addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.name} added to cart!"),
                              backgroundColor: const Color(0xFFFF69B4),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isAvailable
                          ? const Color(0xFFFF1493)
                          : Colors.grey,
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isAvailable ? "Add to Cart" : "Out of Stock",
                    style: TextStyle(
                      color: isAvailable
                          ? const Color(0xFFFF1493)
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 2. Buy Now Button
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable
                        ? const Color(0xFFFF1493)
                        : Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: isAvailable ? 2 : 0,
                  ),
                  onPressed: isAvailable
                      ? () {
                          Provider.of<CartController>(
                            context,
                            listen: false,
                          ).addToCart(product);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    isAvailable ? "Buy Now 🛍️" : "Sold Out 🚫",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedPageStockBadge(int stock) {
    if (stock == 0) {
      return Chip(
        avatar: const Icon(
          Icons.do_not_disturb_on,
          color: Colors.red,
          size: 18,
        ),
        label: const Text(
          "Out of Stock",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red.shade50,
        side: BorderSide(color: Colors.red.shade200),
      );
    } else if (stock <= 5) {
      return Chip(
        avatar: const Icon(Icons.whatshot, color: Colors.orange, size: 18),
        label: Text(
          "Hurry! Only $stock Left",
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange.shade50,
        side: BorderSide(color: Colors.orange.shade200),
      );
    } else {
      return Chip(
        avatar: const Icon(Icons.check_circle, color: Colors.green, size: 18),
        label: Text(
          "In Stock ($stock)",
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade50,
        side: BorderSide(color: Colors.green.shade200),
      );
    }
  }
}
