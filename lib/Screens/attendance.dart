import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Registration/database.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  //###########################################################################

  DateTime endDate = DateTime.now();
  TextEditingController end_date_controller = TextEditingController();
  DateTime startDate = DateTime.now();
  TextEditingController start_date_controller = TextEditingController();

  final _st = GoogleFonts.exo(
      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black26);
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  final TextEditingController monthcontroller = TextEditingController();
  List months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    'August',
    "September",
    "October",
    "November",
    "December"
  ];
  TextEditingController Subject_Controller = TextEditingController();

  List<dynamic> _subjects = usermodel["Subject"];
  String selected_subject = "";

  String selected_month = "";
  var month_number = -1;
  var attendance_count=0;
  var absent_count=0;
  var total_lecture=0;

  List<bool> selected=[false,false,false,false,false,false];
  bool attendance_data = false;
  var subject_index=0;



  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: attendance_data
              ?
          Container(
            height: size.height,
            width: size.width,
            child: Column(
              children: [

                 SizedBox(
                  height: size.height*0.03,
                ),
                Container(
                        width: size.width * 0.9,
                        height: size.height * 0.31,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            border: Border.all(color: Colors.amberAccent, width: 2),
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width*0.055,
                                  ),
                                   AutoSizeText(
                                  "Subject : ",
                                      style: GoogleFonts.openSans(
                                        color: Colors.white,
                                         fontSize: size.height*0.026
                            )),
                                  SizedBox(
                                    width: size.width*0.02,
                                  ),
                                  AutoSizeText(
                                      " ${_subjects[subject_index]}",
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: size.height*0.026
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: size.height*0.02,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width*0.055,
                                  ),
                                  AutoSizeText(
                                      "Present : ",
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: size.height*0.026
                                      )),
                                  SizedBox(
                                    height: size.height*0.02,
                                  ),
                                  AutoSizeText(
                                      " $attendance_count",
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: size.height*0.026
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: size.height*0.02,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width*0.055,
                                  ),
                                  AutoSizeText(
                                      "Absent : ",
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: size.height*0.026
                                      )),
                                  SizedBox(
                                    height: size.height*0.02,
                                  ),
                                  AutoSizeText(
                                      " $absent_count",
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: size.height*0.026
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: size.height*0.02,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width*0.055,
                                  ),
                                  AutoSizeText(
                                      "Total Lecture : ",
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: size.height*0.026
                                      )),
                                  SizedBox(
                                    height: size.height*0.02,
                                  ),
                                  AutoSizeText(
                                      " $total_lecture",
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: size.height*0.026
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )),
              ],
            ),
          )

              :
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.height*0.12,
                  width: size.width*1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(size.width*0.035),
                    itemCount: _subjects.length,
                    itemBuilder:(context, index) {
                      return InkWell(
                        onTap: (){
                          var pre_index=index;
                          setState(() {
                            selected[index]=true;
                            subject_index=index;
                          });
                        },
                        child: Container(
                          height: size.height*0.1,
                          width: size.width*0.2,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(169, 169, 207, 1),
                                  // Color.fromRGBO(86, 149, 178, 1),
                                  Color.fromRGBO(189, 201, 214, 1),
                                  //Color.fromRGBO(118, 78, 232, 1),
                                  Color.fromRGBO(175, 207, 240, 1),

                                  // Color.fromRGBO(86, 149, 178, 1),
                                  Color.fromRGBO(189, 201, 214, 1),
                                  Color.fromRGBO(169, 169, 207, 1),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: selected[subject_index]?
                              Border.all(
                                  color: Colors.white,
                                  width: 2
                              )
                                  :
                              Border.all(
                                  color: Colors.blueAccent,
                                  width: 1
                              )
                          ) ,
                        ),
                      );
                    }, ),
                ),
                SizedBox(
                  height: size.height*0.085,
                  width: size.width*1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /*SearchField(
                    controller: monthcontroller,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                        months.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.exo(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.exo(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.blue,
                    suggestionsDecoration: SuggestionDecoration(
                        color: Colors.blue,
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        fillColor: Colors.blueAccent,
                        filled: true,
                        hintStyle: GoogleFonts.exo(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusColor: Colors.white,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onSuggestionTap: (value) {
                      print(value.searchKey);

                      print(monthcontroller.text.toString());
                      setState(() {
                        selected_month = monthcontroller.text.toString();
                        month_number = months.indexOf(selected_month) + 1;
                        count_attendance();
                      });
                      print(month_number);
                      //FocusScope.of(context).requestFocus();
                    },
                    enabled: true,
                    hint: "${months[DateTime.now().month - 1]}",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),*/
                      /*SizedBox(
                        height: size.height*0.085,
                        width: size.width*0.31,
                        child: SearchField(
                          controller: Subject_Controller,
                          suggestionItemDecoration: SuggestionDecoration(),
                          key: const Key("Search key"),
                          suggestions:
                          _subjects.map((e) => SearchFieldListItem(e)).toList(),
                          searchStyle: _st,
                          suggestionStyle: _st,
                          marginColor: Colors.black,
                          suggestionsDecoration: SuggestionDecoration(
                              color:Colors.blue,
                              //shape: BoxShape.rectangle,
                              padding: const EdgeInsets.all(10),
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(0)),
                          searchInputDecoration: InputDecoration(
                              hintText: "Subject",
                              contentPadding: EdgeInsets.all(size.height*0.02),
                              fillColor: Colors.transparent,
                              filled: true,
                              // hintStyle: _st,
                              suffixIcon: Icon(Icons.arrow_drop_down,color: Colors.black,size: size.height*0.04,),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusColor: Colors.transparent,
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              )),
                          onSuggestionTap: (value) {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              selected_subject=Subject_Controller.text.toString().trim();
                            });


                          },
                          enabled: true,
                          hint: "subject",
                          itemHeight: 50,
                          maxSuggestionsInViewPort: 3,
                        ),
                      ),*/
                      SizedBox(
                        height: size.height*0.085,
                        width: size.width*0.4,
                        child: TextField(
                          controller: start_date_controller,
                          onTap: () async {
                            final start_date = await _selectDate(context).whenComplete(() {

                            });
                            setState(() {
                              startDate=start_date;
                              print("......................$startDate");
                              start_date_controller.text =
                                  startDate.toString().substring(0, 10);
                              //print(".....${selected_subject.trim()}-${start_date_controller.text.trim().toString().split("-")[1]}");
                            });
                          },
                          keyboardType: TextInputType.none,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                              hintText: "Start Date",
                              prefixIcon: Icon(Icons.date_range,
                                  color: Colors.black54,
                                  size: size.height * 0.03),
                              fillColor: Colors.transparent,
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ))),
                        ),
                      ),
                      SizedBox(
                        height: size.height*0.085,
                        width: size.width*0.4,
                        child: TextField(
                          controller: end_date_controller,
                          cursorColor: Colors.black,
                          onTap: () async {
                            final enddate = await _selectDate(context);
                            setState(() {
                              endDate=enddate;
                              count_attendance();
                              print(enddate.toString());
                              end_date_controller.text =
                                  enddate.toString().substring(0, 10);
                            });

                          },
                          keyboardType: TextInputType.none,
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                              hintText: "End Date",
                              prefixIcon: Icon(Icons.date_range,
                                  color: Colors.black54,
                                  size: size.height * 0.03),
                              fillColor: Colors.transparent,
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
        ));
  }

  Future<void> count_attendance() async {

    final now = DateTime.now();
    var currentMon = now.month;
    if (month_number == -1) {
      setState(() {
        month_number = currentMon;
      });
    }
    /*setState(() {
      attendance_count=0;
      absent_count=0;
    });*/
    var doc=await FirebaseFirestore.instance
        .collection("Students")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Attendance").doc("${_subjects[subject_index]}-${startDate.month}")
        .get().then((value) {
      return value.data();
    });
      if(startDate.month==endDate.month)
        {

          for(var i=startDate.day;i<=endDate.day;i++) {
            List<dynamic>map = [];
            if (doc?["$i"]!= null) {
              map=doc?["$i"];
              for (var element in map) {
                element["Status"]=="Present"
                    ?
                attendance_count++
                    :
                absent_count++;
              }

            }
          }
        }
      else{

        // for first month
        var start=startDate.day;
        var end=database().getDaysInMonth(startDate.year, startDate.month);
        for(var i=start;i<=end;i++) {
          List<dynamic>map = [];
          if (doc?["$i"]!= null) {
            map=doc?["$i"];
            for (var element in map) {
              element["Status"]=="Present"
                  ?
              attendance_count++
                  :
              absent_count++;
            }


          }
        }


        // Fore next monts
        var doc_2=await FirebaseFirestore.instance
            .collection("Students")
            .doc(FirebaseAuth.instance.currentUser?.email)
            .collection("Attendance").doc("${_subjects[subject_index]}-${endDate.month}")
            .get().then((value) {
          return value.data();
        });

        print("...........$doc_2");
        start=1;
        for(var i=start;i<=endDate.day;i++) {
          List<dynamic>map = [];
          if (doc_2?["$i"]!= null) {
            map=doc_2?["$i"];
            print("....................$map");
            for (var element in map) {
              element["Status"]=="Present"
                  ?
              attendance_count++
                  :
              absent_count++;
            }

          }
        }

      }

    setState(() {
      total_lecture=attendance_count+absent_count;
      attendance_data=true;
    });

  }

  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2023, 5),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
      print(date);
    }
    return date;
  }
}

/*
Table(
border: TableBorder.all(
color:Colors.black54,
width: 1),
children: [
checkHoliday
?
TableRow(
decoration:   const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.centerLeft,
end: Alignment.centerRight,
colors: [
Color.fromRGBO(169, 169, 207, 1),
// Color.fromRGBO(86, 149, 178, 1),
Color.fromRGBO(189, 201, 214, 1),
//Color.fromRGBO(118, 78, 232, 1),
Color.fromRGBO(175, 207, 240, 1),

// Color.fromRGBO(86, 149, 178, 1),
Color.fromRGBO(189, 201, 214, 1),
Color.fromRGBO(169, 169, 207, 1),
],
),
),
children: [
Center(
child: AutoSizeText(
"Holiday",
style: GoogleFonts.openSans(
color: Colors.red,
fontSize: 16
),

),
),
]
)
    :
TableRow(
decoration:   const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.centerLeft,
end: Alignment.centerRight,
colors: [
Color.fromRGBO(169, 169, 207, 1),
// Color.fromRGBO(86, 149, 178, 1),
Color.fromRGBO(189, 201, 214, 1),
//Color.fromRGBO(118, 78, 232, 1),
Color.fromRGBO(175, 207, 240, 1),

// Color.fromRGBO(86, 149, 178, 1),
Color.fromRGBO(189, 201, 214, 1),
Color.fromRGBO(169, 169, 207, 1),
],
),
),
children: [
Center(
child: AutoSizeText(
"$dateCount",
style: GoogleFonts.openSans(
color: Colors.black,
fontSize: 16
),

),
),
Center(
child: AutoSizeText(
"${months[startDate.month-1]}",
style: GoogleFonts.openSans(
color: Colors.black,
fontSize: 16
),

),
),
Center(
child: AutoSizeText(
"$presentCount",
style: GoogleFonts.openSans(
color: Colors.black,
fontSize: 16
),

),
),
Center(
child: AutoSizeText(
"$absentCount",
style: GoogleFonts.openSans(
color: Colors.black,
fontSize: 16
),

),
)
]
),
]
);*/

/* Center(
          child: Container(
            height: size.height*0.4,
            width: size.width*0.85,
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AutoSizeText(
                        "Subject :",
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.42,
                        child: SearchField(
                          controller: Subject_Controller,
                          suggestionItemDecoration: SuggestionDecoration(),
                          key: const Key("Search key"),
                          suggestions:
                          _subjects.map((e) => SearchFieldListItem(e)).toList(),
                          searchStyle: _st,
                          suggestionStyle: _st,
                          marginColor: Colors.black,
                          suggestionsDecoration: SuggestionDecoration(
                              color:Colors.blue,
                              //shape: BoxShape.rectangle,
                              padding: const EdgeInsets.all(10),
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(0)),
                          searchInputDecoration: InputDecoration(
                              hintText: "Subject",
                              contentPadding: EdgeInsets.all(size.height*0.02),
                              fillColor: Colors.transparent,
                              filled: true,
                              // hintStyle: _st,
                              suffixIcon: Icon(Icons.arrow_drop_down,color: Colors.black,size: size.height*0.04,),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusColor: Colors.transparent,
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              )),
                          onSuggestionTap: (value) {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              selected_subject=Subject_Controller.text.toString().trim();
                            });


                          },
                          enabled: true,
                          hint: "subject",
                          itemHeight: 50,
                          maxSuggestionsInViewPort: 3,
                        ),
                      ),
                    ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AutoSizeText(
                      "From :",
                      style: GoogleFonts.exo(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.42,
                      child: TextField(
                        controller: start_date_controller,
                        onTap: () async {
                          final start_date = await _selectDate(context).whenComplete(() {

                          });
                          setState(() {
                             startDate=start_date;
                            print("......................$startDate");
                            start_date_controller.text =
                                startDate.toString().substring(0, 10);
                            //print(".....${selected_subject.trim()}-${start_date_controller.text.trim().toString().split("-")[1]}");
                          });
                        },
                        keyboardType: TextInputType.none,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            hintText: "Start Date",
                            prefixIcon: Icon(Icons.date_range,
                                color: Colors.black54,
                                size: size.height * 0.03),
                            fillColor: Colors.transparent,
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "      To :",
                      style: GoogleFonts.exo(
                          fontSize: 18,
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: size.width * 0.42,
                      child: TextField(
                        controller: end_date_controller,
                        cursorColor: Colors.black,
                        onTap: () async {
                          final enddate = await _selectDate(context);
                          setState(() {
                            endDate=enddate;
                            print(enddate.toString());
                            end_date_controller.text =
                                enddate.toString().substring(0, 10);
                          });
                        },
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            hintText: "End Date",
                            prefixIcon: Icon(Icons.date_range,
                                color: Colors.black54,
                                size: size.height * 0.03),
                            fillColor: Colors.transparent,
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: size.width*0.55,
                  height: size.height*0.046,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 20,
                          backgroundColor: Colors.black12),
                      onPressed: (){
                        setState(() {
                          attendance_data=true;
                        });
                      },
                      child:AutoSizeText(
                        "Show Attendance",
                        style: GoogleFonts.openSans(
                            color: Colors.white
                        ),
                      )

                  ),
                )

              ],
            ),
          ),
        )*/
