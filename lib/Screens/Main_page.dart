import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Constraints.dart';
import '../Registration/Login.dart';
import '../Registration/Verify Email.dart';
import '../Registration/registration.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    var temp= FirebaseAuth.instance.currentUser;
    if(temp != null){
      fetchuser();
    }
  }

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

  Future<void> fetchuser() async{
    if(!loaded && Platform.isAndroid){
      await FirebaseMessaging.instance.getToken().then((token) async {
        await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).update({
          'Token' : token,
        }).whenComplete(() async {
          await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){
            setState(() {
              usermodel=value.data()!;
              if(usermodel["Subject"]==null){
                Navigator.push(context, PageTransition(
                    child: const StudentDetails(),
                    type: PageTransitionType.bottomToTop,
                  duration: const Duration(milliseconds: 400),
                  childCurrent: const MainPage()
                ),
                );
              }
              if (kDebugMode) {
                print(usermodel);
              }
              loaded=true;
            });
          });
        });

      });
    }
    if(!loaded && Platform.isIOS){
      await FirebaseMessaging.instance.getAPNSToken().then((token) async {
        print(token);
        await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).update({
          'Token' : token,
        }).whenComplete(() async {
          await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){
            setState(() {
              usermodel=value.data()!;
              if (kDebugMode) {
                print(usermodel);
              }
              loaded=true;
            });
          });
        });

      });
    }
  }
}
