import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Notes/NotesTile.dart';
import 'package:campus_link_student/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constraints.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {

  DateTime currDate=DateTime.now();

  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject = usermodel["Subject"][0];
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Column(
      children: [

        SizedBox(
          height: size.height * 0.11,
          width: size.width * 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subjects.length,
            padding: EdgeInsets.only(top: size.height*0.01),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.016,),
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
              );
            },
          ),
        ),
        Divider(
          color: Colors.black,
          height: MediaQuery.of(context).size.height * 0.01,
          thickness: MediaQuery.of(context).size.height * 0.003,
          endIndent: 8,
          indent: 8,
        ),
        StreamBuilder
          (
          stream: FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject").snapshots(),
          builder: ( context, snapshot)
          {
            return  snapshot.hasData
                ?
                snapshot.data?.data() != null
                    ?
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.data()?["Total_Notes"],
                  itemBuilder: (context, index) {
                    Timestamp deadline=snapshot.data!.data()?["Notes-${index+1}"]["Deadline"] ?? Timestamp(0, 0);

                    return NotesTile(
                      deadline: deadline,
                      selectedSubject: selectedSubject,
                      index: index,
                      fileName: snapshot.data!.data()?["Notes-${index+1}"]["File_Name"],
                      size: snapshot.data!.data()!["Notes-${index+1}"]["File_Size"].toString(),
                      stamp: snapshot.data!.data()?["Notes-${index+1}"]["Stamp"],
                      submittedBy: snapshot.data!.data()?["Notes-${index+1}"]["Submitted by"] != null ? (snapshot.data!.data()?["Notes-${index+1}"]["Submitted by"]) : [] ,
                      quizCreated: snapshot.data!.data()?["Notes-${index+1}"]["Quiz_Created"],
                      downloadUrl: snapshot.data!.data()?["Notes-${index+1}"]["Pdf_URL"],
                      Score: snapshot.data!.data()?["Notes-${index+1}"]["Response"] != null && snapshot.data!.data()?["Notes-${index+1}"]["Response"]["${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}"] != null
                          ?
                      "${snapshot.data!.data()?["Notes-${index+1}"]["Response"]["${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}"]["Score"].toString()}"
                          :
                      "0",
                      totalQuestion: snapshot.data!.data()?["Notes-${index+1}"]["Total_Question"] != null
                          ?
                      "${snapshot.data!.data()?["Notes-${index+1}"]["Total_Question"]}"
                          :
                      "0",
                      videolinks: snapshot.data!.data()?["Notes-${index+1}"]["Total_Question"]==null
                      ?
                      []
                      :
                      snapshot.data!.data()?["Notes-${index+1}"]["Additional_Link"],
                    );

                  },)
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
      ],
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

}

