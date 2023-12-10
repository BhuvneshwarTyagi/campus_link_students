import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';

import '../../Constraints.dart';




class EditCollegeFormPage extends StatefulWidget {


  const EditCollegeFormPage({Key? key}) : super(key: key);

  @override


  EditCollegeFormPageState createState() {
    return EditCollegeFormPageState();
  }
}

class EditCollegeFormPageState extends State<EditCollegeFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController collControler = TextEditingController();

  List<dynamic> college = [];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchcollege();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromRGBO(40, 130, 146, 1),
            title: const Text("Edit")),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all( size.width*0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height*0.05,),
                const SizedBox(
                    width: 320,
                    child: Text(
                      "What's your College?",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    height: 100,
                    width:size.width,
                    child:SearchField(
                      controller: collControler,

                      suggestionItemDecoration: SuggestionDecoration(),
                      key: const Key("Search key"),
                      suggestions:
                      college.map((e) => SearchFieldListItem(e)).toList(),
                      searchStyle: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w800),
                      suggestionStyle: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                      marginColor: Colors.black,
                      suggestionsDecoration: SuggestionDecoration(
                          color: const Color.fromRGBO(40, 130, 146, 1),
                          //shape: BoxShape.rectangle,
                          padding: const EdgeInsets.all(10),
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(0)),
                      searchInputDecoration: InputDecoration(
                          hintText: "College",
                          fillColor: Colors.transparent,
                          filled: true,
                          hintStyle: GoogleFonts.openSans(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusColor: Colors.black,
                          disabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          )),
                      onSuggestionTap: (value) {
                        print(value.searchKey);
                        // print(universityController.text.toString());

                        setState(() {
                          //  fetchcollege(universityController.text.toString());
                        });
                        //FocusScope.of(context).requestFocus(colf);
                      },
                      enabled: true,
                      hint: "College",
                      itemHeight: 50,
                      maxSuggestionsInViewPort: 3,
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.1,),
                Container(

                  width: size.width * 0.3,
                  height: size.height * 0.05,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(40, 130, 146, 1),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  child: ElevatedButton(

                      onPressed: () async {
                        if(collControler.text.trim().isNotEmpty) {
                          await    FirebaseFirestore.instance
                              .collection("Students")
                              .doc(usermodel["Email"])
                              .update({
                            "College": collControler.text.trim().toString(),
                          });

                        }
                        else{
                          InAppNotifications.instance
                            ..titleFontSize = 14.0
                            ..descriptionFontSize = 14.0
                            ..textColor = Colors.black
                            ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                            ..shadow = true
                            ..animationStyle = InAppNotificationsAnimationStyle.scale;
                          InAppNotifications.show(
                            // title: '',
                            duration: const Duration(seconds: 2),
                            description: "Please Select the Option First",

                          );
                        }

                      },
                      style: ElevatedButton.styleFrom(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: AutoSizeText(
                        "Update",
                        style: GoogleFonts.exo(
                          fontSize: 18, fontWeight: FontWeight.w600,
                        ),

                      )),
                ),

              ],
            ),
          ),
        ));
  }
  fetchcollege() async {
    final ref =
    await FirebaseFirestore.instance.collection("Colleges").doc(usermodel["University"]).get();
    setState(() {
      college = ref.data()!["Colleges"];
      //print(college);
    });
  }
}
