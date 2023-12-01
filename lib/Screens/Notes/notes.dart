
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import '../../Constraints.dart';
import '../Chat_tiles/PdfViewer.dart';
import 'QuizScore.dart';
import 'QuizScreen.dart';
import 'SubjectQuizScore.dart';
import 'download_tile.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  DateTime currDate=DateTime.now();

  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject = usermodel["Subject"][0];

  String systempath='';

  int currIndex=-1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setsystemppath();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    BorderRadiusGeometry radiusGeomentry=BorderRadius.circular(size.width*0.09);
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
                            onTap: () {
                              setState(() {
                                selectedSubject = subjects[index];
                              });
                            },
                            child: Container(
                              height: size.height * 0.068,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.centerLeft,
                                  //   end: Alignment.centerRight,
                                  //   colors: [
                                  //     Color.fromRGBO(169, 169, 207, 1),
                                  //     // Color.fromRGBO(86, 149, 178, 1),
                                  //     Color.fromRGBO(189, 201, 214, 1),
                                  //     //Color.fromRGBO(118, 78, 232, 1),
                                  //     Color.fromRGBO(175, 207, 240, 1),
                                  //
                                  //     // Color.fromRGBO(86, 149, 178, 1),
                                  //     Color.fromRGBO(189, 201, 214, 1),
                                  //     Color.fromRGBO(169, 169, 207, 1),
                                  //   ],
                                  // ),
                                  shape: BoxShape.circle,
                                  border:  selectedSubject == subjects[index]
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
                                      color: selectedSubject == subjects[index]
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
                                color: selectedSubject == subjects[index]
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
          height: size.height*0.75,
          width: size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Divider(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.01,
                  thickness: MediaQuery.of(context).size.height * 0.003,
                  endIndent: 8,
                  indent: 8,
                ),

                SizedBox(
                  height: size.height*0.7,
                  width: size.width,
                  child: StreamBuilder
                    (
                    stream: FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject").snapshots(),
                    builder: ( context, snapshot)
                    {
                      return  snapshot.hasData
                          ?
                      snapshot.data?.data() != null
                          ?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.data()?["Total_Notes"],
                          itemBuilder: (context, index) {
                            bool isExpanded;
                            if(currIndex==index)
                              {
                                isExpanded=true;
                              }
                            else{
                              isExpanded=false;
                            }
                            Timestamp deadline=snapshot.data!.data()?["Notes-${index+1}"]["Deadline"] ?? Timestamp(0, 0);

                            return Padding(
                              padding:  EdgeInsets.all(size.width*0.032),
                              child: Container(
                                width: size.width*0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: radiusGeomentry,
                                    border: Border.all(color:const Color.fromRGBO(56, 33, 101,1),width: 3)
                                ),
                                child: Stack(

                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: size.height*0.11,
                                          width: size.width*0.93,
                                          child: Padding(
                                              padding:  EdgeInsets.only(top:size.height*0.01,left:size.height*0.01,right:size.height*0.01),
                                              child: InkWell(
                                                onTap: (){
                                                  File file=File("$systempath/Campus Link/$selectedSubject/Notes/${snapshot.data!.data()?["Notes-${index+1}"]["File_Name"]}");
                                                   if(file.existsSync())
                                                   {
                                                     Navigator.push(
                                                       context,
                                                       PageTransition(
                                                         child: PdfViewer(document: "$systempath/Campus Link/$selectedSubject/Notes/${snapshot.data!.data()?["Notes-${index+1}"]["File_Name"]}",name: snapshot.data!.data()?["Notes-${index+1}"]["File_Name"] ),
                                                         type: PageTransitionType.bottomToTopJoined,
                                                         duration: const Duration(milliseconds: 200),
                                                         alignment: Alignment.bottomCenter,
                                                         childCurrent: const Notes(),
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
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:BorderRadius.only(
                                                        topLeft: Radius.circular(size.width*0.02),
                                                        topRight: Radius.circular(size.width*0.02)),
                                                    /* image: DecorationImage(
                                                    image: NetworkImage("${snapshot.data["Notes-${index+1}"]["thumbnailURL"]}",
                                                    ),fit: BoxFit.cover,
                                                  )*/
                                                  ),
                                                  child:Center(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: size.height*0.01,
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
                                                          "Notes : ${index + 1}",
                                                          style: GoogleFonts.courgette(
                                                              color: Colors.black,
                                                              fontSize: size.height*0.023,
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),),
                                              )
                                          ),
                                        ),
                                        AnimatedContainer(
                                          height: isExpanded ? size.height*0.24 :size.height*0.14,
                                          width:size.width*0.98,
                                          duration: const Duration(milliseconds: 1),
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(56, 33, 101,1),
                                              borderRadius: BorderRadius.only(bottomRight:Radius.circular(size.width*0.068),bottomLeft: Radius.circular(size.width*0.068))

                                          ),
                                          child: SingleChildScrollView(
                                            physics: const NeverScrollableScrollPhysics(),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: size.height*0.018,
                                                ),
                                                ListTile(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:BorderRadius.only(
                                                        bottomLeft: Radius.circular(size.width*0.1),
                                                        bottomRight: Radius.circular(size.width*0.12)),),
                                                  title: SizedBox(
                                                      height: size.height*0.088,
                                                      width: size.width*0.75,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          FittedBox(
                                                            fit:BoxFit.fill,
                                                            child: AutoSizeText(
                                                              snapshot.data!.data()?["Notes-${index+1}"]["File_Name"] ?? "",
                                                              style: GoogleFonts.exo(
                                                                  fontSize: size.height*0.02,
                                                                  color: Colors.white70,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                              maxLines: 1,),
                                                          ),
                                                          SizedBox(
                                                            height: size.height*0.0075,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              FittedBox(
                                                                fit: BoxFit.fill,
                                                                child: AutoSizeText(
                                                                  snapshot.data!.data()?["Notes-${index+1}"]["File_Size"]!=null
                                                                      ?
                                                                  "Size:${(int.parse(snapshot.data!.data()?["Notes-${index+1}"]["File_Size"].toString() ?? "")/1048576).toStringAsFixed(2)} MB"
                                                                      :
                                                                  "",
                                                                  style: GoogleFonts.exo(
                                                                      fontSize: size.height*0.016,
                                                                      color: Colors.white70,
                                                                      fontWeight: FontWeight.w500),),
                                                              ),
                                                              FittedBox(
                                                                fit: BoxFit.fill,
                                                                child: AutoSizeText(
                                                                  snapshot.data!.data()?["Notes-${index+1}"]["Stamp"]!=null
                                                                      ?
                                                                  "Date: ${(snapshot.data!.data()?["Notes-${index+1}"]["Stamp"].toDate()).toString().split(" ")[0]}"
                                                                      :
                                                                  "",
                                                                  style: GoogleFonts.exo(
                                                                      fontSize: size.height*0.016,
                                                                      color: Colors.white70,
                                                                      fontWeight: FontWeight.w500),),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: size.height*0.008,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              /*AutoSizeText(
                                                            snapshot.data["Notes-${index+1}"]["Submitted by"]!=null &&  snapshot.data["Notes-${index+1}"]["Submitted by"].contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")
                                                                ?
                                                            "Status : Submit"
                                                                :
                                                            "Status : Panding",
                                                            style: GoogleFonts.exo(
                                                                fontSize: size.height*0.016,
                                                                color: Colors.white70,
                                                                fontWeight: FontWeight.w500),),*/
                                                              FittedBox(
                                                                fit:BoxFit.fill,
                                                                child: AutoSizeText(
                                                                  snapshot.data!.data()?["Notes-${index+1}"]["Stamp"]!=null
                                                                      ?
                                                                  "Deadline : ${(snapshot.data!.data()?["Notes-${index+1}"]["Stamp"].toDate()).toString().split(" ")[0]} ${snapshot.data!.data()?["Notes-${index+1}"]["Submitted by"]!=null &&  snapshot.data!.data()?["Notes-${index+1}"]["Submitted by"].contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")?"( Submit )":"( Pending )"}"
                                                                      :
                                                                  "",
                                                                  style: GoogleFonts.exo(
                                                                      fontSize: size.height*0.016,
                                                                      color: Colors.white70,
                                                                      fontWeight: FontWeight.w500),),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                //   leading:Container(
                                                //       height: size.width*0.07,
                                                //       width: size.width*0.07,
                                                //       decoration:  const BoxDecoration(
                                                //         color: Colors.transparent,
                                                //         shape: BoxShape.circle,
                                                //         /*image:DecorationImage(
                                                // image: fileAlreadyExists
                                                //     ?
                                                // const AssetImage("assets/icon/pdf.png"):
                                                // const AssetImage("assets/icon/download-button.png"),
                                                // fit: BoxFit.cover,
                                                // alignment: Alignment.center, )*/
                                                //       ),
                                                //       child: Image.asset("assets/icon/pdf.png")),

                                                  // subtitle: AutoSizeText('DEADLIiNE',style: GoogleFonts.exo(fontSize: size.height*0.015,color: Colors.black,fontWeight: FontWeight.w400),),
                                                  trailing:  SizedBox(
                                                    height: size.width * 0.12,
                                                    width: size.width * 0.12,
                                                    child: FloatingActionButton(
                                                      backgroundColor:
                                                      (currDate.year>deadline.toDate().year ||
                                                          currDate.month>deadline.toDate().month ||
                                                          currDate.day>deadline.toDate().day ||
                                                          currDate.hour>deadline.toDate().hour ||
                                                          currDate.minute>deadline.toDate().minute ||
                                                          currDate.second>deadline.toDate().second) &&
                                                          (snapshot.data!.data()?["Notes-${index+1}"]["Quiz_Created"]==true)
                                                          ?
                                                      Colors.red
                                                          :
                                                      Colors.lightBlueAccent,
                                                      elevation: 0,
                                                      onPressed: (){
                                                        setState(() {
                                                          if(currIndex==index)
                                                          {
                                                            currIndex=-1;
                                                          }
                                                          else{
                                                            currIndex=index;
                                                          }
                                                        });

                                                      },
                                                      child:Image.asset("assets/icon/speech-bubble.png",
                                                        width: size.height*0.045,
                                                        height: size.height*0.045,),
                                                    ),
                                                  ),

                                                ),
                                                isExpanded
                                                    ?
                                                Padding(
                                                    padding: EdgeInsets.only(top: size.height*0.014),
                                                    child:  snapshot.data!.data()?["Notes-${index+1}"]["Submitted by"]!=null &&  snapshot.data!.data()?["Notes-${index+1}"]["Submitted by"].contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")
                                                        ?
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                            width: size.width*0.72,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                AutoSizeText(
                                                                  "Score :${snapshot.data!.data()?["Notes-${index+1}"]["Response"]["${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}"]["Score"].toString()}/10",
                                                                  style: GoogleFonts.poppins(
                                                                      color: Colors.white70,
                                                                      fontSize: size.height*0.015
                                                                  ),
                                                                ),
                                                                LinearProgressIndicator(
                                                                  minHeight: size.height*0.01,
                                                                  backgroundColor: Colors.black,
                                                                  color: Colors.green,
                                                                  //borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                                  value: snapshot.data!.data()?["Notes-${index+1}"]["Response"]["${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}"]["Score"]/10,
                                                                ),
                                                              ],
                                                            )
                                                        ),
                                                        SizedBox(height: size.height*0.015,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Container(
                                                              height: size.height * 0.046,
                                                              width: size.width * 0.34,
                                                              decoration: BoxDecoration(
                                                                  gradient: const LinearGradient(
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                    colors: [
                                                                      Colors.blue,
                                                                      Colors.purpleAccent,
                                                                    ],
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                                  border: Border.all(color: Colors.black, width: 2)
                                                              ),
                                                              child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.transparent,
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                                  ),

                                                                  onPressed: (){

                                                                  },
                                                                  child: AutoSizeText(
                                                                    "Submitted",
                                                                    style: GoogleFonts.openSans(
                                                                        fontSize: size.height * 0.022,
                                                                        color: Colors.white
                                                                    ),


                                                                  )),
                                                            ),
                                                            Container(
                                                              height: size.height * 0.046,
                                                              width: size.width * 0.34,
                                                              decoration: BoxDecoration(
                                                                  gradient: const LinearGradient(
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                    colors: [
                                                                      Colors.blue,
                                                                      Colors.purpleAccent,
                                                                    ],
                                                                  ),
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(
                                                                          size.width * 0.035)),
                                                                  border: Border.all(
                                                                      color: Colors.black, width: 2)
                                                              ),
                                                              child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors
                                                                          .transparent,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius
                                                                              .all(
                                                                              Radius.circular(size
                                                                                  .width * 0.035)))
                                                                  ),

                                                                  onPressed: () {

                                                                    Navigator.push(context,
                                                                        PageTransition(
                                                                            child: Quizscore(
                                                                              quizId: index + 1, selectedSubject: selectedSubject,),
                                                                            type: PageTransitionType
                                                                                .bottomToTopJoined,
                                                                            childCurrent: const Notes(),
                                                                            duration: const Duration(
                                                                                milliseconds: 300)
                                                                        )
                                                                    );
                                                                  },
                                                                  child: FittedBox(
                                                                    fit: BoxFit.cover,
                                                                    child: AutoSizeText(
                                                                      "Leaderboard",
                                                                      style: GoogleFonts.openSans(
                                                                          fontSize: size.height * 0.022,
                                                                          color: Colors.white
                                                                      ),


                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                        :
                                                    snapshot.data!.data()?["Notes-${index+1}"]["Quiz_Created"]==true
                                                        ?
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        snapshot.data!.data()?["Notes-${index+1}"]["Submitted by"]!=null &&
                                                            snapshot.data!.data()?["Notes-${index+1}"]["Submitted by"]
                                                                .contains("${usermodel["Email"]
                                                                .toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")
                                                            ?
                                                        Container(
                                                          height: size.height * 0.046,
                                                          width: size.width * 0.34,
                                                          decoration: BoxDecoration(
                                                              gradient: const LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [
                                                                  Colors.blue,
                                                                  Colors.purpleAccent,
                                                                ],
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                              border: Border.all(color: Colors.black, width: 2)
                                                          ),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.transparent,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                              ),

                                                              onPressed: (){

                                                              },
                                                              child: AutoSizeText(

                                                                "Submitted",
                                                                style: GoogleFonts.openSans(
                                                                    fontSize: size.height * 0.022,
                                                                    color: Colors.white
                                                                ),


                                                              )),
                                                        )
                                                            :
                                                        Container(
                                                          height: size.height * 0.046,
                                                          width: size.width * 0.34,
                                                          decoration: BoxDecoration(
                                                              gradient: const LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [
                                                                  Colors.blue,
                                                                  Colors.purpleAccent,
                                                                ],
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                              border: Border.all(color: Colors.black, width: 2)
                                                          ),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.transparent,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                              ),

                                                              onPressed: (){

                                                                Navigator.push(context,
                                                                    PageTransition(
                                                                        child: QuizScreen(subject: selectedSubject, notesId: index+1,
                                                                        ),
                                                                        type: PageTransitionType
                                                                            .bottomToTopJoined,
                                                                        childCurrent: const Notes(),
                                                                        duration: const Duration(
                                                                            milliseconds: 300)
                                                                    )
                                                                );

                                                              },
                                                              child: AutoSizeText(

                                                                "Take Quiz",
                                                                style: GoogleFonts.openSans(
                                                                    fontSize: size.height * 0.022,
                                                                    color: Colors.white
                                                                ),


                                                              )),
                                                        ),
                                                        Container(
                                                          height: size.height * 0.046,
                                                          width: size.width * 0.34,
                                                          decoration: BoxDecoration(
                                                              gradient: const LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [
                                                                  Colors.blue,
                                                                  Colors.purpleAccent,
                                                                ],
                                                              ),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      size.width * 0.035)),
                                                              border: Border.all(
                                                                  color: Colors.black, width: 2)
                                                          ),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors
                                                                      .transparent,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .all(
                                                                          Radius.circular(size
                                                                              .width * 0.035)))
                                                              ),

                                                              onPressed: () {
                                                                Navigator.push(context,
                                                                    PageTransition(
                                                                        child: Quizscore(
                                                                          quizId: index + 1, selectedSubject: selectedSubject,),
                                                                        type: PageTransitionType
                                                                            .bottomToTopJoined,
                                                                        childCurrent: const Notes(),
                                                                        duration: const Duration(
                                                                            milliseconds: 300)
                                                                    )
                                                                );
                                                              },
                                                              child: AutoSizeText(
                                                                "Leaderboard",
                                                                style: GoogleFonts.openSans(
                                                                    fontSize: size.height * 0.022,
                                                                    color: Colors.white
                                                                ),


                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                        :
                                                    Container(
                                                      height: size.height * 0.05,
                                                      width: size.width * 0.45,
                                                      decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                            colors: [
                                                              Colors.blue,
                                                              Colors.purpleAccent,
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                          border: Border.all(color: Colors.black, width: 2)
                                                      ),
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.transparent,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                          ),

                                                          onPressed: (){

                                                          },
                                                          child: AutoSizeText(
                                                            "Unavailable",
                                                            style: GoogleFonts.openSans(
                                                                fontSize: size.height * 0.022,
                                                                color: Colors.white
                                                            ),


                                                          )),
                                                    )
                                                ):
                                                const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Positioned(
                                        top: 10,
                                        right: size.width*0.055,
                                        child: Download(downloadUrl:snapshot.data!.data()?["Notes-${index+1}"]["Pdf_URL"], pdfName: snapshot.data!.data()?["Notes-${index+1}"]["File_Name"], path: "/Campus Link/$selectedSubject/Notes"))

                                  ],
                                ),
                              ),
                            );

                          },),
                      )
                          :
                      Center(child: AutoSizeText(
                        "No Data found!",
                        style: GoogleFonts.tiltNeon(
                            color: Colors.black87,
                            fontSize: size.width*0.08
                        ),
                      ),)
                      :
                          const loading(text: "Fetching from the server")
                      ;
                    },),
                )

              ],
            ),
          ),
        ),
      floatingActionButton: Container(
        height: size.height * 0.046,
        width: size.width * 0.372,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.purpleAccent,
              ],
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(
                    size.width * 0.035)),
            border: Border.all(
                color: Colors.black, width: 2)
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors
                    .transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .all(
                        Radius.circular(size
                            .width * 0.035)))
            ),

            onPressed: () {
              Navigator.push(context,
                  PageTransition(
                      child:  subjectQuizScore(subject: selectedSubject,),
                      type: PageTransitionType
                          .bottomToTopJoined,
                      childCurrent: const Notes(),
                      duration: const Duration(
                          milliseconds: 300)
                  )
              );
            },
            child: FittedBox(
              fit: BoxFit.cover,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.leaderboard_sharp,color: Colors.red),
                  SizedBox(
                    width: size.width*0.02,
                  ),
                  AutoSizeText(
                    "Leaderboard",
                    style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
            )),
      )


    );

  }
  // Future<void> checkAndRequestPermissions() async {
  //   directory = await getExternalStorageDirectory();
  //   var permission = await checkALLPermissions.isStoragePermission();
  //   if (permission) {
  //         dir = directory!.path.toString().substring(0, 19);
  //     path = "$dir/Campus Link/${usermodel["University"].split(
  //         " ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"]
  //         .split(" ")[0]} ${usermodel["Branch"].split(
  //         " ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject/Notes/";
  //     Directory(path).exists().then((value) async {
  //       if (!value) {
  //         await Directory(path).create(recursive: true);
  //       }
  //     });
  //     setState(() {
  //       permissionGranted = true;
  //     });
  //   }
  //   else {
  //
  //   }
  // }
  //
  // Future<void>checkExists()
  // async {
  //   await FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject")
  //       .get().then((value) {
  //     if(value.exists)
  //     {
  //         setState(() {
  //
  //           docExists=true;
  //         });
  //     }
  //     else{
  //       setState(() {
  //         docExists=false;
  //       });
  //     }
  //
  //   });
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

