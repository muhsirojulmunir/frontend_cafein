import 'package:cafein/resources/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

const appImages = Assets.images;

class ColorApp {
  static Color colorPrimary = const Color(0xFF1E4E78); // Blue from Podcast
  static Color colorSecondary = const Color(0xFF143656); // Darker Blue
  static Color black = const Color(0xFF000000);
  static Color lightblue = const Color(0xFF0096FF);
  static Color white = const Color(0xFFFFFFFF);
  static Color grey = const Color(0xFF9E9E9E);
  static Color red = const Color(0xFFFF0000);
  static Color green = const Color(0xFF55A630);

  // Status Color
  static Color draft = const Color(0xFF64748B);
  static Color requested = const Color(0xFFF59E0B);
  static Color processing = const Color(0xFF3B82F6);
  static Color shipped = const Color(0xFF8B5CF6);
  static Color received = const Color(0xFF059669);
  static Color done = const Color(0xFF4ECB25);
  static Color cancelled = const Color(0xFFEF4444);
}

class ElevationApp {
  static BoxShadow elevation4pxBottom = BoxShadow(
    color: ColorApp.grey.withAlpha(75),
    spreadRadius: 0,
    blurRadius: 4,
    offset: const Offset(0, 4),
  );
  static BoxShadow elevation4pxRight = BoxShadow(
    color: ColorApp.grey.withAlpha(75),
    spreadRadius: 0,
    blurRadius: 4,
    offset: const Offset(4, 0),
  );
  static BoxShadow elevation10px = BoxShadow(
    color: ColorApp.grey.withAlpha(75),
    spreadRadius: 0,
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
  static BoxShadow elevation4pxUp = BoxShadow(
    color: ColorApp.black.withAlpha(4),
    spreadRadius: 0,
    blurRadius: 4,
    offset: const Offset(0, -4),
  );
}

class TextStyleApp {
  static TextStyle titleText = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodyTextBold = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyTextSmall = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodyTextSmallBold = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );

  // Tambahan untuk Product Report
  static TextStyle bodyTextLarge = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyTextNormal = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );
}

class AppGradient {
  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 0.8],
    colors: [ColorApp.colorPrimary, ColorApp.colorPrimary.withAlpha(50)],
  );

  // Gradient menu home: Navy → Hijau Zamrud
  static LinearGradient menuGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1E4E78), Color(0xFF1A7A55)],
  );

  static LinearGradient pageBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E4E78), Color(0xFF1A7A55)],
  );
  static LinearGradient whiteGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ColorApp.white.withAlpha(0), ColorApp.white],
  );
  static LinearGradient primaryWhiteGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.3, 0.8],
    colors: [ColorApp.white, ColorApp.colorPrimary],
  );
}
