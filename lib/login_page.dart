import 'dart:core';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/signup.dart';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgotpassword.dart';

String name = "";
String email = "";

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _gmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                height: size.height * 0.18,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/icon.png"),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amberAccent,
                      blurRadius: 50,
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      'Welcome To Campus Link',
                  textStyle: GoogleFonts.openSans(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        const Shadow(
                          offset: Offset(1, 1),
                          color: Colors.black,
                          blurRadius: 10,
                        ),
                      ]
                  ),
                      speed: const Duration(milliseconds: 200)
                ),

              ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
              )
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.amberAccent,
                              blurRadius: 20,
                            ),
                          ]),
                          child: TextFormField(
                            controller: _gmail,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(

                              focusedBorder: const OutlineInputBorder(

                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(color: Colors.amber)),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.amber,
                              ),
                              suffixIcon: const Icon(
                                Icons.clear,
                                color: Colors.amber,
                              ),

                              hintText: "Enter Email",
                              fillColor: Colors.black,
                              filled: true,
                              hintStyle: GoogleFonts.openSans(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 2)),
                              disabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 2)),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.amberAccent,
                              blurRadius: 20,
                            ),
                          ]),
                          child: TextFormField(
                            controller: _password,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(color: Colors.amber)),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.amber,
                              ),
                              suffixIcon: const Icon(
                                Icons.visibility_off,
                                color: Colors.amber,
                              ),
                              hoverColor: Colors.red,
                              hintText: "Enter Password",
                              hintStyle: GoogleFonts.openSans(color: Colors.grey),
                              fillColor: Colors.black,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 2)),
                              disabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 2)),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 2)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Container(
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.amberAccent,
                            blurRadius: 20,
                            offset: Offset(6, 6),
                          ),
                        ]),
                        height: size.height * 0.06,
                        width: size.width * 0.83,
                        child: ElevatedButton(

                          onPressed: () {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: _gmail.text.trim(),
                              password: _password.text.trim(),
                            )
                                .then((value) {
                              print("Successful");
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),

                            backgroundColor: Colors.amber,
                          ),
                          child: AutoSizeText(
                            "LOG IN",
                            style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword (),
                            )
                          );
                        },
                        child: AutoSizeText(
                          "Forgot Password ?",
                          style: GoogleFonts.openSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText("Don't Have Account ",
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.amber)),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context)=>const SignUP (),
                                  )
                              );
                            },

                              //const SignUP (),
                            child: AutoSizeText(
                              "Sign Up",
                              style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
