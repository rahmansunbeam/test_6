import 'package:flutter/material.dart';
import 'package:test_6/pages/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {        
        '/': (context) => SplashScreen(),
      },
    );
  }
}
