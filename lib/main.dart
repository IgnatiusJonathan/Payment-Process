import 'package:flutter/material.dart';
import 'package:payment_process/screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'package:payment_process/screens/history_screen.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext konteks) {
    return MaterialApp(
      title: 'Scannabit',
      theme: ThemeData(
        useMaterial3: true, 
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 21, 27, 38),
          secondary: Color.fromARGB(255, 35, 52, 70),
          tertiary: Color.fromARGB(255, 48, 62, 82),
          surface: Color.fromARGB(255, 11, 14, 22),
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          onSecondary: Color.fromARGB(255, 255, 255, 255),
          
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 21, 27, 38),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 48, 62, 82),
          selectedItemColor: Color.fromARGB(120, 255, 255, 255),
          unselectedItemColor: Color.fromARGB(90, 255, 255, 255)
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
