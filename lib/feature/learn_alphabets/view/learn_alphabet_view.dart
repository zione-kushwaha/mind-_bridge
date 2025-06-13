import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../orientation_test/view/orientation_view.dart';
import '../../pallete_generator/repository.dart';
import '../repository/character_image_provider.dart';
import '../repository/character_notifier.dart';

class LearnAlphabetView extends ConsumerStatefulWidget {
  static const String routeName = '/learnAlphabetView';
  @override
  _LearnAlphabetViewState createState() => _LearnAlphabetViewState();
}

class _LearnAlphabetViewState extends ConsumerState<LearnAlphabetView> {
  final FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speak(ref.read(characterProvider));
    });
  }

  void _speak(String text) async {
    setState(() => _isSpeaking = true);
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4); // Slower speech rate
    await flutterTts.speak('This is the letter $text');
    setState(() => _isSpeaking = false);
  }

  void _onNext() {
    ref.read(characterProvider.notifier).nextCharacter();
    final newChar = ref.read(characterProvider);
    _speak(newChar);
  }

  void _onPrevious() {
    ref.read(characterProvider.notifier).previousCharacter();
    final newChar = ref.read(characterProvider);
    _speak(newChar);
  }

  @override
  Widget build(BuildContext context) {
    final currentChar = ref.watch(characterProvider);
    final isFirstLetter = currentChar == 'a';
    final characterImageAsyncValue = ref.watch(
      characterImageProvider(currentChar),
    );

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF7C4DFF),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/first/${currentChar == 'a' ? 1 : currentChar.codeUnitAt(0) - 96}.png', 
              height: 40, 
              errorBuilder: (context, error, stackTrace) => SizedBox(width: 40),
            ),
            SizedBox(width: 10),
            Text(
              'Letter Adventure',
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.home, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
           body: characterImageAsyncValue.when(
        data: (characterImageResponse) {
          final characterImageUrl =
              characterImageResponse.characterImageUrl ?? '';
          final imageData = characterImageResponse.images?.first;

          // Start main Stack
          return Stack(
            children: [
              // Background decoration with fun patterns
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFEFD1F9),  // Light purple
                        Color(0xFFE4F1FE),  // Light blue
                      ],
                    ),
                  ),
                ),
              ),
              
              // Decorative star elements
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.1,
                child: Icon(Icons.star, color: Color(0xFFFFAB40).withOpacity(0.3), size: 30),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                right: MediaQuery.of(context).size.width * 0.15,
                child: Icon(Icons.star, color: Color(0xFF7C4DFF).withOpacity(0.3), size: 24),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.2,
                child: Icon(Icons.star, color: Color(0xFF4CAF50).withOpacity(0.3), size: 20),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.25,
                right: MediaQuery.of(context).size.width * 0.25,
                child: Icon(Icons.star, color: Color(0xFFFFAB40).withOpacity(0.3), size: 25),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Icon(Icons.star, color: Color(0xFF7C4DFF).withOpacity(0.2), size: 18),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                right: MediaQuery.of(context).size.width * 0.05,
                child: Icon(Icons.star, color: Color(0xFFFFAB40).withOpacity(0.2), size: 22),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.35,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Icon(Icons.star, color: Color(0xFF4CAF50).withOpacity(0.2), size: 16),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.45,
                left: MediaQuery.of(context).size.width * 0.15,
                child: Icon(Icons.star, color: Color(0xFF7C4DFF).withOpacity(0.2), size: 20),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                left: MediaQuery.of(context).size.width * 0.25,
                child: Icon(Icons.star, color: Color(0xFFFFAB40).withOpacity(0.15), size: 14),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                right: MediaQuery.of(context).size.width * 0.3,
                child: Icon(Icons.star, color: Color(0xFF4CAF50).withOpacity(0.15), size: 12),
              ),
              
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      // Animated title banner with playful design
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7C4DFF), Color(0xFF9E7BFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF7C4DFF).withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_stories, color: Colors.yellow, size: 32),
                            SizedBox(width: 12),
                            Text(
                              'Learn the Alphabet',
                              style: GoogleFonts.fredoka(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3,
                                    color: Colors.black26,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      // Main letter display area with animated elements
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background shape with animated color
                            TweenAnimationBuilder(
                              tween: ColorTween(
                                begin: Colors.blue.shade200,
                                end: Colors.purple.shade200,
                              ),
                              duration: Duration(seconds: 3),
                              builder: (_, Color? color, __) {
                                return Consumer(
                                  builder: (context, ref, child) {
                                    final colorProvider = ref.watch(
                                      paletteGeneratorProvider(characterImageUrl),
                                    );
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      height: MediaQuery.of(context).size.height * 0.45,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            colorProvider.value?.withOpacity(0.7) ?? color!,
                                            colorProvider.value?.withOpacity(0.5) ?? color!.withOpacity(0.7),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (colorProvider.value ?? color!).withOpacity(0.4),
                                            blurRadius: 15,
                                            spreadRadius: 3,
                                            offset: Offset(0, 6),
                                          )
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          // Fun decorative shapes
                                          Positioned(
                                            top: 20,
                                            left: 20,
                                            child: Icon(Icons.star, color: Colors.white.withOpacity(0.3), size: 18),
                                          ),
                                          Positioned(
                                            bottom: 20,
                                            right: 20,
                                            child: Icon(Icons.star, color: Colors.white.withOpacity(0.3), size: 18),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            
                            // Letter image with fun border and animation
                            TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0.9, end: 1.0),
                              duration: Duration(seconds: 2),
                              curve: Curves.elasticOut,
                              builder: (_, double scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.white, Color(0xFFEFEFEF)],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      border: Border.all(
                                        color: Color(0xFFFFAB40),
                                        width: 8,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFFFAB40).withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                          offset: Offset(0, 5),
                                        )
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(17),
                                      child: Image.network(
                                        characterImageUrl,
                                        fit: BoxFit.contain,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Color(0xFF7C4DFF)),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            // Animated letter label
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.08,
                              child: TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: Duration(milliseconds: 800),
                                builder: (_, double value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 15),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF4CAF50).withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                      ),
                                      child: Text(
                                        currentChar.toUpperCase(),
                                        style: GoogleFonts.fredoka(
                                          color: Colors.white,
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 3,
                                              color: Colors.black26,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            // Description with playful design
                            Positioned(
                              bottom: MediaQuery.of(context).size.height * 0.1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color(0xFF7C4DFF),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                      offset: Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      color: Color(0xFFFFAB40),
                                      size: 24,
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        imageData?.description ?? 'Learn the letter ${currentChar.toUpperCase()}',
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.fredoka(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50,),

                      // Navigation controls with playful designs
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Previous button with playful design
                            if (!isFirstLetter)
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _onPrevious,
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFFFAB40), Color(0xFFFFCC80)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFFFAB40).withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                          offset: Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_rounded, 
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )
                            else
                              SizedBox(width: 62),

                            // Speak button with playful animation
                            GestureDetector(
                              onTap: () => _speak(currentChar),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: _isSpeaking 
                                      ? [Color(0xFF7C4DFF), Color(0xFF9E7BFF)]
                                      : [Color(0xFF7C4DFF), Color(0xFF9E7BFF)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF7C4DFF).withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Ripple animation for speaking
                                        if (_isSpeaking) ...[
                                          for (int i = 1; i <= 3; i++)
                                            TweenAnimationBuilder(
                                              tween: Tween<double>(begin: 0.6, end: 1.6),
                                              duration: Duration(milliseconds: 1000 + (i * 300)),
                                              builder: (_, double size, __) {
                                                return Opacity(
                                                  opacity: (1.0 - (size - 0.6)).clamp(0.0, 1.0),
                                                  child: Container(
                                                    width: 40 * size,
                                                    height: 40 * size,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.white.withOpacity(0.7),
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                        Icon(
                                          _isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_rounded,
                                          size: 44,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Next button with playful design
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _onNext,
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF4CAF50).withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded, 
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                 SizedBox(height: 60,),
                      // Bottom action buttons with playful animation
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(
                          vertical: 15, 
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF7C4DFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Orientation game with animation
                            _buildAnimatedActionButton(
                              context,
                              icon: Icons.gamepad,
                              label: 'Letter Game',
                              color: Color(0xFFFFAB40),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => OrientationView(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var begin = Offset(1.0, 0.0);
                                      var end = Offset.zero;
                                      var curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end).chain(
                                        CurveTween(curve: curve),
                                      );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                    transitionDuration: Duration(milliseconds: 500),
                                  ),
                                );
                              },
                            ),

                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            
                            // Practice button with animation
                            _buildAnimatedActionButton(
                              context,
                              icon: Icons.record_voice_over_rounded,
                              label: 'Speak & Learn',
                              color: Color(0xFF4CAF50),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/first/${currentChar.codeUnitAt(0) - 96}.png',
                                            height: 80,
                                            errorBuilder: (context, error, stackTrace) => 
                                              Icon(Icons.emoji_emotions, size: 80, color: Color(0xFF7C4DFF)),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            'Coming Soon!',
                                            style: GoogleFonts.fredoka(
                                              fontSize: 24,
                                              color: Color(0xFF7C4DFF),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Practice speaking will be ready in our next update!',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF4CAF50),
                                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: Text(
                                              'OK',
                                              style: GoogleFonts.fredoka(color: Colors.white, fontSize: 16),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFEFD1F9),
                Color(0xFFE4F1FE),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    "Loading your letters...",
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      color: Color(0xFF7C4DFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (error, stack) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFEFD1F9),
                Color(0xFFE4F1FE),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.cloud_off,
                      size: 60,
                      color: Color(0xFFFFAB40),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Oops! Something went wrong',
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          color: Color(0xFF7C4DFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Try again later',
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: Icon(Icons.home, color: Colors.white),
                        label: Text(
                          'Go Home',
                          style: GoogleFonts.fredoka(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.9, end: 1.0),
      duration: Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      builder: (_, double scale, __) {
        return GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Transform.scale(
                scale: scale,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.fredoka(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}