import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DownloadPdfButtonSkeleton extends StatelessWidget {
  const DownloadPdfButtonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color:
              Colors.white, // <-- ini penting! jangan samakan dengan baseColor
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ICON SKELETON
            Container(
              width: 20,
              height: 20,
              color: Colors.grey.shade300, // <-- terlihat shimmer
            ),
            const SizedBox(width: 8),

            // TEXT SKELETON
            Container(
              width: 140,
              height: 16,
              color: Colors.grey.shade300, // <-- terlihat shimmer
            ),
          ],
        ),
      ),
    );
  }
}
