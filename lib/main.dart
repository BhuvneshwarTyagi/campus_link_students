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
callbackDispatcher() async {

  try{
    GeoPoint current_location=const GeoPoint(0, 0);
    print(".......Starting workmanager executeTask.....");
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
      // current_location=await CurrentLocationManager().getCurrentLocation();
      print(".......  current Location  fetched $current_location .....");
      print("....... Uploading location to firebase  .....");
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({"Location": current_location}).whenComplete(() {
        print("Start()");
        CurrentLocationManager().stop();}
      );
      print("....... location uploaded to firebase  .....");
      return Future.value(true);
    });

  }catch (e){
    print("..........error.........\n.........$e........");
  }
}



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message");
  }

  print(".............Start().............");
  NotificationServices.display(message);
  Workmanager().initialize(
    callbackDispatcher,
  );
  if(message.data["body"]=="Attendance Initialized"){
    print("error before enter");
    await Workmanager().registerOneOffTask("attendance", "Attendance");
  }
}

Future<void> firebaseMessagingonmessageHandler(RemoteMessage message) async {
  print("Entered onmeassege");
  if (message.data["body"] != null) {
    if (kDebugMode) {
      print(message.data["title"]);
    }
    if (kDebugMode) {
      print(message.data["body"]);
    }
  }

  NotificationServices.display(message);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().whenComplete(() async {
    await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).update({
      "Name":"${TimeOfDay.now().minute}"
    });
  });
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

  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      //super.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.resumed:
          NotificationServices().setUserState(userState: UserState.Online);

          break;
        case AppLifecycleState.inactive:
          NotificationServices().setUserState(userState: UserState.Offline);
          break;
        case AppLifecycleState.paused:
          NotificationServices().setUserState(userState: UserState.Waiting);
          break;
        case AppLifecycleState.detached:
          NotificationServices().setUserState(userState: UserState.Offline);
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('inside catch statement');
      }
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromRGBO(213, 97, 132, 1),
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Checkconnection(),
      builder: InAppNotifications.init(),
    );
  }
}

