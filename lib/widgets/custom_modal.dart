import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomModal extends StatelessWidget {
  final String? imageAsset; // gambar lokal
  final IconData? icon; // icon alternatif
  final Color iconColor;
  final double iconSize;

  final String title; // judul modal
  final String message; // isi modal

  final String cancelText; // teks tombol batal
  final String confirmText; // teks tombol OK

  final VoidCallback onCancel; // aksi tombol batal
  final VoidCallback onConfirm; // aksi tombol OK

  final Color confirmColor; // warna tombol confirm
  final Color cancelColor;

  const CustomModal({
    super.key,
    this.imageAsset,
    this.icon,
    this.iconColor = Colors.red,
    this.iconSize = 80,

    required this.title,
    required this.message,

    this.cancelText = 'Batal',
    this.confirmText = 'OK',

    required this.onCancel,
    required this.onConfirm,

    this.confirmColor = Colors.red,
    this.cancelColor = const Color(0xffe5e5e5),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gambar atau Icon
            if (imageAsset != null)
              Image.asset(
                imageAsset!,
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Icon(icon, color: iconColor, size: iconSize),

            const SizedBox(height: 18),

            // Judul
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            // Pesan
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                // Tombol Cancel
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cancelColor,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(cancelText),
                  ),
                ),

                const SizedBox(width: 12),

                // Tombol Confirm
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
