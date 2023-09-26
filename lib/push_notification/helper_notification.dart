import 'package:campus_link_student/push_notification/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationServices{
  RequestPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // notification permission is granted
    }
    else {
      // Open settings to enable notification permission
    }
  }
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) async {
    const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel("campuslink", "campuslink channel",
        importance: Importance.max, playSound: true);


    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings());

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    _notificationsPlugin.initialize(initializationSettings,);
  }

  static void display(RemoteMessage message) async {
    try {
      print("display");
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
            "campuslink",
            "campuslink channel",
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,

          ),
          iOS: DarwinNotificationDetails());

      await _notificationsPlugin.show(
        id,
        message.data["title"],
        message.data["body"],
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          "campuslink",
          "campuslink channel",
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher'
        ),
        iOS: DarwinNotificationDetails());
  }

  static void onMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification!.android;
    AppleNotification? appleNotification = message.notification!.apple;
    if (notification == null) return;
    if (androidNotification != null || appleNotification != null) {
      _notificationsPlugin.show(notification.hashCode, notification.title,
          notification.body, _notificationDetails());
    }
  }

  Future<void> setUserState({required String status}) async {
    if(status != "Online"){
      String? userId = FirebaseAuth.instance.currentUser?.email;
      final userdoc= await FirebaseFirestore.instance.collection("Students").doc(userId).get();



      List<dynamic> channels= userdoc.data()?["Message_channels"];

      for(var channel in channels){
        await FirebaseFirestore.instance.collection("Messages")
            .doc(channel).update(
            {
              "${userdoc["Email"].toString().split("@")[0]}.Active" : false,
              "${userdoc["Email"].toString().split("@")[0]}.Last_Active" : DateTime.now()
            }
        );
      }
    }


  }

  }
