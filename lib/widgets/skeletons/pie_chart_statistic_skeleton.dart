import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PieChartStatisticSkeleton extends StatelessWidget {
  const PieChartStatisticSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title placeholder
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 180,
                height: 16,
                color: Colors.grey.shade300,
              ),
            ),

            const SizedBox(height: 16),

            // Circle placeholder (pie chart area)
            SizedBox(
              height: 200, // sama dengan widget asli
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Legend placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendSkeleton(),
                const SizedBox(width: 16),
                _legendSkeleton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 70,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}
