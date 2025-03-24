import 'package:flutter/material.dart';
import 'package:workout_app/screens/main_screen.dart';
import 'package:workout_app/screens/workout_detail_screen.dart';
import 'package:workout_app/data/workout_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WorkoutData.initializeCompletedWorkouts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'W_out App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Color.fromARGB(255, 141, 3, 216),
        primaryColorLight: Color.fromARGB(255, 180, 50, 255),
        primaryColorDark: Color.fromARGB(255, 47, 1, 63),
        colorScheme: ColorScheme.light(
          primary: Color.fromARGB(255, 141, 3, 216),
          secondary: Colors.red,
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
        ),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 141, 3, 216),
            onPrimary: Colors.white,
            elevation: 4,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 141, 3, 216),
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 141, 3, 216),
          unselectedItemColor: Colors.grey,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Color.fromARGB(255, 180, 50, 255),
        primaryColorLight: Color.fromARGB(255, 200, 100, 255),
        primaryColorDark: Color.fromARGB(255, 141, 3, 216),
        colorScheme: ColorScheme.dark(
          primary: Color.fromARGB(255, 180, 50, 255),
          secondary: Colors.redAccent,
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
          error: Colors.redAccent,
        ),
        scaffoldBackgroundColor: Color(0xFF121212),
        cardColor: Color(0xFF1E1E1E),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 180, 50, 255),
            onPrimary: Colors.white,
            elevation: 4,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color.fromARGB(255, 180, 50, 255),
          unselectedItemColor: Colors.grey,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/mainScreen': (context) => MainScreen(),
        '/workoutDetail': (context) => WorkoutDetailScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 141, 3, 216),
              Color.fromARGB(255, 47, 1, 63)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 120,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'BREAK IT',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your Personal Workout Companion',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/mainScreen');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fitness_center, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Get to Work',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Color.fromARGB(255, 251, 4, 4),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
