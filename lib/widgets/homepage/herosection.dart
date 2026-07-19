import 'dart:ui';

import 'package:flutter/material.dart';

Widget PageHerosection(
  BuildContext context,
  ScrollController scrollController,
) {
  final screenWidth = MediaQuery.of(context).size.width;

  return LayoutBuilder(
    builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 800;
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? screenWidth * 0.08 : 24,
          vertical: 40,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: isDesktop ? screenWidth * 0.45 : screenWidth - 48,
              child: Column(
                crossAxisAlignment: isDesktop
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Text(
                    "Handcrafted with Love,Just for You ✨",
                    textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop ? 48 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!isDesktop)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 280,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/back.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    "At Handmade Haven, we believe that every little bead tells a story.Our handmade bracelets, necklaces, earrings, and accessories are carefully crafted with premium-quality beads, creativity, and love.",
                    textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 15,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          side: const BorderSide(color: Colors.white30),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          scrollController.animateTo(
                            650.0,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          "Shop Now 🛍️",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isDesktop) const SizedBox(width: 40),

            if (isDesktop)
              Expanded(
                child: SizedBox(
                  height: 350,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/back.jpeg', fit: BoxFit.cover),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
