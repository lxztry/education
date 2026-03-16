import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/wrong_book_screen.dart';
import 'screens/settings_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MathTrainerApp());
}

class MathTrainerApp extends StatelessWidget {
  const MathTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = StorageService.getDarkMode();
    
    return MaterialApp(
      title: '口算训练师',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      routes: {
        '/challenge': (context) => const ChallengeScreen(),
        '/wrongbook': (context) => const WrongBookScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
