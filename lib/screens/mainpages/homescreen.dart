import 'dart:math';
import 'dart:ui';
import 'package:bead_beauty/models/productmodel.dart';
import 'package:bead_beauty/screens/admin/adminloginscreen.dart';
import 'package:bead_beauty/screens/mainpages/aboutusscreen.dart';
import 'package:bead_beauty/screens/mainpages/cartscreen.dart';
import 'package:bead_beauty/services/productservice.dart';
import 'package:bead_beauty/utils/backgroundgradient.dart';
import 'package:bead_beauty/widgets/cartpage/cartitem.dart';
import 'package:bead_beauty/widgets/homepage/catogery.dart';
import 'package:bead_beauty/widgets/homepage/drawer.dart';
import 'package:bead_beauty/widgets/homepage/footer.dart';
import 'package:bead_beauty/widgets/homepage/herosection.dart';
import 'package:bead_beauty/widgets/cartpage/meet.dart';
import 'package:bead_beauty/widgets/homepage/productcard.dart';
import 'package:bead_beauty/widgets/cartpage/reviewinster.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  String searchQuery = "";
  String selectedCategory = "All Items";
  int cartCount = 0;
  String sortBy = "Default";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchAllProducts();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void addToCart(Product product) {
    setState(() {
      cartCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} added to cart!"),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFFFF4D79),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 800;
    int crossAxisCount = screenWidth > 1200 ? 4 : (screenWidth > 800 ? 3 : 2);

    final productProvider = context.watch<ProductProvider>();
    List<Product> displayProducts = List.from(productProvider.products);

    // 1. Category Filter
    if (selectedCategory != "All Items") {
      displayProducts = displayProducts.where((product) {
        return product.category != null &&
            product.category!.toLowerCase() == selectedCategory.toLowerCase();
      }).toList();
    }

    // 2. Search Filter
    if (searchQuery.isNotEmpty) {
      displayProducts = displayProducts.where((product) {
        return product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
      }).toList();
    }

    // 3. Sort Filter
    if (sortBy == "LowToHigh") {
      displayProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == "HighToLow") {
      displayProducts.sort((a, b) => b.price.compareTo(a.price));
    }

    return Scaffold(
      drawer: buildDrawer(context),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                backgroundColor: Colors.white.withOpacity(0.12),
                elevation: 0,

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "✨ Handmade Haven ✨",

                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 24 : 32,
                          letterSpacing: 1,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminLoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                actions: [
                  if (!isMobile) ...[
                    TextButton(
                      onPressed: () {
                        context.read<ProductProvider>().fetchAllProducts();
                      },
                      child: const Text(
                        "Home",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "About Us",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],

                  Consumer<CartController>(
                    builder: (context, cart, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartScreen(),
                                ),
                              );
                            },
                          ),
                          if (cart.totalItemsCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF4D79),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Center(
                                  child: Text(
                                    '${cart.totalItemsCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: gradientColors)),

          // ANIMATED BACKGROUND ELEMENTS
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  ...List.generate(8, (index) {
                    double progress =
                        (_animationController.value + (index * 0.15)) % 1.0;
                    double yPosition =
                        MediaQuery.of(context).size.height *
                        (1.1 - (progress * 1.2));
                    bool isLeft = index % 2 == 0;
                    double baseX = isLeft
                        ? (screenWidth * 0.08)
                        : (screenWidth * 0.88);
                    double xPosition = baseX + (sin(progress * pi * 4) * 30);
                    return Positioned(
                      left: isLeft ? xPosition : null,
                      right: !isLeft ? (screenWidth - xPosition) : null,
                      top: yPosition,
                      child: Opacity(
                        opacity: sin(progress * pi),
                        child: Transform.rotate(
                          angle: sin(progress * pi * 2) * 0.25,
                          child: Icon(
                            Icons.flutter_dash,
                            size: (index % 3 == 0) ? 28 : 22,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),

          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  PageHerosection(context, _scrollController),

                  buildSearchAndSortBar(),

                  Divider(color: Colors.white.withOpacity(0.2), thickness: 1),

                  Catogery(
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) {
                      onCategoryChanged(category);
                    },
                  ),
                  const SizedBox(height: 30),

                  // 📦 PRODUCT GRID SECTION
                  productProvider.isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : displayProducts.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              "No products found",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 8,
                            bottom: 40,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                                childAspectRatio: 0.68,
                              ),
                          itemCount: displayProducts.length,
                          itemBuilder: (context, index) {
                            final product = displayProducts[index];
                            return ProductCard(
                              product: product,
                              onAddToCart: () => addToCart(product),
                            );
                          },
                        ),

                  buildMeetTheMaker(context),
                  buildReviewsAndInstagram(context),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }

  Widget buildSearchAndSortBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: TextField(
                  onChanged: (value) => onSearchChanged(value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search creations...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white.withOpacity(0.08),
              child: DropdownButton<String>(
                value: sortBy,
                dropdownColor: Colors.purple.shade900.withOpacity(0.9),
                icon: const Icon(Icons.sort, color: Colors.white),
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: "Default", child: Text("Default")),
                  DropdownMenuItem(
                    value: "LowToHigh",
                    child: Text("Price: Low to High"),
                  ),
                  DropdownMenuItem(
                    value: "HighToLow",
                    child: Text("Price: High to Low"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    sortBy = value ?? "Default";
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
