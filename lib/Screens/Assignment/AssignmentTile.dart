import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Assignment/upload_assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import '../Chat_tiles/PdfViewer.dart';
import '../Notes/download_tile.dart';
import 'assignment.dart';

class AssignmentTile extends StatefulWidget {
  const AssignmentTile({super.key, required this.subject, required this.index, required this.assignmentUrl, required this.docType, required this.docSize, required this.uploadTime, required this.deadline});
  final String subject;
  final int index;
  final String assignmentUrl;
  final String docType;
  final String docSize;
  final String uploadTime;
  final String deadline;
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
        child: SizedBox(
          height: size.height*0.235,
          width: size.width*0.9,
          child: Card(
            elevation: 30,
            shape: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87,width: 2),
            ),
            child: Column(
              children: [
                Expanded(

                  child: SizedBox(

                    height: size.height*0.12,
                    width: size.width*0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height*0.008,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: size.width*0.045,
                                child: DownloadButton(
                                  downloadUrl: widget.assignmentUrl,
                                  pdfName: "Assignment-${widget.index + 1}.${widget.docType}",
                                  path: "/Campus Link/${widget.subject}/Assignment",
                                )

                            ),
                            SizedBox(
                              width: size.width*0.02,
                            )
                          ],
                        ),
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
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only( left: size.height*0.01,right: size.height*0.008,top: size.height*0.006),
                    height: size.height*0.107,
                    color:  const Color.fromRGBO(60, 99, 100, 1),
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
                              "Assignment : ${widget.index + 1}(${widget.docSize}MB)",
                              style: GoogleFonts.courgette(
                                  color: Colors.black,
                                  fontSize: size.height*0.018,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            AutoSizeText(
                              "Deadline :${widget.deadline}",
                              style: GoogleFonts.courgette(
                                  color: Colors.black,
                                  fontSize: size.height*0.018,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            AutoSizeText(
                              "Before :${widget.uploadTime}",
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
                              widget.subject,
                              assignmentNumber:
                              widget.index + 1),

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
