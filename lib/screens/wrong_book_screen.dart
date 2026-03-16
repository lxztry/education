import 'package:flutter/material.dart';
import '../models/problem.dart';
import '../services/storage_service.dart';

class WrongBookScreen extends StatefulWidget {
  const WrongBookScreen({super.key});

  @override
  State<WrongBookScreen> createState() => _WrongBookScreenState();
}

class _WrongBookScreenState extends State<WrongBookScreen> {
  late List<MathProblem> _wrongProblems;

  @override
  void initState() {
    super.initState();
    _wrongProblems = StorageService.getWrongProblems();
  }

  void _refreshProblems() {
    setState(() {
      _wrongProblems = StorageService.getWrongProblems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('错题本'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          if (_wrongProblems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshProblems,
            ),
        ],
      ),
      body: _wrongProblems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green[400],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '太棒了！',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '暂无错题，继续保持！',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _wrongProblems.length,
              itemBuilder: (context, index) {
                final problem = _wrongProblems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '第 ${index + 1} 题',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          problem.problemText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('正确答案: '),
                            Text(
                              '${problem.answer}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _wrongProblems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                await StorageService.clearWrongProblems();
                _refreshProblems();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已清空错题本')),
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text('清空'),
            )
          : null,
    );
  }
}
