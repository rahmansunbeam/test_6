import 'package:flutter/material.dart';
import 'package:test_6/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.teal),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WordHome(),
      },
    );
  }
}
