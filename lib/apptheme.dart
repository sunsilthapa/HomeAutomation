import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final TextStyle myGlobalTextStyle = GoogleFonts.poppins(
    // Use GoogleFonts.poppins
    textStyle: const TextStyle(
      color: Color(0xFF7a6bbc), // Replace this with your desired font color
      fontSize: 16,
      fontWeight: FontWeight.bold,
      // You can customize other properties like fontFamily, fontStyle, etc. here
    ),
  );
}
