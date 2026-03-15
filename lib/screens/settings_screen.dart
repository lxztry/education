import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _showTimer = true;
  int _dailyGoal = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSectionHeader('练习设置'),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('显示计时器'),
            trailing: Switch(
              value: _showTimer,
              onChanged: (value) {
                setState(() => _showTimer = value);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('声音提示'),
            trailing: Switch(
              value: _soundEnabled,
              onChanged: (value) {
                setState(() => _soundEnabled = value);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.vibration),
            title: const Text('震动反馈'),
            trailing: Switch(
              value: _vibrationEnabled,
              onChanged: (value) {
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
          color: Colors.blue[700],
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
                onChanged: (value) {
                  setState(() => _dailyGoal = value!);
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
