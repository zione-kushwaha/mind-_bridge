import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_bridge/feature/profile/achievement_seaction.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SingleChildScrollView(
      
       
        child: Column(
         
          children: [
            // Profile Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withOpacity(0.8),
                    colorScheme.primary.withOpacity(0.4),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.secondary,
                                colorScheme.tertiary,
                              ],
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/user1.png'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Jeevan Kushwaha',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ABC Learning Champion',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
        
            // Progress Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.school, color: colorScheme.primary, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'Learning Progress',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Container(
                            height: 16,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.tertiary,
                                  colorScheme.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '70%',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '15 of 26 letters learned',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showDetailedReport(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: Text(
                              'View Report',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            // Stats Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.insights, color: colorScheme.primary, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'Learning Stats',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildStatCard(
                            context,
                            'Days Streak',
                            '7',
                            Icons.local_fire_department,
                            colorScheme.secondary,
                          ),
                          _buildStatCard(
                            context,
                            'Letters Learned',
                            '15',
                            Icons.abc,
                            colorScheme.primary,
                          ),
                          _buildStatCard(
                            context,
                            'Words Mastered',
                            '30',
                            Icons.text_fields,
                            colorScheme.tertiary,
                          ),
                          _buildStatCard(
                            context,
                            'Perfect Scores',
                            '12',
                            Icons.star,
                            Colors.amber,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
       
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
      
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
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
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: unlocked ? FontWeight.w500 : FontWeight.normal,
            color: unlocked ? color : Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showDetailedReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Detailed Learning Report',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildReportSection(
                        context,
                        'Letters Learned',
                        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'],
                        ['K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T'],
                      ),
                      const SizedBox(height: 24),
                      _buildProgressChart(context),
                      const SizedBox(height: 24),
                      _buildActivityTimeline(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportSection(
      BuildContext context, String title, List<String> learned, List<String> remaining) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: learned
              .map((letter) => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      letter,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        Text(
          'Letters to Learn:',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: remaining
              .map((letter) => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      letter,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildProgressChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Progress',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Placeholder(), // Replace with actual chart widget
        ),
      ],
    );
  }

  Widget _buildActivityTimeline(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (index) => _buildTimelineItem(context, index)),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, int index) {
    final activities = [
      'Learned the letter B',
      'Practiced 10 words',
      'Completed Alphabet Game',
      'Earned Perfect Score',
      'Reached 7-day streak'
    ];
    final times = [
      '2 hours ago',
      'Yesterday',
      '2 days ago',
      '3 days ago',
      '1 week ago'
    ];
    final icons = [
      Icons.abc,
      Icons.text_fields,
      Icons.games,
      Icons.star,
      Icons.local_fire_department
    ];
    final colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Colors.amber,
      Colors.deepOrange
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors[index].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icons[index], color: colors[index], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activities[index],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  times[index],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}