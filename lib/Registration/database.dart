import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class database
{
  Future<GeoPoint> getloc() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      print("enabled permission");
    } else {
      print('not enabled ermission');
    }
    var status = await Permission.location.status;
    if (status.isGranted) {
      print("Granted");
    } else if (status.isDenied) {
      //openAppSettings();
      Map<Permission, PermissionStatus> status =
      await [Permission.location].request();
    }
    if (await Permission.location.isPermanentlyDenied ||
        await Permission.location.isRestricted) {
      openAppSettings();
    }


    Position x = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    print("location is:${x.latitude.toStringAsPrecision(21)}......${x.longitude.toStringAsPrecision(21)}.........");

    return GeoPoint(double.parse(x.latitude.toStringAsPrecision(21)), double.parse(x.longitude.toStringAsPrecision(21)));
  }

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
            // "notification":<String,dynamic>{
            //   'body': body,
            //   'title':title,
            //   'android_channel_id':"high_importance_channel"
            // },
            "to": token
          })
      );
    }catch(e){

    }
  }



  int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }
}