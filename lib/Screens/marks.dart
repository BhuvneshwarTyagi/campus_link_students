



import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Marks extends StatefulWidget {
  const Marks({Key? key}) : super(key: key);

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  final TextStyle _st=GoogleFonts.exo(
    color: Colors.white,
    fontSize: 22,

  );
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
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
      child: Padding(
        padding: EdgeInsets.all(size.height*0.01),
        child: SizedBox(
          height: size.height,
          width: size.width*0.98,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
            builder: (context, snapshot) {
              return
              snapshot.hasData
                  ?
               ListView.builder(
                 itemCount: snapshot.data!.data()?["Subject"].length,
                 itemBuilder: (context, index) {
                   return Padding(
                     padding: const EdgeInsets.all(5.0),
                     child: Container(
                       height: size.height * 0.31,
                       width: size.width * 0.8,
                       decoration: BoxDecoration(
                           color:  const Color.fromRGBO(40, 86, 122, 1),


                           border: Border.all(color: Colors.white, width: 2),
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
                                   snapshot.data!.data()?["Subject"][index],
                                   style: _st,
                                 ),
                               ],
                             ),
                             SizedBox(
                               height: size.height * 0.02,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 SizedBox(
                                   width: size.width * 0.03,
                                 ),
                                 AutoSizeText(
                                   "Sessional ",
                                   style: _st,
                                 ),
                                 SizedBox(
                                   width: size.width * 0.08,
                                 ),
                                 AutoSizeText(
                                   "Obtained",
                                   style: _st,
                                 ),
                                 SizedBox(
                                   width: size.width * 0.08,

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
                               mainAxisAlignment: MainAxisAlignment.start,
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
                                       border: Border.all(color: Colors.white),
                                       borderRadius: BorderRadius.circular(5)

                                   ),
                                   height: size.height*0.04,
                                   width: size.width*0.12,
                                   child:  Center(
                                     child: AutoSizeText(
                                       snapshot.data!.data()?["S-2-${snapshot.data!.data()?["Subject"][index]}"] ?? "-",
                                       style: GoogleFonts.exo(
                                           fontSize: 22,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white
                                       ),

                                     ),
                                   ),),
                                 SizedBox(
                                   width: size.width * 0.15,

                                 ),
                                 Container(
                                   decoration: BoxDecoration(
                                       border: Border.all(color: Colors.white),
                                       borderRadius: BorderRadius.circular(5)

                                   ),
                                   height: size.height*0.04,
                                   width: size.width*0.12,
                                   child:  Center(
                                     child: AutoSizeText(
                                       snapshot.data!.data()?["S-1-max_marks"]?? "-",
                                       style: GoogleFonts.exo(
                                           fontSize: 22,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white
                                       ),

                                     ),
                                   ),),

                               ],
                             ),
                             SizedBox(
                               height: size.height * 0.014,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.start,
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
                                     border: Border.all(color: Colors.white),
                                     borderRadius: BorderRadius.circular(5)

                                 ),
                                   height: size.height*0.04,
                                   width: size.width*0.12,
                                   child:  Center(
                                     child: AutoSizeText(
                                       snapshot.data!.data()?["S-2-${snapshot.data!.data()?["Subject"][index]}"] ?? "-",
                                       style: GoogleFonts.exo(
                                           fontSize: 22,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white
                                       ),

                                     ),
                                   ),),
                                 SizedBox(
                                   width: size.width * 0.15,
                                 ),
                                 Container(
                                   decoration: BoxDecoration(
                                       border: Border.all(color: Colors.white),
                                       borderRadius: BorderRadius.circular(5)

                                   ),
                                   height: size.height*0.04,
                                   width: size.width*0.12,
                                   child:  Center(
                                     child: AutoSizeText(
                                       snapshot.data!.data()?["S-2-max_marks"]?? "-",
                                       style: GoogleFonts.exo(
                                           fontSize: 22,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white
                                       ),

                                     ),
                                   ),),

                               ],
                             ),
                             SizedBox(
                               height: size.height * 0.014,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.start,
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
                                 Container(decoration: BoxDecoration(
                                     border: Border.all(color: Colors.white),
                                     borderRadius: BorderRadius.circular(5)

                                 ),
                                   height: size.height*0.04,
                                   width: size.width*0.12,
                                   child:  Center(
                                     child: AutoSizeText(
                                       snapshot.data!.data()?["S-3-${snapshot.data!.data()?["Subject"][index]}"] ?? "-",
                                       style: GoogleFonts.exo(
                                           fontSize: 22,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white
                                       ),

                                     ),
                                   ),),
                                 SizedBox(
                                   width: size.width * 0.15,

                                 ),
                                 Container(
                                   decoration: BoxDecoration(
                                       border: Border.all(color: Colors.white),
                                       borderRadius: BorderRadius.circular(5)

                                   ),
                                   height: size.height*0.04,
                                   width: size.width*0.12,
                                   child:  Center(
                                     child: AutoSizeText(
                                       snapshot.data!.data()?["S-3-max_marks"]?? "-",
                                       style: GoogleFonts.exo(
                                           fontSize: 22,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white
                                       ),

                                     ),
                                   ),),
                               ],
                             ),

                           ],
                         ),
                       ),
                     ),
                   );
                 },)
              :
              const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
