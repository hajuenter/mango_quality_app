import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardCardSkeleton extends StatelessWidget {
  final double numberAreaHeight;
  final double iconSize;

  const DashboardCardSkeleton({
    super.key,
    this.numberAreaHeight = 40,
    this.iconSize = 50, // samakan dengan DashboardCard
  });

  Widget _buildShimmerBox({
    double width = 50,
    double height = 50,
    double radius = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShimmerBox(
            width: iconSize,
            height: iconSize,
            radius: 16,
          ), // icon
          const SizedBox(height: 12),
          SizedBox(
            height: numberAreaHeight,
            child: Center(
              child: _buildShimmerBox(
                width: 60,
                height: 24,
                radius: 8,
              ), // number
            ),
          ),
          const SizedBox(height: 6),
          _buildShimmerBox(width: 80, height: 14, radius: 8), // label
        ],
      ),
    );
  }
}
