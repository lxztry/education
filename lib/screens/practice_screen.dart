import 'dart:async';
import 'package:flutter/material.dart';
import '../models/problem.dart';

class PracticeScreen extends StatefulWidget {
  final int difficulty;
  final int problemCount;
  final List<OperationType> operations;

  const PracticeScreen({
    super.key,
    required this.difficulty,
    required this.problemCount,
    required this.operations,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late PracticeSession _session;
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _timer;
  int _seconds = 0;
  bool _showFeedback = false;
  bool? _lastAnswerCorrect;

  @override
  void initState() {
    super.initState();
    _generateProblems();
    _startTimer();
  }

  void _generateProblems() {
    List<MathProblem> problems = [];
    for (int i = 0; i < widget.problemCount; i++) {
      final op = widget.operations[i % widget.operations.length];
      problems.add(ProblemGenerator.generate(
        operation: op,
        difficulty: widget.difficulty,
      ));
    }
    _session = PracticeSession(problems: problems);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _submitAnswer() {
    if (_session.isFinished || _showFeedback) return;

    final answer = int.tryParse(_answerController.text);
    if (answer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入数字')),
      );
      return;
    }

    _session.answer(answer);
    _lastAnswerCorrect = _session.currentProblem?.checkAnswer(answer) ?? false;

    setState(() {
      _showFeedback = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_session.isFinished) {
        _showResult();
      } else {
        setState(() {
          _showFeedback = false;
          _answerController.clear();
        });
        _focusNode.requestFocus();
      }
    });
  }

  void _showResult() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(session: _session, seconds: _seconds),
      ),
    );
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final problem = _session.currentProblem;

    return Scaffold(
      appBar: AppBar(
        title: const Text('练习中'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                _formatTime(_seconds),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: _session.progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                '${_session.currentIndex + 1} / ${widget.problemCount}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              if (problem != null)
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    problem.problemText,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: _showFeedback
                    ? Icon(
                        _lastAnswerCorrect == true
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _lastAnswerCorrect == true
                            ? Colors.green
                            : Colors.red,
                        size: 60,
                      )
                    : TextField(
                        controller: _answerController,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 32),
                        decoration: InputDecoration(
                          hintText: '请输入答案',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        onSubmitted: (_) => _submitAnswer(),
                      ),
              ),
              const Spacer(),
              if (!_showFeedback)
                ElevatedButton(
                  onPressed: _submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('提交答案', style: TextStyle(fontSize: 18)),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final PracticeSession session;
  final int seconds;

  const ResultScreen({
    super.key,
    required this.session,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = session.problems.isEmpty
        ? 0.0
        : session.correctCount / session.problems.length * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('练习结果'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(
                accuracy >= 80 ? Icons.emoji_events : Icons.sentiment_satisfied,
                size: 80,
                color: accuracy >= 80 ? Colors.amber : Colors.green,
              ),
              const SizedBox(height: 20),
              Text(
                accuracy >= 80 ? '太棒了！' : '继续加油！',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    '正确',
                    '${session.correctCount}',
                    Colors.green,
                  ),
                  _buildStatCard(
                    '错误',
                    '${session.wrongCount}',
                    Colors.red,
                  ),
                  _buildStatCard(
                    '用时',
                    _formatTime(seconds),
                    Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '正确率: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${accuracy.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: accuracy >= 80 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('返回首页', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
