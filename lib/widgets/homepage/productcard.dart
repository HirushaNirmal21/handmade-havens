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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        8.0,
                      ), // Padding slightly reduced
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        _buildStockIndicator(actualStock),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool isSmall = constraints.maxWidth < 150;
                            return isSmall
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rs. ${widget.product.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      _buildActionButtons(
                                        cartController,
                                        actualStock,
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Rs. ${widget.product.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      _buildActionButtons(
                                        cartController,
                                        actualStock,
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(CartController cartController, int actualStock) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          icon: Icon(
            widget.product.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.product.isLiked ? Colors.red : Colors.white70,
            size: 20,
          ),
          onPressed: () => cartController.toggleLikeProduct(widget.product),
        ),
        Text(
          "${widget.product.likeCount}",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: actualStock > 0
              ? () {
                  cartController.addToCart(widget.product);
                  widget.onAddToCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Added to cart!"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_cart,
              color: actualStock > 0 ? Colors.white : Colors.white38,
              size: 20,
            ),
          ),
        ),
      ],
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
