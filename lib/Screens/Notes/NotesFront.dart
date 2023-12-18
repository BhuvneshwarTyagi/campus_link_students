import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constraints.dart';
import '../Assignment/countDown.dart';
import '../Chat_tiles/PdfViewer.dart';
import '../Feedback/feedback.dart';
import 'QuizScore.dart';
import 'QuizScreen.dart';
import 'Raise_Query_Notes.dart';
import 'download_tile.dart';
import 'notes_list.dart';

class Front extends StatefulWidget {
  const Front({super.key, required this.deadline, required this.selectedSubject, required this.index, required this.fileName, required this.description, required this.size, required this.stamp, required this.submittedBy, required this.quizCreated, required this.downloadUrl, required this.Score, required this.totalQuestion, required this.videolinks, required this.userFieldExist});
  final Timestamp deadline;
  final String selectedSubject ;
  final int index;
  final String fileName;
  final String description;
  final String size;
  final Timestamp stamp;
  final List<dynamic> submittedBy;
  final bool quizCreated;
  final String downloadUrl;
  final String Score;
  final String totalQuestion;
  final List<dynamic> videolinks;
  final bool userFieldExist;
  @override
  State<Front> createState() => _FrontState();
}

class _FrontState extends State<Front> {
  bool isExpanded = false;
  String systempath='';
  DateTime currDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setsystemppath();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      key: const ValueKey(true),
      shape: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.5,
          )
      ),
      child: Stack(

        children: [
          Column(
            children: [
              InkWell(
                onTap: (){
                  File file=File("$systempath/Campus Link/${widget.selectedSubject}/Notes/${widget.fileName}");
                  if(file.existsSync())
                  {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: PdfViewer(document: "$systempath/Campus Link/${widget.selectedSubject}/Notes/${widget.fileName}",name: widget.fileName),
                        type: PageTransitionType.bottomToTopJoined,
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.bottomCenter,
                        childCurrent: const NotesList(),
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
                      description: "Please download the notes first",
                      // leading: const Icon(
                      //   Icons.error_outline_outlined,
                      //   color: Colors.red,
                      //   size: 55,
                      // )
                    );
                  }
                },
                child: SizedBox(
                  height: size.height*0.11,
                  width: size.width*0.93,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        widget.selectedSubject,
                        style: GoogleFonts.courgette(
                            color: Colors.black,
                            fontSize: size.height*0.02,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      AutoSizeText(
                        "Notes : ${widget.index + 1}",
                        style: GoogleFonts.courgette(
                            color: Colors.black,
                            fontSize: size.height*0.023,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ExpansionTile(
                collapsedBackgroundColor: const Color.fromRGBO(60, 99, 100, 1),
                backgroundColor: const Color.fromRGBO(60, 99, 100, 1),
                title: Row(
                  children: [
                    AutoSizeText(
                      widget.description,
                      style: GoogleFonts.tiltNeon(
                          fontSize: size.width*0.045,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                    ),
                    AutoSizeText(

                      "   (${(int.parse(widget.size ?? "")/1048576).toStringAsFixed(2)} MB)",

                      style: GoogleFonts.tiltNeon(
                          fontSize: size.width*0.035,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),),
                  ],
                ),
                iconColor: Colors.black,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Uploaded on: ${(widget.stamp.toDate()).toString().split(" ")[0]}",
                      style: GoogleFonts.tiltNeon(
                          fontSize: size.width*0.035,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),),
                    widget.deadline.seconds !=0
                        ?
                    !widget.submittedBy.contains(usermodel["Email"])
                        ?
                    CountDownTimer(deadline: "${widget.deadline.toDate().day}-${widget.deadline.toDate().month}-${widget.deadline.toDate().year}")
                        :
                    AutoSizeText(
                      "Quiz submitted",
                      style: GoogleFonts.tiltNeon(
                          color: Colors.green,
                          fontSize: size.width*0.04
                      ),)
                        :
                    AutoSizeText(
                      "Quiz not assigned till now",
                      style: GoogleFonts.tiltNeon(
                          color: Colors.orange,
                          fontSize: size.width*0.04
                      ),)
                  ],
                ),
                children: [
                  widget.submittedBy.contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")
                      ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "Score :${widget.Score}/${widget.totalQuestion}",
                              style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: size.height*0.015
                              ),
                            ),
                            LinearProgressIndicator(
                              minHeight: size.height*0.01,
                              backgroundColor: Colors.black,
                              color: Colors.green,
                              value: int.parse(widget.Score)/int.parse(widget.totalQuestion),
                              //borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height*0.015,),
                      ListTile(
                        leading: SizedBox(
                          width: size.width*0.1,
                          child: Image.asset("assets/images/leaderboard.png"),
                        ),
                        title: AutoSizeText(
                          "Leaderboard",
                          style: GoogleFonts.tiltNeon(
                              fontSize: size.width * 0.045,
                              color: Colors.black87
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              PageTransition(
                                  child: Quizscore(
                                    quizId: widget.index + 1, selectedSubject: widget.selectedSubject,),
                                  type: PageTransitionType
                                      .bottomToTopJoined,
                                  childCurrent: const NotesList(),
                                  duration: const Duration(
                                      milliseconds: 300)
                              )
                          );
                        },
                      )
                    ],
                  )
                      :
                  widget.quizCreated==true
                      ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.submittedBy.contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")
                          ?
                      const SizedBox()
                          :
                      ListTile(
                        title: AutoSizeText(

                          "Take Quiz",
                          style: GoogleFonts.tiltNeon(
                              fontSize: size.height * 0.022,
                              color: Colors.white
                          ),


                        ),
                        onTap: (){

                          Navigator.push(context,
                              PageTransition(
                                  child: QuizScreen(subject: widget.selectedSubject, notesId: widget.index+1,
                                  ),
                                  type: PageTransitionType
                                      .bottomToTopJoined,
                                  childCurrent: const NotesList(),
                                  duration: const Duration(
                                      milliseconds: 300)
                              )
                          );

                        },
                      ),
                      ListTile(
                        leading: SizedBox(
                          width: size.width*0.1,
                          child: Image.asset("assets/images/leaderboard.png"),
                        ),
                        title: AutoSizeText(
                          "Leaderboard",
                          style: GoogleFonts.tiltNeon(
                              fontSize: size.width * 0.045,
                              color: Colors.black87
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              PageTransition(
                                  child: Quizscore(
                                    quizId: widget.index + 1, selectedSubject: widget.selectedSubject,),
                                  type: PageTransitionType
                                      .bottomToTopJoined,
                                  childCurrent: const NotesList(),
                                  duration: const Duration(
                                      milliseconds: 300)
                              )
                          );
                        },
                      )
                    ],
                  )
                      :
                  const SizedBox(),
                  ListTile(
                    leading: SizedBox(
                      width: size.width*0.1,
                      child: Image.asset("assets/images/feedback.png"),
                    ),
                    title: AutoSizeText(
                      "Feedback",
                      style: GoogleFonts.tiltNeon(
                          fontSize: size.height*0.02,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return FeedbackPage(
                          index: widget.index+1,
                          subject: widget.selectedSubject,
                        );
                      },));
                    },
                  ),
                  ListTile(
                    leading: SizedBox(
                      width: size.width*0.1,
                      child: Image.asset("assets/images/query.png"),
                    ),
                    title: AutoSizeText(
                      "Raise query",
                      style: GoogleFonts.tiltNeon(
                          fontSize: size.height*0.02,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                    ),
                    onTap: () async {
                      await FirebaseFirestore.instance.collection("Notes")
                          .doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.selectedSubject}")
                          .update({
                        usermodel["Email"].toString().split("@")[0]: {
                          "Email": usermodel["Email"],
                          "Name": usermodel["Name"],
                          "Profile_URL": usermodel["Profile_URL"]
                        },
                      }).whenComplete(() {

                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return NotesQuery(
                            index: widget.index+1,
                            subject: widget.selectedSubject,
                          );
                        },));
                      });
                    },
                  ),

                  SizedBox(
                    height: widget.videolinks.isNotEmpty ? size.width*0.06 + (size.height*0.07 * widget.videolinks.length ) : 0,
                    child: ListView.builder(
                      itemCount: widget.videolinks.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            index==0
                                ?
                            AutoSizeText(
                              "Video Lectures",
                              style: GoogleFonts.tiltNeon(
                                fontSize: size.width*0.05,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),

                              maxLines: 3,
                            )
                                :
                            const SizedBox(),

                            ListTile(
                              leading: SizedBox(
                                width: size.width*0.1,
                                child: Image.asset("assets/images/link.png"),
                              ),
                              title: AutoSizeText(
                                widget.videolinks[index],
                                style: GoogleFonts.tiltNeon(
                                    fontSize: size.width*0.05,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline
                                ),

                                maxLines: 3,
                              ),
                              onTap: () async {
                                final Uri url = Uri.parse(widget.videolinks[index]);
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),

          Positioned(
              top: 10,
              right: size.width*0.055,
              child: Row(
                children: [
                  DownloadButton(downloadUrl: widget.downloadUrl, pdfName: widget.fileName, path: "/Campus Link/${widget.selectedSubject}/Notes"),

                  SizedBox(
                   width: size.width*0.08,
                  )
                ],
              ))

        ],
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
