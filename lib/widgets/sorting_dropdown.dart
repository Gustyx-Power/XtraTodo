import 'package:flutter/material.dart';
import '../providers/task_provider.dart';

class SortingDropdown extends StatelessWidget {
  final TaskProvider provider;

  const SortingDropdown({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: provider.sort,
      items: ['Created Date', 'Due Date'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          provider.sort = newValue;
        }
      },
    );
  }
}