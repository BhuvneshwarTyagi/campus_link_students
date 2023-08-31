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
      print(".......  current Location  fetched ${current_location.longitude} .....");
      print("....... Uploading location to firebase  .....");
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "Location": GeoPoint(double.parse(current_location.latitude.toStringAsPrecision(21)), double.parse(current_location.longitude.toStringAsPrecision(21))),
        "Active":true
          }).whenComplete(() {
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
      await Workmanager().registerOneOffTask("attendance", "Attendance");
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
        case AppLifecycleState.hidden:
          // TODO: Handle this case.
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
      home:Checkconnection(),
      builder: InAppNotifications.init(),
    );
  }
}

