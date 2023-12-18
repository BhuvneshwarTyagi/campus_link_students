import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Sessional%20Marks/Marks%20Query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class ViewMarks extends StatefulWidget {
  const ViewMarks({super.key});

  @override
  State<ViewMarks> createState() => _ViewMarksState();
}

class _ViewMarksState extends State<ViewMarks> {
  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject = usermodel["Subject"] == null ? "" : usermodel["Subject"][0];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
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
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,)),
          title: AutoSizeText("Sessional Marks",
              style: GoogleFonts.tiltNeon(
                color: Colors.black,
                fontSize: size.width*0.07
              ),
          ),
        ),
        body: Column(
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
            usermodel["Marks"] != null && usermodel["Marks"][selectedSubject] != null
                ?
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: usermodel["Marks"][selectedSubject]["Total"],
              padding: EdgeInsets.only(top: size.height*0.01),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: AutoSizeText(
                      "Sessional ${index+1}",
                      style: GoogleFonts.tiltNeon(
                        color: Colors.black,
                        fontSize: size.width*0.05
                      ),
                    ),
                    trailing: SizedBox(
                      width: size.width*0.25,
                      child: Row(
                        children: [
                          AutoSizeText(
                            "${usermodel["Marks"][selectedSubject]["Sessional_${index+1}"]}/${usermodel["Marks"][selectedSubject]["Sessional_${index+1}_total"]}" ,
                            style: GoogleFonts.tiltNeon(
                                color: Colors.black,
                                fontSize: size.width*0.05
                            ),
                          ),
                          PopupMenuButton(
                            onSelected: (value) {
                              if(value=="1"){
                                showDialog(context: context, builder: (context) {
                                  return MarksQuery(sessional: index+1, selectedSubject: selectedSubject);
                                },);
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem(
                                  value: "1",
                                    child: Text("Raise Query"),
                                )
                            ];
                          },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                :
            Center(
              child: AutoSizeText("No sessional marks uploaded till now.\nCome back later.",
                  style: GoogleFonts.tiltNeon(
                      color: Colors.black,
                      fontSize: size.width*0.055
                  ),
                  textAlign: TextAlign.center
              ),
            ),
          ],
        ),
      ),
    );
  }
}
