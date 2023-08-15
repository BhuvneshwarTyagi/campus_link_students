import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Constraints.dart';

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
        desiredAccuracy: LocationAccuracy.high);
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print("location is:${x.latitude}");
    print("location is:${x.longitude}");

    return GeoPoint(x.latitude, x.longitude);
  }


}