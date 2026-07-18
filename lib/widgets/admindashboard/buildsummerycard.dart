import 'package:bead_beauty/services/orderservice.dart';
import 'package:bead_beauty/services/productservice.dart';
import 'package:flutter/material.dart';

Widget buildSummaryCards(
  BuildContext context,
  OrderProvider orderProvider,
  ProductProvider productProvider,
) {
  double totalIncome = orderProvider.orders
      .where((o) => o.orderStatus.toString().toLowerCase() == "completed")
      .fold(0.0, (sum, item) => sum + item.totalAmount);

  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: MediaQuery.of(context).size.width > 600 ? 2.8 : 3.8,
      children: [
        _buildCard(
          "Total Revenue 💰",
          "Rs. ${totalIncome.toStringAsFixed(2)}",
          Colors.greenAccent,
        ),
        _buildCard(
          "Total Orders 📦",
          "${orderProvider.orders.length} Orders",
          Colors.cyanAccent,
        ),
        _buildCard(
          "Store Products 💎",
          "${productProvider.products.length} Items",
          Colors.orangeAccent,
        ),
      ],
    ),
  );
}

Widget _buildCard(String title, String val, Color col) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF0F3460),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: col.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          val,
          style: TextStyle(
            color: col,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
