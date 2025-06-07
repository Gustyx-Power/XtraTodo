import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:xtratodo/screens/stats_screen.dart';
import '../providers/task_provider.dart';
import '../services/preferences_helper.dart';
import '../widgets/filter_chip.dart';
import '../widgets/sorting_dropdown.dart';
import '../widgets/task_card.dart';
import 'add_edit_screen.dart';
import 'gamification_screen.dart'; // Screen baru buat gamifikasi
import '../models/task.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        if (provider.showSavePrompt) {
          provider.showSavePrompt = false;
        }

        if (provider.shouldShowConfetti) {
          _confettiController.play();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('XtraTodo'),
            actions: [
              IconButton(
                icon: Icon(
                  Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                  themeProvider.toggleTheme(
                    Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.light,
                  );
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'Stats') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen()));
                  } else if (value == 'Gamification') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => GamificationScreen(
                                points: provider.points, level: provider.level)));
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Stats', child: Text('View Stats')),
                  const PopupMenuItem(value: 'Gamification', child: Text('Gamification')),
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        FilterChipWidget(label: 'Semua', provider: provider),
                        const SizedBox(width: 8),
                        FilterChipWidget(label: 'Selesai', provider: provider),
                        const SizedBox(width: 8),
                        FilterChipWidget(label: 'Tertunda', provider: provider),
                        const SizedBox(width: 16),
                        SortingDropdown(provider: provider),
                      ],
                    ),
                  ),
                  Expanded(
                    child: provider.tasks.isEmpty
                        ? const Center(child: Text('Belum ada tugas'))
                        : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: provider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = provider.tasks[index];
                        return TaskCard(
                          task: task,
                          onDelete: () => provider.deleteTask(task.id!),
                          onToggle: () => provider.toggleComplete(task),
                          onEdit: () => _showEditPopup(context, task),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 20,
                  colors: const [Colors.blue, Colors.red, Colors.green, Colors.yellow],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditScreen()),
            ).then((newTask) {
              if (newTask != null) {
                print('Tugas diterima: ${newTask.title}, ID: ${newTask.id}');
                final provider = Provider.of<TaskProvider>(context, listen: false);
                if (newTask.id == null) {
                  provider.addTask(newTask);
                } else {
                  provider.updateTask(newTask);
                }
              } else {
                print('Tidak ada tugas diterima');
              }
            }),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showEditPopup(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description ?? '');
    DateTime? dueDate = task.dueDate;
    String? course = task.course;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tugas'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              ListTile(
                title: Text(dueDate == null
                    ? 'Pilih Tanggal Jatuh Tempo'
                    : 'Jatuh Tempo: ${DateFormat('dd MMM yyyy').format(dueDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      dueDate = picked;
                    });
                  }
                },
              ),
              const Text('Kategori: Perkuliahan (khusus)'),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: course,
                hint: const Text('Pilih Mata Kuliah'),
                isExpanded: true,
                items: ['Pemrograman Mobile', 'Pemrograman Web', 'Bisnis Elektronik', 'IMK' , 'Sistem Terdistribusi'].map((course) {
                  return DropdownMenuItem<String>(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    course = value;
                    if (value != null) {
                      titleController.text = 'Perkuliahan - $value';
                    }
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final updatedTask = Task(
                id: task.id,
                title: course != null ? 'Perkuliahan - $course' : titleController.text,
                description: descriptionController.text.isEmpty ? null : descriptionController.text,
                dueDate: dueDate,
                category: Category.Perkuliahan,
                isCompleted: task.isCompleted,
                createdAt: task.createdAt,
                completedAt: task.completedAt,
                course: course,
              );
              final provider = Provider.of<TaskProvider>(context, listen: false);
              provider.updateTask(updatedTask);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}