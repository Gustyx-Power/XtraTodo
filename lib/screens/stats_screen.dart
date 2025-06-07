import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final chartData = getChartData(provider.tasks);
        final insight = getInsight(chartData);

        return Scaffold(
          appBar: AppBar(title: const Text('Statistik Produktivitas')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tugas Selesai vs Tertunda (7 Hari Terakhir)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups: chartData.entries.map((e) {
                        final day = int.parse(e.key.split('-').last);
                        return BarChartGroupData(
                          x: day,
                          barRods: [
                            BarChartRodData(toY: e.value['completed'] ?? 0, color: Colors.green),
                            BarChartRodData(toY: e.value['pending'] ?? 0, color: Colors.red),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Insight: $insight', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, Map<String, double>> getChartData(List<Task> tasks) {
    final now = DateTime.now();
    final data = <String, Map<String, double>>{};
    for (var i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dayKey = DateFormat('yyyy-MM-dd').format(date);
      data[dayKey] = {
        'completed': tasks.where((t) => t.isCompleted && t.completedAt?.day == date.day).length.toDouble(),
        'pending': tasks.where((t) => !t.isCompleted && t.dueDate != null && t.dueDate!.day == date.day).length.toDouble(),
      };
    }
    return data;
  }

  String getInsight(Map<String, Map<String, double>> chartData) {
    if (chartData.isEmpty) return 'Belum ada data';
    final mostProductiveDay = chartData.entries.reduce((a, b) => (a.value['completed'] ?? 0) > (b.value['completed'] ?? 0) ? a : b);
    final day = DateFormat('dd MMM yyyy').format(DateTime.parse(mostProductiveDay.key));
    return 'Paling produktif pada $day dengan ${mostProductiveDay.value['completed']} tugas selesai';
  }
}