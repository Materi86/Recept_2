import 'package:familiens_receptbok/features/recipe/list/view/recipe_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
          surface: Colors.white,
          surfaceContainerHighest: const Color(0xFFF1F3F4),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xFF2D3436),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF2D3436),
            size: 24,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C5CE7),
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF6C5CE7),
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
          headlineLarge: GoogleFonts.poppins(
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w600,
            fontSize: 32,
            letterSpacing: -0.5,
          ),
          headlineMedium: GoogleFonts.poppins(
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w600,
            fontSize: 24,
            letterSpacing: -0.3,
          ),
          headlineSmall: GoogleFonts.poppins(
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -0.2,
          ),
          titleLarge: GoogleFonts.poppins(
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          titleMedium: GoogleFonts.poppins(
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          bodyLarge: GoogleFonts.inter(
            color: const Color(0xFF636E72),
            fontSize: 16,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.inter(
            color: const Color(0xFF636E72),
            fontSize: 14,
            height: 1.4,
          ),
          bodySmall: GoogleFonts.inter(
            color: const Color(0xFF74B9FF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF6C5CE7).withOpacity(0.1),
          selectedColor: const Color(0xFF6C5CE7),
          labelStyle: GoogleFonts.poppins(
            color: const Color(0xFF6C5CE7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          secondaryLabelStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide.none,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFFDDD6FE),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF6C5CE7),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE17055),
              width: 1,
            ),
          ),
          labelStyle: GoogleFonts.poppins(
            color: const Color(0xFF74B9FF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFFB2BEC3),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const RecipeListPage(),
    );
  }
}

