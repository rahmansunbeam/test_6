import 'package:flutter/material.dart';
import 'package:test_6/view/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
      },
    );
  }
}
