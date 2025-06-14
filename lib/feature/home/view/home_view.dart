import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:mind_bridge/feature/task_view/features/home/presentation/screens/home_screen.dart';

import 'widgets/templete_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology, color: theme.colorScheme.secondary),
            SizedBox(width: 8),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Mind Bridge',
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                  ),
                  colors: [
                    Colors.white,
                    theme.colorScheme.secondary,
                    Colors.white,
                  ],
                ),
              ],
              isRepeatingAnimation: true,
              totalRepeatCount: 3,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: Column(
          children: [
            <Widget>[
              templateWidget(),
              TaskView(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/user1.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Jeevan Kushwaha',
                      style: theme.textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Learning Progress: 70%',
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.secondary,
                      ),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ][currentPageIndex],
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildBottomNavigation() {
    final theme = Theme.of(context);
    
    return ConvexAppBar(
      style: TabStyle.fixed,
      
      curve: Curves.easeInOut,
      shadowColor: Colors.black38,
      backgroundColor: theme.colorScheme.primary,
      activeColor: Colors.white,
      
      height: 60,
      elevation: 8,
      cornerRadius: 20,
      items: [
        TabItem(
          icon: FontAwesomeIcons.house,
          title: 'Home',
          activeIcon: Icon(
            FontAwesomeIcons.house,
            color: Colors.white,
            size: 26,
          ),
        ),
        TabItem(
          icon: FontAwesomeIcons.gamepad,
          title: 'Games',
          activeIcon: Icon(
            FontAwesomeIcons.gamepad,
            color: Colors.white,
            size: 26,
          ),
        ),
        TabItem(
          icon: FontAwesomeIcons.user,
          title: 'Profile',
          activeIcon: Icon(
            FontAwesomeIcons.user,
            color: Colors.white,
            size: 26,
          ),
        ),
      ],
      initialActiveIndex: currentPageIndex,
      onTap: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }
}
//
