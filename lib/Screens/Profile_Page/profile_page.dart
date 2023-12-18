import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Profile_Page/subject_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';
import '../../Constraints.dart';


bool profile_update = false;

class Profile_page extends StatefulWidget {
  const Profile_page({super.key});
  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {
  TextEditingController universityController = TextEditingController();
  TextEditingController collControler = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController sectionController = TextEditingController();



  List<dynamic> university = [];
  List<dynamic> college = [];
  List<dynamic> course = [];
  List<dynamic> branch = [];
  List<String> year = ['1', '2', '3', '4', '5'];
  List<String> section = ['A', 'B', 'C', 'D', 'E'];
  bool edituniversity = true;
  bool editcollege = true;
  bool editcourse = true;
  bool edityear = true;
  bool editbranch = true;
  bool editsection = true;
  bool editsubject = true;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    fetchuniversity();
    fetchcollege();
    fetchcourse();
    fetchbranch();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*1,
      width: size.width*1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            // Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            //Color.fromRGBO(118, 78, 232, 1),
            Colors.deepPurple.shade300
          ],
        ),

      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(

          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 15,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.black26.withOpacity(0.6),

          title: AutoSizeText(
            "My Profile",
            style: GoogleFonts.gfsDidot(
              fontWeight: FontWeight.w700,
              fontSize: size.height * 0.03,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent
                // gradient: LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //     colors: [
                //       Color.fromRGBO(120, 149, 150, 1),
                //       Color.fromRGBO(120, 149, 150, 1),
                //       Colors.white,
                //       Color.fromRGBO(120, 149, 150, 1),
                //       Color.fromRGBO(120, 149, 150, 1),
                //     ]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Column(children: [
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    Stack(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: size.height * 0.06,
                            backgroundImage: usermodel["Profile_URL"] != null
                                ? NetworkImage(usermodel["Profile_URL"])
                                : null,
                            backgroundColor: Colors.grey,
                            child: usermodel["Profile_URL"] == null
                                ? AutoSizeText(
                              usermodel["Name"].toString().substring(0, 1),
                              style: GoogleFonts.exo(
                                  fontSize: size.height * 0.05,
                                  fontWeight: FontWeight.w600),
                            )
                                : null,
                          ),
                        ),
                        Positioned(
                            bottom: -5,
                            left: 205,
                            child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt_rounded,
                                  size: size.height * 0.03,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  print(imagePicker);
                                  XFile? file = await imagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  print(file?.path);

                                  setState(() {
                                    profile_update = true;
                                  });
                                  // Create reference of Firebase Storage

                                  Reference reference =
                                  FirebaseStorage.instance.ref();

                                  // Create Directory into Firebase Storage

                                  Reference image_directory =
                                  reference.child("User_profile");

                                  Reference image_folder = image_directory
                                      .child("${usermodel["Email"]}");

                                  await image_folder
                                      .putFile(File(file!.path))
                                      .whenComplete(
                                        () async {
                                      String download_url =
                                      await image_folder.getDownloadURL();
                                      print("uploaded");
                                      print(download_url);
                                      await FirebaseFirestore.instance
                                          .collection("Students")
                                          .doc(FirebaseAuth
                                          .instance.currentUser?.email)
                                          .update({
                                        "Profile_URL": download_url,
                                      }).whenComplete(() async {
                                        await FirebaseFirestore.instance
                                            .collection("Students")
                                            .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                            .get()
                                            .then((value) {
                                          setState(() {
                                            usermodel = value.data()!;
                                          });
                                        }).whenComplete(() {
                                          setState(() {
                                            profile_update = false;
                                          });
                                        });
                                      });
                                      setState(() {
                                        profile_update = false;
                                      });
                                    },
                                  );
                                }))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.01, bottom: size.height * 0.005),
                      child: AutoSizeText(
                        usermodel["Name"],
                        style: GoogleFonts.exo(
                            fontSize: size.height * 0.023,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.height * 0.001),
                      child: AutoSizeText(
                        usermodel["Email"],
                        style: GoogleFonts.exo(
                            fontSize: size.height * 0.023,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: size.height * 0.022),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.all(size.height * 0.01),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      edituniversity
                          ?
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.height * 0.02),
                              child: AutoSizeText("University :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                  color: Colors.black26.withOpacity(0.7),

                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.outer,
                                        color: Colors.black54,
                                        offset: Offset(1, 1))
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.account_balance,
                                              color: Colors.black),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          AutoSizeText(
                                            usermodel["University"],
                                            style: GoogleFonts.exo(
                                              fontSize: size.height * 0.02,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            edituniversity = false;
                                            editcollege = true;
                                            editcourse = true;
                                            edityear = true;
                                            editbranch = true;
                                            editsection = true;
                                            editsubject = true;
                                          });
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const EditUniversityFormPage(),));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          :

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: size.height * 0.064,
                          width: size.width,
                          decoration: BoxDecoration(
                            color:   Colors.black26.withOpacity(0.7),
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.84,
                                child: SearchField(
                                  controller: universityController,
                                  suggestionItemDecoration:
                                  SuggestionDecoration(),
                                  key: const Key("Search key"),
                                  suggestions: university
                                      .map((e) => SearchFieldListItem(e))
                                      .toList(),
                                  searchStyle: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  suggestionStyle: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  marginColor: Colors.black,
                                  suggestionsDecoration:
                                  SuggestionDecoration(
                                      color: const Color.fromRGBO(
                                          40, 130, 146, 1),
                                      //shape: BoxShape.rectangle,
                                      padding: const EdgeInsets.all(10),
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.black),
                                      borderRadius:
                                      BorderRadius.circular(0)),
                                  searchInputDecoration: InputDecoration(
                                      hintText: "University",
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      hintStyle: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      focusColor: Colors.black,
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      )),
                                  onSuggestionTap: (value) {
                                    print(value.searchKey);
                                    // print(universityController.text.toString());

                                    //FocusScope.of(context).requestFocus(colf);
                                  },
                                  enabled: true,
                                  hint: "University",
                                  itemHeight: 50,
                                  maxSuggestionsInViewPort: 3,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.11,
                                child: TextButton(
                                  onPressed: () async {
                                    if (universityController.text
                                        .trim()
                                        .isNotEmpty) {
                                      await FirebaseFirestore.instance
                                          .collection("Students")
                                          .doc(usermodel["Email"])
                                          .update({
                                        "University": universityController
                                            .text
                                            .trim()
                                            .toString(),
                                      }).whenComplete(() {
                                        setState(() {
                                          edituniversity = true;
                                        });
                                      });
                                    } else {
                                      InAppNotifications.instance
                                        ..titleFontSize = 14.0
                                        ..descriptionFontSize = 14.0
                                        ..textColor = Colors.black
                                        ..backgroundColor =
                                        const Color.fromRGBO(
                                            150, 150, 150, 1)
                                        ..shadow = true
                                        ..animationStyle =
                                            InAppNotificationsAnimationStyle
                                                .scale;
                                      InAppNotifications.show(
                                        // title: '',
                                        duration:
                                        const Duration(seconds: 2),
                                        description:
                                        "Please Select the Option First",
                                      );
                                    }
                                  },
                                 child: AutoSizeText(
                                 "Save",style: GoogleFonts.exo(
                                   color: Colors.green.shade800,
                                   fontWeight: FontWeight.w700,
                                   fontSize: size.height*0.008
                                 ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      editcollege
                          ? SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.height * 0.02),
                              child: AutoSizeText("College :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                  color:  Colors.black26.withOpacity(0.7),

                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.outer,
                                        color: Colors.black54,
                                        offset: Offset(1, 1))
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.maps_home_work),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          AutoSizeText(
                                            usermodel["College"],
                                            style: GoogleFonts.exo(
                                                fontSize:
                                                size.height * 0.02,
                                                fontWeight:
                                                FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              editcollege=false;
                                              edituniversity = true;
                                              editcourse = true;
                                              edityear = true;
                                              editbranch = true;
                                              editsection = true;
                                              editsubject = true;
                                            });
                                          },
                                          icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: size.height * 0.064,
                          width: size.width,
                          decoration: BoxDecoration(
                            color:   Colors.black26.withOpacity(0.7),
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.845,
                                child: SearchField(
                                  controller: collControler,
                                  suggestionItemDecoration:
                                  SuggestionDecoration(),
                                  key: const Key("Search key"),
                                  suggestions: college
                                      .map((e) => SearchFieldListItem(e))
                                      .toList(),
                                  searchStyle: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  suggestionStyle: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  marginColor: Colors.black,
                                  suggestionsDecoration:
                                  SuggestionDecoration(
                                      color: const Color.fromRGBO(
                                          40, 130, 146, 1),
                                      //shape: BoxShape.rectangle,
                                      padding: const EdgeInsets.all(10),
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.black),
                                      borderRadius:
                                      BorderRadius.circular(0)),
                                  searchInputDecoration: InputDecoration(
                                      hintText: "College",
                                      fillColor: Colors.transparent,

                                      filled: true,
                                      hintStyle: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      focusColor: Colors.black,
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      )),
                                  onSuggestionTap: (value) {
                                    print(value.searchKey);
                                    // print(universityController.text.toString());

                                    //FocusScope.of(context).requestFocus(colf);
                                  },
                                  enabled: true,
                                  hint: "College",
                                  itemHeight: 50,
                                  maxSuggestionsInViewPort: 3,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.11,
                                child: TextButton(
                                  onPressed: () async {
                                    if(collControler.text.trim().isNotEmpty) {
                                      await    FirebaseFirestore.instance
                                          .collection("Students")
                                          .doc(usermodel["Email"])
                                          .update({
                                        "College": collControler.text.trim().toString(),
                                      }).whenComplete(() {
                                        setState(() {
                                          editcollege=true;
                                        });
                                      });

                                    }
                                    else{
                                      InAppNotifications.instance
                                        ..titleFontSize = 14.0
                                        ..descriptionFontSize = 14.0
                                        ..textColor = Colors.black
                                        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                        ..shadow = true
                                        ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                      InAppNotifications.show(
                                        // title: '',
                                        duration: const Duration(seconds: 2),
                                        description: "Please Select the Option First",

                                      );
                                    }

                                  },
                                 child: AutoSizeText(
                                    "Save",style: GoogleFonts.exo(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w700,
                                      fontSize: size.height*0.008
                                  ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      editcourse
                          ?
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.height * 0.02),
                              child: AutoSizeText("Course",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                  color: Colors.black26.withOpacity(0.7),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.outer,
                                        color: Colors.black54,
                                        offset: Offset(1, 1))
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(CupertinoIcons.book),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          AutoSizeText(
                                            usermodel["Course"],
                                            style: GoogleFonts.exo(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              editcourse=false;
                                              edituniversity = true;
                                              editcollege = true;
                                              edityear = true;
                                              editbranch = true;
                                              editsection = true;
                                              editsubject = true;
                                            });
                                          },
                                          icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          height: size.height * 0.064,
                          width: size.width,
                          decoration: BoxDecoration(
                            color:   Colors.black26.withOpacity(0.7),
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.84,
                                child: SearchField(
                                  controller:courseController,

                                  suggestionItemDecoration: SuggestionDecoration(),
                                  key: const Key("Search key"),
                                  suggestions:
                                  course.map((e) => SearchFieldListItem(e)).toList(),
                                  searchStyle: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  suggestionStyle: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  marginColor: Colors.black,
                                  suggestionsDecoration: SuggestionDecoration(
                                      color:
                                      const Color.fromRGBO(40, 130, 146, 1),

                                    //shape: BoxShape.rectangle,
                                      padding: const EdgeInsets.all(10),
                                      border: Border.all(width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.circular(0)),
                                  searchInputDecoration: InputDecoration(
                                      hintText: "Course",
                                      fillColor: Colors.transparent,

                                      filled: true,
                                      hintStyle: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      focusColor: Colors.black,
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      )),
                                  onSuggestionTap: (value) {
                                    print(value.searchKey);
                                    // print(universityController.text.toString());

                                  },
                                  enabled: true,
                                  hint: "Course",
                                  itemHeight: 50,
                                  maxSuggestionsInViewPort: 3,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.11,
                                child: TextButton(
                                  onPressed: () async {
                                    if(courseController.text.trim().isNotEmpty) {
                                      await    FirebaseFirestore.instance
                                          .collection("Students")
                                          .doc(usermodel["Email"])
                                          .update({
                                        "Course": courseController.text.trim().toString(),
                                      }).whenComplete(() {
                                        setState(() {
                                          editcourse=true;
                                        });
                                      });

                                    }
                                    else{
                                      InAppNotifications.instance
                                        ..titleFontSize = 14.0
                                        ..descriptionFontSize = 14.0
                                        ..textColor = Colors.black
                                        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                        ..shadow = true
                                        ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                      InAppNotifications.show(
                                        // title: '',
                                        duration: const Duration(seconds: 2),
                                        description: "Please Select the Option First",

                                      );
                                    }

                                  },
                                  child: AutoSizeText(
                                    "Save",style: GoogleFonts.exo(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w700,
                                      fontSize: size.height*0.008
                                  ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      editbranch
                          ?
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.height * 0.02),
                              child: AutoSizeText("Branch",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                  color:  Colors.black26.withOpacity(0.7),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.outer,
                                        color: Colors.black54,
                                        offset: Offset(1, 1))
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.account_tree_outlined),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          AutoSizeText(
                                            usermodel["Branch"],
                                            style: GoogleFonts.exo(
                                                fontSize:
                                                size.height * 0.02,
                                                fontWeight:
                                                FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              editbranch = false;
                                              edituniversity = true;
                                              editcollege = true;
                                              editcourse = true;
                                              edityear = true;
                                              editsection = true;
                                              editsubject = true;
                                            });
                                            // Navigator.push(context,
                                            //     MaterialPageRoute(builder: (context) => const EditBranchFormPage(),));
                                          },
                                          icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color:   Colors.black26.withOpacity(0.7),
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.84,
                                child: SearchField(
                                  controller: branchController,
                                  suggestionItemDecoration:
                                  SuggestionDecoration(),
                                  key: const Key("Search key"),
                                  suggestions: branch
                                      .map((e) => SearchFieldListItem(e))
                                      .toList(),
                                  searchStyle: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  suggestionStyle: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  marginColor: Colors.black,
                                  suggestionsDecoration:
                                  SuggestionDecoration(
                                      color: const Color.fromRGBO(
                                          40, 130, 146, 1),
                                      //shape: BoxShape.rectangle,
                                      padding: const EdgeInsets.all(10),
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.black),
                                      borderRadius:
                                      BorderRadius.circular(0)),
                                  searchInputDecoration: InputDecoration(
                                      hintText: "Branch",
                                      fillColor:   Colors.transparent,

                                      filled: true,
                                      hintStyle: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      focusColor: Colors.black,
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      )),
                                  onSuggestionTap: (value) {
                                    print(value.searchKey);
                                    // print(universityController.text.toString());

                                  },
                                  enabled: true,
                                  hint: "Branch",
                                  itemHeight: 50,
                                  maxSuggestionsInViewPort: 3,
                                ),
                              ),
                              SizedBox(
                                  width: size.width * 0.11,
                                  child: TextButton(
                                      onPressed: () async {
                                        if (branchController.text
                                            .trim()
                                            .isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection("Students")
                                              .doc(usermodel["Email"])
                                              .update({
                                            "University": branchController
                                                .text
                                                .trim()
                                                .toString(),
                                          }).whenComplete(() {
                                            setState(() {
                                              editbranch=true;
                                            });
                                          });
                                        } else {
                                          InAppNotifications.instance
                                            ..titleFontSize = 14.0
                                            ..descriptionFontSize = 14.0
                                            ..textColor = Colors.black
                                            ..backgroundColor =
                                            const Color.fromRGBO(
                                                150, 150, 150, 1)
                                            ..shadow = true
                                            ..animationStyle =
                                                InAppNotificationsAnimationStyle
                                                    .scale;
                                          InAppNotifications.show(
                                            // title: '',
                                            duration:
                                            const Duration(seconds: 2),
                                            description:
                                            "Please Select the Option First",
                                          );
                                        }
                                      },
                                    child: AutoSizeText(
                                      "Save",style: GoogleFonts.exo(
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.w700,
                                        fontSize: size.height*0.008
                                    ),
                                    ),
                                  ),
                              )
                            ],
                          ),
                        ),
                      ),
                      edityear
                          ?
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.height * 0.02),
                              child: AutoSizeText("Year",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                  color: Colors.black26.withOpacity(0.7),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.outer,
                                        color: Colors.black54,
                                        offset: Offset(1, 1))
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.date_range),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          AutoSizeText(
                                            usermodel["Year"],
                                            style: GoogleFonts.exo(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              edityear=false;
                                              edituniversity = true;
                                              editcollege = true;
                                              editcourse = true;
                                              editbranch = true;
                                              editsection = true;
                                              editsubject = true;
                                            });
                                          },
                                          icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: size.height * 0.064,
                          width: size.width,
                          decoration: BoxDecoration(
                            color:   Colors.black26.withOpacity(0.7),
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.84,
                                child:SearchField(
                                  controller:yearController ,

                                  suggestionItemDecoration: SuggestionDecoration(),
                                  key: const Key("Search key"),
                                  suggestions:
                                  year.map((e) => SearchFieldListItem(e)).toList(),
                                  searchStyle: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  suggestionStyle: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  marginColor: Colors.black,
                                  suggestionsDecoration: SuggestionDecoration(
                                      color:
                                      const Color.fromRGBO(40, 130, 146, 1),
                                      //shape: BoxShape.rectangle,
                                      padding: const EdgeInsets.all(10),
                                      border: Border.all(width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.circular(0)),
                                  searchInputDecoration: InputDecoration(
                                      hintText: "Year",
                                      fillColor: Colors.transparent,

                                      filled: true,
                                      hintStyle: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      focusColor: Colors.black,
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      )),
                                  onSuggestionTap: (value) {
                                    print(value.searchKey);
                                    // print(universityController.text.toString())
                                  },
                                  enabled: true,
                                  hint: "Year",
                                  itemHeight: 50,
                                  maxSuggestionsInViewPort: 2,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.11,
                                child: TextButton(
                                  onPressed: () async {
                                    if(yearController.text.trim().isNotEmpty) {
                                      await    FirebaseFirestore.instance
                                          .collection("Students")
                                          .doc(usermodel["Email"])
                                          .update({
                                        "University": yearController.text.trim().toString(),
                                      }).whenComplete(() {
                                        setState(() {
                                          edityear=true;
                                        });
                                      });

                                    }
                                    else{
                                      InAppNotifications.instance
                                        ..titleFontSize = 14.0
                                        ..descriptionFontSize = 14.0
                                        ..textColor = Colors.black
                                        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                        ..shadow = true
                                        ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                      InAppNotifications.show(
                                        // title: '',
                                        duration: const Duration(seconds: 2),
                                        description: "Please Select the Option First",

                                      );
                                    }

                                  },
                                  child: AutoSizeText(
                                    "Save",style: GoogleFonts.exo(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w700,
                                      fontSize: size.height*0.008
                                  ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      editsection
                          ?
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.height * 0.02),
                              child: AutoSizeText("Section",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                  color: Colors.black26.withOpacity(0.7),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.outer,
                                        color: Colors.black54,
                                        offset: Offset(1, 1))
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(CupertinoIcons.layers_fill),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          AutoSizeText(
                                            usermodel["Section"],
                                            style: GoogleFonts.exo(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              editsection=false;
                                              edituniversity = true;
                                              editcollege = true;
                                              editcourse = true;
                                              edityear = true;
                                              editbranch = true;
                                              editsubject = true;
                                            });
                                          },
                                          icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: size.height * 0.064,
                          width: size.width,
                          decoration: BoxDecoration(
                            color:   Colors.black26.withOpacity(0.7),
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: size.width * 0.84,
                                  child:SearchField(
                                    controller: sectionController,

                                    suggestionItemDecoration: SuggestionDecoration(),
                                    key: const Key("Search key"),
                                    suggestions:
                                    section.map((e) => SearchFieldListItem(e)).toList(),
                                    searchStyle: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                    suggestionStyle: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    marginColor: Colors.black,
                                    suggestionsDecoration: SuggestionDecoration(
                                        color:
                                        const Color.fromRGBO(40, 130, 146, 1),
                                        //shape: BoxShape.rectangle,
                                        padding: const EdgeInsets.all(10),
                                        border: Border.all(width: 2, color: Colors.black),
                                        borderRadius: BorderRadius.circular(0)),
                                    searchInputDecoration: InputDecoration(
                                        hintText: "Section",
                                        fillColor: Colors.transparent,

                                        filled: true,
                                        hintStyle: GoogleFonts.openSans(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            width: 3,
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        focusColor: Colors.black,
                                        disabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            width: 3,
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            width: 3,
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(30),
                                        )),
                                    onSuggestionTap: (value) {
                                      print(value.searchKey);


                                    },
                                    enabled: true,
                                    hint: "Section",
                                    itemHeight: 50,
                                    maxSuggestionsInViewPort: 3,
                                  )
                              ),
                              SizedBox(
                                width: size.width * 0.11,
                                child: TextButton(
                                  onPressed: () async {
                                    if(sectionController.text.trim().isNotEmpty) {
                                      await    FirebaseFirestore.instance
                                          .collection("Students")
                                          .doc(usermodel["Email"])
                                          .update({
                                        "University": sectionController.text.trim().toString(),
                                      }).whenComplete(() {
                                        setState(() {
                                          editsection=true;
                                        });
                                      });

                                    }
                                    else{
                                      InAppNotifications.instance
                                        ..titleFontSize = 14.0
                                        ..descriptionFontSize = 14.0
                                        ..textColor = Colors.black
                                        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                        ..shadow = true
                                        ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                      InAppNotifications.show(
                                        // title: '',
                                        duration: const Duration(seconds: 2),
                                        description: "Please Select the Option First",

                                      );
                                    }

                                  },
                                  child: AutoSizeText(
                                    "Save",style: GoogleFonts.exo(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w700,
                                      fontSize: size.height*0.008
                                  ),
                                  ),
                                  ),
                                ),

                            ],
                          ),
                        ),
                      )
                      ,

                      SizedBox(
                        height: size.height * 0.08 * usermodel["Subject"].length +
                            size.height * 0.05,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.height * 0.02),
                              child: AutoSizeText("Subjects ",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            SizedBox(
                              height: size.height *
                                  0.08 *
                                  usermodel["Subject"].length,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: usermodel["Subject"].length,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.015,
                                        bottom: size.height * 0.05,
                                        left: size.height * 0.015,
                                        right: size.height * 0.01),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: size.height * 0.1),
                                      width: size.width * 0.4,
                                      height: size.height * 0.06,
                                      decoration: BoxDecoration(
                                        color: Colors.black26.withOpacity(0.7),

                                      borderRadius: const BorderRadius.all(
                                            Radius.circular(30)),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 10,
                                              blurStyle: BlurStyle.outer,
                                              color: Colors.black54,
                                              offset: Offset(1, 1))
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.subject),
                                                SizedBox(
                                                  width: size.width * 0.02,
                                                ),
                                                AutoSizeText(
                                                  usermodel["Subject"][index],
                                                  style: GoogleFonts.exo(
                                                      fontSize:
                                                      size.height * 0.02,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  if(edituniversity  && editcollege  && editcourse   && edityear && editbranch && editsection  && editsubject)
                                                  {

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                          const EditSubjectFormPage(),
                                                        )).whenComplete(() {
                                                      setState(() {
                                                        editcourse=false;
                                                      });
                                                    });
                                                  }
                                                  else {
                                                    InAppNotifications.instance
                                                      ..titleFontSize = 14.0
                                                      ..descriptionFontSize = 14.0
                                                      ..textColor = Colors.black
                                                      ..backgroundColor =
                                                      const Color.fromRGBO(
                                                          150, 150, 150, 1)
                                                      ..shadow = true
                                                      ..animationStyle =
                                                          InAppNotificationsAnimationStyle
                                                              .scale;
                                                    InAppNotifications.show(
                                                      // title: '',
                                                      duration:
                                                      const Duration(seconds: 2),
                                                      description:
                                                      "Save The Previous Detail First",
                                                    );
                                                  }
                                                },
                                                icon: const Icon(Icons.edit))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )

                      ,
                      SizedBox(
                        height: size.height * 0.05,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

      ),
    );
  }

  fetchuniversity() async {
    final ref = await FirebaseFirestore.instance
        .collection("University")
        .doc("University")
        .get();
    university = ref.data()!["University"];
  }

  fetchcollege() async {
    final ref = await FirebaseFirestore.instance
        .collection("Colleges")
        .doc(usermodel["University"])
        .get();
    setState(() {
      college = ref.data()!["Colleges"];
      //print(college);
    });
  }

  fetchcourse() async {
    final ref =
    await FirebaseFirestore.instance.collection("Course").doc(usermodel["College"]).get();
    setState(() {
      course = ref.data()!["Course"];
    });
  }

  fetchbranch() async {
    final ref =
    await FirebaseFirestore.instance.collection("Branch").doc(usermodel["Course"]).get();
    setState(() {
      branch = ref.data()!["Branch"];
    });
  }

}
