import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarksQuery extends StatefulWidget {
  const MarksQuery({super.key, required this.sessional, required this.selectedSubject});
  final int sessional;
  final String selectedSubject;
  @override
  State<MarksQuery> createState() => _MarksQueryState();
}

class _MarksQueryState extends State<MarksQuery> {

  List<String> description= [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: size.height*0.45,
        width: size.width*0.7,
        child: Card(
          color: Colors.black26,
          child: Column(
            children: [
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),

                shrinkWrap: true,
                children: [
                  Card(
                    color: description.contains("Calculation Errors") ? Colors.green.shade200 : Colors.white,
                    child: Center(
                      child: ListTile(
                        title: AutoSizeText("Calculation Errors",
                            style: GoogleFonts.tiltNeon(
                              color: Colors.black,
                              fontSize: size.width*0.04
                            ),
                            textAlign: TextAlign.center
                        ),
                        titleAlignment: ListTileTitleAlignment.center,
                        onTap: (){
                          setState(() {
                            description.contains("Calculation Errors")
                                ?
                            description.remove("Calculation Errors")
                                :
                            description.add("Calculation Errors");
                          });
                        },

                      ),
                    ),
                  ),
                  Card(
                    color: description.contains("Regrading Requests") ? Colors.green.shade200 : Colors.white,
                    child: Center(
                      child: ListTile(
                        title: AutoSizeText("Regrading Requests",
                            style: GoogleFonts.tiltNeon(
                                color: Colors.black,
                                fontSize: size.width*0.04
                            ),
                            textAlign: TextAlign.center
                        ),
                        titleAlignment: ListTileTitleAlignment.center,
                        onTap: (){
                          setState(() {
                            description.contains("Regrading Requests")
                                ?
                            description.remove("Regrading Requests")
                                :
                            description.add("Regrading Requests");
                          });
                        },

                      ),
                    ),
                  ),
                  Card(
                    color: description.contains("Overall Grade Calculation") ? Colors.green.shade200 : Colors.white,
                    child: Center(
                      child: ListTile(
                        title: AutoSizeText("Overall Grade Calculation",
                            style: GoogleFonts.tiltNeon(
                                color: Colors.black,
                                fontSize: size.width*0.04
                            ),
                            textAlign: TextAlign.center
                        ),
                        titleAlignment: ListTileTitleAlignment.center,
                        onTap: (){
                          setState(() {
                            description.contains("Overall Grade Calculation")
                                ?
                            description.remove("Overall Grade Calculation")
                                :
                            description.add("Overall Grade Calculation");
                          });
                        },

                      ),
                    ),
                  ),
                  Card(
                    color: description.contains("Incomplete Grading") ? Colors.green.shade200 : Colors.white,
                    child: Center(
                      child: ListTile(
                        title: AutoSizeText("Incomplete Grading",
                            style: GoogleFonts.tiltNeon(
                                color: Colors.black,
                                fontSize: size.width*0.04
                            ),
                            textAlign: TextAlign.center
                        ),
                        titleAlignment: ListTileTitleAlignment.center,
                        onTap: (){
                          setState(() {
                            description.contains("Incomplete Grading")
                                ?
                            description.remove("Incomplete Grading")
                                :
                            description.add("Incomplete Grading");
                          });
                        },

                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(
                width: size.width*0.4,
                height: size.height*0.08,
                child: Card(
                  color: Colors.blueGrey,
                  child: Center(
                    child: ListTile(
                      title: AutoSizeText("Raise Query",
                          style: GoogleFonts.tiltNeon(
                              color: Colors.black,
                              fontSize: size.width*0.04
                          ),
                          textAlign: TextAlign.center
                      ),
                      onTap: () async {
                        await raiseQuery().whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> raiseQuery() async {
    await FirebaseFirestore.instance.collection("Teachers Id").doc(
      "${usermodel["University"].toString().split(" ")[0]} "
          "${usermodel["College"].toString().split(" ")[0]} "
          "${usermodel["Course"].toString().split(" ")[0]} "
          "${usermodel["Branch"].toString().split(" ")[0]} "
          "${usermodel["Year"].toString().split(" ")[0]} "
          "${usermodel["Section"].toString().split(" ")[0]} "
          "${widget.selectedSubject}"
    ).get().then((value) async {
      await FirebaseFirestore.instance.collection("Teachers").doc(value.data()?["Email"]).update({
        "Querys" : FieldValue.arrayUnion([{
          "from" : "${usermodel["University"].toString().split(" ")[0]} "
              "${usermodel["College"].toString().split(" ")[0]} "
              "${usermodel["Course"].toString().split(" ")[0]} "
              "${usermodel["Branch"].toString().split(" ")[0]} "
              "${usermodel["Year"].toString().split(" ")[0]} "
              "${usermodel["Section"].toString().split(" ")[0]} ",
          "Subject" : widget.selectedSubject,
          "Sessional" : widget.sessional,
          "description" : description,
          "by" : usermodel["Email"],
          "Type" : "Marks",
          "Time" : DateTime.now()
        }])
      });
    });
  }
}
