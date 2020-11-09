import 'package:flutter/material.dart';
import 'package:test_6/pages/home_page.dart';

// TODOS
// Screen is too small at the bottom
// Cards dont rest fully inside te screen
// wordset buttons have white space on the right
// wordset scrolls quickly to the end and do not return
//

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => WordHome(),
      },
    );
  }
}
