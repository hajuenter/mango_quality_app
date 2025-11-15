import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// ------------------------------------------------------------
///  SKELETON HEADER
/// ------------------------------------------------------------
class CustomTableHeaderSkeleton extends StatelessWidget {
  final double width;

  const CustomTableHeaderSkeleton({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
///  SKELETON CELL
/// ------------------------------------------------------------
class CustomTableCellSkeleton extends StatelessWidget {
  final double width;

  const CustomTableCellSkeleton({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
///  FULL TABLE SKELETON (HEADER + ROWS)
/// ------------------------------------------------------------
class CustomTableSkeleton extends StatelessWidget {
  const CustomTableSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 4,
      radius: const Radius.circular(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(190),
            1: FixedColumnWidth(80),
            2: FixedColumnWidth(80),
            3: FixedColumnWidth(80),
          },
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey, width: 0.2),
          ),
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
              children: [
                CustomTableHeaderSkeleton(width: 120),
                CustomTableHeaderSkeleton(width: 50),
                CustomTableHeaderSkeleton(width: 50),
                CustomTableHeaderSkeleton(width: 50),
              ],
            ),

            for (int i = 0; i < 4; i++)
              const TableRow(
                children: [
                  CustomTableCellSkeleton(width: 140),
                  CustomTableCellSkeleton(width: 40),
                  CustomTableCellSkeleton(width: 40),
                  CustomTableCellSkeleton(width: 40),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
