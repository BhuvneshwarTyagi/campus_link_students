
import 'package:campus_link_student/Registration/Login.dart';
import 'package:campus_link_student/Registration/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Constraints.dart';
import '../Registration/Verify Email.dart';
import '../Registration/navigation.dart';
import 'dashboard.dart';
import 'loadingscreen.dart';




class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}



class _MainPageState extends State<MainPage> {
  var mtoken;
  bool loaded =false;

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot)  {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SignInScreen();
        } else if (snapshot.connectionState == ConnectionState.active && !snapshot.hasData) {
          return const SignInScreen();
        } else if (snapshot.connectionState == ConnectionState.active && snapshot.hasData)
        {

          if(FirebaseAuth.instance.currentUser!.emailVerified){
            !loaded?
            getToken()
            :
                null;

             return  loaded?
             const navigation()
             :
              const loading( text: "Data is Retrieving from server please wait");
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

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).update({
        'Token' : token,
      });
      List<dynamic> subjects=await FirebaseFirestore
          .instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get()
          .then((value) {
        return value.data()?["Subject"];
      }).whenComplete(() => print("done......"));

      for(var s in subjects){

        await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){
          usermodel=value.data()!;
        }).whenComplete(() async {
          // String channel_perfix = "${usermodel["University"].toString().trim().split(" ")[0]} "
          //     "${usermodel["College"].toString().trim().split(" ")[0]} "
          //     "${usermodel["Course"].toString().trim().split(" ")[0]} "
          //     "${usermodel["Branch"].toString().trim().split(" ")[0]} "
          //     "${usermodel["Year"].toString().trim().split(" ")[0]} "
          //     "${usermodel["Section"].toString().trim().split(" ")[0]}";
          // await FirebaseFirestore
          //     .instance
          //     .collection("Messages")
          //     .doc(channel_perfix+s.toString().trim().split(" ")[0])
          //     .update({
          //   "Token" : FieldValue.arrayUnion([token])
          // });
        });}
      if(mounted){
        setState(() {
          loaded=true;
        });      }
    },
    );

  }

Future<void> fetch_userdata()
async {
  await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){
    usermodel=value.data()!;
  }).whenComplete(() {
    setState(() {
      loaded=true;
    });
  });
}



}

