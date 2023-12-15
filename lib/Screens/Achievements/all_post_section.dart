import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Achievements/post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../Constraints.dart';
import 'user_profile.dart';
import 'add_post.dart';

class achievementPage extends StatefulWidget {
  const achievementPage({Key? key}) : super(key: key);

  @override
  State<achievementPage> createState() => _achievementPageState();
}

class _achievementPageState extends State<achievementPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        width: size.width * 1,
        color: Colors.black45,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Achievements")
              .orderBy("Time-Stamp", descending: true)
              .orderBy("Likes", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.data!=null
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.vertical,

                    itemBuilder: (context, index) {
                      return snapshot.data!.docs[index].data()["Liked by"]!=null
                         ?
                      !snapshot.data!.docs[index].data()["Liked by"].contains(usermodel["Email"])
                      ?
                      SizedBox(
                        /*height: size.height*1,
                          width: size.width*1,*/
                        child: PostTile(
                          email: snapshot.data?.docs[index].data()["Email"],
                          postImageUrl: snapshot.data!.docs[index].data()["Image-URL"].toString(),
                          likes: snapshot.data?.docs[index].data()["Likes"],
                          name: snapshot.data?.docs[index].data()["Name"],
                          stamp: snapshot.data!.docs[index].data()["Time-Stamp"],
                          topicName: snapshot.data?.docs[index].data()["Topic"],
                          topicDescription: snapshot.data?.docs[index]
                              .data()["Topic-Description"],
                          postedBy:
                          snapshot.data!.docs[index].data()["Post by"],
                          doc: snapshot.data!.docs[index].data()["doc"],
                          userProfile:snapshot.data!.docs[index].data()["Profile_URL"].toString(),
                          alreadyLiked:
                          snapshot.data!.docs[index].data()["Like by"]!=null
                            ?
                          snapshot.data!.docs[index].data()["Like by"].contains(usermodel["Email"])
                          :
                          false,
                        ),
                      )
                      :
                      SizedBox()
                          :
                      SizedBox(
                        /*height: size.height*1,
                          width: size.width*1,*/
                        child: Padding(
                          padding:  EdgeInsets.all(size.height*0.005),
                          child: PostTile(
                            email: snapshot.data?.docs[index].data()["Email"],
                            postImageUrl: snapshot.data!.docs[index].data()["Image-URL"].toString(),
                            likes: snapshot.data?.docs[index].data()["Likes"],
                            name: snapshot.data?.docs[index].data()["Name"],
                            stamp: snapshot.data!.docs[index].data()["Time-Stamp"],
                            topicName: snapshot.data?.docs[index].data()["Topic"],
                            topicDescription: snapshot.data?.docs[index]
                                .data()["Topic-Description"],
                            postedBy:
                            snapshot.data!.docs[index].data()["Post by"],
                            doc: snapshot.data!.docs[index].data()["doc"],
                            userProfile:snapshot.data!.docs[index].data()["Profile_URL"].toString(),
                            alreadyLiked:
                            snapshot.data!.docs[index].data()["Like by"]!=null
                                ?
                            snapshot.data!.docs[index].data()["Like by"].contains(usermodel["Email"])
                            :
                            false,
                          ),
                        ),
                      );




                    },
                  )
                : const SizedBox();
          },
        ),
      ),
      floatingActionButton: Container(
        height: size.height*0.072,
        width: size.height*0.072,
        decoration:  BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.all(Radius.circular( size.height*0.072))
        ),
        child: InkWell(
          onTap: (){
            Navigator.push(context, PageTransition(
              child: const addPost(),
              type: PageTransitionType.bottomToTopJoined,
              duration: const Duration(milliseconds: 400),
              alignment: Alignment.bottomCenter,
              childCurrent: const achievementPage(),
            ),);
          },
            child: Icon(Icons.add,size: size.height*0.04,color: Colors.white70,weight: 5,)),
      ),
    );
  }
}
