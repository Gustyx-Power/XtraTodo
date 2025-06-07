import 'package:flutter/material.dart';

class GamificationScreen extends StatelessWidget {
  final int points;
  final int level;

  const GamificationScreen({super.key, required this.points, required this.level});

  @override
  Widget build(BuildContext context) {
    final double progress = points / (level * 100); // Progress berdasarkan target level
    final int nextLevelPoints = (level + 1) * 100;
    final int minPoints = level * 100;
    final int maxPoints = (level + 1) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Bar Melingkar
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      color: Colors.green[700],
                      strokeWidth: 15,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        points.toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Level $level - ${getLevelName(level)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Keuntungan/Reward
            const Text(
              'Keuntungan Saya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRewardItem('Level Up ke Gold', '1000 poin', Icons.star, level >= 3),
            _buildRewardItem('Unlock Stats Detail', '500 poin', Icons.bar_chart, points >= 500),
            _buildRewardItem('Bonus Confetti', '200 poin', Icons.celebration, points >= 200),
            const SizedBox(height: 20),
            // Misi
            const Text(
              'Misi Saya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildMissionItem('Selesaikan 5 Tugas', 'Dapatkan 50 Poin', () {
              // Logika misi (contoh)
              print('Misi Selesaikan 5 Tugas dipilih');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(String title, String threshold, IconData icon, bool isUnlocked) {
    return ListTile(
      leading: Icon(icon, color: isUnlocked ? Colors.green : Colors.grey),
      title: Text(title),
      subtitle: Text('Tersedia di $threshold'),
      trailing: isUnlocked
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.lock, color: Colors.grey),
    );
  }

  Widget _buildMissionItem(String title, String reward, VoidCallback onTap) {
    return ListTile(
      leading: const Icon(Icons.task, color: Colors.orange),
      title: Text(title),
      subtitle: Text(reward),
      trailing: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        child: const Text('Mulai'),
      ),
    );
  }

  String getLevelName(int level) {
    switch (level) {
      case 1:
        return 'Bronze';
      case 2:
        return 'Silver';
      case 3:
        return 'Gold';
      default:
        return 'Platinum';
    }
  }
}