import 'package:campus_link_student/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, required this.subject, required this.index});
  final String subject;
  final int index;
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController feed = TextEditingController();
  List feedbackItem = [];
  int? selectedIndex;
  List<String>TextItem=["The explanations are clear and accessible",
    "Well-organized with clear headings and subheadings.",
    "Highly relevant to the course curriculum.",
    "Comprehensive coverage with enriching insights.",
    "Engaging with real-world examples and visuals."];


  double rate = 0;
  int emoji=1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage("assets/images/bg-image.png"),fit: BoxFit.fill
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: AutoSizeText(
            'Give feedback',
            style: GoogleFonts.tiltNeon(
              color: Colors.black,
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "Note: Your identity will not be shown to the teachers but for security reasons we are storing your details.",
                        style: GoogleFonts.tiltNeon(
                          fontSize: size.width*0.04,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
              SizedBox(
                height: size.height * 0.02,
              ),
              AutoSizeText(
                'How did we do?',
                style: GoogleFonts.tiltNeon(fontSize: size.width * 0.05),
                textAlign: TextAlign.start,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: size.width * 0.65,
                  height: size.height * 0.07,
                  child: Row(
                    children: [
                      RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          allowHalfRating: true,
                          glow: true,

                          direction: Axis.horizontal,
                          itemSize: size.width * 0.13,
                          itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              rate= rating;
                              emoji=rating.toInt();
                              emoji==6 ? emoji = 5 : null;
                            });
                          }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Row(
                children: [
                  AutoSizeText(
                    'Care to share more about it?',
                    style: GoogleFonts.tiltNeon(fontSize: size.width * 0.05),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
              SizedBox(
                height: size.height*0.4,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 30,
                        color: feedbackItem.contains(TextItem[index])
                            ?
                        Colors.green.shade300
                            :
                        Colors.white,
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              feedbackItem.contains(TextItem[index])
                                  ?
                              feedbackItem.remove(TextItem[index])
                                  :
                              feedbackItem.add(TextItem[index]);
                            });
                          },
                          title: Text(
                            TextItem[index],
                            style: GoogleFonts.tiltNeon(
                                fontSize: size.width*0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Card (
                shape: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: size.width * 0.005, color: Colors.black),
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                ),
                child: InkWell(
                    onTap: () async {
                      print("Feedback is $feedbackItem");
                      await FirebaseFirestore
                          .instance
                          .collection("Notes")
                          .doc(
                          "${usermodel["University"]} "
                            "${usermodel["College"]} "
                            "${usermodel["Course"]} "
                            "${usermodel["Branch"]} "
                            "${usermodel["Year"]} "
                            "${usermodel["Section"]} "
                            "${widget.subject}"
                      ).update({
                        "Notes-${widget.index}.FeedbackList" : FieldValue.arrayUnion([usermodel["Email"]]),
                        "Notes-${widget.index}.Feedback.${usermodel["Email"].toString().split("@")[0]}" : {
                          "By" : usermodel["Email"],
                          "Rating" : rate,
                          "Description" : feedbackItem
                        }
                      }).onError((error, stackTrace) {
                        print("Error is  ${error.toString()}");
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context){

                            return Dialog(
                              elevation: 30,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.03)),
                              child: SizedBox(
                                height: size.height*0.5,
                                child: Card(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height:size.height * 0.07,
                                        ),
                                        const Image(image: AssetImage("assets/images/thankyou.png")),
                                        AutoSizeText(
                                          'Thank you!',
                                          style: GoogleFonts.tiltNeon(
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.width * 0.07),
                                          textAlign:TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        AutoSizeText(
                                          'By making your voice heard, you help us improve provided content.',
                                          style: TextStyle(
                                            fontSize: size.width * 0.04,
                                          ),
                                          textAlign:TextAlign.center,
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: AutoSizeText(
                                              'Go Back',
                                              style: GoogleFonts.tiltNeon(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width * 0.04),
                                              textAlign:TextAlign.center,
                                            ),)
                                      ],
                                    )),
                              ),
                            );
                          });
                    },
                    child: SizedBox(
                      width: size.width*0.9,
                      height: size.height*0.05,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText('PUBLISH FEEDBACK',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * 0.055,
                                ),
                            ),
                            SizedBox(
                              width: size.width*0.02,
                            ),
                            SizedBox(
                              width: size.width*0.08,
                              height: size.width*0.08,
                              child: Image.asset("assets/images/emoji$emoji.png"),
                            )
                          ],
                        ),
                      ),
                    ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}








