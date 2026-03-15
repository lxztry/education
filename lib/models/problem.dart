import 'dart:math';

enum OperationType { addition, subtraction, multiplication, division }

class MathProblem {
  final int num1;
  final int num2;
  final OperationType operation;
  final int answer;

  MathProblem({
    required this.num1,
    required this.num2,
    required this.operation,
    required this.answer,
  });

  String get operationSymbol {
    switch (operation) {
      case OperationType.addition:
        return '+';
      case OperationType.subtraction:
        return '-';
      case OperationType.multiplication:
        return '×';
      case OperationType.division:
        return '÷';
    }
  }

  String get problemText => '$num1 $operationSymbol $num2 = ?';

  bool checkAnswer(int userAnswer) => userAnswer == answer;

  Map<String, dynamic> toJson() => {
    'num1': num1,
    'num2': num2,
    'operation': operation.index,
    'answer': answer,
  };

  factory MathProblem.fromJson(Map<String, dynamic> json) => MathProblem(
    num1: json['num1'],
    num2: json['num2'],
    operation: OperationType.values[json['operation']],
    answer: json['answer'],
  );
}

class ProblemGenerator {
  static final Random _random = Random();

  static MathProblem generate({
    required OperationType operation,
    required int difficulty,
  }) {
    int num1, num2, answer;

    switch (operation) {
      case OperationType.addition:
        num1 = _generateNumber(difficulty);
        num2 = _generateNumber(difficulty);
        answer = num1 + num2;
        break;
      case OperationType.subtraction:
        num1 = _generateNumber(difficulty);
        num2 = _random.nextInt(num1) + 1;
        answer = num1 - num2;
        break;
      case OperationType.multiplication:
        num1 = _generateMultiplier(difficulty);
        num2 = _random.nextInt(10) + 1;
        answer = num1 * num2;
        break;
      case OperationType.division:
        num2 = _generateMultiplier(difficulty);
        answer = _random.nextInt(10) + 1;
        num1 = num2 * answer;
        break;
    }

    return MathProblem(
      num1: num1,
      num2: num2,
      operation: operation,
      answer: answer,
    );
  }

  static int _generateNumber(int difficulty) {
    int max = 10;
    if (difficulty >= 2) max = 50;
    if (difficulty >= 3) max = 100;
    return _random.nextInt(max) + 1;
  }

  static int _generateMultiplier(int difficulty) {
    int max = 9;
    if (difficulty >= 2) max = 12;
    return _random.nextInt(max) + 1;
  }

  static List<OperationType> getOperations(int difficulty) {
    List<OperationType> ops = [OperationType.addition];
    if (difficulty >= 1) ops.add(OperationType.subtraction);
    if (difficulty >= 2) ops.add(OperationType.multiplication);
    if (difficulty >= 3) ops.add(OperationType.division);
    return ops;
  }
}

class PracticeSession {
  final List<MathProblem> problems;
  final Map<int, bool> answers;
  int currentIndex;
  int correctCount;
  int wrongCount;

  PracticeSession({
    required this.problems,
  })  : answers = {},
        currentIndex = 0,
        correctCount = 0,
        wrongCount = 0;

  MathProblem? get currentProblem =>
      currentIndex < problems.length ? problems[currentIndex] : null;

  bool get isFinished => currentIndex >= problems.length;

  void answer(int userAnswer) {
    if (currentProblem == null) return;

    bool isCorrect = currentProblem!.checkAnswer(userAnswer);
    answers[currentIndex] = isCorrect;

    if (isCorrect) {
      correctCount++;
    } else {
      wrongCount++;
    }
    currentIndex++;
  }

  double get progress => problems.isEmpty ? 0 : currentIndex / problems.length;

  List<MathProblem> get wrongProblems {
    List<MathProblem> wrong = [];
    for (var entry in answers.entries) {
      if (!entry.value) {
        wrong.add(problems[entry.key]);
      }
    }
    return wrong;
  }
}
