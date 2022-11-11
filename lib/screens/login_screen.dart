import 'dart:io';

import 'package:flutter/material.dart';

import './home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateLoginScreen()
      : SafeArea(child: GenerateLoginScreen());
}

class GenerateLoginScreen extends StatefulWidget {
  GenerateLoginScreen({Key? key}) : super(key: key);

  @override
  State<GenerateLoginScreen> createState() => _GenerateLoginScreenState();
}

class _GenerateLoginScreenState extends State<GenerateLoginScreen> {
  bool password = true;
  Color iconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: DrawClipFirst(),
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.orange, Colors.deepOrangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft),
                ),
              ),
            ),
            ClipPath(
              clipper: DrawClipSecond(),
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.orangeAccent.withOpacity(0.8),
                    Colors.orange,
                  ], begin: Alignment.topLeft, end: Alignment.bottomLeft),
                ),
              ),
            ),
            Container(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: Platform.isIOS
                          ? EdgeInsets.only(top: 40, left: 10)
                          : EdgeInsets.only(top: 10, left: 10),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 30),
                      child: Text(
                        "Administrator",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(40, 120, 50, 0),
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: Theme.of(context).primaryColor),
                              labelText: "E-mail Address",
                              labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color),
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding:
                                  EdgeInsets.only(top: 15, bottom: 15),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFE0E0E0), width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFDD9246), width: 1),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 10, 50, 0),
                      child: Container(
                        child: TextFormField(
                          obscureText: password,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1?.color),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  password = !password;
                                });
                              },
                              icon: password
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: iconColor,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: iconColor,
                                    ),
                            ),
                            prefixIcon: Icon(Icons.lock_outline_rounded,
                                color: Theme.of(context).primaryColor),
                            labelText: "Password",
                            labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color),
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding:
                                EdgeInsets.only(top: 15, bottom: 15),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0), width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFDD9246), width: 1),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 49, top: 20),
                          child: TextButton(
                            onPressed: () {
                              //TODO Forgot Password
                            },
                            child: Text(
                              "forgot password?".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFDD9746),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Container(
                          height: 45,
                          width: 130,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              //TODO Email Validation
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomeScreen.routeName, (route) => false,
                                  arguments: true);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            // TODO Send email to Admin?
                          });
                        },
                        child: Text(
                          "Contact the Administrator",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFDD9246),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawClipFirst extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(center: Offset(size.width, 50), radius: 150));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DrawClipSecond extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(
        Rect.fromCircle(center: Offset(size.width * 0.2, 50), radius: 200));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
