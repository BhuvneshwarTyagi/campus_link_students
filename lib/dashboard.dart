import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Registration/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../push_notification/temp.dart';
import '../Screens/attendance.dart';
import 'Registration/registration.dart';
import 'Registration/signUp.dart';

class StudentDashBoard extends StatefulWidget {
  const StudentDashBoard({Key? key}) : super(key: key);

  @override
  State<StudentDashBoard> createState() => _StudentDashBoardState();
}

class _StudentDashBoardState extends State<StudentDashBoard> {
  List<dynamic> name_email = [];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      fect_name_email();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return name_email.length == 0
        ?
    const Center(child: CircularProgressIndicator())
        :
    Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        title: AutoSizeText(
          "Campus Link",
          style: GoogleFonts.gfsDidot(
            fontWeight: FontWeight.w700,
            fontSize: size.height * 0.033,
            color: Colors.white,
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.black,
                    Colors.blueAccent,
                    Colors.purple,
                  ],
                ),
              ),
              accountName: AutoSizeText(
                name_email[0],
                style: GoogleFonts.exo(
                    fontSize: size.height * 0.022,
                    fontWeight: FontWeight.w600),
              ),
              accountEmail: AutoSizeText(
                name_email[1],
                style: GoogleFonts.exo(
                    fontSize: size.height * 0.02,
                    fontWeight: FontWeight.w600),
              ),
              currentAccountPicture: CircleAvatar(
                // backgroundColor: Colors.teal.shade300,
                child: AutoSizeText(
                  name_email[0].toString().substring(0, 1),
                  style: GoogleFonts.exo(
                      fontSize: size.height * 0.05,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home,color: Colors.black,),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings,color: Colors.black),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contacts,color: Colors.black),
              title: const Text("Contact Us"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.edit,color: Colors.black),
              title: const Text("Edit Your Detail"),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    child: const StudentDetails(),
                type: PageTransitionType.rightToLeftJoined,
                duration: const Duration(milliseconds: 350),
                childCurrent: const StudentDashBoard(),
                )
                );
                },
            ),
            ListTile(
              leading: const Icon(Icons.logout,color: Colors.black),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app,color: Colors.black),
              title: const Text("Exit"),
              onTap: () {
               exit(0);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: size.height * 1,
          width: size.width * 1,
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.22,
                width: size.width * 1,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.04,
                        ),
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.teal,
                          child: Text(
                            name_email[0].toString().substring(0, 1),
                            style: GoogleFonts.exo(
                                fontSize: size.height * 0.06,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(left: size.width * 0.08),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                "Welcome",
                                style: GoogleFonts.exo(
                                  fontSize: size.height * 0.022,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              AutoSizeText(
                                name_email![0],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.03,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.13),
                child: Container(
                  height: size.height,
                  width: size.width * 1,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {
                              print("clicked");
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const Attendance(),
                                  type: PageTransitionType.rightToLeftJoined,
                                  duration: const Duration(milliseconds: 350),
                                  childCurrent: const StudentDashBoard(),
                                ),
                              );



                            },
                            child: Card(
                              elevation: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: size.height * 0.1,
                                      width: size.width * 0.2,
                                      decoration: BoxDecoration(
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/attendance_icon.png"),
                                          fit: BoxFit.fill,
                                        ),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          "View Attendance",
                                          style: GoogleFonts.exo(
                                              fontSize:
                                              size.height * 0.02,
                                              fontWeight:
                                              FontWeight.w500),
                                        ),
                                        AutoSizeText(
                                          "Click to See Your Attendance",
                                          style: GoogleFonts.exo(
                                              fontSize:
                                              size.height * 0.01,
                                              fontWeight:
                                              FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {

                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: const Attendance(),
                                              type: PageTransitionType.rightToLeftJoined,
                                              duration: const Duration(milliseconds: 350),
                                              childCurrent: const StudentDashBoard(),
                                            ),
                                          );

                                        },
                                        icon: const Icon(
                                            Icons.arrow_forward_ios))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () async {
                              // GeoPoint current_location=const GeoPoint(0, 0);
                              // await CurrentLocationManager().askForLocationAlwaysPermission();
                              // print(".......complete asking For Location Always Permission .....");
                              // print(".......Starting Location  .....");
                              // CurrentLocationManager().start();
                              // print("....... Location started .....");
                              // print("....... fetching current Location  .....");
                              // current_location=await CurrentLocationManager().getCurrentLocation();
                              // print(".......  current Location  fetched $current_location .....");
                              // print("....... Uploading location to firebase  .....");
                              database().getloc();
                            },
                            child: Card(
                              elevation: 50,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          "assets/images/assignment_icon.png",
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "View Assignment",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      AutoSizeText(
                                        "Click to See Your Assignment",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height * 0.01,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.arrow_forward_ios))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => const Loginpage(),
                              //     ));
                            },
                            child: Card(
                              elevation: 50,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/notes_icon.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "View Notes",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      AutoSizeText(
                                        "Click to see notes",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height * 0.01,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.arrow_forward_ios))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 50,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/mark_icon.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "View Mark",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      AutoSizeText(
                                        "Click to See Your Mark",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height * 0.01,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.arrow_forward_ios))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 50,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/performance_icon.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "View Performance",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      AutoSizeText(
                                        "Click to See Your Performance",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height * 0.01,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.arrow_forward_ios))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fect_name_email() async {
    name_email.clear();
    final ref = await FirebaseFirestore.instance
        .collection("Students")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();

    setState(() {
      name_email.add(ref.data()?["Name"]);
      name_email.add(ref.data()?["Email"]);
    });
  }
}
