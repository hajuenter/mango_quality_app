import 'package:flutter/material.dart';
import '../config/colors.dart';

class FilterChipsRow extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;
  final List<String>? filters;

  const FilterChipsRow({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
    this.filters,
  });

  @override
  Widget build(BuildContext context) {
    final chipFilters = filters ?? ['Semua', 'Sehat', 'Busuk'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: chipFilters.map((filter) {
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
          selectedColor: AppColors.primaryAuth,
          backgroundColor: Colors.grey.shade200,
          showCheckmark: false,
          onSelected: (_) => onSelected(filter),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }).toList(),
    );
  }
}
