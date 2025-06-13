import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_bridge/feature/orientation_test/provider/request_response.dart' as img;

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
  bool _showConfetti = false;

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
    _speak(currentLetter);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      _showConfetti = false;
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
        _showConfetti = true;
        _animationController.forward();
      }
    });
  }
  Widget _buildConfetti() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Confetti background
            Container(
              color: Colors.black.withOpacity(0.2),
            ),
            // Stars animation (simulated with widgets)
            ...List.generate(20, (index) {
              final random = Random();
              final top = random.nextDouble() * MediaQuery.of(context).size.height;
              final left = random.nextDouble() * MediaQuery.of(context).size.width;
              final size = random.nextDouble() * 20 + 10;
              
              return Positioned(
                top: top,
                left: left,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500 + random.nextInt(500)),
                  curve: Curves.easeOut,
                  transform: Matrix4.identity()
                    ..scale(_showConfetti ? 1.0 : 0.0)
                    ..rotateZ(_showConfetti ? random.nextDouble() * 6.28 : 0),
                  child: Icon(
                    Icons.star,
                    color: [
                      Colors.yellow,
                      Colors.amber,
                      Colors.orange,
                      Colors.red,
                      Colors.pink,
                      Colors.purple,
                    ][random.nextInt(6)],
                    size: size,
                  ),
                ),
              );
            }),
            // Celebration message
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                transform: Matrix4.identity()..scale(_showConfetti ? 1.0 : 0.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFF4CAF50)],
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
                        'Great Job!',
                        style: GoogleFonts.fredoka(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black38,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Icon(
                        Icons.thumb_up,
                        color: Colors.yellow,
                        size: 40,
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
  }@override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenHeight > screenWidth;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEFD1F9), // Light purple shade
                  Color(0xFFE4F1FE), // Light blue shade
                ],
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isPortrait ? screenWidth * 0.05 : screenWidth * 0.1,
              vertical: isPortrait ? 0 : screenHeight * 0.05,
            ),
            child: Column(
              children: [
                SizedBox(height: isPortrait ? screenHeight * 0.05 : 0),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform:
                      Matrix4.identity()..scale(_animation.value * 0.2 + 0.8),                  child: Container(
                    width: isPortrait ? screenWidth * 0.8 : screenWidth * 0.45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7C4DFF), Color(0xFF9E7BFF)], // Purple theme from main app
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF7C4DFF).withOpacity(0.6),
                          blurRadius: 12,
                          spreadRadius: 2,
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
                          color: Colors.yellow,
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
                            color: Color(0xFFFFAB40), // Secondary color from app theme
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),                          child: Text(
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
                  ),
                ),
                SizedBox(
                  height:
                      isPortrait ? screenHeight * 0.05 : screenHeight * 0.03,
                ),
                Expanded(
                  child:
                      isPortrait
                          ? _buildPortraitLayout(screenHeight, screenWidth)
                          : _buildLandscapeLayout(screenHeight, screenWidth),
                ),
              ],
            ),
          ),
          if (_showConfetti) _buildConfetti(),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(double screenHeight, double screenWidth) {
    return Column(
      children: [
        Expanded(
          flex: 20,
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
                      horizontal: screenWidth * 0.1,
                    ),
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenHeight * 0.02,
                      mainAxisExtent: screenHeight * 0.11,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final image = images[randomizedIndices[index]];
                      final imageState = imageStates[randomizedIndices[index]];

                      return GestureDetector(
                        onTap: () => _handleImageTap(index, image.isCorrect),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  imageState == null
                                      ? Colors.blue.shade300
                                      : imageState
                                      ? Colors.green
                                      : Colors.red,
                              width: imageState == null ? 2 : 4,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  image.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                                if (imageState != null)
                                  Container(
                                    color: Colors.black.withOpacity(0.4),
                                    child: Center(
                                      child: Icon(
                                        imageState
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color:
                                            imageState
                                                ? Colors.green.shade300
                                                : Colors.red.shade300,
                                        size: screenHeight * 0.08,
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
                loading:
                    () => Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                error:
                    (error, stack) => Center(
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
        Consumer(
          builder: (context, ref, child) {
            final imgsAsyncValue = ref.watch(
              img.imageProcessorProvider(currentLetter),
            );
            return imgsAsyncValue.when(
              data: (imageResponse) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: screenHeight * 0.15,
                  child: Image.network(
                    imageResponse.characterImageUrl,
                    fit: BoxFit.contain,
                  ),
                );
              },
              loading:
                  () => SizedBox(
                    height: screenHeight * 0.15,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              error:
                  (error, stack) => SizedBox(
                    height: screenHeight * 0.15,
                    child: Center(child: Text('Error')),
                  ),
            );
          },
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _speak(currentLetter),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: screenHeight * 0.05,
                ),
              ),
            ),
            Image.asset('assets/first/14.png', height: screenHeight * 0.15),
          ],
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onTryAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.015,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.015,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Next Letter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(double screenHeight, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  imageState == null
                                      ? Colors.blue.shade300
                                      : imageState
                                      ? Colors.green
                                      : Colors.red,
                              width: imageState == null ? 2 : 4,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  image.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                                if (imageState != null)
                                  Container(
                                    color: Colors.black.withOpacity(0.4),
                                    child: Center(
                                      child: Icon(
                                        imageState
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color:
                                            imageState
                                                ? Colors.green.shade300
                                                : Colors.red.shade300,
                                        size: screenHeight * 0.08,
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
                loading:
                    () => Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                error:
                    (error, stack) => Center(
                      child: Text(
                        'Error loading images',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final imgsAsyncValue = ref.watch(
                    img.imageProcessorProvider(currentLetter),
                  );
                  return imgsAsyncValue.when(
                    data: (imageResponse) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: screenHeight * 0.3,
                        child: Image.network(
                          imageResponse.characterImageUrl,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                    loading:
                        () => SizedBox(
                          height: screenHeight * 0.3,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    error:
                        (error, stack) => SizedBox(
                          height: screenHeight * 0.3,
                          child: Center(child: Text('Error')),
                        ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.05),
              GestureDetector(
                onTap: () => _speak(currentLetter),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: screenHeight * 0.08,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onTryAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Next Letter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
