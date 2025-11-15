import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/colors.dart';

class DownloadPdfButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DownloadPdfButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAuth,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(120, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.download_rounded, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'Unduh Laporan PDF',
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
