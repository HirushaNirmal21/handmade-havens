import 'package:bead_beauty/utils/backgroundgradient.dart';
import 'package:bead_beauty/widgets/cartpage/buildodersummerycard.dart';
import 'package:bead_beauty/widgets/cartpage/cartitem.dart';
import 'package:bead_beauty/widgets/cartpage/cartitemlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktopOrTablet = screenWidth > 768;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Shopping Cart 🛒",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          child: Consumer<CartController>(
            builder: (context, cartController, child) {
              final cartItems = cartController.cartItems;

              if (cartItems.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Your cart is empty!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktopOrTablet ? 1100 : double.infinity,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: isDesktopOrTablet
                      ? _buildDesktopLayout(
                          cartController,
                        ) // 💻 Web / Tablet UI
                      : _buildMobileLayout(cartController),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(CartController cart) {
    return Column(
      children: [
        Expanded(child: buildCartItemsList(cart)),
        const SizedBox(height: 16),
        buildOrderSummaryCard(cart),
      ],
    );
  }

  Widget _buildDesktopLayout(CartController cart) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: buildCartItemsList(cart)),
        const SizedBox(width: 24),
        Expanded(flex: 4, child: buildOrderSummaryCard(cart)),
      ],
    );
  }
}
