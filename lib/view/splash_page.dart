import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:test_6/view/home_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;

  @override
  void initState() {
    super.initState();
    _loadTimer();
  }

  _loadTimer() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => WordHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[700],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              width: 50.0 * MediaQuery.textScaleFactorOf(context),
              height: 50.0 * MediaQuery.textScaleFactorOf(context),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/icon/icon.png'))),
            ),
          ),
          Text('Just Another Flashcard App',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto Slab',
                fontSize: 18.0 * MediaQuery.textScaleFactorOf(context),
              )),
          Container(
            height: (MediaQuery.of(context).size.height / 100) * 50,
            child: SpinKitThreeBounce(
              color: Colors.white,
              size: 30 * MediaQuery.textScaleFactorOf(context),
            ),
          ),
        ],
      ),
    );
  }
}
