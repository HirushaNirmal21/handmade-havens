import 'package:flutter/material.dart';

const gradientColors = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFF4D79), Color(0xFFFF7597), Color(0xFFFFF0F3)],
);

final gradient2 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.white.withOpacity(0.6),
    Colors.white.withOpacity(0.1), 
    const Color(
      0xFFFFD700,
    ).withOpacity(0.4),
  ],
  stops: const [0.0, 0.5, 1.0],
);
