import 'dart:core';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

String name = "";
String email = "";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
                height: size.height * 0.07,
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
                height: size.height * 0.07,
              ),
               AnimatedTextKit(
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
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              Form(
                child: Column(
                  children: [
                    Container(
                      width: size.width * 0.9,
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
                          hoverColor: Colors.red,
                          hintText: "Enter Email",
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
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Container(
                      height: size.height * 0.06,
                      width: size.width * 0.8,
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.amberAccent,
                          blurRadius: 20,
                          offset: Offset(6, 6),
                        ),
                      ]),

                      child: ElevatedButton(

                        onPressed: () {

                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                            email: _gmail.text.trim(),
                          )
                              .then((value) {
                            print("email  has been send ");
                          },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.amber,
                        ),
                        child: AutoSizeText(
                          "Reset Password",
                          style: GoogleFonts.openSans(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Loginpage(),
                          ),
                        );
                      },
                      child: AutoSizeText(
                        "Back to Login",
                        style: GoogleFonts.openSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
