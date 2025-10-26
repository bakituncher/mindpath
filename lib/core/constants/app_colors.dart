import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Doğa temalı, sakin tonlar
  static const Color primaryBeige = Color(0xFFF5F1E8);
  static const Color secondaryBeige = Color(0xFFE8DCC4);
  static const Color pastelBlue = Color(0xFFB8D4E8);
  static const Color pastelGreen = Color(0xFFA8C9A5);
  static const Color mintGreen = Color(0xFFBFD8BD);
  static const Color lavender = Color(0xFFD4C5E8);
  static const Color peach = Color(0xFFFFD9C0);

  // Neutral Colors
  static const Color darkGray = Color(0xFF4A4A4A);
  static const Color mediumGray = Color(0xFF8E8E8E);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAF9F6);

  // Accent Colors
  static const Color calmBlue = Color(0xFF7CA8C9);
  static const Color deepGreen = Color(0xFF5A7D5A);
  static const Color warmBrown = Color(0xFFA67C52);

  // Emotion Colors
  static const Color joyYellow = Color(0xFFFFF4CC);
  static const Color calmTeal = Color(0xFF9ED4D4);
  static const Color energyOrange = Color(0xFFFFB88C);
  static const Color peaceViolet = Color(0xFFC4B5E8);

  // Background Gradients
  static const LinearGradient morningGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFE8D6), Color(0xFFFFF4E6)],
  );

  static const LinearGradient eveningGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFB8D4E8), Color(0xFFE8DCC4)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A5568), Color(0xFF2D3748)],
  );

  static const LinearGradient meditationGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA8C9A5), Color(0xFFBFD8BD)],
  );
}

