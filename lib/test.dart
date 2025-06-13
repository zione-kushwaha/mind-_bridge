// import 'package:flutter/material.dart';
// import 'package:mind_bridge/feature/home/view/home_view.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mind Bridge',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//         primaryColor: Colors.green,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Color(0xFF7C4DFF),
//           primary: Color(0xFF7C4DFF),
//           secondary: Color(0xFFFFAB40),
//           tertiary: Color(0xFF4CAF50),
//           background: Color(0xFFF5F5F7),
//         ),
//         fontFamily: 'OpenDyslexicRegular',
//         textTheme: TextTheme(
//           headlineLarge: GoogleFonts.fredoka(
//             fontSize: 28, 
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF7C4DFF),
//           ),
//           headlineMedium: GoogleFonts.fredoka(
//             fontSize: 24, 
//             fontWeight: FontWeight.bold,
//           ),
//           bodyLarge: TextStyle(
//             fontFamily: 'OpenDyslexicRegular',
//             fontSize: 18,
//           ),
//         ),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Color(0xFF7C4DFF),
//           elevation: 0,
//           centerTitle: true,
//         ),
//         cardTheme: CardThemeData(
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         buttonTheme: ButtonThemeData(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//       home: HomePage(),
//     );
//   }
// }