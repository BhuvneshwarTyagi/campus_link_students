

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Profile_Page/section.dart';
import 'package:campus_link_student/Screens/Profile_Page/subject_edit.dart';
import 'package:campus_link_student/Screens/Profile_Page/year.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../Constraints.dart';

import 'branch.dart';
import 'college.dart';
import 'course_edit.dart';
import 'university_edit.dart';

bool profile_update=false;


class Profile_page extends StatefulWidget {
  const Profile_page({super.key});


  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 15,
          iconTheme: const IconThemeData(
            color: Colors.white,

          ),
          backgroundColor: const Color.fromRGBO(40, 130, 146, 1),
          title: AutoSizeText(
            "My Profile",
            style: GoogleFonts.gfsDidot(
              fontWeight: FontWeight.w700,
              fontSize: size.height * 0.03,
              color: Colors.white,
            ),
          ),
          // actions: [
          //   Container(
          //
          //         height: size.height*0.01,
          //       width: size.height*0.09,
          //       decoration: const BoxDecoration(
          //           color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(30))
          //       ),
          //       child: IconButton(onPressed: (){},
          //           icon:const Icon(
          //             Icons.edit,
          //           ),
          //       ),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(


            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(120, 149, 150, 1),
                    Color.fromRGBO(120, 149, 150, 1),

                         Colors.white,
                    Color.fromRGBO(120, 149, 150, 1),
                    Color.fromRGBO(120, 149, 150, 1),




                  ]

              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Stack(
                           children: [
                             Center(
                               child: CircleAvatar(
                                 radius: size.height * 0.06,

                                 backgroundImage: usermodel["Profile_URL"] != null
                                     ? NetworkImage(usermodel["Profile_URL"])
                                     : null,
                                 backgroundColor: Colors.grey,
                                 child: usermodel["Profile_URL"] == null
                                     ? AutoSizeText(
                                   usermodel["Name"].toString().substring(0, 1),
                                   style: GoogleFonts.exo(
                                       fontSize: size.height * 0.05,
                                       fontWeight: FontWeight.w600),
                                 )
                                     : null,
                               ),
                             ),
                             Positioned(
                                 bottom: -5,
                                 left: 205,
                                 child: IconButton(
                                     icon: Icon(Icons.camera_alt_rounded,size:size.height*0.03 ,color: Colors.white,),
                                     onPressed: () async {

                                       ImagePicker imagePicker=ImagePicker();
                                       print(imagePicker);
                                       XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                                       print(file?.path);

                                       setState(() {
                                         profile_update=true;
                                       });
                                       // Create reference of Firebase Storage

                                       Reference reference=FirebaseStorage.instance.ref();

                                       // Create Directory into Firebase Storage

                                       Reference image_directory=reference.child("User_profile");


                                       Reference image_folder=image_directory.child("${usermodel["Email"]}");

                                       await image_folder.putFile(File(file!.path)).whenComplete(() async {


                                         String download_url=await image_folder.getDownloadURL();
                                         print("uploaded");
                                         print(download_url);
                                         await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).update({
                                           "Profile_URL":download_url,
                                         }).whenComplete(() async {
                                           await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){

                                             setState(() {
                                               usermodel=value.data()!;
                                             });
                                           }).whenComplete(() {
                                             setState(() {
                                               profile_update=false;
                                             });
                                           });

                                         });
                                         setState(() {
                                           profile_update=false;
                                         });
                                       },
                                       );}))
                           ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:size.height * 0.01,bottom: size.height*0.005),
                          child: AutoSizeText(
                            usermodel["Name"],
                            style: GoogleFonts.exo(
                                fontSize: size.height * 0.023,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.height * 0.001),
                          child: AutoSizeText(
                            usermodel["Email"],
                            style: GoogleFonts.exo(
                                fontSize: size.height * 0.023,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                      height: size.height * 0.022),
                      ]),
                ),
                Container(
                  padding: EdgeInsets.all(size.height * 0.01),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // TextField(
                      //     decoration: const InputDecoration(border: UnderlineInputBorder()),
                      //     autofocus: true,
                      //     keyboardType: TextInputType.multiline,
                      //     maxLines: null,
                      //     controller: _Controller
                      // ),
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:size.height * 0.01,left:size.height * 0.02 ),
                              child: AutoSizeText("University :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(

                                width: size.width,
                                height: size.height*0.06,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(40, 130, 146, 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: Colors.black,),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.inner,
                                        color: Colors.black54,
                                        offset: Offset(1, 1)
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [
                                           Row(

                                             children: [ const Icon(Icons.account_balance,color: Colors.black),
                                             SizedBox(width: size.width*0.02,),
                                             AutoSizeText(
                                               usermodel["University"],
                                               style: GoogleFonts.exo(

                                                   fontSize: size.height * 0.02,
                                                   fontWeight: FontWeight.w700,
                                               color: Colors.black,
                                               ),
                                             ),],),
                                      IconButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditUniversityFormPage(),));
                                      },
                                          icon: const Icon(Icons.edit,color: Colors.black,
                                          ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Divider(
                            //   color: Colors.black,
                            //   thickness: size.height * 0.0014,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:size.height * 0.01,left:size.height * 0.02 ),
                              child: AutoSizeText("College :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.06,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(40, 130, 146, 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: Colors.black,),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.inner,
                                        color: Colors.black54,
                                        offset: Offset(1, 1)
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [ const Icon(Icons.maps_home_work),
                                          SizedBox(width: size.width*0.02,),
                                          AutoSizeText(
                                            usermodel["College"],
                                            style: GoogleFonts.exo(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),],),
                                      IconButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditCollegeFormPage(),));
                                      }, icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.all(size.height * 0.01),
                            //   child: AutoSizeText(
                            //     usermodel["College"],
                            //     style: GoogleFonts.exo(
                            //         fontSize: size.height * 0.023,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                            // Divider(
                            //   color: Colors.black,
                            //   thickness: size.height * 0.0014,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:size.height * 0.01,left:size.height * 0.02 ),
                              child: AutoSizeText("Course",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),

                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.06,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(40, 130, 146, 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: Colors.black,),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.inner,
                                        color: Colors.black54,
                                        offset: Offset(1, 1)
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [ const Icon(CupertinoIcons.book),
                                          SizedBox(width: size.width*0.02,),
                                          AutoSizeText(
                                            usermodel["Course"],
                                            style: GoogleFonts.exo(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),],),
                                      IconButton(
                                          onPressed: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const EditCourse(),));

                                          }, icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.all(size.height * 0.01),
                            //   child: AutoSizeText(
                            //     usermodel["Branch"],
                            //     style: GoogleFonts.exo(
                            //         fontSize: size.height * 0.023,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                            // Divider(
                            //   color: Colors.black,
                            //   thickness: size.height * 0.0014,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:size.height * 0.01,left:size.height * 0.02 ),
                              child: AutoSizeText("Branch",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),

                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.06,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(40, 130, 146, 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: Colors.black,),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.inner,
                                        color: Colors.black54,
                                        offset: Offset(1, 1)
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [ const Icon(Icons.account_tree_outlined),
                                          SizedBox(width: size.width*0.02,),
                                          AutoSizeText(
                                            usermodel["Branch"],
                                            style: GoogleFonts.exo(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),],),
                                      IconButton(
                                          onPressed: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const EditBranchFormPage(),));

                                      }, icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.all(size.height * 0.01),
                            //   child: AutoSizeText(
                            //     usermodel["Branch"],
                            //     style: GoogleFonts.exo(
                            //         fontSize: size.height * 0.023,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                            // Divider(
                            //   color: Colors.black,
                            //   thickness: size.height * 0.0014,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:size.height * 0.01,left:size.height * 0.02 ),
                              child: AutoSizeText("Year",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),

                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.06,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(40, 130, 146, 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: Colors.black,),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.inner,
                                        color: Colors.black54,
                                        offset: Offset(1, 1)
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [ const Icon(Icons.date_range),
                                          SizedBox(width: size.width*0.02,),
                                          AutoSizeText(
                                            usermodel["Year"],
                                            style: GoogleFonts.exo(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),],),
                                      IconButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  const EditYearFormPage(),));
                                      }, icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.all(size.height * 0.01),
                            //   child: AutoSizeText(
                            //     usermodel["Branch"],
                            //     style: GoogleFonts.exo(
                            //         fontSize: size.height * 0.023,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                            // Divider(
                            //   color: Colors.black,
                            //   thickness: size.height * 0.0014,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:size.height * 0.01,left:size.height * 0.02 ),
                              child: AutoSizeText("Section",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),

                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Container(
                                width: size.width,
                                height: size.height*0.06,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(40, 130, 146, 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: Colors.black,),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.inner,
                                        color: Colors.black54,
                                        offset: Offset(1, 1)
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [  const Icon(CupertinoIcons.layers_fill),
                                          SizedBox(width: size.width*0.02,),
                                          AutoSizeText(
                                            usermodel["Section"],
                                            style: GoogleFonts.exo(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),],),
                                      IconButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  const EditSectionFormPage(),));
                                      }, icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.all(size.height * 0.01),
                            //   child: AutoSizeText(
                            //     usermodel["Branch"],
                            //     style: GoogleFonts.exo(
                            //         fontSize: size.height * 0.023,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                            // Divider(
                            //   color: Colors.black,
                            //   thickness: size.height * 0.0014,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height*0.08*usermodel["Subject"].length +size.height*0.05,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:size.height * 0.01,left:size.height * 0.02 ),
                              child: AutoSizeText("Subjects ",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                         SizedBox(
                           height: size.height*0.08*usermodel["Subject"].length,
                             child: GridView.builder(
                               physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                               itemCount:  usermodel["Subject"].length,
                               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, index) {
                               return  Padding(
                                 padding: EdgeInsets.only(top:size.height * 0.015,bottom: size.height*0.05,left:size.height * 0.015,right: size.height * 0.01 ),
                                 child: Container(
                                   margin: EdgeInsets.only(bottom: size.height*0.1),
                                   width: size.width*0.4,
                                   height: size.height*0.06,
                                   decoration: BoxDecoration(
                                     color: Color.fromRGBO(40, 130, 146, 1),
                                     borderRadius: const BorderRadius.all(Radius.circular(30)),
                                     border: Border.all(color: Colors.black,),
                                     boxShadow: const [
                                       BoxShadow(
                                           blurRadius: 10,
                                           blurStyle: BlurStyle.inner,
                                           color: Colors.black54,
                                           offset: Offset(1, 1)
                                       )
                                     ],
                                   ),
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Row(

                                           children: [ const Icon(Icons.subject),
                                             SizedBox(width: size.width*0.02,),
                                             AutoSizeText(
                                               usermodel["Subject"][index],
                                               style: GoogleFonts.exo(
                                                   fontSize: size.height * 0.02,
                                                   fontWeight: FontWeight.w700),
                                             ),],),
                                         IconButton(onPressed: (){
                                           Navigator.push(context, MaterialPageRoute(builder: (context) => const EditSubjectFormPage(),));
                                         }, icon: const Icon(Icons.edit))
                                       ],
                                     ),
                                   ),
                                 ),
                               );
                             },),
                           ),

                            // Padding(
                            //   padding: EdgeInsets.all(size.height * 0.01),
                            //   child: AutoSizeText(
                            //     usermodel["Branch"],
                            //     style: GoogleFonts.exo(
                            //         fontSize: size.height * 0.023,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                            // Divider(
                            //   color: Colors.black,
                            //   thickness: size.height * 0.0014,
                            // ),

                          ],
                        ),
                      ),
                      SizedBox(height: size.height*0.05,)

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        // bottomNavigationBar: Container(
        //   padding: EdgeInsets.only(right: size.height * 0.04),
        //   width: size.width,
        //   height: size.height * 0.08,
        //   decoration: const BoxDecoration(
        //       color:  Color.fromRGBO(40, 130, 146, 1),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       SizedBox(
        //         width: size.width * 0.2,
        //         height: size.height * 0.05,
        //         child: ElevatedButton(
        //             onPressed: () {
        //               Navigator.pushReplacement(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => const StudentDetails(),
        //                   ));
        //             },
        //             style: ElevatedButton.styleFrom(
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(15.0),
        //               ),
        //               backgroundColor: Colors.white,
        //             ),
        //             child: AutoSizeText(
        //               "Edit",
        //               style: GoogleFonts.exo(
        //                   fontSize: 18, fontWeight: FontWeight.w600,
        //               color: const Color.fromRGBO(40, 130, 146, 1),),
        //
        //             )),
        //       ),
        //     ],
        //   ),
        // ),

    );
  }

}
