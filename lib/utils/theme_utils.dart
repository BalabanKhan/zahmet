import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/trip_provider.dart';

class ThemeUtils {
  static TextStyle getTaskTextStyle(TripState state, {double fontSize = 16}) {
    if (state == TripState.aestheticTorture) {
      return GoogleFonts.comicNeue(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF757575),
      );
    }
    
    // Normal & PassiveAggressive state
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: FontWeight.w500, // Very thin
      color: const Color(0xFF757575), // Careless pale grey, but slightly darker
    );
  }
}
