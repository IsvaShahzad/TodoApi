import 'dart:async';
import 'package:ezi_taskmanager/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'get_started.dart';



class SplashScreen extends StatefulWidget {
  final List<String> tasks;

  SplashScreen({required this.tasks});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
            () =>
            //     Navigator.pushReplacement(
            // context, MaterialPageRoute(builder: (context) => ImageWithTextDemo(tasks: widget.tasks,)))
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginScreen(tasks: widget.tasks,)))
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff201b39), // Set background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5.0), // Add padding around the image
              child: Image.asset(
                'assets/images/splashscreenimage1.jpeg',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}