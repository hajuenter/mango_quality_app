import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DashboardCard extends StatelessWidget {
  final IconData? icon; // Bisa pakai IconData
  final String? imageAsset; // Bisa pakai Image PNG/JPG
  final String? svgAsset; // Bisa pakai SVG
  final String number; // Angka atau teks
  final String label; // Label di bawah
  final Color backgroundColor; // Warna card
  final Color iconColor; // Warna icon/SVG
  final double iconSize; // Ukuran icon/gambar
  final Color? statusDotColor; // Warna lingkaran status di depan number
  final double numberFontSize; // Ukuran font number
  final Color? numberColor; // Warna number

  // Tinggi area number tetap agar label sejajar
  final double numberAreaHeight;

  const DashboardCard({
    super.key,
    this.icon,
    this.imageAsset,
    this.svgAsset,
    required this.number,
    required this.label,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.iconSize = 40,
    this.statusDotColor,
    this.numberFontSize = 24,
    this.numberColor,
    this.numberAreaHeight = 40, // default tinggi number area
  }) : assert(
         icon != null || imageAsset != null || svgAsset != null,
         'Harus ada salah satu: icon, imageAsset, atau svgAsset',
       );

  @override
  Widget build(BuildContext context) {
    // Icon / Image / SVG
    Widget displayIcon;
    if (icon != null) {
      displayIcon = Icon(icon, size: iconSize, color: iconColor);
    } else if (imageAsset != null) {
      displayIcon = Image.asset(
        imageAsset!,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      );
    } else {
      displayIcon = SvgPicture.asset(
        svgAsset!,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    }

    // Number widget + status dot
    final color = numberColor ?? Colors.black;

    Widget numberWidget;
    if (statusDotColor != null) {
      numberWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusDotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: numberAreaHeight,
            child: Center(
              child: AutoSizeText(
                number,
                style: GoogleFonts.rubik(
                  fontSize: numberFontSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                maxLines: 1,
                minFontSize: 12,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    } else {
      numberWidget = SizedBox(
        height: numberAreaHeight,
        child: Center(
          child: AutoSizeText(
            number,
            style: GoogleFonts.rubik(
              fontSize: numberFontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            minFontSize: 12,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          displayIcon,
          const SizedBox(height: 12),
          numberWidget,
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.rubik(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
