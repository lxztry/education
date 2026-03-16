import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _soundEnabled;
  late bool _vibrationEnabled;
  late bool _showTimer;
  late int _dailyGoal;
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    _soundEnabled = StorageService.getSoundEnabled();
    _vibrationEnabled = StorageService.getVibrationEnabled();
    _showTimer = StorageService.getShowTimer();
    _dailyGoal = StorageService.getDailyGoal();
    _darkMode = StorageService.getDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSectionHeader('外观'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('深色模式'),
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) async {
                await StorageService.setDarkMode(value);
                setState(() => _darkMode = value);
              },
            ),
          ),
          const Divider(),
          _buildSectionHeader('练习设置'),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('显示计时器'),
            trailing: Switch(
              value: _showTimer,
              onChanged: (value) async {
                await StorageService.setShowTimer(value);
                setState(() => _showTimer = value);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('声音提示'),
            trailing: Switch(
              value: _soundEnabled,
              onChanged: (value) async {
                await StorageService.setSoundEnabled(value);
                setState(() => _soundEnabled = value);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.vibration),
            title: const Text('震动反馈'),
            trailing: Switch(
              value: _vibrationEnabled,
              onChanged: (value) async {
                await StorageService.setVibrationEnabled(value);
                setState(() => _vibrationEnabled = value);
              },
            ),
          ),
          const Divider(),
          _buildSectionHeader('学习目标'),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('每日目标'),
            subtitle: Text('$_dailyGoal 题/天'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showDailyGoalDialog,
          ),
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('今日练习'),
            subtitle: Text('${StorageService.getTodayCount()} 题'),
          ),
          const Divider(),
          _buildSectionHeader('关于'),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('版本'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('给我们评分'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('感谢您的支持！')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showDailyGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('设置每日目标'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [10, 20, 30, 50].map((goal) {
              return RadioListTile<int>(
                title: Text('$goal 题'),
                value: goal,
                groupValue: _dailyGoal,
                onChanged: (value) async {
                  await StorageService.setDailyGoal(value!);
                  setState(() => _dailyGoal = value);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
