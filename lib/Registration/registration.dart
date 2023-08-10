import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:searchfield/searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'Login.dart';

//import 'Login.dart';
class StudentDetails extends StatefulWidget {
  const StudentDetails({Key? key}) : super(key: key);

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final TextEditingController rollno=TextEditingController();

  final TextEditingController universityController = TextEditingController();
  final FocusNode univf = FocusNode();
  List<dynamic> university = [ ];

  final TextEditingController collegeController = TextEditingController();
  final FocusNode colf = FocusNode();
  List<dynamic>  college= [ ];
  final TextEditingController courseController = TextEditingController();
  final FocusNode corsef = FocusNode();
  List<dynamic> course = [ ];

  final TextEditingController yearController = TextEditingController();
  final FocusNode yearf = FocusNode();
  List<String> year = ['1', '2', '3', '4','5'];


  final TextEditingController branchController = TextEditingController();
  final FocusNode branchf = FocusNode();
  List<dynamic> branch = [];



  final TextEditingController sectionController = TextEditingController();
  final FocusNode sectionf = FocusNode();
  List<String> section = ['A', 'B', 'C', 'D','E'];

  List <TextEditingController> subjectlist=[TextEditingController()] ;
  List <FocusNode> subjectf = [FocusNode()];
  List<dynamic> subjects = [];

  List<String> subject=[];


  @override
  void initState() {
    // TODO: implement initState
    fetchuniversity();
    super.initState();
  }
//ar firebaseDB= FirebaseFirstore.instance.collection("").doc("").Snapshots();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      body: Container(
        height: size.height * 1,
        width: size.width*1,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [

              const Color.fromRGBO(86, 149, 178, 1),
              // Color.fromRGBO(86, 149, 178, 1),
              const Color.fromRGBO(68, 174, 218, 1),
              //Color.fromRGBO(118, 78, 232, 1),
              Colors.deepPurple.shade300
            ],
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(

            child: Column(
              children: [
                SizedBox(height: size.height * 0.03),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      "Student Details",

                      textStyle:GoogleFonts.openSans(
                        color: Colors.white54,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          const Shadow(
                            color:Colors.black,
                            offset:Offset(1, 1),
                            blurRadius: 5,

                          ),
                        ],
                      ),

                    ),

                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                ),

                SizedBox(height: size.height * 0.02),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: rollno,
                    decoration: InputDecoration(
                        fillColor: Colors.black26.withOpacity(0.6),
                        filled: true,
                        hintText: "Enter Roll No.",
                        contentPadding: EdgeInsets.only(left:size.height*0.041 ,top: size.height*0.055),
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black12, width: 3),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        )),
                    style:  TextStyle(   color: Colors.white.withOpacity(0.9)),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(

                    controller: universityController,

                    focusNode: univf,
                    suggestionItemDecoration: SuggestionDecoration(
                     padding: EdgeInsets.all(25.0)
                    ),
                    key: const Key("Search key"),
                    suggestions:
                    university.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),


                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,


                    ),
                    marginColor: Colors.black,
                    suggestionsDecoration: SuggestionDecoration(
                      
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          
                          colors: [

                            const Color.fromRGBO(86, 149, 178, 1),

                            const Color.fromRGBO(68, 174, 218, 1),

                            Colors.deepPurple.shade300
                          ],
                        ),
                        // color: const Color.fromRGBO(3, 74, 140, 1),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left:size.height*0.041 ,top: size.height*0.055),
                        hintText: "University",
                       // contentPadding: EdgeInsets.only(left: 30.0),
                        fillColor: Colors.black26.withOpacity(0.6),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black12, width: 3),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        )),
                    onSuggestionTap: (value) {
                      print(value.searchKey);
                      print(universityController.text.toString());

                      setState(() {
                        fetchcollege(universityController.text.toString());
                      });
                      FocusScope.of(context).requestFocus(colf);

                    },

                    enabled: true,
                    hint: "University",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: collegeController,
                    focusNode: colf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    college.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.amber,
                    suggestionsDecoration: SuggestionDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                          colors: [

                            const Color.fromRGBO(86, 149, 178, 1),

                            const Color.fromRGBO(68, 174, 218, 1),

                            Colors.deepPurple.shade300
                          ],
                        ),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.amber),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left:size.height*0.041 ,top: size.height*0.055),
                        hintText: "College",
                        fillColor: Colors.black26.withOpacity(0.6),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black12, width: 3),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        )),
                    onSuggestionTap: (value) {

                      print(value.searchKey);
                      print(courseController.text.toString());
                      setState(() {
                        fetchcourse(collegeController.text.toString());
                      });

                      FocusScope.of(context).requestFocus(corsef);

                    },
                    enabled: true,
                    hint: "College",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: courseController,
                    focusNode: corsef,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    course.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.amber,
                    suggestionsDecoration: SuggestionDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                          colors: [

                            const Color.fromRGBO(86, 149, 178, 1),

                            const Color.fromRGBO(68, 174, 218, 1),

                            Colors.deepPurple.shade300
                          ],
                        ),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.amber),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "Course",
                        contentPadding: EdgeInsets.only(left:size.height*0.041 ,top: size.height*0.055),
                        fillColor: Colors.black26.withOpacity(0.6),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black12, width: 3),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        )
                    ),
                    onSuggestionTap: (value) {

                      print(value.searchKey);
                      print(courseController.text.toString());
                      setState(() {
                        fetchbranch(courseController.text.toString());
                      });

                      FocusScope.of(context).requestFocus(yearf);

                    },
                    enabled: true,
                    hint: "Course",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: yearController,
                    focusNode: yearf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    year.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.amber,
                    suggestionsDecoration: SuggestionDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                          colors: [

                            const Color.fromRGBO(86, 149, 178, 1),

                            const Color.fromRGBO(68, 174, 218, 1),

                            Colors.deepPurple.shade300
                          ],
                        ),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.amber),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "Year",
                        contentPadding: EdgeInsets.only(left:size.height*0.041 ,top: size.height*0.055),
                        fillColor: Colors.black26.withOpacity(0.6),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black12, width: 3),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        )),
                    onSuggestionTap: (value) {
                      print(value.searchKey);
                      print(universityController.text.toString());


                      FocusScope.of(context).requestFocus(branchf);

                    },
                    enabled: true,
                    hint: "Year",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: branchController,
                    focusNode: branchf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    branch.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.amber,
                    suggestionsDecoration: SuggestionDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                          colors: [

                            const Color.fromRGBO(86, 149, 178, 1),

                            const Color.fromRGBO(68, 174, 218, 1),

                            Colors.deepPurple.shade300
                          ],
                        ),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.amber),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "Branch",
                        contentPadding: EdgeInsets.only(left:size.height*0.041 ,top: size.height*0.055),
                        fillColor: Colors.black26.withOpacity(0.6),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black12, width: 3),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        )
                    ),
                    onSuggestionTap: (value) {
                      print(value.searchKey);

                      setState(() {
                        fetchsubject(branchController.text.toString());
                      });
                      FocusScope.of(context).requestFocus(sectionf);
                    },
                    enabled: true,
                    hint: "Branch",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: sectionController,
                    focusNode: sectionf,
                    suggestionItemDecoration: SuggestionDecoration(),
                    key: const Key("Search key"),
                    suggestions:
                    section.map((e) => SearchFieldListItem(e)).toList(),
                    searchStyle: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                    suggestionStyle: GoogleFonts.openSans(
                      color: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    marginColor: Colors.amber,
                    suggestionsDecoration: SuggestionDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                          colors: [

                            const Color.fromRGBO(86, 149, 178, 1),

                            const Color.fromRGBO(68, 174, 218, 1),

                            Colors.deepPurple.shade300
                          ],
                        ),
                        //shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(10),
                        border: Border.all(width: 2, color: Colors.amber),
                        borderRadius: BorderRadius.circular(0)),
                    searchInputDecoration: InputDecoration(
                        hintText: "Section",
                        contentPadding: EdgeInsets.only(left:size.height*0.041 ,top: size.height*0.055),
                        fillColor: Colors.black26.withOpacity(0.6),
                        filled: true,
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black12, width: 3),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        )),
                    onSuggestionTap: (value) {
                      print(value.searchKey);
                      print(universityController.text.toString());

                      //FocusScope.of(context).requestFocus(subjectf);


                    },
                    enabled: true,
                    hint: "Section",
                    itemHeight: 50,
                    maxSuggestionsInViewPort: 3,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(

                    height: size.height*0.14*subjectlist.length,
                    width: size.width*1,
                    color: Colors.transparent,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subjectlist.length,
                      shrinkWrap: true,
                      itemBuilder:(context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(
                                child:  SearchField(
                                  //focusNode:subjectf[index],
                                  controller: subjectlist[index],


                                  suggestionItemDecoration: SuggestionDecoration(),
                                  key: const Key("Search key"),
                                  suggestions:
                                  subjects.map((e) => SearchFieldListItem(e)).toList(),
                                  searchStyle: GoogleFonts.openSans(

                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  suggestionStyle: GoogleFonts.openSans(
                                    color: Colors.amber,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  marginColor: Colors.amber,
                                  suggestionsDecoration: SuggestionDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,

                                        colors: [

                                          const Color.fromRGBO(86, 149, 178, 1),

                                          const Color.fromRGBO(68, 174, 218, 1),

                                          Colors.deepPurple.shade300
                                        ],
                                      ),
                                      //shape: BoxShape.rectangle,
                                      padding: const EdgeInsets.all(10),
                                      border: Border.all(width: 2, color: Colors.amber),
                                      borderRadius: BorderRadius.circular(0)),
                                  searchInputDecoration: InputDecoration(
                                      suffixIcon: SizedBox(
                                        width: size.width*0.28,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(onPressed: (){
                                              setState(() {
                                                //print(subjectlist[index].text.toString());
                                                subjectlist.add(TextEditingController());

                                              });
                                              FocusScope.of(context).requestFocus(subjectf[index]);
                                            },
                                              icon: const Icon(Icons.add),
                                              color: Colors.white,
                                              iconSize: size.height*0.04,
                                            ),
                                            IconButton(onPressed: (){
                                              setState(() {
                                                if(index!=0){
                                                  subjectlist.removeAt(index);
                                                }
                                              }
                                              );
                                            },
                                              icon: const Icon(Icons.delete),
                                              color: Colors.white,
                                              iconSize: size.height*0.04,
                                            )
                                          ],
                                        ),
                                      ),
                                      hintText: "Enter Subject Name",
                                      contentPadding: EdgeInsets.only(left:size.height*0.041 ,top: size.height*0.055),
                                      fillColor: Colors.black26.withOpacity(0.6),
                                      filled: true,
                                      hintStyle: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        borderSide: BorderSide(color: Colors.black12, width: 3),
                                      ),

                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 3),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      )
                                  ),
                                  onSuggestionTap: (value) {
                                    print(value.searchKey);
                                    FocusScope.of(context).removeListener;


                                  },
                                  enabled: true,
                                  hint: "Enter subject Name",
                                  itemHeight: 50,
                                  maxSuggestionsInViewPort: 3,


                                ),

                              ),


                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  width: size.width*0.9,
                  height: size.height*0.065,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 60,
                            blurStyle: BlurStyle.outer,
                            color: Colors.black54,
                            offset: Offset(1, 1)
                        )
                      ],
                      gradient:const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black,width: 2)
                  ),

                  child: ElevatedButton(
                    onPressed: ()
                    async {
                      for(int i=0;i< subjectlist.length;i++){

                        subject.add(subjectlist[i].text.trim());
                      }
                      if(
                      rollno.text.toString().isNotEmpty &&
                          universityController.text.toString().isNotEmpty &&
                          courseController.text.toString().isNotEmpty &&
                          collegeController.text.toString().isNotEmpty &&
                          yearController.text.toString().isNotEmpty &&
                          branchController.text.toString().isNotEmpty &&
                          sectionController.text.toString().isNotEmpty
                      ){
                        await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).update(

                            {
                              "Rollnumber": rollno.text.trim().toString(),
                              "University": universityController.text.trim().toString(),
                              "College": collegeController.text.trim().toString(),
                              "Course": courseController.text.trim().toString(),
                              "Year": yearController.text.trim().toString(),
                              "Branch": branchController.text.trim().toString(),
                              "Section": sectionController.text.trim().toString(),
                              "Subject": subject,
                              "Active":false
                            }
                        ).then((value) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const SignInScreen(),
                              type: PageTransitionType.rightToLeftJoined,
                              duration: const Duration(milliseconds: 400),
                              alignment: Alignment.bottomCenter,
                              childCurrent: const StudentDetails(),
                            ),
                          );

                          print("Sucessfully uploaded");
                        }).onError((error, stackTrace) {
                          print("Error is: $error");
                          InAppNotifications.instance
                            ..titleFontSize = 35.0
                            ..descriptionFontSize = 20.0
                            ..textColor = Colors.black
                            ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                            ..shadow = true
                            ..animationStyle = InAppNotificationsAnimationStyle.scale;
                          InAppNotifications.show(
                              title: 'Failed',
                              duration: const Duration(seconds: 2),
                              description: error.toString().split(']')[1].trim(),
                              leading: const Icon(
                                Icons.error_outline_outlined,
                                color: Colors.red,
                                size: 55,
                              ));
                        });

                      }
                      else {
                        InAppNotifications.instance
                          ..titleFontSize = 14.0
                          ..descriptionFontSize = 14.0
                          ..textColor = Colors.black
                          ..backgroundColor =
                          const Color.fromRGBO(150, 150, 150, 1)
                          ..shadow = true
                          ..animationStyle =
                              InAppNotificationsAnimationStyle.scale;
                        InAppNotifications.show(
                            title: 'Failed',
                            duration: const Duration(seconds: 2),
                            description: "Please fill all the details",
                            leading: const Icon(
                              Icons.error_outline_outlined,
                              color: Colors.red,
                              size: 20,
                            ));
                      }



                    },


                    style: ElevatedButton.styleFrom(
                      shape:const StadiumBorder(),
                      backgroundColor: Colors.transparent,

                    ),
                    child: AutoSizeText("Submit",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                        color: Colors.black,
                        shadows:[
                          const Shadow(color: Colors.black,

                            offset: Offset(1,1),
                          ),
                        ] ,


                      ),


                    ),

                  ),
                ),
                SizedBox(height: size.height * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fetchuniversity() async {
    final ref= await  FirebaseFirestore.instance.collection("University").doc("University").get();
    university=ref.data()!["University"];
  }


  fetchcollege(String uni) async {
    final ref= await  FirebaseFirestore.instance.collection("Colleges").doc(uni).get();
    setState(() {
      college= ref.data()!["Colleges"];
      print(college);
    });
  }
  fetchcourse(String coll) async {
    final ref= await  FirebaseFirestore.instance.collection("Course").doc(coll).get();
    setState(() {
      course= ref.data()!["Course"];
    });
  }

  fetchbranch(String cou) async {
    final ref= await  FirebaseFirestore.instance.collection("Branch").doc(cou).get();
    setState(() {
      branch= ref.data()!["Branch"];
    });
  }

  fetchsubject(String branch) async {
    final ref= await  FirebaseFirestore.instance.collection("Subject").doc(branch).get();
    setState(() {
      subjects= ref.data()!["Subject"];
    });
  }



}

