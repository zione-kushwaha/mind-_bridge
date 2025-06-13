import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_bridge/feature/orientation_test/provider/request_response.dart' as img;
import 'package:confetti/confetti.dart';

class OrientationView extends ConsumerStatefulWidget {
  static const routeName = '/orientationView';
  const OrientationView({super.key});

  @override
  ConsumerState<OrientationView> createState() => _OrientationViewState();
}

class _OrientationViewState extends ConsumerState<OrientationView>
    with SingleTickerProviderStateMixin {
  String currentLetter = 'a';
  List<int> randomizedIndices = List.generate(9, (index) => index);
  final Random random = Random();
  Map<int, bool?> imageStates = {};
  bool correctResponseSelected = false;
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ConfettiController _confettiController;
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    _speak(currentLetter);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.2);
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.speak(text);
  }

  void randomizeIndices() {
    setState(() {
      randomizedIndices.shuffle(random);
      imageStates.clear();
      correctResponseSelected = false;
      _showCelebration = false;
    });
  }

  void onNext() {
    _animationController.reverse().then((_) {
      setState(() {
        currentLetter = String.fromCharCode(currentLetter.codeUnitAt(0) + 1);
        randomizeIndices();
        _speak(currentLetter);
      });
    });
  }

  void onTryAgain() {
    _animationController.reverse().then((_) {
      randomizeIndices();
    });
  }

  void _handleImageTap(int index, bool isCorrect) {
    if (correctResponseSelected) return;

    setState(() {
      imageStates[randomizedIndices[index]] = isCorrect;
      if (isCorrect) {
        correctResponseSelected = true;
        _showCelebration = true;
        _confettiController.play();
        _animationController.forward();
      }
    });
  }

  Widget _buildCelebration() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 5,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.2,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
            // Celebration message
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                transform: Matrix4.identity()..scale(_showCelebration ? 1.0 : 0.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9],
                    tileMode: TileMode.clamp,
                    transform: GradientRotation(pi / 4),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Awesome!',
                        style: GoogleFonts.fredoka(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black38,
                              offset: Offset(2, 2),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.amber,
                        size: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenHeight > screenWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        title: Text(
          'Letter Adventure',
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline_rounded, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.tertiary.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'How to Play',
                          style: GoogleFonts.fredoka(
                            fontSize: 28,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildHelpStep(
                          Icons.search,
                          'Find the image',
                          'that starts with "${currentLetter.toUpperCase()}"',
                          theme.colorScheme.primary,
                        ),
                        SizedBox(height: 15),
                        _buildHelpStep(
                          Icons.touch_app,
                          'Tap the image',
                          'to select your answer',
                          theme.colorScheme.secondary,
                        ),
                        SizedBox(height: 15),
                        _buildHelpStep(
                          Icons.arrow_forward,
                          'Click "Next Letter"',
                          'to continue the adventure',
                          theme.colorScheme.tertiary,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            shadowColor: theme.colorScheme.primary.withOpacity(0.5),
                          ),
                          child: Text(
                            'Let\'s Play!',
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background with decorative elements
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.05),
                  theme.colorScheme.background,
                ],
              ),
            ),
            child: CustomPaint(
              painter: _BackgroundPainter(),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isPortrait ? screenWidth * 0.05 : screenWidth * 0.1,
                vertical: isPortrait ? 0 : screenHeight * 0.05,
              ),
              child: Column(
                children: [
                  SizedBox(height: isPortrait ? screenHeight * 0.02 : 0),
                  // Letter search card
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    transform: Matrix4.identity()..scale(_animation.value * 0.2 + 0.8),
                    child: Container(
                      width: isPortrait ? screenWidth * 0.9 : screenWidth * 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            Color(0xFF9E7BFF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: theme.colorScheme.secondary,
                            size: isPortrait ? screenHeight * 0.035 : screenHeight * 0.05,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Find the Letter ',
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontSize: isPortrait ? screenHeight * 0.025 : screenHeight * 0.04,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(isPortrait ? 8 : 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '${currentLetter.toUpperCase()}',
                              style: GoogleFonts.fredoka(
                                color: Colors.white,
                                fontSize: isPortrait ? screenHeight * 0.03 : screenHeight * 0.045,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isPortrait ? screenHeight * 0.03 : screenHeight * 0.02),
                  Expanded(
                    child: isPortrait
                        ? _buildPortraitLayout(screenHeight, screenWidth, theme)
                        : _buildLandscapeLayout(screenHeight, screenWidth, theme),
                  ),
                ],
              ),
            ),
          ),
          if (_showCelebration) _buildCelebration(),
        ],
      ),
    );
  }

  Widget _buildHelpStep(IconData icon, String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(double screenHeight, double screenWidth, ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.42,
          child: Consumer(
            builder: (context, ref, child) {
              final imgsAsyncValue = ref.watch(
                img.imageProcessorProvider(currentLetter),
              );
              return imgsAsyncValue.when(
                data: (imageResponse) {
                  final images = imageResponse.images;
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      
                    ),
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenHeight * 0.02,

                      mainAxisExtent: screenHeight * 0.125,
                    ),
                    itemBuilder: (context, index) {
                      final image = images[randomizedIndices[index]];
                      final imageState = imageStates[randomizedIndices[index]];

                      return GestureDetector(
                        onTap: () => _handleImageTap(index, image.isCorrect),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          transform: Matrix4.identity()
                            ..scale(imageState != null ? 1.05 : 1.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: imageState == null
                                  ? theme.colorScheme.primary.withOpacity(0.5)
                                  : imageState
                                      ? theme.colorScheme.tertiary
                                      : Colors.redAccent,
                              width: imageState == null ? 3 : 5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (imageState == null
                                    ? theme.colorScheme.primary.withOpacity(0.2)
                                    : imageState
                                        ? theme.colorScheme.tertiary.withOpacity(0.4)
                                        : Colors.redAccent.withOpacity(0.3)),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Image
                                Image.network(
                                  image.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary.withOpacity(0.1),
                                            theme.colorScheme.secondary.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: theme.colorScheme.primary,
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                // Overlay for selected state
                                if (imageState != null)
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: imageState
                                            ? [
                                                theme.colorScheme.tertiary.withOpacity(0.7),
                                                Color(0xFF8BC34A).withOpacity(0.7),
                                              ]
                                            : [
                                                Colors.redAccent.withOpacity(0.7),
                                                Colors.red[300]!.withOpacity(0.7),
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            imageState
                                                ? Icons.check_circle_outline
                                                : Icons.close_rounded,
                                            color: Colors.white,
                                            size: screenHeight * 0.06,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            imageState ? 'Correct!' : 'Try Again',
                                            style: GoogleFonts.fredoka(
                                              color: Colors.white,
                                              fontSize: screenHeight * 0.02,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                    strokeWidth: 3,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    'Error loading images',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        
        // Letter display with animation
        Row(
          
          children: [
            SizedBox(width: 0.1 * screenWidth,),
              GestureDetector(
              onTap: () {
                _speak(currentLetter);
                setState(() {
                  _animationController.reset();
                  _animationController.forward();
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      Color(0xFF9E7BFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_animation.value * 0.2),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: screenHeight * 0.05,
                          ),
                          // Sound waves animation
                          ...List.generate(3, (index) {
                            return Opacity(
                              opacity: (1 - _animation.value) * 0.6,
                              child: Container(
                                width: screenHeight * 0.05 *
                                    (1 + (_animation.value * (index + 1) * 0.5)),
                                height: screenHeight * 0.05 *
                                    (1 + (_animation.value * (index + 1) * 0.5)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(
                                        1 - (_animation.value * (index + 1) * 0.3),
                                  
                                    ))
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 0.1 * screenWidth,),
            Consumer(
              builder: (context, ref, child) {
                final imgsAsyncValue = ref.watch(
                  img.imageProcessorProvider(currentLetter),
                );
                return imgsAsyncValue.when(
                  data: (imageResponse) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: screenHeight * 0.18,
            
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Letter container
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.secondary,
                                width: 3,
                              ),
                            ),
                            child: Image.network(
                              imageResponse.characterImageUrl,
                              fit: BoxFit.contain,
                              height: screenHeight * 0.16,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: theme.colorScheme.primary,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          // Animated decorative elements
                          ...List.generate(6, (index) {
                            final angle = index * (pi * 2 / 6);
                            final radius = screenHeight * 0.13;
                            final x = radius * cos(angle);
                            final y = radius * sin(angle);
                            
                            return Positioned(
                              left: screenWidth * 0.5 + x,
                              top: screenHeight * 0.09 + y,
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _animation.value * 2 * pi,
                                    child: Icon(
                                      Icons.star,
                                      color: [
                                        theme.colorScheme.secondary,
                                        theme.colorScheme.tertiary,
                                        Colors.amber,
                                      ][index % 3],
                                      size: 12 + (8 * _animation.value),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                  loading: () => SizedBox(
                    height: screenHeight * 0.18,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  error: (error, stack) => SizedBox(
                    height: screenHeight * 0.18,
                    child: Center(
                      child: Text(
                        'Error loading letter',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            ),
            
          ],
        ),
     
      SizedBox(height: 0.04*screenHeight,),
        
        // Bottom controls
       
        
        // Action buttons
        Padding(
          padding: EdgeInsets.only(
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Try Again button
              ElevatedButton(
                onPressed: onTryAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.018,
                  ),
                  elevation: 5,
                  shadowColor: theme.colorScheme.secondary.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: screenHeight * 0.025,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Try Again',
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Next Letter button
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.018,
                  ),
                  elevation: 5,
                  shadowColor: theme.colorScheme.tertiary.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Next Letter',
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: screenHeight * 0.025,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(double screenHeight, double screenWidth, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image grid
        Expanded(
          flex: 3,
          child: Consumer(
            builder: (context, ref, child) {
              final imgsAsyncValue = ref.watch(
                img.imageProcessorProvider(currentLetter),
              );
              return imgsAsyncValue.when(
                data: (imageResponse) {
                  final images = imageResponse.images;
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: screenWidth * 0.02,
                      mainAxisSpacing: screenHeight * 0.02,
                    ),
                    itemBuilder: (context, index) {
                      final image = images[randomizedIndices[index]];
                      final imageState = imageStates[randomizedIndices[index]];

                      return GestureDetector(
                        onTap: () => _handleImageTap(index, image.isCorrect),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          transform: Matrix4.identity()
                            ..scale(imageState != null ? 1.05 : 1.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: imageState == null
                                  ? theme.colorScheme.primary.withOpacity(0.5)
                                  : imageState
                                      ? theme.colorScheme.tertiary
                                      : Colors.redAccent,
                              width: imageState == null ? 3 : 5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (imageState == null
                                    ? theme.colorScheme.primary.withOpacity(0.2)
                                    : imageState
                                        ? theme.colorScheme.tertiary.withOpacity(0.4)
                                        : Colors.redAccent.withOpacity(0.3)),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  image.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary.withOpacity(0.1),
                                            theme.colorScheme.secondary.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: theme.colorScheme.primary,
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if (imageState != null)
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: imageState
                                            ? [
                                                theme.colorScheme.tertiary.withOpacity(0.7),
                                                Color(0xFF8BC34A).withOpacity(0.7),
                                              ]
                                            : [
                                                Colors.redAccent.withOpacity(0.7),
                                                Colors.red[300]!.withOpacity(0.7),
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            imageState
                                                ? Icons.check_circle_outline
                                                : Icons.close_rounded,
                                            color: Colors.white,
                                            size: screenHeight * 0.06,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            imageState ? 'Correct!' : 'Try Again',
                                            style: GoogleFonts.fredoka(
                                              color: Colors.white,
                                              fontSize: screenHeight * 0.018,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    'Error loading images',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Right panel with letter and controls
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Letter display
              Consumer(
                builder: (context, ref, child) {
                  final imgsAsyncValue = ref.watch(
                    img.imageProcessorProvider(currentLetter),
                  );
                  return imgsAsyncValue.when(
                    data: (imageResponse) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: screenHeight * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.secondary,
                                  width: 3,
                                ),
                              ),
                              child: Image.network(
                                imageResponse.characterImageUrl,
                                fit: BoxFit.contain,
                                height: screenHeight * 0.33,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: theme.colorScheme.primary,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            // Decorative stars
                            ...List.generate(6, (index) {
                              final angle = index * (pi * 2 / 6);
                              final radius = screenHeight * 0.25;
                              final x = radius * cos(angle);
                              final y = radius * sin(angle);
                              
                              return Positioned(
                                left: screenWidth * 0.15 + x,
                                top: screenHeight * 0.175 + y,
                                child: AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _animation.value * 2 * pi,
                                      child: Icon(
                                        Icons.star,
                                        color: [
                                          theme.colorScheme.secondary,
                                          theme.colorScheme.tertiary,
                                          Colors.amber,
                                        ][index % 3],
                                        size: 16 + (10 * _animation.value),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                    loading: () => SizedBox(
                      height: screenHeight * 0.35,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    error: (error, stack) => SizedBox(
                      height: screenHeight * 0.35,
                      child: Center(
                        child: Text(
                          'Error loading letter',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.05),
              
              // Sound button
              GestureDetector(
                onTap: () {
                  _speak(currentLetter);
                  setState(() {
                    _animationController.reset();
                    _animationController.forward();
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        Color(0xFF9E7BFF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_animation.value * 0.2),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.volume_up_rounded,
                              color: Colors.white,
                              size: screenHeight * 0.08,
                            ),
                            // Sound waves animation
                            ...List.generate(3, (index) {
                              return Opacity(
                                opacity: (1 - _animation.value) * 0.6,
                                child: Container(
                                  width: screenHeight * 0.08 *
                                      (1 + (_animation.value * (index + 1) * 0.5)),
                                  height: screenHeight * 0.08 *
                                      (1 + (_animation.value * (index + 1) * 0.5)),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(
                                          1 - (_animation.value * (index + 1) * 0.3),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
           
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Try Again button
                  ElevatedButton(
                    onPressed: onTryAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      elevation: 5,
                                          shadowColor: theme.colorScheme.secondary.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: screenHeight * 0.025,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Try Again',
                          style: GoogleFonts.fredoka(
                            color: Colors.white,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  
                  // Next Letter button
                  ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.tertiary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      elevation: 5,
                      shadowColor: theme.colorScheme.tertiary.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next Letter',
                          style: GoogleFonts.fredoka(
                            color: Colors.white,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: screenHeight * 0.025,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw some decorative background elements
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.35,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw some random circles in the background
    final random = Random();
    for (var i = 0; i < 10; i++) {
      final circlePaint = Paint()
        ..color = Colors.primaries[i % Colors.primaries.length]
            .withOpacity(0.05)
        ..style = PaintingStyle.fill;

      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.5;
      final radius = random.nextDouble() * 50 + 20;

      canvas.drawCircle(Offset(x, y), radius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}