import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/meditation_category.dart';
import '../widgets/meditation_category_card.dart';

class MeditationsHomeScreen extends StatelessWidget {
  const MeditationsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      const MeditationCategory(
        title: 'Beginner',
        imageUrl: 'assets/images/beginner.png',
      ),
      const MeditationCategory(
        title: 'Sleep',
        imageUrl: 'assets/images/sleep.png',
      ),
      const MeditationCategory(
        title: 'Anxiety',
        imageUrl: 'assets/images/anxiety.png',
      ),
      const MeditationCategory(
        title: 'Focus',
        imageUrl: 'assets/images/focus.png',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          'Meditations',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return MeditationCategoryCard(category: categories[index]);
          },
        ),
      ),
    );
  }
}
