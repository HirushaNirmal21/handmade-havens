import 'dart:convert';

import 'package:bead_beauty/widgets/cartpage/cartitem.dart';
import 'package:bead_beauty/widgets/cartpage/showcustomdetails.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildOrderSummaryCard(CartController cart) {
  return Builder(
    builder: (context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Order Summary 🧾",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Items",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "${cart.totalItemsCount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Rs. ${cart.totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    String itemsSummary = "";
                    for (var item in cart.cartItems) {
                      itemsSummary +=
                          "• ${item.quantity}x ${item.product.name} — Rs. ${(item.product.price * item.quantity).toStringAsFixed(2)}\n";
                    }

                    final List<Map<String, dynamic>> itemsList = cart.cartItems
                        .map<Map<String, dynamic>>(
                          (item) => {
                            'name': item.product.name,
                            'qty': item.quantity,
                            'price': item.product.price,
                          },
                        )
                        .toList();

                    final Map<String, dynamic> rawOrderJson = {
                      'customerName': "In-Cart Inquiry",
                      'totalAmount': cart.totalAmount,
                      'items': itemsList,
                    };
                    final String jsonRawData = jsonEncode(rawOrderJson);

                    String whatsappMessage =
                        "━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
                        " 🛒  *CART DETAILS INQUIRY*  🛒\n"
                        "━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
                        "📦 *ITEMS IN CART*\n"
                        "$itemsSummary\n"
                        "──────────────────────────\n"
                        "💰 *TOTAL AMOUNT : Rs. ${cart.totalAmount.toStringAsFixed(2)}*\n"
                        "──────────────────────────\n\n"
                        "🔗 *CART RAW DATA:*\n"
                        "```$jsonRawData```\n\n"
                        "━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
                        "Hi, I need more information about these items in my cart.\n"
                        "━━━━━━━━━━━━━━━━━━━━━━━━━━";

                    final String phone = "94757209765";
                    final String encodedMessage = Uri.encodeComponent(
                      whatsappMessage,
                    );
                    final Uri whatsappUrl = Uri.parse(
                      "https://api.whatsapp.com/send?phone=$phone&text=$encodedMessage",
                    );

                    if (await canLaunchUrl(whatsappUrl)) {
                      await launchUrl(
                        whatsappUrl,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  icon: const Icon(Icons.chat, color: Colors.greenAccent),
                  label: const Text(
                    "More Details via WhatsApp",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.greenAccent,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 🔘 BUTTON 2: Place Order (Generate QR)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => showCustomerDetailsDialog(context, cart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF1493),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Place Order (Generate QR) 📋",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
