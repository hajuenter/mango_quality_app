import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FilterChipsRowSkeleton extends StatelessWidget {
  const FilterChipsRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final chipWidths = [
      70.0, // "Semua"
      65.0, // "Sehat"
      65.0, // "Busuk"
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: chipWidths[index],
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }),
      ),
    );
  }
}
