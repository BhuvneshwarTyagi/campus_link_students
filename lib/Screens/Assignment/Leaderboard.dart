import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import 'Top3_Leaderboard_tile.dart';

class AssignmentsOverAllLeaderBoard extends StatefulWidget {
  const AssignmentsOverAllLeaderBoard({super.key,});
  @override
  State<AssignmentsOverAllLeaderBoard> createState() => _AssignmentsOverAllLeaderBoardState();
}

class _AssignmentsOverAllLeaderBoardState extends State<AssignmentsOverAllLeaderBoard> {
  List<Map<String,dynamic>>result=[];
  int averageSubmission=0;
  bool load = false;
  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject =" ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSubject = usermodel["Subject"][0];
    call();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/celebration.gif"),fit: BoxFit.fill)
      ),
      child: Column(
        children: [
          SizedBox(
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
          const Divider(
            height: 1.5,
            color: Colors.black87,
            indent: 8,
            thickness: 1.5,
            endIndent: 8,
          ),
          SizedBox(
            height: size.height*0.7,
            child: StreamBuilder(
              stream: FirebaseFirestore
                  .instance
                  .collection("Assignment")
                  .doc(
                  "${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject"
              )
                  .snapshots(),
              builder: (context, snapshot) {

                return snapshot.hasData && load && result.isNotEmpty && snapshot.data!.exists
                    ?
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      TopThree(
                        data: [
                          {
                            "Name" : result[0]['Name'],
                            "Email" : result[0]['Email'],
                            "Submitted" : result[0]['Score'],
                          },
                          {
                            "Name" : result[1]['Name'],
                            "Email" : result[1]['Email'],
                            "Submitted" : result[1]['Score'],
                          },
                          {
                            "Name" : result[2]['Name'],
                            "Email" : result[2]['Email'],
                            "Submitted" : result[2]['Score'],
                          }
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AutoSizeText("Average Submission/Assignment: ",
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.width*0.05
                                ),),
                              AutoSizeText("$averageSubmission",
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.green[900],
                                    fontSize: size.width*0.06
                                ),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.022,
                      ),
                      Column(
                          children: [
                            SizedBox(
                                height: size.height * 0.095*(result.length),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: result.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(size.height * 0.008),
                                      child: SizedBox(
                                        height: size.height * 0.08,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.1,
                                              child: Center(
                                                  child: AutoSizeText(
                                                      "${index+1}",
                                                      style: GoogleFonts.tiltNeon(
                                                          fontSize: size.height*0.03,
                                                          color: Colors.black
                                                      )
                                                  )),
                                            ),
                                            Container(
                                              height: size.height * 0.07,
                                              width: size.width * 0.8,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black,width: 1.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(size.width * 0.08)),
                                                color: result[index]["Score"]*2 < snapshot.data!.data()?["Total_Assignment"] ? Colors.red[400] : Colors.green,
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.all(size.height * 0.006),
                                                    child: StreamBuilder(
                                                      stream: FirebaseFirestore.instance.collection("Students").doc(result[index]["Email"]).snapshots(),
                                                      builder: (context, studentsnapshot) {
                                                        return studentsnapshot.hasData
                                                            ?
                                                        CircleAvatar(
                                                            radius: size.width * 0.06,
                                                            backgroundColor: Colors.green[900],
                                                            child:  studentsnapshot.data!.data()?["Profile_URL"] !="null" && studentsnapshot.data!.data()?["Profile_URL"] != null
                                                                ?
                                                            CircleAvatar(
                                                              radius: size.width * 0.055,
                                                              backgroundImage: NetworkImage(studentsnapshot.data!.data()?["Profile_URL"]),
                                                            )
                                                                :
                                                            CircleAvatar(
                                                              radius: size.width * 0.055,
                                                              backgroundImage: const AssetImage("assets/images/unknown.png"),
                                                            )
                                                        )
                                                            :
                                                        const SizedBox();
                                                      }
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child:Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          AutoSizeText(
                                                            result[index]["Name"],
                                                            style: GoogleFonts.tiltNeon(
                                                                color: Colors.black,
                                                                fontSize: size.width * 0.045),
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                          AutoSizeText(
                                                            result[index]["Rollnumber"],
                                                            style: GoogleFonts.tiltNeon(
                                                                color: Colors.black,
                                                                fontSize: size.width * 0.036),
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                  AutoSizeText(
                                                    "${result[index]["Score"]} / ${snapshot.data!.data()?["Total_Assignment"]}",
                                                    style: const TextStyle(
                                                      color:Color.fromARGB(255, 10, 52, 84),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width*0.04,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },

                                )
                            ),
                          ])
                    ],
                  ),
                )
                    :
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Center(
                    child: AutoSizeText(
                      "No Assignment assigned till now.\nPlease come back later",
                      style: GoogleFonts.tiltNeon(
                          fontSize: 20,
                          color: Colors.black
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              ),
          ),
        ],
      ),
    );
  }


  call() async {
    await calculateResult().whenComplete((){
      setState(() {
        load=true;
      });
    });
  }
  Future<void> calculateResult() async {
    result=[];
    int submitted=0;
    final snap = await FirebaseFirestore
        .instance
        .collection("Assignment")
        .doc(
        "${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject"
    )
        .get();
    final allStudentsdata = await FirebaseFirestore.
    instance.
    collection("Students").
    where("Subject", arrayContains: selectedSubject).
    where("University",isEqualTo: usermodel["University"]).
    where("Year",isEqualTo: usermodel["Year"]).
    where("Branch",isEqualTo: usermodel["Branch"]).
    where("College",isEqualTo: usermodel["College"]).
    where("Section",isEqualTo: usermodel["Section"]).
    where("Course",isEqualTo: usermodel["Course"]).
    get();

    for(var email in  allStudentsdata.docs)
    {
        Map<String,dynamic>data={};
        data["Name"]=email.data()["Name"];
        data["Rollnumber"]=email.data()["Rollnumber"];
        data["Score"]=0;
        data["Quiz-Time"]= Timestamp(0,0);
        data["Email"]=email.data()["Email"];
        int stop= snap.data()?["Total_Assignment"] ?? 0;
        for(int i=1;i<= stop;i++){
          if(snap.data()?["Assignment-$i"]['Submitted-by']!=null && snap.data()?["Assignment-$i"]['Submitted-by'].contains(email.data()["Email"]) ){
            if(snap.data()?["Assignment-$i"]['submitted-Assignment'][email.data()['Email'].toString().split('@')[0]]['Status']=="Accepted"){
              data["Score"]++;
              submitted++;
              data["Quiz-Time"]=snap.data()?["Assignment-$i"]['submitted-Assignment'][email.data()['Email'].toString().split('@')[0]]['Time'];
            }
          }

        }
        result.add(data);
    }
    sortResult();
      averageSubmission = (submitted/snap.data()?["Total_Assignment"]).round();
  }
  sortResult(){
    result.sort((a, b) {
        return a["Score"].compareTo(b["Score"]);
      },
    );
    result = result.reversed.toList();
    result.sort((a,b) {
      if(a["Score"]==b["Score"])
      {
        return int.parse(a["Rollnumber"]).compareTo(int.parse(b["Rollnumber"]));
      }
      else{
        return 0;
      }
    });
  }
}
