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
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        //shadowColor: Colors.amberAccent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0))),
        title: Center(
          child: AutoSizeText(
            "My Attendance",
            style: GoogleFonts.bungeeSpice(
                color: Colors.amber,
                fontSize: 26,
                fontWeight: FontWeight.w500
            ),
          ),
        ),

      ),
      body: Container(
        width: size.width * 1,
        height: size.height * 1,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg-image.png"),
                fit: BoxFit.cover
            )
        ),
        child:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SearchField(
                  controller: monthcontroller,
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key("Search key"),
                  suggestions:
                  months.map((e) => SearchFieldListItem(e)).toList(),
                  searchStyle: GoogleFonts.exo(
                      color: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.exo(
                    color: Colors.amber,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  marginColor: Colors.amber,
                  suggestionsDecoration: SuggestionDecoration(
                      color:  Colors.black,
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.amber),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                      hintText: "Select Month",
                      fillColor: Colors.black,
                      filled: true,
                      hintStyle: GoogleFonts.exo(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.amber,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusColor: Colors.amber,
                      disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.amber,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.amber,
                        ),
                        borderRadius: BorderRadius.circular(30),
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




                  },
                  enabled: true,
                  hint: "Select Months",
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                ),
              ),
              SizedBox(
                height: size.height*0.22*attendance_count.length,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: attendance_count.length,
                  itemBuilder: (context, index) {

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: size.height * 0.18,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 5, spreadRadius: 2,
                                  color: Colors.amberAccent,
                                  offset: Offset(1, 1)
                              )
                            ],
                            border: Border.all(color: Colors.amberAccent, width: 2),
                            borderRadius: BorderRadius.circular(15.0)
                        ),
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
                                      color: Colors.amber
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.05,

                                ),
                                AutoSizeText(
                                  subjects[index],
                                  style: GoogleFonts.exo(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber
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
                                      color: Colors.amber
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.05,

                                ),
                                AutoSizeText(
                                  attendance_count[index],
                                  style: GoogleFonts.exo(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber
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
                                      color: Colors.amber
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.05,

                                ),
                                AutoSizeText(
                                  "",
                                  style: GoogleFonts.exo(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber
                                  ),

                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  },),
              )
            ],
          ),
        )
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
    attendance_count.clear();
    final ref = await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).get();
    setState(() {
      subjects=ref.data()?["Subject"];
      attendance_count.clear();
    });

    //print(subjects);
    //print("I am in");
    for (var i in subjects) {
      final ref=await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).collection("Attendance").doc("$i-$month_number").get();
       //print("$i-$month_number");

        setState(() {
          attendance_count.add(ref.data()?["count_attendance"].toString());
          print(attendance_count);

        });
        if(ref.data()?["count_attendance"].toString()==null)
          {
            attendance_count.clear();
          }

    }
      //print("\n\n\n\n$attendance_count");
}

}
