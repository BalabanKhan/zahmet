import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/trip_provider.dart';

class ThemeUtils {
  static TextStyle getTaskTextStyle(TripState state, {double fontSize = 16}) {
    if (state == TripState.aestheticTorture) {
      return GoogleFonts.comicNeue(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFBDBDBD),
      );
    }
    
    // Normal & PassiveAggressive state
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: FontWeight.w300, // Very thin
      color: const Color(0xFFBDBDBD), // Careless pale grey
    );
  }
}
