

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
 @override
  void initState() {
   count_attendance();
    // TODO: implement initState
    super.initState();
  }

  @override

  final  TextEditingController monthcontroller=TextEditingController();
  List months=[
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


  String selected_month="";
  var month_number=-1;

  List<dynamic>subjects = [];
  List<dynamic>attendance_count=[];
 List<dynamic>absent_count=[];
 List<dynamic>percent_of_attendance=[];

  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
        body: Container(
          width: size.width * 1,
          height: size.height * 1,
          child:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(

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
                        color:  Colors.blue,
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
                        selected_month=monthcontroller.text.toString();
                        month_number=months.indexOf(selected_month)+1;
                        count_attendance();
                      });
                      print(month_number);
                      //FocusScope.of(context).requestFocus();
                    },
                    enabled: true,
                    hint: "${months[DateTime.now().month-1]}",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                attendance_count.isNotEmpty && absent_count.isNotEmpty
                    ?
                SizedBox(
                  height: size.height,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: attendance_count.length,
                    itemBuilder: (context, index) {

                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: size.height * 0.24,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              border: Border.all(color: Colors.amberAccent, width: 2),
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: Card(
                            elevation: 40,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.05,
                                    ),
                                    AutoSizeText(
                                      "Subject  :",
                                      style: GoogleFonts.exo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.05,

                                    ),
                                    AutoSizeText(
                                      subjects[index],
                                      style: GoogleFonts.exo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.014,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.05,
                                    ),
                                    AutoSizeText(
                                      "Present  :",
                                      style: GoogleFonts.exo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.05,

                                    ),
                                    AutoSizeText(
                                      attendance_count[index],
                                      style: GoogleFonts.exo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),

                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.014,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.05,
                                    ),
                                    AutoSizeText(
                                      "Absent  :",
                                      style: GoogleFonts.exo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.05,

                                    ),
                                    AutoSizeText(
                                      "${absent_count[index]}",
                                      style: GoogleFonts.exo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),

                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.014,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.05,
                                    ),
                                    AutoSizeText(
                                      "Attendance :",
                                      style: GoogleFonts.exo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.05,

                                    ),
                                    AutoSizeText(
                                      "${percent_of_attendance[index]} %",
                                      style: GoogleFonts.exo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),

                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },)

                )
                    :
                Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    "No Data found Corresponding this month",
                    style: GoogleFonts.exo(
                        fontSize: 18,
                        color: Colors.black87
                    ),

                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
Future count_attendance() async {
  final now = DateTime.now();
  var currentMon = now.month;
  if(month_number==-1)
    {
      setState(() {
        month_number=currentMon;
      });

    }
  print(currentMon);
    final ref_1 = await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).get();
    setState(() {
      subjects=ref_1.data()?["Subject"];
      attendance_count.clear();
      absent_count.clear();
    });

  print(subjects);
    for (var i in subjects) {
      final ref=await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).collection("Attendance").doc("$i-$month_number").get();
       if(ref.data()?.length==null)
         {
           print("....${ref.data()?.length}");
         }
        setState(() {
          if(ref.data()?.length !=null)
            {
              attendance_count.add(ref.data()?["count_attendance"].toString());
              absent_count.add(ref_1.data()?["$i-total-lectures"] -
                  ref.data()?["count_attendance"]);
              double percent=(ref.data()?["count_attendance"]/ref_1.data()?["$i-total-lectures"])*100;
              percent_of_attendance.add(percent.toStringAsPrecision(4));
            }



        });
        print("..........${attendance_count.length}");
        print(percent_of_attendance);

    }

}

}
