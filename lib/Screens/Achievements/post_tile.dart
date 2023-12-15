import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class PostTile extends StatefulWidget {
   PostTile({super.key,required this.email,required this.postImageUrl,required this.likes,required this.name,required this.stamp,required this.topicName,required this.topicDescription,required this.postedBy,required this.doc,required this.userProfile,required this.alreadyLiked});
   String email;
   String postImageUrl;
   int likes;
   String name;
   Timestamp stamp;
   String topicName;
   String topicDescription;
   String postedBy;
   String doc;
   String userProfile;
   bool alreadyLiked;
  @override
  State<PostTile> createState() => _PageState();
}

class _PageState extends State<PostTile> {
  bool isLike=false;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(top:size.height*0.003),
      shape: Border.all(
          color: Colors.black,
          width: 1
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: Colors.transparent,
            leading:  CircleAvatar(
              radius: size.width*0.08,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                  radius: size.width*0.062,
                 backgroundColor: Colors.green,
                 child:
                     usermodel["Profile-URL"]!=null
                         ?
                 Image.network(usermodel["Profile-URL"])
                :
                         AutoSizeText(usermodel["Name"].toString().substring(0,1),
                           style:GoogleFonts.exo(
                             color: Colors.black,
                             fontSize: size.height*0.035,
                             fontWeight: FontWeight.w600
                           ) ,)
                ,
              ),
            ),
            title: AutoSizeText(widget.name),
            subtitle:  AutoSizeText(widget.postedBy),
            trailing: TextButton(
            onPressed: () async {

              if(isLike)
                {

                  print("${widget.email.toString().split("@")[0]}-${widget.stamp.toDate()}");
                 await FirebaseFirestore.instance
                      .collection("Achievements").doc(widget.doc).update({
                   "Likes":FieldValue==0?0:FieldValue.increment(-1),
                   "Liked by":FieldValue.arrayRemove([usermodel["Email"]])
                 });
                  setState(() {
                    isLike=!isLike;
                  });
                 }
                 else{

                await FirebaseFirestore.instance
                    .collection("Achievements").doc(widget.doc).update({
                  "Likes":FieldValue.increment(1),
                  "Liked by":FieldValue.arrayUnion([usermodel["Email"]])
                });
                setState(() {
                  isLike=!isLike;
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              child: Container(
                height: size.height*0.031,
                  width: size.width*0.065,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                child:
                widget.alreadyLiked || isLike
                    ?
                Center(child: Icon(Icons.thumb_up,size: size.height*0.03,color: Colors.pinkAccent,))
                :
                Center(child: Icon(Icons.thumb_up,size: size.height*0.03,color:Colors.black26))
              ),
            ),
          ),
          Divider(
            color: Colors.black,
             height: size.height*0.015,
            thickness: 1,
            endIndent: size.height*0.02,
            indent: size.height*0.02,
          ),
          SizedBox(height: size.height*0.02,),
           Padding(
            padding: EdgeInsets.only(left: size.width*0.026),
            child:  AutoSizeText(widget.topicName,
            style: GoogleFonts.tiltNeon(
              fontWeight: FontWeight.w400,
              fontSize: size.height*0.022,
              color: Colors.black
            ),),
          ),
          SizedBox(height: size.height*0.02,),
           Padding(
            padding: EdgeInsets.only(left: size.width*0.026),
            child:  AutoSizeText(widget.topicDescription),
          ),
          SizedBox(height: size.height*0.02,),
          SizedBox(
            width: size.width,
            height:widget.postImageUrl!="null"? size.height*0.5:size.height*0,
            child:
            widget.postImageUrl.toString()!="null"
                ?
            Image.network(widget.postImageUrl,fit: BoxFit.cover,)
            :
            const SizedBox(),
          ),
          Container(
            height: size.height*0.022,
            color: Colors.white70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end ,
              children: [
                SizedBox(
                  width: size.width*0.02,
                ),
                Padding(
                  padding:  EdgeInsets.all(size.height*0.001),
                  child: AutoSizeText("Date : ${widget.stamp.toDate().toString().split(" ")[0]}",
                    style: GoogleFonts.exo(
                      fontSize: size.height*0.02
                    ),),
                ),
                SizedBox(
                  width: size.width*0.02,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
