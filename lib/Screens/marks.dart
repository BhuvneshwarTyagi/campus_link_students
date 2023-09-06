import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'loadingscreen.dart';
late double s1Percent;
late double s2Percent;
late double s3Percent;

class Marks extends StatefulWidget {
  const Marks({Key? key}) : super(key: key);

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  var previousIndex = -1;
   int? touchedIndex=-1;

   // sessional percentage



  List<bool> selected =List.filled(usermodel["Subject"].length, false);
  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject = usermodel["Subject"][0];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextStyle _st = GoogleFonts.exo(
      color: Colors.white,
      fontSize: size.height * 0.024,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage("assets/images/bg-image.png"),fit: BoxFit.fill
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Colors.black,
              // Colors.deepPurple,
              // Colors.purpleAccent
              const Color.fromRGBO(86, 149, 178, 1),

              const Color.fromRGBO(68, 174, 218, 1),
              //Color.fromRGBO(118, 78, 232, 1),
              Colors.deepPurple.shade300
            ],
          ),
        ),
        child: Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.12,
                    width: size.width * 1,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: subjects.length,
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
                                      var preIndex = index;

                                      setState(() {
                                        selected = List.filled(subjects.length, false);
                                        /*if (previousIndex != -1) {
                                          selected[previousIndex] = false;
                                        }*/
                                        selected[index] = true;
                                       // previousIndex = index;
                                        print(subjects[index]);
                                        selectedSubject = subjects[index];
                                      });
                                    },
                                    child: Container(
                                      height: size.height * 0.068,
                                      width: size.width * 0.2,
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color.fromRGBO(169, 169, 207, 1),
                                              Color.fromRGBO(189, 201, 214, 1),
                                              Color.fromRGBO(175, 207, 240, 1),
                                              Color.fromRGBO(189, 201, 214, 1),
                                              Color.fromRGBO(169, 169, 207, 1),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          border: selected[index]
                                              ? Border.all(
                                                  color: Colors.white, width: 2)
                                              : Border.all(
                                                  color: Colors.blueAccent,
                                                  width: 1)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.008,
                                  ),
                                  AutoSizeText(
                                    "${subjects[index]}",
                                    style: GoogleFonts.openSans(
                                        color: selected[index]
                                            ? Colors.white
                                            : Colors.black87),
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
                    height: MediaQuery.of(context).size.height * 0.06,
                    thickness: MediaQuery.of(context).size.height * 0.001,
                  ),


                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  SizedBox(

                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Students")
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData)
                          {
                            if(snapshot.data!.data()?["S-1-$selectedSubject"]!=null && snapshot.data!.data()?["S-1-max_marks"]!=null) {
                              int s1Marks = int.parse(snapshot.data!
                                  .data()?["S-1-$selectedSubject"]);
                              int s1MaxMarks = int.parse(
                                  snapshot.data!.data()?["S-1-max_marks"]);
                              s1Percent = double.parse(
                                  ((s1Marks / s1MaxMarks) * 100)
                                      .toStringAsFixed(2));
                            }
                            if(snapshot.data!.data()?["S-2-$selectedSubject"]!=null && snapshot.data!.data()?["S-2-max_marks"]!=null) {
                              int s2Marks = int.parse(snapshot.data!
                                  .data()?["S-2-$selectedSubject"]);
                              int s2MaxMarks = int.parse(
                                  snapshot.data!.data()?["S-2-max_marks"]);
                              s2Percent = double.parse(
                                  ((s2Marks / s2MaxMarks) * 100)
                                      .toStringAsFixed(2));
                            }
                            if(snapshot.data!.data()?["S-3-$selectedSubject"]!=null && snapshot.data!.data()?["S-3-max_marks"]!=null) {
                              int s3Marks = int.parse(snapshot.data!
                                  .data()?["S-3-$selectedSubject"]);
                              int s3MaxMarks = int.parse(
                                  snapshot.data!.data()?["S-3-max_marks"]);
                              s3Percent = double.parse(
                                  ((s3Marks / s3MaxMarks) * 100)
                                      .toStringAsFixed(2));
                            }
                          }

                        return snapshot.hasData

                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child:Column(
                                  children: [
                                    Container(
                                  height: size.height*0.33,
                                  width: size.width * 0.9,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(200, 62, 118, 1),
                                        Color.fromRGBO(70, 50, 110, 1),
                                      ],
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                  ),
                                      child: Card(
                                        elevation: 40,
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.03,
                                                ),
                                                AutoSizeText(
                                                  "Subject  :",
                                                  style: _st,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.05,
                                                ),
                                                AutoSizeText(
                                                  selectedSubject,
                                                  style: _st,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.03,
                                                ),
                                                AutoSizeText(
                                                  "Sessional ",
                                                  style: _st,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.16,
                                                ),
                                                AutoSizeText(
                                                  "Obtained",
                                                  style: _st,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.098,
                                                ),
                                                AutoSizeText(
                                                  "   Max",
                                                  style: _st,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.014,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.09,
                                                ),
                                                AutoSizeText(
                                                  "S-1 ",
                                                  style: _st,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.25,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: size.height * 0.04,
                                                  width: size.width * 0.12,
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      snapshot.data!.data()?[
                                                      "S-1-${selectedSubject.trim()}"] ??
                                                          "-",
                                                      style: GoogleFonts.exo(
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.15,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: size.height * 0.04,
                                                  width: size.width * 0.12,
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      snapshot.data!.data()?[
                                                      "S-1-max_marks"] ??
                                                          "-",
                                                      style: GoogleFonts.exo(
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.014,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.09,
                                                ),
                                                AutoSizeText(
                                                  "S-2 ",
                                                  style: _st,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.24,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: size.height * 0.04,
                                                  width: size.width * 0.12,
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      snapshot.data!.data()?[
                                                      "S-2-${selectedSubject.trim()}"] ??
                                                          "-",
                                                      style: GoogleFonts.exo(
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.15,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: size.height * 0.04,
                                                  width: size.width * 0.12,
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      snapshot.data!.data()?[
                                                      "S-2-max_marks"] ??
                                                          "-",
                                                      style: GoogleFonts.exo(
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.014,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.09,
                                                ),
                                                AutoSizeText(
                                                  "S-3 ",
                                                  style: _st,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.24,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: size.height * 0.04,
                                                  width: size.width * 0.12,
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      snapshot.data!.data()?[
                                                      "S-3-${selectedSubject.trim()}"] ??
                                                          "-",
                                                      style: GoogleFonts.exo(
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.15,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: size.height * 0.04,
                                                  width: size.width * 0.12,
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      snapshot.data!.data()?[
                                                      "S-3-max_marks"] ??
                                                          "-",
                                                      style: GoogleFonts.exo(
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height*0.032,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            height: size.height * 0.048,
                                            width: size.width * 0.25,
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.purpleAccent,
                                                  ],
                                                ),
                                                borderRadius:
                                                const BorderRadius.all(Radius.circular(20)),
                                                border: Border.all(color: Colors.black, width: 2)),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent),
                                              onPressed: () {
                                                setState(() {

                                                  snapshot.data!.data()?["S-1-$selectedSubject"]!=null && snapshot.data!.data()?["S-1-max_marks"]!=null
                                                      ?
                                                  SizedBox(
                                                    height: size.height * 0.5,
                                                    width: size.width * 0.45,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: size.height * 0.05,
                                                          child: AutoSizeText(
                                                            "Pie Chart For Sessional-1",
                                                            style: GoogleFonts.openSans(
                                                                fontSize: size.height * 0.04,
                                                                color: Colors.black87,
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: size.height * 0.4,
                                                          width: size.width * 0.45,
                                                          child: PieChart(
                                                            PieChartData(
                                                                pieTouchData: PieTouchData(
                                                                  enabled: true,
                                                                  touchCallback: (_, pieTouchResponse) {
                                                                    //var pieTouchResponse;
                                                                    setState(() {
                                                                      if (pieTouchResponse
                                                                          ?.touchedSection
                                                                      is FlLongPressEnd ||
                                                                          pieTouchResponse
                                                                              ?.touchedSection
                                                                          is FlPanEndEvent) {
                                                                        touchedIndex = -1;
                                                                      } else {
                                                                        touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                                                                      }
                                                                    });
                                                                    print("....stastwst$touchedIndex");
                                                                  },
                                                                ),
                                                                borderData: FlBorderData(
                                                                  show: false,
                                                                ),
                                                                sectionsSpace: 10,
                                                                centerSpaceRadius: 65,
                                                                sections:
                                                                sectionData(context, touchedIndex)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                      :
                                                  const SizedBox(
                                                    child: AutoSizeText("NO data Found"),
                                                  );
                                                  
                                                });

                                              },
                                              child: const AutoSizeText("S-1"),
                                            )),
                                        Container(
                                            height: size.height * 0.048,
                                            width: size.width * 0.25,
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.purpleAccent,
                                                  ],
                                                ),
                                                borderRadius:
                                                const BorderRadius.all(Radius.circular(20)),
                                                border: Border.all(color: Colors.black, width: 2)),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent),
                                              onPressed: () {
                                                setState(() {


                                                  snapshot.data!.data()?["S-2-$selectedSubject"]!=null && snapshot.data!.data()?["S-2-max_marks"]!=null
                                                      ?
                                                  SizedBox(
                                                    height: size.height * 0.5,
                                                    width: size.width * 0.45,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: size.height * 0.05,
                                                          child: AutoSizeText(
                                                            "Pie Chart For Sessional-2",
                                                            style: GoogleFonts.openSans(
                                                                fontSize: size.height * 0.04,
                                                                color: Colors.black87,
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: size.height * 0.4,
                                                          width: size.width * 0.45,
                                                          child: PieChart(
                                                            PieChartData(
                                                                pieTouchData: PieTouchData(
                                                                  enabled: true,
                                                                  touchCallback: (_, pieTouchResponse) {
                                                                    //var pieTouchResponse;
                                                                    setState(() {
                                                                      if (pieTouchResponse
                                                                          ?.touchedSection
                                                                      is FlLongPressEnd ||
                                                                          pieTouchResponse
                                                                              ?.touchedSection
                                                                          is FlPanEndEvent) {
                                                                        touchedIndex = -1;
                                                                      } else {
                                                                        touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                                                                      }
                                                                    });
                                                                    // print("....stastwst$touchedIndex");
                                                                  },
                                                                ),
                                                                borderData: FlBorderData(
                                                                  show: false,
                                                                ),
                                                                sectionsSpace: 10,
                                                                centerSpaceRadius: 65,
                                                                sections:
                                                                sectionData(context, touchedIndex)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                      :
                                                  const SizedBox(
                                                    child: AutoSizeText("No data found"),
                                                  );

                                                });

                                              },
                                              child: const AutoSizeText("S-2"),
                                            )),
                                        Container(
                                            height: size.height * 0.048,
                                            width: size.width * 0.25,
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.purpleAccent,
                                                  ],
                                                ),
                                                borderRadius:
                                                const BorderRadius.all(Radius.circular(20)),
                                                border: Border.all(color: Colors.black, width: 2)),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent),
                                              onPressed: () {
                                                setState(() {

                                                });

                                              },
                                              child: const AutoSizeText("S-3"),
                                            )),

                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height*0.03,
                                    ),

                                   
                                    /*snapshot.data!.data()?["S-3-$selectedSubject"]!=null && snapshot.data!.data()?["S-3-max_marks"]!=null
                                        ?
                                    SizedBox(
                                      height: size.height * 0.5,
                                      width: size.width * 0.45,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.05,
                                            child: AutoSizeText(
                                              "Pie Chart For Sessional-1",
                                              style: GoogleFonts.openSans(
                                                  fontSize: size.height * 0.04,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.4,
                                            width: size.width * 0.45,
                                            child: PieChart(
                                              PieChartData(
                                                  pieTouchData: PieTouchData(
                                                    enabled: true,
                                                    touchCallback: (_, pieTouchResponse) {
                                                      //var pieTouchResponse;
                                                      setState(() {
                                                        if (pieTouchResponse
                                                            ?.touchedSection
                                                        is FlLongPressEnd ||
                                                            pieTouchResponse
                                                                ?.touchedSection
                                                            is FlPanEndEvent) {
                                                          touchedIndex = -1;
                                                        } else {
                                                          touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                                                        }
                                                      });
                                                      print("....stastwst$touchedIndex");
                                                    },
                                                  ),
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  sectionsSpace: 10,
                                                  centerSpaceRadius: 65,
                                                  sections:
                                                  sectionData(context, touchedIndex)),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                        :
                                    const SizedBox(),*/
                                    SizedBox(
                                      height: size.height * 0.05,
                                    ),

                                  ],
                                ),
                              )
                            : const loading(
                                text:
                                    "Data is Retrieving from server please wait");
                      },
                    ),
                  ),

                ],
              ),
            )),
      ),
    );
  }
  List<PieChartSectionData> sectionData(
      BuildContext context, int? touchedIndex) {
    return PieData()
        .data
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
      double size = index == touchedIndex
          ? MediaQuery.of(context).size.height * 0.095
          : MediaQuery.of(context).size.height * 0.08;
      double _fontSize = index == touchedIndex ? 30 : 16;

      print(",,,,,,,,,,,,${index == touchedIndex}");

      final value = PieChartSectionData(
          color: data.color,
          value: data.present,
          radius: size,
          title: '${data.present}%',
          titleStyle: GoogleFonts.openSans(
              color: Colors.amber,
              fontSize: _fontSize,
              fontWeight: FontWeight.w600));
      return MapEntry(index, value);
    })
        .values
        .toList();
  }
}

class PieData {
  List<Data> data = [
    Data(name: "Present", present: s1Percent, color: Colors.greenAccent),
    Data(name: "Absent", present: 100.0-s1Percent , color: Colors.red)
  ];
}

class Data {
  late String name;
  late double present;
  late Color color;
  Data({required this.name, required this.present, required this.color});
}
