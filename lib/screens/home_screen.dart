import 'package:flutter/material.dart';
import '../models/problem.dart';
import 'practice_screen.dart';
import 'challenge_screen.dart';
import 'wrong_book_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('口算训练师'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                '每日练习',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildMenuCard(
                context,
                icon: Icons.calculate,
                title: '自由练习',
                subtitle: '选择难度和题型',
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PracticeSetupScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuCard(
                context,
                icon: Icons.emoji_events,
                title: '闯关模式',
                subtitle: '挑战更高难度',
                color: Colors.orange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChallengeScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuCard(
                context,
                icon: Icons.book,
                title: '错题本',
                subtitle: '巩固薄弱知识点',
                color: Colors.red,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WrongBookScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuCard(
                context,
                icon: Icons.settings,
                title: '设置',
                subtitle: '自定义学习参数',
                color: Colors.grey,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
              const Spacer(),
              const Text(
                '坚持每天练习，口算能力稳步提升！',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

class PracticeSetupScreen extends StatefulWidget {
  const PracticeSetupScreen({super.key});

  @override
  State<PracticeSetupScreen> createState() => _PracticeSetupScreenState();
}

class _PracticeSetupScreenState extends State<PracticeSetupScreen> {
  int _difficulty = 1;
  int _problemCount = 10;
  final Set<OperationType> _selectedOps = {OperationType.addition};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自由练习'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '题目数量',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [10, 20, 30, 50].map((count) {
              return ChoiceChip(
                label: Text('$count 题'),
                selected: _problemCount == count,
                onSelected: (selected) {
                  if (selected) setState(() => _problemCount = count);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            '难度选择',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ChoiceChip(
                label: const Text('简单'),
                selected: _difficulty == 1,
                onSelected: (selected) {
                  if (selected) setState(() => _difficulty = 1);
                },
              ),
              ChoiceChip(
                label: const Text('中等'),
                selected: _difficulty == 2,
                onSelected: (selected) {
                  if (selected) setState(() => _difficulty = 2);
                },
              ),
              ChoiceChip(
                label: const Text('困难'),
                selected: _difficulty == 3,
                onSelected: (selected) {
                  if (selected) setState(() => _difficulty = 3);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            '运算类型',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              FilterChip(
                label: const Text('加法'),
                selected: _selectedOps.contains(OperationType.addition),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedOps.add(OperationType.addition);
                    } else {
                      _selectedOps.remove(OperationType.addition);
                    }
                  });
                },
              ),
              FilterChip(
                label: const Text('减法'),
                selected: _selectedOps.contains(OperationType.subtraction),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedOps.add(OperationType.subtraction);
                    } else {
                      _selectedOps.remove(OperationType.subtraction);
                    }
                  });
                },
              ),
              FilterChip(
                label: const Text('乘法'),
                selected: _selectedOps.contains(OperationType.multiplication),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedOps.add(OperationType.multiplication);
                    } else {
                      _selectedOps.remove(OperationType.multiplication);
                    }
                  });
                },
              ),
              FilterChip(
                label: const Text('除法'),
                selected: _selectedOps.contains(OperationType.division),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedOps.add(OperationType.division);
                    } else {
                      _selectedOps.remove(OperationType.division);
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _selectedOps.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PracticeScreen(
                          difficulty: _difficulty,
                          problemCount: _problemCount,
                          operations: _selectedOps.toList(),
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('开始练习', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
