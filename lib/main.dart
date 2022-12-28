import 'package:flutter/material.dart';

import 'package:work_schedule/navigation/navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Navigation(),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.brown,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.inversePrimary),
            backgroundColor: const MaterialStatePropertyAll<Color>(Colors.brown),
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.brown,
        ),
      ),
    );
  }
}
