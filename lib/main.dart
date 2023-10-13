import 'dart:async';
import 'package:campus_link_student/Registration/database.dart';
import 'package:campus_link_student/push_notification/helper_notification.dart';
import 'package:campus_link_student/push_notification/temp.dart';
import 'package:campus_link_student/push_notification/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'Connection.dart';


const fetchBackground = "fetchBackground";
@pragma('vm:entry-point')
callbackDispatcher() async {

  try{
    GeoPoint current_location=const GeoPoint(0, 0);
    print(".......Starting workmanager executeTask  1.....");
    Workmanager().executeTask((taskName, inputData) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      print(".......Starting asking For Location Always Permission .....");
      await CurrentLocationManager().askForLocationAlwaysPermission();
      print(".......complete asking For Location Always Permission .....");
      print(".......Starting Location  .....");
      CurrentLocationManager().start();

      print("....... Location started .....");
      print("....... fetching current Location  .....");
      current_location=await database().getloc();
      CurrentLocationManager().stop();
      // current_location=await CurrentLocationManager().getCurrentLocation();
      print(".......  current Location  fetched ${current_location.longitude} .....");
      print("....... Uploading location to firebase  .....");
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "Location": GeoPoint(double.parse(current_location.latitude.toStringAsPrecision(21)), double.parse(current_location.longitude.toStringAsPrecision(21))),
        "Active": true
          }).whenComplete(() {
        print("Start()");
        CurrentLocationManager().stop();

          }
      );
      print("....... location uploaded to firebase  .....");
      Workmanager().cancelByUniqueName("${inputData?["Stamp"]}");
      return Future.value(true);
    });

  }catch (e){
    print("..........error.........\n.........$e........");
  }
}
@pragma('vm:entry-point')
callbackDispatcherfordelevery() async {

  try{
    print(".......Starting workmanager executeTask   2.....");
    Workmanager().executeTask((taskName, inputData) async {
      try{
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        print(".............doc ${inputData?["channel"]}");
        print(".............stamp ${inputData?["stamp"]}");
        await FirebaseFirestore.instance.collection("Messages").doc(inputData?["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
            {
              "${inputData?["Email"]}_${inputData?["Stamp"]}_Delevered" : FieldValue.arrayUnion([
                {
                  "Email" : FirebaseAuth.instance.currentUser?.email,
                  "Stamp" : DateTime.now()
                }
              ])
            }
        );
      }
      catch (e){
        print("fucking error............................. $e ");
      }
      return Future.value(true);
    });

  }catch (e){
    print("..........error.........\n.........$e........");
  }
}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message");
  }

  print(".............from background handler.............");

  //NotificationServices.display(message);

  if(message.data["body"]=="Attendance Initialized"){

    try{
      Workmanager().initialize(
        callbackDispatcher,
      );
      String stamp=DateTime.now().toString();
      await Workmanager().registerOneOffTask(stamp, "Attendance",inputData: {"Stamp":stamp});

    }catch(e){
      print("........Error from background handler.........");
    }
  }
  print(message.data["msg"]);
  if(message.data["msg"]=="true"){
    try{
      Workmanager().initialize(
        callbackDispatcherfordelevery,
      );
      print(".......workmanager");
      await Workmanager().registerOneOffTask("Develered", "Delevery",inputData: {
        "channel" :message.data["channel"],
        "Stamp" : message.data["stamp"],
        "Email" : message.data["Email"]
      });
    }catch(e){
      print("........Error from background handler.........");
    }
  }
}
@pragma('vm:entry-point')
Future<void> firebaseMessagingonmessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a onmessage message");
  }

  print(".............From onmessage.............");

  NotificationServices.display(message);

  if(message.data["body"]=="Attendance Initialized"){
    print("error before enter");
    try{
      GeoPoint current_location=await database().getloc();
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "Location": current_location,
        "Active":true
      });
    }catch(e){
      print("........Error from onmessage handler.........");
    }
  }
  if(message.data["msg"]=="true"){
    await FirebaseFirestore.instance.collection("Messages").doc(message.data["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
        {
          "${message.data["Email"]}_${message.data["stamp"]}_Delevered" : FieldValue.arrayUnion([
            {
              "Email" : FirebaseAuth.instance.currentUser?.email,
              "Stamp" : DateTime.now()
            }
          ])
        }
    );
  }
}
@pragma('vm:entry-point')
Future<void> firebaseMessagingonmessageOpenedAppHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a onmessage message");
  }

  print(".............From onmessage.............");

  NotificationServices.display(message);

  if(message.data["body"]=="Attendance Initialized"){
    print("error before enter");
    try{
      GeoPoint current_location=await database().getloc();
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "Location": current_location,
        "Active":true
      });
    }catch(e){
      print("........Error from onmessage handler.........");
    }
  }
  if(message.data["msg"]=="true"){
    await FirebaseFirestore.instance.collection("Messages").doc(message.data["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
        {
          "${message.data["Email"]}_${message.data["stamp"]}_Delevered" : FieldValue.arrayUnion([
            {
              "Email" : FirebaseAuth.instance.currentUser?.email,
              "Stamp" : DateTime.now()
            }
          ])
        }
    );
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(
        callbackDispatcher,
      );
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }



class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    NotificationServices.initialize(context);

    FirebaseMessaging.onMessage.listen(firebaseMessagingonmessageHandler);

    FirebaseMessaging.onBackgroundMessage.call(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingonmessageOpenedAppHandler);

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromRGBO(213, 97, 132, 1),
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home:Checkconnection(),
      builder: InAppNotifications.init(),
    );
  }
}

