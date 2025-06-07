import 'package:flutter/material.dart';
import '../providers/task_provider.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final TaskProvider provider;

  const FilterChipWidget({required this.label, required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: provider.filter == label,
      onSelected: (selected) {
        if (selected) {
          provider.filter = label;
        }
      },
    );
  }
}