import 'dart:async';
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
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ImageWithTextDemo(tasks: widget.tasks,))));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image.asset('assets/images/splashscreen.jfif')
    );
  }
}

