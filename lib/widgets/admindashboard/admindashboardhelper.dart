import 'package:bead_beauty/models/ordermodel.dart';
import 'package:bead_beauty/services/productservice.dart';
import 'package:bead_beauty/widgets/admindashboard/builddialoginfo.dart';
import 'package:flutter/material.dart';
import 'package:bead_beauty/services/orderservice.dart';
import 'package:bead_beauty/widgets/admindashboard/showsnackbar.dart';
import 'package:provider/provider.dart';

class Admindashboardhelper {
  Future<void> handleDeleteOrder(BuildContext context, int orderId) async {
    try {
      await Provider.of<OrderProvider>(
        context,
        listen: false,
      ).deleteOrder(orderId);
      showSnackBar(context, "Order Deleted Successfully!", Colors.green);
    } catch (e) {
      showSnackBar(context, "Error deleting order: $e", Colors.redAccent);
    }
  }

  void showOrderDetailsDialog(BuildContext context, OrderModel order) {
    final currentStatus = order.orderStatus.toLowerCase();
    final isPending = currentStatus == "pending";

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFF1493).withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "📄 Order Receipt #${order.id ?? 'N/A'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white60),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 20),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isPending
                            ? Colors.amber.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isPending ? Colors.amber : Colors.greenAccent,
                        ),
                      ),
                      child: Text(
                        order.orderStatus.toUpperCase(),
                        style: TextStyle(
                          color: isPending ? Colors.amber : Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Customer Details Box
                    buildDialogInfoBox(
                      title: "CUSTOMER DETAILS",
                      titleColor: const Color(0xFFFF1493),
                      children: [
                        Text(
                          "👤 Name: ${order.customerName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "📞 Phone: ${order.phoneNumber}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "📍 Address: ${order.deliveryAddress}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    buildDialogInfoBox(
                      title: "ORDERED ITEMS",
                      titleColor: Colors.amberAccent,
                      children: [
                        Text(
                          order.orderItems.isNotEmpty
                              ? order.orderItems
                              : "No items specified",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Summary Box
                    buildDialogInfoBox(
                      title: "TOTAL INVOICE",
                      titleColor: Colors.cyanAccent,
                      children: [
                        Text(
                          "📅 Date: ${order.orderDate ?? 'Just now'}",
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Payable:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rs. ${order.totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Color(0xFFFF1493),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isPending) ...[
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if (order.id != null)
                                _handleCompleteOrder(context, order.id!);
                            },
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text("Complete"),
                          ),
                          const SizedBox(width: 8),
                        ],
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showOrderDeleteConfirmDialog(context, order);
                          },
                          icon: const Icon(Icons.delete_outline, size: 16),
                          label: const Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOrderDeleteConfirmDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Delete Order?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to permanently delete Order #${order.id}?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              if (order.id != null)
                Admindashboardhelper().handleDeleteOrder(context, order.id!);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCompleteOrder(BuildContext context, int orderId) async {
    try {
      await Provider.of<OrderProvider>(
        context,
        listen: false,
      ).completeOrder(orderId);
      showSnackBar(context, "Order Marked as Completed!", Colors.green);
    } catch (e) {
      showSnackBar(context, "Error completing order: $e", Colors.redAccent);
    }
  }

  Future<void> handleDeleteProduct(int productId, BuildContext context) async {
    try {
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).deleteProduct(productId);
      showSnackBar(context, "Product Deleted Successfully!", Colors.green);
    } catch (e) {
      showSnackBar(context, "Error deleting product: $e", Colors.redAccent);
    }
  }
}
