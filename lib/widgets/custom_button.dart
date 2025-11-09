import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final Color color;
  final Color textColor;
  final bool isBold;
  final double fontSize; // ✅ tambahan fontSize opsional

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    required this.color,
    required this.textColor,
    this.isBold = false, // default tidak bold
    this.fontSize = 16, // ✅ default font size 16
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: loading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: GoogleFonts.rubik(
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: textColor,
              ),
            ),
    );
  }
}
