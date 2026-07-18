import 'package:bead_beauty/models/productmodel.dart';
import 'package:bead_beauty/screens/productdetails.dart';
import 'package:bead_beauty/widgets/cartpage/cartitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartController, child) {
        int actualStock = widget.product.stockQuantity;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(product: widget.product),
              ),
            );
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()..translate(0, isHovered ? -8 : 0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isHovered ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isHovered ? 0.15 : 0.04),
                    blurRadius: isHovered ? 30 : 20,
                    offset: Offset(0, isHovered ? 12 : 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedScale(
                              scale: isHovered ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child:
                                  widget.product.imageUrl != null &&
                                      widget.product.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      widget.product.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Container(
                                      color: Colors.white10,
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.white30,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            _buildStockIndicator(actualStock),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //  Price
                                Text(
                                  "Rs. ${widget.product.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                //  Like Section
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: Icon(
                                        widget.product.isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: widget.product.isLiked
                                            ? Colors.red
                                            : Colors.white70,
                                      ),
                                      onPressed: () {
                                        cartController.toggleLikeProduct(
                                          widget.product,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${widget.product.likeCount}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                InkWell(
                                  onTap: actualStock > 0
                                      ? () {
                                          cartController.addToCart(
                                            widget.product,
                                          );
                                          widget.onAddToCart();

                                          ScaffoldMessenger.of(
                                            context,
                                          ).clearSnackBars();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "✨ ${widget.product.name} added to cart!",
                                              ),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                    255,
                                                    241,
                                                    67,
                                                    194,
                                                  ),
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      : null,
                                  customBorder: const CircleBorder(),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: actualStock > 0
                                          ? Colors.transparent
                                          : Colors.white.withOpacity(0.05),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: actualStock > 0
                                            ? Colors.white
                                            : Colors.white38,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStockIndicator(int stock) {
    if (stock == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          "Out of Stock 🚫",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (stock <= 5) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orangeAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "🔥 Only $stock left! Hurry up",
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Text(
        "Stock: $stock left",
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }
}
