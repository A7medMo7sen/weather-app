import 'package:flutter/material.dart';
import 'weather_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  static const _themePrefKey = 'isDarkMode';
  ThemeMode _themeMode = ThemeMode.dark;
 
  
Future<void> _onTogleTheme() async {

    final newMode =_themeMode == ThemeMode.dark? ThemeMode.light : ThemeMode.dark;
    setState(() {
      _themeMode= newMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefKey, newMode==ThemeMode.dark);
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themePrefKey) ?? true;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }
 @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(
        onTogle: _onTogleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
