import 'package:flutter/material.dart';
import '../config/colors.dart';

class FilterChipsRow extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const FilterChipsRow({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['Semua', 'Sehat', 'Busuk'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: filters.map((filter) {
        final bool isSelected = filter == selectedFilter;

        return ChoiceChip(
          label: Text(
            filter,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.primaryAuth, // semua aktif hijau
          backgroundColor: Colors.grey.shade200,
          showCheckmark: false, // hilangkan tanda centang
          onSelected: (_) => onSelected(filter),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }).toList(),
    );
  }
}
