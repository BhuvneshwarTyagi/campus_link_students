
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Assignment/AssignmentTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constraints.dart';
import '../loadingscreen.dart';

class AssignmentList extends StatefulWidget {
  const AssignmentList({super.key});

  @override
  State<AssignmentList> createState() => _AssignmentListState();
}

class _AssignmentListState extends State<AssignmentList> {
  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject =" ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSubject = usermodel["Subject"][0];
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        Divider(
          color: Colors.black,
          height: MediaQuery.of(context).size.height * 0.01,
          thickness: MediaQuery.of(context).size.height * 0.003,
          endIndent: 8,
          indent: 8,
        ),
        StreamBuilder(
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.data()!["Total_Assignment"] ,
                shrinkWrap: true,
                itemBuilder: (context, index) {


                  return AssignmentTile(
                      subject: selectedSubject,
                      index: index,
                      assignmentUrl: snapshot.data!.data()!["Assignment-${index + 1}"]["Assignment"],
                      docType: snapshot.data!.data()!["Assignment-${index + 1}"]["Document-type"],
                      docSize: (snapshot.data!.data()!["Assignment-${index + 1}"]["Size"]/1048576).toStringAsFixed(2),
                      uploadTime: snapshot.data!.data()!["Assignment-${index + 1}"]["Time"].toString().substring(10, 15),
                      deadline: snapshot.data!.data()?["Assignment-${index + 1}"]["Last Date"],
                    status: (snapshot.data!.data()?["Assignment-${index + 1}"]["submitted-Assignment"] != null && snapshot.data!.data()?["Assignment-${index + 1}"]["submitted-Assignment"][usermodel["Email"].toString().split("@")[0]] != null)
                        ?
                    "${snapshot.data!.data()?["Assignment-${index + 1}"]["submitted-Assignment"][usermodel["Email"].toString().split("@")[0]]["Status"]}"
                        :
                    "",
                    count: (snapshot.data!.exists && snapshot.data!.data()?["Assignment-${index+1}"]["Submitted-by"] != null)
                        ?
                    int.parse("${snapshot.data!.data()?["Assignment-${index+1}"]["Submitted-by"].length}")
                        :
                    0, assignedOn: snapshot.data!.data()?["Assignment-${index+1}"]["Assign-Date"],
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
      ],
    );
  }

}
