import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'XtraTodo',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.light,
              ),
              cardTheme: const CardTheme(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
                elevation: 6,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(fontFamily: 'Roboto'),
                titleLarge: TextStyle(fontSize: 20),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
              ),
              cardTheme: const CardTheme(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
                elevation: 6,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(fontFamily: 'Roboto', color: Colors.black), // Text hitam
                titleLarge: TextStyle(fontSize: 20, color: Colors.black), // Judul hitam
                titleMedium: TextStyle(fontSize: 16, color: Colors.black), // Subtitle hitam
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}