import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Assignment/upload_assignment.dart';
import 'package:campus_link_student/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import '../../Constraints.dart';
import '../Chat_tiles/PdfViewer.dart';
import '../Notes/download_tile.dart';

class Assignment extends StatefulWidget {
  const Assignment({Key? key}) : super(key: key);

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject =" ";
  String systempath="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSubject = usermodel["Subject"][0];
    setsystemppath();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: size.height*0.11,
        flexibleSpace: SizedBox(
          height: size.height * 0.11,
          width: size.width * 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subjects.length,
            padding: EdgeInsets.only(top: size.height*0.01),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.016,
                        right: size.width * 0.016),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              selectedSubject = subjects[index];

                              print(selectedSubject);
                            });

                          },
                          child: Container(
                            height: size.height * 0.068,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                                border: subjects[index]== selectedSubject
                                    ? Border.all(
                                    color: Colors.greenAccent, width: 2)
                                    : Border.all(
                                    color: Colors.white,
                                    width: 1)),
                            child: Center(
                              child: AutoSizeText(
                                "${subjects[index][0]}",
                                style: GoogleFonts.openSans(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                    color:  subjects[index]== selectedSubject
                                        ? Colors.greenAccent
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.006,
                        ),
                        AutoSizeText(
                          "${subjects[index]}",
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                              color:  subjects[index]== selectedSubject
                                  ? Colors.greenAccent
                                  : Colors.black),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: SizedBox(
        height: size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Divider(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.015,
                thickness: MediaQuery.of(context).size.height * 0.003,
                endIndent: 8,
                indent: 8,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                child: SizedBox(
                  height: size.height * 0.69,
                  width: size.width*0.9,
                  child: StreamBuilder(
                    stream: FirebaseFirestore
                        .instance
                        .collection("Assignment")
                        .doc("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $selectedSubject",)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ?
                      snapshot.data!.data()!=null
                          ?
                      ListView.builder(
                        itemCount: snapshot.data!.data()!["Total_Assignment"] ,
                        itemBuilder: (context, index) {


                          return Padding(
                              padding: EdgeInsets.all( size.height*0.01),
                              child:  InkWell(
                                onTap: () async {
                                  File file=File("$systempath/Campus Link/$selectedSubject/Assignment/Assignment-${index + 1}.${snapshot.data!.data()?["Assignment-${index + 1}"]["Document-type"]}");
                                  if(file.existsSync())
                                  {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: PdfViewer(
                                            document: "$systempath/Campus Link/$selectedSubject/Assignment/Assignment-${index + 1}.${snapshot.data!.data()?["Assignment-${index + 1}"]["Document-type"]}",
                                            name: "Assignment-${index + 1}.${snapshot.data!.data()?["Assignment-${index + 1}"]["Document-type"]}"
                                        ),
                                        type: PageTransitionType.bottomToTopJoined,
                                        duration: const Duration(milliseconds: 200),
                                        alignment: Alignment.bottomCenter,
                                        childCurrent: const Assignment(),
                                      ),
                                    );
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
                                      description: "Please download the assignment first",
                                      // leading: const Icon(
                                      //   Icons.error_outline_outlined,
                                      //   color: Colors.red,
                                      //   size: 55,
                                      // )
                                    );
                                  }
                                },
                                child: Container(
                                  height: size.height*0.235,
                                  width: size.width*0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius:  BorderRadius.all(Radius.circular(size.width*0.068)),
                                      border: Border.all(color: Colors.black,width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(

                                        child: Container(

                                          height: size.height*0.12,
                                          width: size.width*0.9,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:BorderRadius.only(topLeft: Radius.circular(size.width*0.068),topRight: Radius.circular(size.width*0.068)),

                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: size.height*0.008,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [

                                                  CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    radius: size.width*0.045,
                                                    child: Download(
                                                        downloadUrl: snapshot.data!.data()?["Assignment-${index + 1}"]["Assignment"],
                                                        pdfName: "Assignment-${index + 1}.${snapshot.data!.data()?["Assignment-${index + 1}"]["Document-type"]}",
                                                        path: "/Campus Link/$selectedSubject/Assignment",
                                                    )

                                                  ),
                                                  SizedBox(
                                                    width: size.width*0.02,
                                                  )
                                                ],
                                              ),
                                              AutoSizeText(
                                                selectedSubject,
                                                style: GoogleFonts.courgette(
                                                    color: Colors.black,
                                                    fontSize: size.height*0.02,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Assignment : ${index+1}",
                                                style: GoogleFonts.courgette(
                                                    color: Colors.black,
                                                    fontSize: size.height*0.02,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only( left: size.height*0.01,right: size.height*0.008,top: size.height*0.006),
                                          height: size.height*0.107,
                                          width: size.width*0.9,
                                          decoration: BoxDecoration(
                                            color:  const Color.fromRGBO(60, 99, 100, 1),
                                            borderRadius: BorderRadius.only(bottomRight:Radius.circular(size.width*0.068),bottomLeft: Radius.circular(size.width*0.068)),

                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                    "Assignment : ${index + 1}(${(int.parse(snapshot.data!.data()!["Assignment-${index + 1}"]["Size"].toString())/1048576).toStringAsFixed(2)}MB)",
                                                    style: GoogleFonts.courgette(
                                                        color: Colors.black,
                                                        fontSize: size.height*0.018,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    "Deadline :${snapshot.data!.data()?["Assignment-${index + 1}"]["Last Date"]}",
                                                    style: GoogleFonts.courgette(
                                                        color: Colors.black,
                                                        fontSize: size.height*0.018,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    "Before :${snapshot.data!.data()?["Assignment-${index + 1}"]["Time"].toString().substring(10, 15)}",
                                                    style: GoogleFonts.courgette(
                                                        color: Colors.black,
                                                        fontSize: size.height*0.018,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ],
                                              ),


                                              Container(
                                                height: size.height * 0.045,
                                                width: size.width * 0.2,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                   BorderRadius.all(
                                                        Radius.circular(size.width*0.068)),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child:uploadAssignment(
                                                    selectedSubject:
                                                    selectedSubject,
                                                    assignmentNumber:
                                                    index + 1),

                                                // ElevatedButton(
                                                //     style: ElevatedButton.styleFrom(
                                                //         shape:
                                                //         const RoundedRectangleBorder(
                                                //             borderRadius:
                                                //             BorderRadius.all(
                                                //                 Radius
                                                //                     .circular(
                                                //                     20))),
                                                //         backgroundColor:
                                                //         Colors.transparent),
                                                //     onPressed: () {
                                                //       Navigator.push(
                                                //           context,
                                                //           PageTransition(
                                                //             child: uploadAssignment(
                                                //                 selectedSubject:
                                                //                 selectedSubject,
                                                //                 assignmentNumber:
                                                //                 index + 1),
                                                //             type: PageTransitionType
                                                //                 .bottomToTopJoined,
                                                //             duration: const Duration(
                                                //                 milliseconds: 200),
                                                //             childCurrent:
                                                //             const Assignment(),
                                                //           ));
                                                //     },
                                                //     child: AutoSizeText(
                                                //       "Submit",
                                                //       style: GoogleFonts.gfsDidot(
                                                //           fontWeight: FontWeight.w600,
                                                //           fontSize:
                                                //           size.height * 0.03),
                                                //     )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )


                                    ],
                                  ),
                                ),
                              )
                          );
                        },
                      )
                          :
                      Center(
                              child: AutoSizeText(
                                  "No Data found!",
                                style: GoogleFonts.tiltNeon(
                                  color: Colors.black87,
                                  fontSize: size.width*0.08
                                ),
                              ),
                          )
                          :
                      const loading(text: "Fetching data from server");
                    }
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Future<void> getdata() async {
  //   await FirebaseFirestore.instance
  //       .collection("Assignment")
  //       .doc(
  //     "${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $selectedSubject",
  //   )
  //       .get()
  //       .then((value) {
  //
  //     if (value.data() == null) {
  //       setState(() {
  //         nodata = true;
  //       });
  //     } else {
  //       setState(() {
  //         nodata = false;
  //         snapshot = value;
  //       });
  //     }
  //   }).whenComplete(() {
  //     setState(() {
  //       loaded = true;
  //     });
  //   });
  // }
  //
  // Future<void> checkAndRequestPermissions() async {
  //   if(Platform.isAndroid){
  //     directory = await getExternalStorageDirectory();
  //   }
  //
  //   bool permission=false;
  //    if(Platform.isAndroid){
  //      permission=await checkALLPermissions.isStoragePermission();
  //      if(!permission){
  //        if(await Permission.manageExternalStorage.request().isGranted){
  //          permission=true;
  //        }else{
  //          await Permission.manageExternalStorage.request().then((value) {
  //            bool check=value.isGranted;
  //            if(check){permission=true;}});
  //        }
  //
  //      }
  //    }
  //    if(Platform.isIOS){
  //      print("inside ios");
  //      permission= await Permission.mediaLibrary.isGranted;
  //      print("no permission");
  //      if(!permission){
  //        if(await Permission.mediaLibrary.request().isGranted){
  //          print("permission granted");
  //          permission=true;
  //        }else{
  //          print("not granted, requesting again");
  //          await Permission.mediaLibrary.request().then((value) {
  //            print("2nd request result: $value");
  //            bool check=value.isGranted;
  //            if(check){permission=true;}});
  //        }
  //
  //      }
  //    }
  //   //if (permission) {
  //     String? dir = directory?.path.toString().substring(0, 19);
  //     if(Platform.isIOS){
  //       await getDownloadsDirectory().then((value){
  //
  //         dir=value?.path;
  //         print("dir printing: $dir");
  //       });
  //     }
  //     path = "${dir!}/Campus Link/$selectedSubject/Assignment";
  //     await Directory(path).exists().then((value) async {
  //       if (!value) {
  //         try{
  //           await Directory(path)
  //               .create(recursive: true)
  //               .whenComplete(() => print(">>>>>created"));
  //         }catch(e){
  //           print("file error: $e");
  //         }
  //       }
  //     });
  //     setState(() {
  //       permissionGranted = true;
  //     });
  //
  //
  // }
  setsystemppath() async {
    Directory? directory;
    if(Platform.isAndroid){
      Directory? directory = await getExternalStorageDirectory();

      systempath = directory!.path.toString().substring(0, 19);

    }
    if(Platform.isIOS){
      directory= await getApplicationDocumentsDirectory();
      systempath = directory.path;
    }
  }
}
