import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/colors.dart';

class RealtimeActivityCard extends StatelessWidget {
  final String type; // "sehat" atau "busuk"
  final String message; // contoh: "Mangga Sehat Terdeteksi"
  final String time; // contoh: "21/10/2025 12:23:32"

  const RealtimeActivityCard({
    super.key,
    required this.type,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSehat = type.toLowerCase() == 'sehat';

    // Warna & gambar sesuai jenis mangga
    final Color bgColor = isSehat ? AppColors.barGreen : AppColors.barRed;
    final Color borderColor = isSehat ? AppColors.borGreen : AppColors.borRed;
    final String imageAsset = isSehat ? 'assets/sehat.png' : 'assets/busuk.png';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 5, // 🔹 Garis di sisi kiri
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 8,
        ), // 🔹 Padding kecil
        child: Row(
          children: [
            // 🔹 Icon lingkaran
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor, // sama dengan warna card
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(imageAsset, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 8),
            // 🔹 Teks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // tetap aman kalau panjang
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: GoogleFonts.rubik(
                      fontSize: 12.5,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
