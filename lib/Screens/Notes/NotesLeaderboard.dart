import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import '../Assignment/Top3_Leaderboard_tile.dart';

class NotesLeaderBoard extends StatefulWidget {
   const NotesLeaderBoard({super.key,});
  @override
  State<NotesLeaderBoard> createState() => _NotesLeaderBoardState();
}

class _NotesLeaderBoardState extends State<NotesLeaderBoard> {
  List<Map<String,dynamic>>result=[];
  List<Map<String,dynamic>>unattemptedStudents=[];
  String selectedSubject=usermodel["Subject"][0];
  bool load=false;
  Map<String,dynamic>allEmailsWithLink={};
  late QuerySnapshot<Map<String, dynamic>> allStudentsData;
  List<Map<String,dynamic>>allEmail=[];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchEmail().whenComplete(() {
      calculateResult().whenComplete(() {
        setState(() {
          load=true;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(image: AssetImage("assets/images/celebration.gif"),fit: BoxFit.fill),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.11,
            width: size.width * 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: usermodel["Subject"].length,
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
                                selectedSubject = usermodel["Subject"][index];
                                result.clear();
                                unattemptedStudents.clear();
                                load=false;
                                allEmail.clear();


                              });
                              await fetchEmail().whenComplete(() async {
                                await calculateResult();
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
                                  border:  selectedSubject == usermodel["Subject"][index]
                                      ? Border.all(
                                      color: Colors.greenAccent, width: 2)
                                      : Border.all(
                                      color: Colors.white,
                                      width: 1)),
                              child: Center(
                                child: AutoSizeText(
                                  "${usermodel["Subject"][index][0]}",
                                  style: GoogleFonts.openSans(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      color: selectedSubject == usermodel["Subject"][index]
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
                            "${usermodel["Subject"][index]}",
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w600,
                                color: selectedSubject == usermodel["Subject"][index]
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
          load && result.isNotEmpty
              ?
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject").snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ?
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        index==0
                            ?
                        Column(
                              children: [

                                TopThree(
                                  data: [
                                    {
                                      "Name" : result[0]['Name'],
                                      "Email" : result[0]['Email'],
                                      "Submitted" : result[0]['Score'],
                                    },
                                    {
                                      "Name" : result.length>=2 ? result[1]['Name'] : 'Unknown',
                                      "Email" : result.length>=2 ? result[1]['Email'] : 'Unknown',
                                      "Submitted" : result.length>=2 ? result[1]['Score'] : 0,
                                    },
                                    {
                                      "Name" : result.length>=3 ? result[2]['Name'] : 'Unknown',
                                      "Email" : result.length>=3 ? result[2]['Email'] : 'Unknown',
                                      "Submitted" : result.length>=3 ? result[2]['Score'] : 0,
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
                                        AutoSizeText("Attempted Students: ",
                                          style: GoogleFonts.tiltNeon(
                                              color: Colors.black,
                                              fontSize: size.width*0.05
                                          ),),
                                        AutoSizeText("${result.length}/${allStudentsData.docs.length}",
                                          style: GoogleFonts.poppins(
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
                              ],
                            )
                            :
                        const SizedBox(),

                        Padding(
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
                                    color: const Color.fromARGB(255, 228, 243, 247),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.all(size.height * 0.006),
                                        child: CircleAvatar(
                                          radius: size.width * 0.06,
                                          backgroundColor: Colors.green[900],
                                          child:  allEmailsWithLink[result[index]["Email"]]!="null"
                                              ?
                                          CircleAvatar(
                                            radius: size.width * 0.055,
                                            backgroundImage: NetworkImage("${allEmailsWithLink[result[index]["Email"]]}"),
                                          ):
                                          AutoSizeText(
                                            result[index]["Name"].toString().substring(0,1),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.tiltNeon(
                                                color: Colors.white,
                                                fontSize: size.width*0.07
                                            ),
                                          ),),
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
                                        "${result[index]["Score"].toString()} / 10",
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
                        ),
                        index==result.length-1 && unattemptedStudents.isNotEmpty
                            ?
                        Column(
                          children: [
                            Divider(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.height * 0.03,
                              thickness: MediaQuery.of(context).size.height * 0.003,
                              endIndent: 8,
                              indent: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    AutoSizeText("Unattempted Students : ",
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: size.width*0.05
                                      ),
                                    ),
                                    AutoSizeText("${unattemptedStudents.length}/${allStudentsData.docs.length}",
                                      style: GoogleFonts.poppins(
                                          color: Colors.red[900],
                                          fontSize: size.width*0.06
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                                height: size.height * 0.096*(unattemptedStudents.length),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:unattemptedStudents.length,
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
                                                    ),
                                                  )),
                                            ),
                                            Container(
                                              height: size.height * 0.07,
                                              width: size.width * 0.8,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: Colors.black
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(size.width * 0.08)),
                                                color: const Color.fromARGB(255, 228, 243, 247),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.all(size.height * 0.006),
                                                    child: CircleAvatar(
                                                      radius: size.width * 0.06,
                                                      backgroundColor: Colors.red[200],
                                                      child:  allEmailsWithLink[unattemptedStudents[index]["Email"]]!="null"
                                                          ?
                                                      CircleAvatar(
                                                        radius: size.width * 0.055,
                                                        backgroundImage: NetworkImage("${allEmailsWithLink[unattemptedStudents[index]["Email"]]}"),
                                                      ):
                                                      AutoSizeText(
                                                        unattemptedStudents[index]["Name"][0],
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.tiltNeon(
                                                            color: Colors.black,
                                                            fontSize: size.width*0.08
                                                        ),
                                                      ),),
                                                  ),
                                                  Expanded(
                                                      child:Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          AutoSizeText(
                                                            unattemptedStudents[index]["Name"],
                                                            style: GoogleFonts.tiltNeon(
                                                                color: Colors.black,
                                                                fontSize: size.width * 0.045),
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                          AutoSizeText(
                                                            unattemptedStudents[index]["Roll-number"],
                                                            style: GoogleFonts.tiltNeon(
                                                                color: Colors.black,
                                                                fontSize: size.width * 0.036),
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                          )
                                                        ],
                                                      )
                                                  ),

                                                  const AutoSizeText("UA",
                                                    style: TextStyle(
                                                      color:Colors.red,
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
                            )
                          ],
                        )
                            :
                        const SizedBox()
                      ],
                    );
                  },

                )
                    :
                const SizedBox(
                  child: Center(child: Text("No Data Found")),
                );
              }
          )
              :
          SizedBox(
            height: size.height*0.63,
            width: size.width,
            // decoration: const BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: [
            //         Colors.blue,
            //         Colors.purpleAccent,
            //       ],
            //     )
            // ),
            child: Center(
              child: AutoSizeText(
                "Quiz submissions are less than three.\nPlease come back later.",
                style: GoogleFonts.tiltNeon(
                    fontSize: 20,
                    color: Colors.black
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    )
      ;
  }




  Future<void> calculateResult() async {
    result.clear();
    final snapshot = await FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject").get();

    for(var email in  allEmail)
    {
      print("Email is present : $email");
      if(snapshot.data()?[email["Email"].toString().split("@")[0]] != null)
      {
        Map<String,dynamic>data={};
        data["Name"]=email["Name"];
        data["Rollnumber"]=email["Roll-number"];
        data["Score"]=snapshot.data()?[email["Email"].toString().split("@")[0]]["Score"];
        data["Quiz-Time"]=snapshot.data()?[email["Email"].toString().split("@")[0]]["Time"];
        data["Email"]=email["Email"];
        result.add(data);
        unattemptedStudents.removeWhere((element) => element["Email"]==email["Email"]);
      }
      else{

      }
    }


    // Sort the map based on timeStamp and Quiz Sore ....

    print("....................Before$result");

    result.sort((a, b) {
      if(a["Score"]==b["Score"])
      {
        return a["Quiz-Time"].compareTo(b["Quiz-Time"]);
      }
      else{
        return a["Score"].compareTo(b["Score"]);
      }
    },);
    int s=0;
    int e=result.length-1;
    while(s<e)
    {
      var temp =result[s];
      result[s]=result[e];
      result[e]=temp;
      s++;
      e--;
    }
    setState(() {
      load=true;
    });



  }

  Future<void> fetchEmail() async {
    await FirebaseFirestore.instance.collection("Students")
        .where("University",isEqualTo: usermodel["University"])
        .where("College",isEqualTo: usermodel["College"])
        .where("Branch",isEqualTo: usermodel["Branch"])
        .where("Course",isEqualTo: usermodel["Course"])
        .where("Year",isEqualTo: usermodel["Year"])
        .where("Section",isEqualTo: usermodel["Section"])
        .where("Subject",arrayContains: selectedSubject).get().then((value) {

      setState(() {
        allStudentsData=value;
      });
    }).whenComplete(() {
      setState(() {


        for(int i=0;i<allStudentsData.docs.length;i++)
        {

          allEmailsWithLink["${allStudentsData.docs[i]["Email"]}"] =
          allStudentsData.docs[i]["Profile_URL"]!=null
              ?
          "${allStudentsData.docs[i]["Profile_URL"]}"
              :
          "null";

          unattemptedStudents.add(
              {
                "Name":allStudentsData.docs[i]["Name"],
                "Roll-number":allStudentsData.docs[i]["Rollnumber"],
                "Email":allStudentsData.docs[i]["Email"]
              });

          allEmail.add(
              {
                "Name":allStudentsData.docs[i]["Name"],
                "Roll-number":allStudentsData.docs[i]["Rollnumber"],
                "Email":allStudentsData.docs[i]["Email"]
              });

        }

      });
    });

  }


}

