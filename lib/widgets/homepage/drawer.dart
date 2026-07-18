import 'package:bead_beauty/screens/mainpages/aboutusscreen.dart';
import 'package:bead_beauty/screens/mainpages/cartscreen.dart';
import 'package:bead_beauty/widgets/cartpage/cartitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: const Color(0xFFFF4D79),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF4D79), Color(0xFFFF7597)],
        ),
      ),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                "✨ Bead Beauty ✨",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home, color: Colors.white, size: 24),
            title: const Text(
              "Home",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () => Navigator.pop(context),
          ),

          ListTile(
            leading: const Icon(Icons.info, color: Colors.white, size: 24),
            title: const Text(
              "About Us",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            },
          ),

          Consumer<CartController>(
            builder: (context, cart, child) {
              return ListTile(
                leading: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 24,
                ),
                title: Text(
                  "Cart (${cart.totalItemsCount})",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
