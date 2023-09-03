import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Constraints.dart';
import '../Registration/Login.dart';
import '../Registration/Verify Email.dart';
import 'loadingscreen.dart';
import 'navigation.dart';




class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}



class _MainPageState extends State<MainPage> {
  bool loaded=false;


  @override
  Widget build(BuildContext context) {
    return
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot)  {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SignInScreen();
          } else if (snapshot.connectionState == ConnectionState.active && !snapshot.hasData) {
            return const SignInScreen();
          } else if (snapshot.connectionState == ConnectionState.active && snapshot.hasData)
          {
            if(FirebaseAuth.instance.currentUser!.emailVerified){
              !loaded
                  ?
              fetchuser()
                  :
              null;

              return
                loaded ?
                const navigation()
                    :
                const loading(text: "Retrieving data from the server please wait",);
            }
            else{
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
              return const Verify();
            }
          }
          else{
            return const SignInScreen();}
        },

      );
  }
  Future<void> fetchuser() async {
    await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){
      setState(() {
        usermodel=value.data()!;
      });
    }).whenComplete((){
      setState(() {
        if (kDebugMode) {
          print(usermodel);
        }
        loaded=true;
      });
    });

  }
}
