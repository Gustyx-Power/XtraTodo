import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
    required this.onEdit,
  });

  Color getCardColor() {
    if (task.isCompleted) return Colors.green[100]!;
    return Colors.primaries[DateTime.now().millisecondsSinceEpoch % Colors.primaries.length]
    [100]!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getCardColor(),
      elevation: 1,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) => onToggle(),
          ),
          title: Text(
            task.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description != null)
                Text(
                  task.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (task.dueDate != null)
                Text(
                  'Due: ${DateFormat('dd MMM yyyy').format(task.dueDate!)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                ),
              if (task.category == Category.Perkuliahan && task.course != null)
                Text(
                  'Mata Kuliah: ${task.course}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}