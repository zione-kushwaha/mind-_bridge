import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/image_data_data.dart';
import 'image_data_widget.dart';

class templateWidget extends StatefulWidget {
  @override
  _templateWidgetState createState() => _templateWidgetState();
}

class _templateWidgetState extends State<templateWidget> with SingleTickerProviderStateMixin {
  final pageController = PageController(viewportFraction: 0.85);
  int pageIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Add haptic feedback when changing pages
    pageController.addListener(() {
      if (pageController.page?.round() != pageIndex) {
        HapticFeedback.lightImpact();
      }
    });
    
    // Create bouncing animation for welcome text
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(_animation),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/user1.png'),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Jeevan! 👋',
                          style: GoogleFonts.fredoka(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Ready to learn today?',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Pick an activity:',
                style: GoogleFonts.fredoka(
                  fontSize: 18, 
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.63,
          child: PageView.builder(
            controller: pageController,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return LocationWidget(location: location);
            },
            onPageChanged: (index) => setState(() => pageIndex = index),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              locations.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 10,
                width: pageIndex == index ? 24 : 10,
                decoration: BoxDecoration(
                  color: pageIndex == index
                      ? theme.colorScheme.secondary
                      : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        Text(
          'Swipe to see more!',
          style: GoogleFonts.fredoka(
            fontSize: 14,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8)
      ],
    );
  }
}
