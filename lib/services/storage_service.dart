import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/problem.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }

  static const String _wrongProblemsKey = 'wrong_problems';
  static const String _challengeLevelKey = 'challenge_level';
  static const String _highScoreKey = 'high_score';
  static const String _dailyGoalKey = 'daily_goal';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _showTimerKey = 'show_timer';
  static const String _darkModeKey = 'dark_mode';
  static const String _todayCountKey = 'today_count';
  static const String _lastPracticeDateKey = 'last_practice_date';

  static List<MathProblem> getWrongProblems() {
    final jsonString = prefs.getString(_wrongProblemsKey);
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => MathProblem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveWrongProblems(List<MathProblem> problems) async {
    final jsonString = json.encode(problems.map((e) => e.toJson()).toList());
    await prefs.setString(_wrongProblemsKey, jsonString);
  }

  static Future<void> addWrongProblem(MathProblem problem) async {
    final problems = getWrongProblems();
    problems.add(problem);
    await saveWrongProblems(problems);
  }

  static Future<void> clearWrongProblems() async {
    await prefs.remove(_wrongProblemsKey);
  }

  static int getChallengeLevel() {
    return prefs.getInt(_challengeLevelKey) ?? 1;
  }

  static Future<void> setChallengeLevel(int level) async {
    await prefs.setInt(_challengeLevelKey, level);
  }

  static int getHighScore() {
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  static Future<void> setHighScore(int score) async {
    await prefs.setInt(_highScoreKey, score);
  }

  static int getDailyGoal() {
    return prefs.getInt(_dailyGoalKey) ?? 20;
  }

  static Future<void> setDailyGoal(int goal) async {
    await prefs.setInt(_dailyGoalKey, goal);
  }

  static bool getSoundEnabled() {
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  static bool getVibrationEnabled() {
    return prefs.getBool(_vibrationEnabledKey) ?? true;
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    await prefs.setBool(_vibrationEnabledKey, enabled);
  }

  static bool getShowTimer() {
    return prefs.getBool(_showTimerKey) ?? true;
  }

  static Future<void> setShowTimer(bool show) async {
    await prefs.setBool(_showTimerKey, show);
  }

  static bool getDarkMode() {
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool enabled) async {
    await prefs.setBool(_darkModeKey, enabled);
  }

  static int getTodayCount() {
    final lastDate = prefs.getString(_lastPracticeDateKey);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    
    if (lastDate != today) {
      return 0;
    }
    return prefs.getInt(_todayCountKey) ?? 0;
  }

  static Future<void> incrementTodayCount() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString(_lastPracticeDateKey);
    
    int count;
    if (lastDate != today) {
      count = 1;
    } else {
      count = (prefs.getInt(_todayCountKey) ?? 0) + 1;
    }
    
    await prefs.setInt(_todayCountKey, count);
    await prefs.setString(_lastPracticeDateKey, today);
  }
}
