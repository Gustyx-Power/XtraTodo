import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_helper.dart';
import '../services/preferences_helper.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  String _filter = 'Semua';
  String _sort = 'Created Date';
  int _points = 0;
  int _level = 1;
  bool _showSavePrompt = false;
  int _lastLevel = 1;

  TaskProvider() {
    loadData();
  }

  String get filter => _filter;
  set filter(String value) {
    _filter = value;
    notifyListeners();
  }

  String get sort => _sort;
  set sort(String value) {
    _sort = value;
    notifyListeners();
  }

  bool get showSavePrompt => _showSavePrompt;
  set showSavePrompt(bool value) {
    _showSavePrompt = value;
    notifyListeners();
  }

  int get points => _points;
  int get level => _level;
  bool get shouldShowConfetti => _level > _lastLevel;

  List<Task> get tasks {
    var filtered = _tasks.where((task) {
      if (_filter == 'Semua') return true;
      if (_filter == 'Selesai') return task.isCompleted;
      if (_filter == 'Tertunda') return !task.isCompleted;
      return false;
    }).toList();

    filtered.sort((a, b) {
      if (_sort == 'Tanggal Dibuat') return b.createdAt.compareTo(a.createdAt);
      if (_sort == 'Tanggal Jatuh Tempo') {
        final aDue = a.dueDate ?? DateTime.now();
        final bDue = b.dueDate ?? DateTime.now();
        return aDue.compareTo(bDue);
      }
      return 0;
    });

    return filtered;
  }

  Future<void> loadData() async {
    _tasks = await DatabaseHelper.instance.getTasks();
    _points = await PreferencesHelper.getPoints();
    _lastLevel = await PreferencesHelper.getLevel();
    _level = _lastLevel;
    _checkLevel();
    _checkSavePrompt();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    print('Menambahkan tugas: ${task.title}');
    try {
      await DatabaseHelper.instance.insertTask(task);
      _tasks = await DatabaseHelper.instance.getTasks();
      print('Jumlah tugas setelah tambah: ${_tasks.length}');
      notifyListeners();
    } catch (e) {
      print('Error menambahkan tugas: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    print('Memperbarui tugas: ${task.title}, ID: ${task.id}');
    try {
      await DatabaseHelper.instance.updateTask(task);
      _tasks = await DatabaseHelper.instance.getTasks();
      print('Jumlah tugas setelah update: ${_tasks.length}');
      notifyListeners();
    } catch (e) {
      print('Error memperbarui tugas: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _tasks = await DatabaseHelper.instance.getTasks();
    notifyListeners();
  }

  Future<void> toggleComplete(Task task) async {
    if (!task.isCompleted) {
      final newTask = task.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      await DatabaseHelper.instance.updateTask(newTask);
      _tasks = await DatabaseHelper.instance.getTasks();

      final points = task.priorityPoints;
      _points += points;
      await PreferencesHelper.setPoints(_points);
      _checkLevel();
      _checkSavePrompt();

      notifyListeners();
    }
  }

  void _checkLevel() {
    final newLevel = (_points ~/ 100) + 1;
    if (newLevel != _level) {
      _lastLevel = _level;
      _level = newLevel;
      PreferencesHelper.setLevel(_level);
    }
  }

  void _checkSavePrompt() {
    if (_points > 100 && !_showSavePrompt) {
      _showSavePrompt = true;
    }
  }
}