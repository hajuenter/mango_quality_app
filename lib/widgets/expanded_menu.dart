import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandedMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget content;

  const ExpandedMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          splashColor: Colors.transparent, // Hilangkan efek cipratan
          highlightColor: Colors.transparent, // Hilangkan efek tekan
          hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 52,
                    right: 16,
                    bottom: 12,
                  ),
                  child: content,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
