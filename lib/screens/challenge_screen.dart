import 'package:flutter/material.dart';
import 'practice_screen.dart';
import '../models/problem.dart';
import '../services/storage_service.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late int _currentLevel;
  final int _maxLevel = 10;
  late int _highScore;

  @override
  void initState() {
    super.initState();
    _currentLevel = StorageService.getChallengeLevel();
    _highScore = StorageService.getHighScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('闯关模式'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                '选择关卡',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '当前最高: $_highScore 关',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _maxLevel,
                  itemBuilder: (context, index) {
                    final level = index + 1;
                    final isUnlocked = level <= _currentLevel;
                    final isCompleted = level < _currentLevel;

                    return GestureDetector(
                      onTap: isUnlocked
                          ? () => _startChallenge(level)
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? (isCompleted
                                  ? Colors.green
                                  : Colors.orange)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: isUnlocked
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$level',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (isCompleted)
                                      const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                  ],
                                )
                              : Icon(
                                  Icons.lock,
                                  color: Colors.grey[500],
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildLevelInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelInfo() {
    final difficulty = (_currentLevel / 3).ceil();
    final problemCount = 10 + (_currentLevel - 1) * 5;
    final operations = ProblemGenerator.getOperations(difficulty);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '第 $_currentLevel 关信息',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text('题目数量: $problemCount'),
          Text('难度: ${['简单', '中等', '困难'][difficulty - 1]}'),
          Text('运算: ${operations.map((o) => _getOpName(o)).join(", ")}'),
        ],
      ),
    );
  }

  String _getOpName(OperationType op) {
    switch (op) {
      case OperationType.addition:
        return '加法';
      case OperationType.subtraction:
        return '减法';
      case OperationType.multiplication:
        return '乘法';
      case OperationType.division:
        return '除法';
    }
  }

  void _startChallenge(int level) {
    final difficulty = (level / 3).ceil().clamp(1, 3);
    final problemCount = 10 + (level - 1) * 5;
    final operations = ProblemGenerator.getOperations(difficulty);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PracticeScreen(
          difficulty: difficulty,
          problemCount: problemCount,
          operations: operations,
          isChallenge: true,
          challengeLevel: level,
        ),
      ),
    ).then((result) {
      final accuracy = result as double? ?? 0;
      if (accuracy >= 80) {
        setState(() {
          if (level == _currentLevel && _currentLevel < _maxLevel) {
            _currentLevel++;
            StorageService.setChallengeLevel(_currentLevel);
          }
          if (level > _highScore) {
            _highScore = level;
            StorageService.setHighScore(_highScore);
          }
        });
      }
    });
  }
}
