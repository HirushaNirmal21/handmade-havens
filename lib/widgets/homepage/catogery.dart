import 'package:flutter/material.dart';
import 'dart:ui';

class Catogery extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const Catogery({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 600;

    final List<Widget> categoryChips = [
      _buildCategoryChip("All Items", selectedCategory == "All Items"),
      _buildCategoryChip("Bracelets", selectedCategory == "Bracelets"),
      _buildCategoryChip(
        "Rings Necklaces",
        selectedCategory == "Rings Necklaces",
      ),
      _buildCategoryChip(
        "Other Accessories",
        selectedCategory == "Other Accessories",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: isLargeScreen
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categoryChips,
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: categoryChips),
            ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.9)
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: InkWell(
              onTap: () {
                onCategorySelected(label);
              },
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFFF4D79)
                        : Colors.white.withOpacity(0.9),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
