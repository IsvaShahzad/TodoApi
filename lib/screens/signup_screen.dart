import 'package:ezi_taskmanager/screens/add_task.dart';
import 'package:ezi_taskmanager/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'forgotpassword_screen.dart';

class SignUpScreen extends StatefulWidget {
  final List<String> tasks;
  SignUpScreen({required this.tasks});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = true;

  final LoginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  late String email;
  late String password;
  late String Username;
  late bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd7c6f0),
      body: Form(
          key: LoginFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Padding(
                    padding: EdgeInsets.only(top: 100),
                      child: Text('Sign Up,', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Montserrat'),)),
                  // Container(
                  //   height: 300,
                  //   width: double.infinity,
                  //   child: Stack(
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             image:
                  //                 AssetImage("assets/images/login_image.jpeg"),
                  //             // fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 22.0),
                              // child: Text('Email',
                              //     style: TextStyle(
                              //         fontSize: 15,
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                            ),
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat'),
                                decoration: InputDecoration(
                                  hintText: 'Enter Username',
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat'),
                                  filled: true,
                                  fillColor: Colors.white,
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
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat'),
                                decoration: InputDecoration(
                                  hintText: 'Enter Email',
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat'),
                                  filled: true,
                                  fillColor: Colors.white,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: _isObscure,
                                decoration: InputDecoration(
                                  hintText: ' Enter Password',
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat'),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF000000),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Your Password ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF99a9dd), // Button color
                                    onPrimary: Colors.white, // Text color
                                    minimumSize: const Size(180, 50),
                                    maximumSize: const Size(180, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          0.0), // Make borders square
                                    ),
                                  ),
                                  onPressed: () async {
                                    // if (LoginFormKey.currentState!.validate()) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            AddListScreen(tasks: widget.tasks),
                                      ),
                                    );
                                    // }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                  // Empty container as a placeholder
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  color: Color(0xFFdf4652),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(fontFamily: 'Montserrat'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginScreen(
                                                    tasks: widget.tasks)));
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Color(
                                            0xFFdf4652), // Sign up button color
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
