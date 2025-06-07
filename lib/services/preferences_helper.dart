import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static Future<int> getPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('total_points') ?? 0;
  }

  static Future<void> setPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_points', points);
  }

  static Future<int> getLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('level') ?? 1;
  }

  static Future<void> setLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', level);
  }

  static String getLevelName(int level) {
    switch (level) {
      case 1: return 'Bronze';
      case 2: return 'Silver';
      case 3: return 'Gold';
      case 4: return 'Platinum';
      case 5: return 'Diamond';
      case 6: return 'Master';
      case 7: return 'Grandmaster';
      case 8: return 'Epic';
      case 9: return 'Legend';
      default: return 'Mythic';
    }
  }

  static int getPointsForLevel(int level) {
    switch (level) {
      case 1: return 0;
      case 2: return 101;
      case 3: return 251;
      case 4: return 501;
      case 5: return 1001;
      case 6: return 1501;
      case 7: return 2501;
      case 8: return 3501;
      case 9: return 5001;
      default: return 7001;
    }
  }
}