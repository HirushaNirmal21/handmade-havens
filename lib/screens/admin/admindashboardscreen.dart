import 'package:bead_beauty/models/ordermodel.dart';
import 'package:bead_beauty/models/productmodel.dart';
import 'package:bead_beauty/services/orderservice.dart';
import 'package:bead_beauty/services/productservice.dart';
import 'package:bead_beauty/services/reviewservice.dart';
import 'package:bead_beauty/widgets/admindashboard/admindashboardhelper.dart';
import 'package:bead_beauty/widgets/admindashboard/buildsummerycard.dart';
import 'package:bead_beauty/widgets/admindashboard/showsnackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedSection = 0;
  final List<String> _categories = ["Bangles", "Rings", "Necklaces"];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
      Provider.of<OrderProvider>(context, listen: false).fetchAllOrders();
      Provider.of<ReviewProvider>(context, listen: false).fetchReviews();
    });
  }

  Future<void> _handleSaveProduct(dynamic product, bool isEditing) async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    try {
      if (isEditing) {
        await provider.updateProduct(product);
        showSnackBar(context, "Product Updated Successfully!", Colors.green);
      } else {
        await provider.addNewProduct(product);
        showSnackBar(context, "Product Added Successfully!", Colors.green);
      }
    } catch (e) {
      showSnackBar(context, "Error saving product: $e", Colors.redAccent);
    }
  }

  void _showDeleteConfirmDialog(dynamic product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Delete Product?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete '${product.name}'?",
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
              Admindashboardhelper().handleDeleteProduct(product.id, context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    final bool currentLoading = (_selectedSection == 0 || _selectedSection == 1)
        ? orderProvider.isLoading
        : productProvider.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          "🛒 Admin Control Panel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              productProvider.fetchAllProducts();
              orderProvider.fetchAllOrders();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Row(
            children: [
              if (isDesktop) ...[
                Container(
                  width: 240,
                  color: const Color(0xFF16213E),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildSidebarItem(
                        0,
                        "Live Orders 🔔",
                        Icons.notifications_active,
                      ),
                      _buildSidebarItem(1, "Order History 📜", Icons.history),
                      _buildSidebarItem(
                        2,
                        "Manage Products 📦",
                        Icons.inventory_2,
                      ),
                      _buildSidebarItem(3, "FeedBacks 💬", Icons.message),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1, color: Colors.white12),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: currentLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF1493),
                          ),
                        )
                      : Column(
                          children: [
                            buildSummaryCards(
                              context,
                              orderProvider,
                              productProvider,
                            ),
                            Expanded(
                              child: _buildSelectedSectionContent(
                                productProvider,
                                orderProvider,
                                reviewProvider,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
          if (productProvider.isSyncing)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                color: Color(0xFFFF1493),
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 4, 10, 28),
              selectedItemColor: const Color.fromARGB(255, 0, 170, 255),
              unselectedItemColor: const Color.fromARGB(153, 255, 0, 0),
              currentIndex: _selectedSection,
              onTap: (index) => setState(() => _selectedSection = index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active),
                  label: "Live Orders",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: "History",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2),
                  label: "Products",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: "FeedBacks",
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildSidebarItem(int index, String title, IconData icon) {
    final bool isSelected = _selectedSection == index;
    return Material(
      color: isSelected ? const Color(0xFF1F4068) : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFFFF1493) : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => setState(() => _selectedSection = index),
      ),
    );
  }

  Widget _buildSelectedSectionContent(
    ProductProvider productProvider,
    OrderProvider orderProvider,
    ReviewProvider reviewProvider,
  ) {
    switch (_selectedSection) {
      case 0:
        final List<OrderModel> liveOrders = orderProvider.orders
            .where((o) => o.orderStatus.toLowerCase() == "pending")
            .toList();
        return _buildOrdersSection("Live Orders", liveOrders);
      case 1:
        final List<OrderModel> historyOrders = orderProvider.orders
            .where((o) => o.orderStatus.toLowerCase() != "pending")
            .toList();
        return _buildOrdersSection("Order History", historyOrders);
      case 2:
        return _buildProductManagementSection(productProvider);
      case 3:
        return _buildFeedbackSection(reviewProvider);
      default:
        return const SizedBox();
    }
  }

  Widget _buildFeedbackSection(ReviewProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Customer Feedbacks",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: provider.reviews.length,
            itemBuilder: (context, index) {
              final review = provider.reviews[index];
              return Card(
                color: const Color(0xFF0F3460),
                child: ListTile(
                  title: Text(
                    review.authorName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    review.content,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => provider.deleteReview(review.id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductManagementSection(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Product Management",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1493),
              ),
              onPressed: () => _showProductDialog(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Product",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: provider.products.isEmpty
              ? const Center(
                  child: Text(
                    "No products found.",
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : ListView.builder(
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    final bool isLowStock = product.stockQuantity <= 5;

                    return Card(
                      color: const Color(0xFF0F3460),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading:
                            product.imageUrl != null &&
                                product.imageUrl!.isNotEmpty
                            ? Image.network(
                                product.imageUrl!,
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image,
                                  color: Colors.white24,
                                ),
                              )
                            : const Icon(Icons.image, color: Colors.white24),
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Price: Rs. ${product.price} | Category: ${product.category ?? 'N/A'}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isLowStock
                                  ? "⚠️ Low Stock: ${product.stockQuantity} remaining"
                                  : "Stock: ${product.stockQuantity}",
                              style: TextStyle(
                                color: isLowStock
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                fontWeight: isLowStock
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.cyanAccent,
                                size: 20,
                              ),
                              onPressed: () =>
                                  _showProductDialog(existingProduct: product),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () =>
                                  _showDeleteConfirmDialog(product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildOrdersSection(String title, List<OrderModel> ordersList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ordersList.isEmpty
              ? const Center(
                  child: Text(
                    "No orders found.",
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : ListView.builder(
                  itemCount: ordersList.length,
                  itemBuilder: (context, index) {
                    final order = ordersList[index];
                    final isPending =
                        order.orderStatus.toLowerCase() == "pending";

                    return Card(
                      color: const Color(0xFF0F3460),
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Admindashboardhelper()
                            .showOrderDetailsDialog(context, order),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order #${order.id ?? 'N/A'}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    order.orderStatus.toUpperCase(),
                                    style: TextStyle(
                                      color: isPending
                                          ? Colors.amber
                                          : Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white12, height: 16),
                              Text(
                                "👤 Customer: ${order.customerName}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "📞 Phone: ${order.phoneNumber}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.orderDate ?? "Just now",
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    "Rs. ${order.totalAmount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Color(0xFFFF1493),
                                      fontWeight: FontWeight.bold,
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
                ),
        ),
      ],
    );
  }

  void _showProductDialog({dynamic existingProduct}) {
    final isEditing = existingProduct != null;
    final nameController = TextEditingController(
      text: isEditing ? existingProduct.name : "",
    );
    final descController = TextEditingController(
      text: isEditing ? existingProduct.description : "",
    );
    final priceController = TextEditingController(
      text: isEditing ? existingProduct.price.toString() : "",
    );
    final stockController = TextEditingController(
      text: isEditing ? existingProduct.stockQuantity.toString() : "",
    );
    final imageController = TextEditingController(
      text: isEditing ? existingProduct.imageUrl ?? "" : "",
    );
    String selectedCat =
        (isEditing && _categories.contains(existingProduct.category))
        ? existingProduct.category!
        : _categories[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          title: Text(
            isEditing ? "✏️ Edit Product" : "➕ Add Product",
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: descController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: priceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Price",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: stockController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Stock Quantity",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: imageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Image URL",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedCat,
                  dropdownColor: const Color(0xFF16213E),
                  style: const TextStyle(color: Colors.white),
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedCat = val!),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1493),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  final updatedProduct = Product(
                    id: isEditing ? existingProduct.id : 0,
                    name: nameController.text,
                    description: descController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    stockQuantity: int.tryParse(stockController.text) ?? 0,
                    imageUrl: imageController.text.isEmpty
                        ? null
                        : imageController.text,
                    category: selectedCat,
                    likeCount: isEditing ? existingProduct.likeCount : 0,
                    isLiked: isEditing ? existingProduct.isLiked : false,
                  );
                  Navigator.pop(context);
                  _handleSaveProduct(updatedProduct, isEditing);
                }
              },
              child: Text(
                isEditing ? "Update" : "Add",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
