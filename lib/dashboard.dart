import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;



class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  void sendPushMessage(String token, String body,String title) async{
    try{
      await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String ,  String>{
            'Content-Type' : "application/json",
            "Authorization":  "key=AAAAIV7WaYA:APA91bFtEFPpqZBF3z1FeRD6CmhYYrtA2EX7Y7oGCf2qjAHLKcyi15Dbd7e3Cjo3WS1rKeHCzS_07fUfUsV6jnTJ7uZiHy2z8h-CIRW9jjO2jxycobLjgrI7nVT76-mUt8Dd41psJ_oI"
          },
          body: jsonEncode(<String,dynamic>{
            'priority': 'high',
            "data": <String,dynamic>{
              'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
              'status':"done",
              'body': body,
              'title':title,
            },
            "notification":<String,dynamic>{
              'body': body,
              'title':title,
              'android_channel_id':"campuslink"
            },
            "to": token
          })
      );
    }catch(e){

    }
  }
  @override
  Widget build(BuildContext context) {
Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Home Page",style: GoogleFonts.exo(
          fontSize: 20,
          color: Colors.amberAccent
        ),),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout),color: Colors.amberAccent,)
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(child: ElevatedButton(
            onPressed: () async {
              String token="";
              await FirebaseFirestore.instance.collection("User Tokens").doc("1").get().then((value){
                setState(() {
                  token=value.data()!["token"];
                });
              }).whenComplete(() => sendPushMessage(
                  token,
                  "background",
                  'title'));

              },
            child: Text("Send"))),
      ),
    );


  }
}