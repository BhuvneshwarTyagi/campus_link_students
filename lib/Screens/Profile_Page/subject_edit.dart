import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';

import '../../Constraints.dart';

class EditSubjectFormPage extends StatefulWidget {
  const EditSubjectFormPage({Key? key}) : super(key: key);

  @override
  EditSubjectFormPageState createState() {
    return EditSubjectFormPageState();
  }
}

class EditSubjectFormPageState extends State<EditSubjectFormPage> {
  List<TextEditingController> subjectlist = [TextEditingController()];
  List<dynamic> subjects = [];
  List<FocusNode> subjectf = [FocusNode()];

  List<dynamic> college = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromRGBO(40, 130, 146, 1),
            title: const Text("Edit")),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Form(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    const SizedBox(
                      width: 320,
                      child: Text(
                        "What's your Subjects?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: size.height * 0.14 * subjectlist.length,
                        width: size.width * 1,
                        color: Colors.transparent,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subjectlist.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SearchField(
                                      //focusNode:subjectf[index],
                                      controller: subjectlist[index],

                                      suggestionItemDecoration:
                                          SuggestionDecoration(),
                                      key: const Key("Search key"),
                                      suggestions: subjects
                                          .map((e) => SearchFieldListItem(e))
                                          .toList(),
                                      searchStyle: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                      suggestionStyle: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      marginColor: Colors.white,
                                      suggestionsDecoration:
                                          SuggestionDecoration(
                                              color: const Color.fromRGBO(
                                                  40, 130, 146, 1),
                                              //shape: BoxShape.rectangle,
                                              padding: const EdgeInsets.all(10),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                      searchInputDecoration: InputDecoration(
                                          suffixIcon: SizedBox(
                                            width: size.width * 0.28,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      //print(subjectlist[index].text.toString());
                                                      subjectlist.add(
                                                          TextEditingController());
                                                    });
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            subjectf[index]);
                                                  },
                                                  icon: const Icon(Icons.add),
                                                  color: const Color.fromRGBO(
                                                      40, 130, 146, 1),
                                                  iconSize: size.height * 0.04,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (index != 0) {
                                                        subjectlist
                                                            .removeAt(index);
                                                      }
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  color: const Color.fromRGBO(
                                                      40, 130, 146, 1),
                                                  iconSize: size.height * 0.04,
                                                )
                                              ],
                                            ),
                                          ),
                                          hintText: "Enter Subject Name",
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          focusColor: Colors.black,
                                          disabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 3,
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 3,
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          )),
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
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      height: size.height * 0.05,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(40, 130, 146, 1),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      child: ElevatedButton(
                          onPressed: () async {
                            for (int i = 0; i < subjectlist.length; i++) {
                              subjects.add(subjectlist[i].text.trim());
                            }
                            if (subjects.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection("Students")
                                  .doc(usermodel["Email"])
                                  .update({
                                "Subject": FieldValue.arrayUnion(subjects),
                              });
                            } else {
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
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
