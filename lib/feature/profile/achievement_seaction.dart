import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, 
                      color: colorScheme.primary, 
                      size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Achievements',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAchievementBadge(
                      context,
                      'A',
                      'Alphabet Ace',
                      true,
                      colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    _buildAchievementBadge(
                      context,
                      'B',
                      'Brilliant Beginner',
                      true,
                      colorScheme.secondary,
                    ),
                    const SizedBox(width: 16),
                    _buildAchievementBadge(
                      context,
                      'C',
                      'Clever Learner',
                      true,
                      colorScheme.tertiary,
                    ),
                    const SizedBox(width: 16),
                    _buildAchievementBadge(
                      context,
                      'D',
                      'Daring Discoverer',
                      false,
                      Colors.grey,
                    ),
                    const SizedBox(width: 16),
                    _buildAchievementBadge(
                      context,
                      'E',
                      'Excellent Explorer',
                      false,
                      Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(
    BuildContext context,
    String letter,
    String title,
    bool unlocked,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: unlocked ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: unlocked ? color : Colors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: unlocked
                ? Text(
                    letter,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  )
                : Icon(Icons.lock, color: Colors.grey, size: 32),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: unlocked ? FontWeight.w500 : FontWeight.normal,
              color: unlocked ? color : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}