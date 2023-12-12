import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Screens/Assignment/countDown.dart';
import 'package:campus_link_student/Screens/Assignment/upload_assignment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import '../Chat_tiles/PdfViewer.dart';
import '../Notes/download_tile.dart';
import 'assignment.dart';
import 'individual_assignment_leaderboard.dart';

class AssignmentTile extends StatefulWidget {
  const AssignmentTile({super.key, required this.subject, required this.index, required this.assignmentUrl, required this.docType, required this.docSize, required this.uploadTime, required this.deadline, required this.status, required this.count, required this.assignedOn});
  final String subject;
  final int index;
  final String assignmentUrl;
  final String docType;
  final String docSize;
  final String uploadTime;
  final String deadline;
  final String status;
  final int count;
  final Timestamp assignedOn;
  @override
  State<AssignmentTile> createState() => _AssignmentTileState();
}

class _AssignmentTileState extends State<AssignmentTile> {
  String systempath="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setsystemppath();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height*0.01),
      child: InkWell(
        onTap: () async {
          File file=File("$systempath/Campus Link/${widget.subject}/Assignment/Assignment-${widget.index + 1}.${widget.docType}");
          if(file.existsSync())
          {
            Navigator.push(
              context,
              PageTransition(
                child: PdfViewer(
                    document: "$systempath/Campus Link/${widget.subject}/Assignment/Assignment-${widget.index + 1}.${widget.docType}",
                    name: "Assignment-${widget.index + 1}.${widget.docType}"
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
        child: Card(
          elevation: 30,
          shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87,width: 2),
          ),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                child: Stack(
                  children: [

                    SizedBox(
                      height: size.height*0.107,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              widget.subject,
                              style: GoogleFonts.courgette(
                                  color: Colors.black,
                                  fontSize: size.height*0.02,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            AutoSizeText(
                              "Assignment : ${widget.index+1}",
                              style: GoogleFonts.courgette(
                                  color: Colors.black,
                                  fontSize: size.height*0.02,
                                  fontWeight: FontWeight.w400
                              ),
                            ),

                          ],
                        ),
                        SizedBox(
                          height: size.height*0.09,
                            width: size.width*0.2,
                            child: widget.status == "Accepted"
                                ?
                            Image.asset("assets/images/approved.png")
                                :
                            widget.status == "Rejected"
                                ?
                            Image.asset("assets/images/rejected.png")
                                :
                            const SizedBox()
                        ),
                      ],
                    ),
                  ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: DownloadButton(
                        downloadUrl: widget.assignmentUrl,
                        pdfName: "Assignment-${widget.index + 1}.${widget.docType}",
                        path: "/Campus Link/${widget.subject}/Assignment",
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color:  const Color.fromRGBO(60, 99, 100, 1),
                child: ExpansionTile(
                  iconColor: Colors.black,
                  title: AutoSizeText(
                    "Assignment : ${widget.index + 1}(${widget.docSize}MB)",
                    style: GoogleFonts.courgette(
                        color: Colors.black,
                        fontSize: size.width*0.05,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "Assigned on: ${widget.assignedOn.toDate()}",
                        style: GoogleFonts.tiltNeon(
                            color: Colors.black,
                            fontSize: size.width*0.04
                        ),
                      ),
                      (widget.status == "" )
                          ?
                      CountDownTimer(
                         deadline: widget.deadline,
                      )
                          :
                      AutoSizeText(
                        widget.status == "Pending" ? "Status Pending" : widget.status,
                        style: GoogleFonts.tiltNeon(
                        color: widget.status == "Pending" ? Colors.orange : widget.status == "Rejected" ? Colors.red : Colors.green,
                        fontSize: size.width*0.04
                      ),
                      )
                      ,
                    ],
                  ),
                  children: [
                    widget.status == ""
                        ?
                    Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: uploadAssignment(
                        selectedSubject: widget.subject,
                        assignmentNumber: widget.index + 1,
                        totalSubmittedAssignment: widget.count,
                      ),

                    )
                        :
                    const SizedBox(),
                    Card(

                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: ListTile(
                        leading: SizedBox(
                          width: size.width*0.1,
                          child: Image.asset("assets/images/leaderboard.png"),
                        ),
                        title: AutoSizeText(
                          "Leaderboard",
                          style: GoogleFonts.courgette(
                              color: Colors.black,
                              fontSize: size.height*0.018,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              PageTransition(
                                  child: IndividualAssignmentLeaderboard(
                                    index: widget.index,
                                    subject: widget.subject,
                                  ),
                                  type: PageTransitionType.bottomToTopJoined,
                                childCurrent: AssignmentTile(
                                  subject: widget.subject,
                                  assignmentUrl: widget.assignmentUrl,
                                  deadline: widget.deadline,
                                  docSize: widget.docSize,
                                  docType: widget.docType,
                                  index: widget.index,
                                  status: widget.status,
                                  uploadTime: widget.uploadTime,
                                  count: widget.count, assignedOn: widget.assignedOn,
                                ),
                              ),
                          );
                        },
                      ),
                    ),

                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
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
