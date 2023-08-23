import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';
import '../Registration/database.dart';

class chat_page extends StatefulWidget {
  const chat_page({Key? key, required this.channel}) : super(key: key);
  final String channel;
  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController= ScrollController();
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    print(widget.channel);
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(63, 63, 63,1),
        leadingWidth: size.width*0.07,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: size.height*0.03,
              backgroundColor: Colors.white70,
              backgroundImage:usermodel["Profile_URL"]!=null?

              NetworkImage(usermodel["Profile_URL"])
                  :
              null,
              // backgroundColor: Colors.teal.shade300,
              child: usermodel["Profile_URL"]==null?
              AutoSizeText(
                usermodel["Name"].toString().substring(0, 1),
                style: GoogleFonts.exo(
                  color: Colors.black54,
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.w600),
              )
                  :
              null,
            ),
            SizedBox(
              width: size.width*0.03,
            ),
            AutoSizeText(
              usermodel["Name"],
              style: GoogleFonts.exo(
                color: Colors.white
              ),
            ),
          ],
        ),
        actions:<Widget> [
          IconButton(onPressed: (){},
              icon: Icon(Icons.more_vert,size: size.height*0.04,))
        ],
      ),
      body: Container(
        height: size.height,
        //color: Colors.black26,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Messages").doc(widget.channel).snapshots(),
          builder: (context, snapshot) {
            List<dynamic> message = snapshot.data?.data()!["Messages"]==null ? [] : snapshot.data?.data()!["Messages"].reversed.toList();
           return
             snapshot.hasData
                 ?
             message.isNotEmpty
                 ?
             ListView.builder(
               reverse: true,
               scrollDirection: Axis.vertical,
               itemCount: message.length,
               controller: scrollController,
               itemBuilder: (context, index) {
                 return
                   Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       index!=message.length-1
                           ?
                       message[index+1]["Stamp"].toDate().day==message[index]["Stamp"].toDate().day
                           ?
                       const SizedBox()
                           :
                       date(message[index]["Stamp"].toDate())
                           :
                       date(message[index]["Stamp"].toDate())
                       ,
                       message[index]["UID"]==usermodel["Email"]
                           ?
                       bubble("${message[index]["text"]}","${message[index]["Name"]}",  message[index]["Stamp"].toDate(), true,size)
                           :
                       bubble("${message[index]["text"]}", "${message[index]["Name"]}",  message[index]["Stamp"].toDate(), false,size)
                     ],
                   );
               },
             )
                 :
             const SizedBox()
                 :
             const Center(
                   child: CircularProgressIndicator(),
                 );
        },
        ),

      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width*1,
          //color: Colors.black26,
          padding: EdgeInsets.all(size.width*0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                   height: size.height*0.062,
                   width: size.width*0.84,
                   child: TextField(
                     controller: messageController,
                     enableSuggestions: true,
                     maxLines: 5,
                     minLines: 1,
                     autocorrect: true,
                     textAlign:TextAlign.start,
                     style: const TextStyle(color: Colors.white,fontSize: 18),
                     decoration: InputDecoration(
                       fillColor: Colors.black54,
                       filled: true,
                       hintText: "Message",
                       hintStyle:  GoogleFonts.exo(
                           color: Colors.white54,
                           fontSize: 19,//height:size.height*0.0034
                       ),
                       contentPadding: EdgeInsets.only(left: size.width*0.2),
                       enabledBorder: const OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(30.0)),
                           borderSide: BorderSide(color: Colors.black54, width: 1)
                       ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.black54, width: 1)
                      ),
                      prefixIcon: Icon(Icons.emoji_emotions_outlined,size: size.height*0.042,color: Colors.white54,),
                     ),

                   ),
                 ),
              IconButton(
                      onPressed: () async {
                    messageController.text.trim()==""
                        ?
                        null
                        :
                    await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                      "Messages": FieldValue.arrayUnion([{
                        "Name": usermodel["Name"].toString(),
                        "UID": usermodel["Email"].toString(),
                        "text": messageController.text.trim().toString(),
                        "Stamp": DateTime.now(),
                      }])
                    },
                    ).whenComplete(() async {
                      setState(() {
                        messageController.clear();
                      });
                      List<dynamic> tokens = await FirebaseFirestore
                          .instance
                          .collection("Messages")
                          .doc(widget.channel)
                          .get().then((value){
                            return value.data()?["Token"];
                      });
                      for(var element in tokens){
                        element.toString() != usermodel["Token"]
                            ?
                        database().sendPushMessage(element, messageController.text.trim(), "New Message")
                            :
                        null;
                      }
                    },
                    );
                  },
                     icon: Icon(Icons.send,size: size.height*0.04,)),
            ],
          ),
        ),
      ),
    );
  }

  Widget show_date(String chat_time){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height*0.032,
          width: MediaQuery.of(context).size.width*0.28,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(63, 63, 63,1),
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            border: Border.all(
              color: const Color.fromRGBO(63, 63, 63,1),
              width: 1
            )
          ),
          child: Center(
            child: AutoSizeText(
                chat_time,
              style: GoogleFonts.exo(
                fontSize: 16,
                color:Colors.black54
              ),
            ),
          ),
        )
      ],
    );
  }
 /* Widget bubble(String text, String stamp,bool sender){
    
    return BubbleSpecialThree(
      text: text,
      isSender: sender,
      textStyle: GoogleFonts.poppins(
      color: Colors.black
    ),
    );
  }  */
  Widget bubble(String text,String name, DateTime stamp,bool sender,Size size) {
    return Align(
      alignment: sender ?
      Alignment.centerRight
          :
      Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: sender ?
        MainAxisAlignment.end
            :
        MainAxisAlignment.start
        ,
        children: [

          sender
              ?
          const SizedBox()
              :
          Row(
            children: [
              SizedBox(width: size.width * 0.02),
              CircleAvatar(
                radius: size.width * 0.045,
                backgroundImage:usermodel["Profile_URL"]!=null?

                NetworkImage(usermodel["Profile_URL"])
                    :
                null,
                // backgroundColor: Colors.teal.shade300,
                child: usermodel["Profile_URL"]==null?
                AutoSizeText(
                  usermodel["Name"].toString().substring(0, 1),
                  style: GoogleFonts.exo(
                      fontSize: size.height * 0.01,
                      fontWeight: FontWeight.w600),
                )
                    :
                null,
              ),
            ],
          ),

          Container(
            width: text.length > 23
                ?
            size.width * 0.028 * 25
                :
            name.length >= text.length
                ?
            size.width * 0.037 * name.length
                :
            size.width * 0.035 * text.length
            ,
            margin: EdgeInsets.symmetric(
                horizontal: sender ? size.width * 0.03 : size.width * 0.01,
                vertical: size.height * 0.01),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: sender ?
                  const Radius.circular(30)
                      :
                  const Radius.circular(0),
                  topLeft: !sender ?
                  const Radius.circular(30)
                      :
                  const Radius.circular(0),
                  bottomLeft: sender ?
                  const Radius.circular(30)
                      :
                  const Radius.circular(0),
                  bottomRight: !sender ?
                  const Radius.circular(30)
                      :
                  const Radius.circular(0),
                )
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: AutoSizeText(name,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * 0.028,
                        fontWeight: FontWeight.w600
                    ),),
                ),
                SizedBox(
                  width: size.width * 0.92,
                  child: AutoSizeText(
                    text,
                    style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.92,
                  child: AutoSizeText(
                    "${stamp.hour}:${stamp.minute < 10 ? "0" : ""}${stamp
                        .minute} ${stamp.hour < 12 ? "am" : "pm"}",
                    style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: size.width * 0.022,
                        fontWeight: FontWeight.w400
                    ),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget date(DateTime date){

    return DateChip(
        date: date,
      color: Colors.white,

    );
  }
}
