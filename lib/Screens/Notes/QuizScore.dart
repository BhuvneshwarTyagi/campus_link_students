
import 'package:campus_link_student/Screens/Assignment/Top3_Leaderboard_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import '../loadingscreen.dart';

class Quizscore extends StatefulWidget {
   Quizscore({super.key,required this.quizId,required this.selectedSubject});
 int quizId;
 String selectedSubject;
  @override
  State<Quizscore> createState() => _QuizscoreState();
}

class _QuizscoreState extends State<Quizscore> {

  List<Map<String,dynamic>>result=[];
  List<Map<String,dynamic>>unattemptedStudents=[];
  late DocumentSnapshot<Map<String, dynamic>> snapshot;
  bool load=false;
  Map<String,dynamic>allEmailsWithLink={};
  late QuerySnapshot<Map<String, dynamic>> allStudentsData;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEmail().whenComplete(() {
      fetchtData();
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            title:  Center(
              child: AutoSizeText(
                '${widget.selectedSubject} Leaderboard Quiz ${widget.quizId}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,),
            ),
          ),
          body: load && snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"]!=null && snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"].length>=3
            ?
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TopThree(data: [
                  {
                    "Name" : result[0]['Name'] ?? '',
                    "Email" : result[0]['Email'] ?? '',
                    "Submitted" : result[0]['Score'] ?? 0,
                  },
                  {
                    "Name" : result[1]['Name'] ?? '',
                    "Email" : result[1]['Email'] ?? '',
                    "Submitted" : result[1]['Score'] ?? 0,
                  },
                  {
                    "Name" : result[2]['Name'] ?? '',
                    "Email" : result[2]['Email'] ?? '',
                    "Submitted" : result[2]['Score'] ?? 0,
                  }
                ],),

                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AutoSizeText("Attempted Students : ${result.length}/${allStudentsData.docs.length}",
                      style: GoogleFonts.poppins(
                        color: Colors.amber,
                        fontSize: size.height*0.015
                      ),),
                    AutoSizeText("Unattempted Students : ${unattemptedStudents.length}/${allStudentsData.docs.length}",
                      style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: size.height*0.015
                      ),)
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
                            itemCount:result.length,
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
                                                style: TextStyle(
                                                    fontSize: size.height*0.03,
                                                    color: Colors.white
                                                )
                                            )),
                                      ),
                                      Container(
                                          height: size.height * 0.07,
                                          width: size.width * 0.8,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
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
                                                    backgroundColor: Colors.black,
                                                    child:  allEmailsWithLink[result[index]["Email"]]!="null"
                                                        ?
                                                    CircleAvatar(
                                                      radius: size.width * 0.1,
                                                      backgroundImage: NetworkImage("${allEmailsWithLink[result[index]["Email"]]}"),
                                                    ):
                                                    AutoSizeText(
                                                      result[index]["Name-Rollnumber"].toString().split("-")[0][0],
                                                      textAlign: TextAlign.center,
                                                    ),),
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.45,
                                                    child:Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        AutoSizeText(
                                                          result[index]["Name-Rollnumber"].toString().split("-")[0],
                                                          style: TextStyle(
                                                              fontSize: size.width * 0.045),
                                                          maxLines: 1,
                                                          textAlign: TextAlign.left,
                                                        ),
                                                        AutoSizeText(
                                                          result[index]["Name-Rollnumber"].toString().split("-")[1],
                                                          style: TextStyle(
                                                              fontSize: size.width * 0.036),
                                                          maxLines: 1,
                                                          textAlign: TextAlign.left,
                                                        )
                                                      ],
                                                    )
                                                ),
                                                AutoSizeText("${result[index]["Score"].toString()} / 10",
                                                    style: const TextStyle(
                                                        color:Color.fromARGB(255, 10, 52, 84),
                                                        fontWeight: FontWeight.w500)),
                                              ])),
                                    ],
                                  ),
                                ),
                              );
                            },

                          )
                      ),
                      SizedBox(
                          height: size.height * 0.096*(unattemptedStudents.length),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:unattemptedStudents.length,
                            itemBuilder: (context, index) {

                              return Column(
                                children: [
                                  index==0
                                      ?
                                  Divider(
                                    color: Colors.black,
                                    height: MediaQuery.of(context).size.height * 0.03,
                                    thickness: MediaQuery.of(context).size.height * 0.003,
                                    endIndent: 8,
                                    indent: 8,
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
                                                  style: TextStyle(
                                                    fontSize: size.height*0.03,
                                                    color: Colors.white
                                                  ),
                                                )),
                                          ),
                                          Container(
                                              height: size.height * 0.07,
                                              width: size.width * 0.8,
                                              decoration: BoxDecoration(
                                                border: Border.all(),
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
                                                        backgroundColor: Colors.black,
                                                        child:  allEmailsWithLink[unattemptedStudents[index]["Email"]]!="null"
                                                            ?
                                                        CircleAvatar(
                                                          radius: size.width * 0.1,
                                                          backgroundImage: NetworkImage("${allEmailsWithLink[unattemptedStudents[index]["Email"]]}"),
                                                        ):
                                                        AutoSizeText(
                                                          unattemptedStudents[index]["Name"][0],
                                                          textAlign: TextAlign.center,
                                                        ),),
                                                    ),
                                                    SizedBox(
                                                        width: size.width * 0.45,
                                                        child:Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            AutoSizeText(
                                                              unattemptedStudents[index]["Name"],
                                                              style: TextStyle(
                                                                  fontSize: size.width * 0.045),
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            AutoSizeText(
                                                              unattemptedStudents[index]["Roll-number"],
                                                              style: TextStyle(
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
                                                            fontWeight: FontWeight.w500)),
                                                  ])),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },

                          )
                      )
                    ])

              ],
            ),
          )
              :
              const SizedBox(
                child: Center(child: Text("Less then three Submissions Please Wait..")),
              )),
    );
  }

 void fetchtData()
  {
    FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.selectedSubject}").get().then((value) {
      snapshot=value;
    }).whenComplete(() async {
      if(snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"]!=null)
        {
          await calculateResult().whenComplete(() {
            setState(() {
              load=true;
            });
          });
        }
    });

  }
  Future<bool> calculateResult()
  async {
    result.clear();
   for(var email in  snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"])
     {
       Map<String,dynamic>data={};
       data["Name-Rollnumber"]="${email.toString().split("-")[1]}-${email.toString().split("-")[2]}";
       data["Score"]=snapshot.data()?["Notes-${widget.quizId}"]["Response"][email]["Score"];
       data["Quiz-Time"]=snapshot.data()?["Notes-${widget.quizId}"]["Response"][email]["TimeStamp"];
       data["Email"]="${email.toString().split("-")[0]}@gmail.com";
       result.add(data);
       unattemptedStudents.removeWhere((element) => element["Email"]=="${email.toString().split("-")[0]}@gmail.com");
     }
      print("Email is present : $unattemptedStudents");
   // Sort the map based on timeStamp and Quiz Sore ....
    print("....................Before${result}");
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
      load=true;
   print("....................After$result");
   return true;
  }

  Future<void> fetchEmail()
  async {
    await FirebaseFirestore.instance.collection("Students")
        .where("University",isEqualTo: usermodel["University"])
        .where("College",isEqualTo: usermodel["College"])
        .where("Branch",isEqualTo: usermodel["Branch"])
        .where("Course",isEqualTo: usermodel["Course"])
        .where("Year",isEqualTo: usermodel["Year"])
        .where("Section",isEqualTo: usermodel["Section"])
        .where("Subject",arrayContains: widget.selectedSubject).get().then((value) {

      setState(() {
        allStudentsData=value;
        print("$allStudentsData");
      });
    }).whenComplete(() {
      setState(() {
       // allEmails=List.generate(allStudentsData.docs.length, (index) => allStudentsData.docs[index]["Email"]);
      
        for(int i=0;i<allStudentsData.docs.length;i++)
          {
            //print("    $i-----${allStudentsData.docs[i]["Profile_URL"]}");
            allEmailsWithLink["${allStudentsData.docs[i]["Email"]}"]=allStudentsData.docs[i]["Profile_URL"]!=null?"${allStudentsData.docs[i]["Profile_URL"]}":"null";
            unattemptedStudents.add(
                {
                  "Name":allStudentsData.docs[i]["Name"],
                  "Roll-number":allStudentsData.docs[i]["Rollnumber"],
                  "Email":allStudentsData.docs[i]["Email"]
                }
                );
          }
      });
    });

  }

}
