import 'package:flutter/material.dart';

Widget buildMeetTheMaker(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  bool isMobile = screenWidth < 800;

  List<Widget> contents = [
    ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.asset(
        'meet.jpeg',
        width: isMobile ? double.infinity : 600,
        height: 350,
        fit: BoxFit.cover,
      ),
    ),
    const SizedBox(width: 40, height: 20),
    Expanded(
      flex: isMobile ? 0 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Meet the Maker ✨",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Hi, I'm Timashi Manawadu,Every piece at Bead Beauty is lovingly handcrafted to bring beauty, elegance, and joy into your everyday life. Inspired by soft colors, delicate flowers, and timeless designs, each creation is made with patience and attention to every detail. Thank you for supporting handmade art and being part of the Bead Beauty journey. 💖",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    ),
  ];

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    ),
    child: isMobile ? Column(children: contents) : Row(children: contents),
  );
}
