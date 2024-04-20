import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
import '../api/constants.dart';
import '../api/user_model.dart';
import 'get_started.dart';


class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _taskController = TextEditingController();

  bool onClicked = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf2e8ff),
        body: Padding(
            padding: EdgeInsets.only(top: 80),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Container(
                  //   height: 260,
                  //   width: double.infinity,
                  //   child: Stack(
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             image: AssetImage("assets/images/imageadd.png"),
                  //             // fit: BoxFit.cover,
                  //
                  //           ),
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Text('Forgot Password,', style: TextStyle(fontFamily: 'Montserrat',
                    fontSize: 25,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Padding(
                        padding: EdgeInsets.only(top: 45),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: _taskController,

                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Email',
                                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey, fontFamily: 'Montserrat'),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    RegExp regex = RegExp(
                                        r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter your Email ';
                                    } else if (!regex.hasMatch(value)) {
                                      return 'Enter according to format';
                                    }
                                    return null;
                                  },
                                ),
                              ),


                              SizedBox(height: 30.0),

                              ElevatedButton(
                                onPressed: () async {

                                },
                                child: Text('Send',style: TextStyle(fontFamily: 'Montserrat'),),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF99a9dd), // Button color
                                  onPrimary: Colors.white, // Text color
                                  minimumSize: const Size(20, 50),
                                  maximumSize: const Size(20, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0), // Make borders square
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ])));
  }
}
