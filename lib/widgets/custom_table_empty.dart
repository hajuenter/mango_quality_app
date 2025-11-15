import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyTableState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyTableState({
    super.key,
    this.message = "Belum ada riwayat musim",
    this.icon = Icons.grid_view,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
