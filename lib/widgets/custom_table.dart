import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTableHeader extends StatelessWidget {
  final String text;

  const CustomTableHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.rubik(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class CustomTableCell extends StatelessWidget {
  final String text;

  const CustomTableCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.rubik(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }
}
