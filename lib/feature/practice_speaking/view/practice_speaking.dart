import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:lottie/lottie.dart';
import 'repository/character_image_provider.dart';

class PracticeSpeaking extends ConsumerStatefulWidget {
  static const String routeName = '/practiceSpeakingView';
  const PracticeSpeaking({super.key});

  @override
  ConsumerState<PracticeSpeaking> createState() => _PracticeSpeakingState();
}

class _PracticeSpeakingState extends ConsumerState<PracticeSpeaking>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _firstVisibleIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  final FlutterTts flutterTts = FlutterTts();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _currentLetter = 'a';
  bool is_listening = false;
  bool isCorrect = false;
  bool _showCelebration = false;
  
  // Animation controller for pulse effect
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initSpeech();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    ); // We'll control animation start manually
    
    _seupAnimation();
    _speakCurrentLetter();
  }

  // Speak the current letter when page loads
  void _speakCurrentLetter() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak("Say the letter ${_currentLetter.toUpperCase()}");
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }
  void _startListening() async {
    // Play a fun sound or animation to indicate listening is starting
    setState(() {
      is_listening = true;
    });
    
    await flutterTts.speak("I'm listening");
    
    await _speechToText.listen(
      onResult: _onSpeechResult,
      sampleRate: 1,
      partialResults: false,
    );

    // Set timeout for listening
    Future.delayed(Duration(seconds: 5), () {
      if(is_listening) {
        _stopListening();
      }
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      is_listening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _checkResult();
    });
  }

  void _seupAnimation() {
    // Create a fun path animation that follows a parabolic arc
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
      ),
    );
  }

  void _onScroll() {
    final firstVisibleIndex =
        (_scrollController.offset / MediaQuery.of(context).size.width * 0.3)
            .round();
    setState(() {
      _firstVisibleIndex = firstVisibleIndex;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
  void _checkResult() {
    String first_letter =
        _lastWords.isNotEmpty ? _lastWords[0].toLowerCase() : '';
    if (first_letter == _currentLetter) {
      setState(() {
        isCorrect = true;
        _showCelebration = true;
        _controller.reset();
        _controller.forward();
      });

      // Play success sound
      flutterTts.speak("Great job!");
      
      // Run animation once then move to next letter
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 1500), () {
            _nextLetter();
          });
        }
      });
    } else {
      setState(() {
        isCorrect = false;
      });
      // Play gentle incorrect sound
      flutterTts.speak("Let's try again!");
      _showIncorrectDialog();
    }
  }

  void _showIncorrectDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[100]!, Colors.orange[50]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.orange[300]!,
                width: 3,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange[100],
                      ),
                      child: Icon(
                        Icons.emoji_emotions,
                        color: Colors.orange,
                        size: 60,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Let's try again!",
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "You can do it! Say the letter '${_currentLetter.toUpperCase()}'",
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    color: Colors.orange[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    // Give them a second before starting to listen again
                    Future.delayed(Duration(milliseconds: 500), () {
                      _startListening();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    decoration: BoxDecoration(
                     color:  Color(0xFF7C4DFF),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color:  Color(0xFF7C4DFF),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "Try Again",
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _nextLetter() {
    setState(() {
      _currentLetter = String.fromCharCode(_currentLetter.codeUnitAt(0) + 1);
      isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final middleY = MediaQuery.of(context).size.height * 0.5;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerx = screenWidth / 2 - 25;
    final provider = ref.watch(
      characterImageProviderSpeakingPractice(_currentLetter),
    );

    return Scaffold(
      body: provider.when(
        data: (characterImageResponse) {
          final characterImageUrl = characterImageResponse.characterImageUrl;
          final imageData = characterImageResponse.images;
          final data = imageData.toList();
          final img_1 = data[0];

          final image = img_1.imageUrl;
          return Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:  Color(0xFF7C4DFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'SPEAKING PRACTICE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Stack(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .08,
                              ),
                              Container(
                                child: Image.asset('assets/alphabets/17.png'),
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                          Column(
                            children: [
                              Container(
                                child: Image.asset('assets/alphabets/18.png'),
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                              Container(
                                child: Image.asset('assets/alphabets/17.png'),
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    isCorrect
                        ? AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            double t =
                                _animation.value; // Animation progress [0, 1]
                            double x = t * screenWidth; // Horizontal movement
                            double y =
                                100 -
                                100 *
                                    (1 -
                                        4.5 *
                                            (t - 0.5) *
                                            (t - 0.5)); // Parabolic formula

                            return Positioned(
                              left: x,
                              top: y,
                              child: Image.network(
                                img_1.imageUrl,
                                width: 50,
                                height: 50,
                              ),
                            );
                          },
                        )
                        : Container(
                          child: Image.network(
                            img_1.imageUrl,
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                        ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      img_1.additionalImage2Url ??
                          'https://via.placeholder.com/150',
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Image.network(
                      characterImageUrl,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Image.network(
                      img_1.additionalImage1Url ??
                          'https://via.placeholder.com/150',
                      height: MediaQuery.of(context).size.height * 0.13,
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    GestureDetector(
                      onTap: () {
                        _startListening();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.2,
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:  Color(0xFF7C4DFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.mic, color: Colors.white, size: 30),
                      ),
                    ),
                    // Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:
                          is_listening
                              ? Image.asset(
                                'assets/alphabets/25.png',
                                width: MediaQuery.of(context).size.width * 0.35,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              )
                              : isCorrect
                              ? Image.asset(
                                'assets/alphabets/20.png',
                                width: MediaQuery.of(context).size.width * 0.35,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              )
                              : Image.asset(
                                'assets/alphabets/21.png',
                                width: MediaQuery.of(context).size.width * 0.35,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),
                    ),
                     GestureDetector(
                  onTap: _nextLetter,
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color:  Color(0xFF7C4DFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                  ],
                ),
                // Spacer(),
               
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}