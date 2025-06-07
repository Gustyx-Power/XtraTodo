import 'package:intl/intl.dart';



class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final Category? category;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? course;

  Task({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.category,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.course,
  });

  // copyWith
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Category? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    String? course,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      course: course ?? this.course,
    );
  }

  // priorityPoints dueDate
  int get priorityPoints {
    if (dueDate == null) return 45; // Low
    final daysLeft = dueDate!.difference(DateTime.now()).inDays;
    if (daysLeft <= 1) return 100; // High
    if (daysLeft <= 3) return 80; // Middle
    return 45; // Low
  }

  int get priorityColor {
    if (dueDate == null) return 0xFF4CAF50; // Green (Low Risk)
    final daysLeft = dueDate!.difference(DateTime.now()).inDays;
    if (daysLeft <= 1) return 0xFFF44336; // Red (High Risk)
    if (daysLeft <= 3) return 0xFFFFC107; // Yellow (Middle Risk)
    return 0xFF4CAF50; // Green (Low Risk)
  }

  String get formattedDueDate {
    return dueDate != null ? DateFormat('dd MMM yyyy').format(dueDate!) : '-';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'category': category
          ?.toString()
          .split('.')
          .last,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'course': course,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      category: map['category'] != null ? Category.values.firstWhere((e) =>
      e
          .toString()
          .split('.')
          .last == map['category']) : null,
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      completedAt: map['completedAt'] != null ? DateTime.parse(
          map['completedAt']) : null,
      course: map['course'],
    );
  }
}
enum Category {Perkuliahan}