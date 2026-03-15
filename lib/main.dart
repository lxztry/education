import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/wrong_book_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MathTrainerApp());
}

class MathTrainerApp extends StatelessWidget {
  const MathTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '口算训练师',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/challenge': (context) => const ChallengeScreen(),
        '/wrongbook': (context) => const WrongBookScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
