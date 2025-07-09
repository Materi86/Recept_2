import 'package:familiens_receptbok/features/recipe/list/view/recipe_list_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDFBF6),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFE57373),
          foregroundColor: const Color(0xFF4E342E),
          titleTextStyle: GoogleFonts.robotoSlab(
            color: const Color(0xFF4E342E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE57373),
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.robotoSlab(
            color: const Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.robotoSlab(
            color: const Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.lato(
            color: const Color(0xFF4E342E),
          ),
          bodyMedium: GoogleFonts.lato(
            color: const Color(0xFF4E342E),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFA5D6A7),
          labelStyle: GoogleFonts.lato(
            color: const Color(0xFF4E342E),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE57373)),
          ),
          labelStyle: GoogleFonts.lato(
            color: const Color(0xFF4E342E),
          ),
        ),
      ),
      home: const RecipeListPage(),
    );
  }
}

