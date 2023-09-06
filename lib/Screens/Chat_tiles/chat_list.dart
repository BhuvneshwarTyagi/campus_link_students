import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../../Constraints.dart';
import '../loadingscreen.dart';
import 'chat.dart';

class chatsystem extends StatefulWidget {
  const chatsystem({super.key});

  @override
  State<chatsystem> createState() => _chatsystemState();
}

class _chatsystemState extends State<chatsystem> {
  String channel_perfix =
      "${usermodel["University"].toString().trim().split(" ")[0]} "
      "${usermodel["College"].toString().trim().split(" ")[0]} "
      "${usermodel["Course"].toString().trim().split(" ")[0]} "
      "${usermodel["Branch"].toString().trim().split(" ")[0]} "
      "${usermodel["Year"].toString().trim().split(" ")[0]} "
      "${usermodel["Section"].toString().trim().split(" ")[0]} ";


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(63, 63, 63, 1),
        leadingWidth: size.width * 0.07,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Campus Link"),
      ),
      body:
         ! no_subjects
        ?
         SizedBox(
           height: size.height*0.8,
           width: size.width,
           child: ListView.builder(
             scrollDirection: Axis.vertical,
             itemCount: usermodel["Subject"].length,
             itemBuilder: (context, index) {
               return SizedBox(
                 height: size.height*0.1,
                 width: size.width,
                 child: StreamBuilder(
                     stream: FirebaseFirestore.instance.collection("Messages").doc( channel_perfix +usermodel["Subject"][index]).snapshots(),
                     builder: (context, snapshot) {
                       print("chat List");

                       int readCount=0;
                       int count=0;
                       snapshot.hasData
                           ?
                       readCount= snapshot.data?.data()!["Messages"].length
                           :
                       null;
                       snapshot.hasData
                           ?
                       count= int.parse("${snapshot.data?.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"]}")
                           :
                       null;
                       return snapshot.hasData
                           ?
                       InkWell(
                         onTap: () async {

                           Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(
                               builder: (context) => chat_page(channel: channel_perfix + usermodel["Subject"][index]),
                             ),
                           );
                         },
                         child: Container(
                           height: size.height*0.1,
                           decoration: const BoxDecoration(
                               color: Colors.white,
                               border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
                           padding: EdgeInsets.all(size.width*0.02),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               CircleAvatar(
                                 backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                                 radius: size.width*0.07,
                                 // backgroundImage: NetworkImage(snapshot.data!.data()!["image_URL"]),
                               ),

                               SizedBox(width: size.width*0.03),
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   AutoSizeText("${usermodel["Subject"][index]}",
                                     style: GoogleFonts.poppins(color: Colors.black,fontSize: size.width*0.045,fontWeight: FontWeight.w500),
                                   ),
                                   Row(
                                     children: [
                                       SizedBox(
                                         width: size.width*0.7,
                                         child: AutoSizeText("${snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["Name"]}: ${snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].length <25 ? snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"] : snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].toString().substring(0,25)}",
                                           style: GoogleFonts.poppins(
                                               color: Colors.black.withOpacity(0.80),
                                               fontSize: size.width*0.035,
                                               fontWeight: FontWeight.w400
                                           ),
                                           textAlign: TextAlign.left,
                                         ),
                                       ),
                                       readCount - count>0
                                           ?
                                       CircleAvatar(
                                         radius: size.width*0.03,
                                         backgroundColor: Colors.green,
                                         child: AutoSizeText("${readCount - count}",
                                           style: GoogleFonts.poppins(
                                               color: Colors.white,
                                               fontSize: size.width*0.035,
                                               fontWeight: FontWeight.w400
                                           ),
                                           textAlign: TextAlign.left,
                                         ),
                                       )
                                           :
                                       const SizedBox(),
                                     ],
                                   )
                                 ],
                               )
                             ],
                           ),
                         ),
                       )
                           :
                      const SizedBox();
                     }
                 ),
               );
             },
           ),
         )
             :
         SizedBox(
           width: size.width*1,
           height: size.height*1,
           child: const Center(
             child: Image(
               image: AssetImage("assets/icon/No_data_found.png"),
               fit: BoxFit.cover,
             ),
           ),
         )
    );
  }

  Future<void> markFalse() async {
    for(var subject in usermodel["Subject"]){
      await FirebaseFirestore.instance.collection("Messages").doc(channel_perfix+subject.toString()).update({
        "${usermodel["Email"].toString().split("@")[0]}.Active" : false
      });
    }
    print(".....................false");
  }
}
