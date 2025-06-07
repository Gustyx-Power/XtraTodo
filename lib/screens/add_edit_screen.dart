import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class AddEditScreen extends StatefulWidget {
  final Task? task;

  const AddEditScreen({super.key, this.task});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  String? _course;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate;
// Default ke Perkuliahan
    _course = widget.task?.category == Category.Perkuliahan ? widget.task?.course : null;
    if (_course != null) _titleController.text = 'Perkuliahan - $_course';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Tambah Tugas' : 'Edit Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? 'Pilih Tanggal Jatuh Tempo'
                          : 'Jatuh Tempo: ${DateFormat('dd MMM yyyy').format(_dueDate!)}',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDueDate,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Hanya Perkuliahan sebagai opsi
              const Text('Kategori: Perkuliahan (khusus)'),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: _course,
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
                    _course = value;
                    if (value != null) {
                      _titleController.text = 'Perkuliahan - $value';
                    }
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  print('Tombol ${widget.task == null ? 'Tambah' : 'Update'} ditekan');
                  if (_formKey.currentState!.validate()) {
                    print('Form valid');
                    final newTask = Task(
                      id: widget.task?.id,
                      title: _course != null ? 'Perkuliahan - $_course' : _titleController.text,
                      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                      dueDate: _dueDate,
                      category: Category.Perkuliahan, // Hanya Perkuliahan
                      isCompleted: widget.task?.isCompleted ?? false,
                      createdAt: widget.task?.createdAt ?? DateTime.now(),
                      completedAt: widget.task?.completedAt,
                      course: _course, // Simpan mata kuliah
                    );
                    Navigator.pop(context, newTask);
                  } else {
                    print('Form tidak valid');
                  }
                },
                child: Text(widget.task == null ? 'Tambah' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}