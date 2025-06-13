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
      body: characterImageAsyncValue.when(
        data: (characterImageResponse) {
          final characterImageUrl =
              characterImageResponse.characterImageUrl ?? '';
          final imageData = characterImageResponse.images?.first;

          return Stack(
            children: [
              // Background decoration
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade50,
                        Colors.green.shade50,
                      ],
                    ),
                  ),
                ),
              ),
              
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Header with fun design
                  Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school, color: Colors.white, size: 28),
                        SizedBox(width: 10),
                        Text(
                          'LEARN ALPHABETS',
                          style: GoogleFonts.fredoka(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  // Main letter display area
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background shape with animated color
                        Consumer(
                          builder: (context, ref, child) {
                            final colorProvider = ref.watch(
                              paletteGeneratorProvider(characterImageUrl),
                            );
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: colorProvider.value?.withOpacity(0.7) ?? 
                                  Colors.blue.shade200,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        
                        // Letter image with fun border
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 8,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 3,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              characterImageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        // Letter label
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.15,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              currentChar.toUpperCase(),
                              style: GoogleFonts.fredoka(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        
                        // Description
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              imageData?.description ?? '',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredoka(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Navigation controls
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous button
                        if (!isFirstLetter)
                          FloatingActionButton(
                            heroTag: 'prev',
                            backgroundColor: Colors.green,
                            child: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: _onPrevious,
                          )
                        else
                          SizedBox(width: 56), // Placeholder for balance

                        // Speak button
                        GestureDetector(
                          onTap: () => _speak(currentChar),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _isSpeaking ? Colors.orange : Colors.green,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Icon(
                              _isSpeaking ? Icons.volume_up : Icons.volume_down,
                              size: 36,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Next button
                        FloatingActionButton(
                          heroTag: 'next',
                          backgroundColor: Colors.green,
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                          onPressed: _onNext,
                        ),
                      ],
                    ),
                  ),

                  // Bottom action buttons
                  Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      top: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Orientation button
                        _buildActionButton(
                          context,
                          icon: Icons.accessibility_new,
                          label: 'Orientation',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrientationView(),
                              ),
                            );
                          },
                        ),

                        // Practice button
                        _buildActionButton(
                          context,
                          icon: Icons.mic,
                          label: 'Practice',
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PracticeSpeaking(),
                            //   ),
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Oops! Something went wrong',
            style: GoogleFonts.fredoka(
              fontSize: 20,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Icon(
              icon,
              color: Colors.green,
              size: 30,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.fredoka(
            color: Colors.green,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}