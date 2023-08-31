import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Screens/assignment.dart';
import '../Screens/attendance.dart';
import '../Screens/chat_list.dart';
import '../Screens/marks.dart';
import '../Screens/notes.dart';
import '../Screens/performance.dart';
import '../Screens/profile_page.dart';

class navigation extends StatefulWidget {
  const navigation({Key? key}) : super(key: key);

  @override
  State<navigation> createState() => _navigationState();
}

class _navigationState extends State<navigation> {
  List<Widget>All_Pages=[const Assignment(),const Notes(),const Attendance(),const Marks(),performance(child: null,)];
  List<String>cuu_title=["Assingments","Notes","Attendeance","Marks","Performance"];
  var curr_index=3;


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
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
      child: usermodel.isNotEmpty?
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const chatsystem(),
                    type: PageTransitionType.rightToLeftJoined,
                    duration: const Duration(milliseconds: 350),
                    childCurrent: const navigation(),
                  ),
                );
              },
              icon: const Icon(Icons.send_outlined),
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.black38,
          titleTextStyle: GoogleFonts.gfsDidot(
              color: Colors.black,
              //const Color.fromRGBO(150, 150, 150, 1),
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.height * 0.04),
          title:Text(cuu_title[curr_index],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.black,
                        Colors.blueAccent,
                        Colors.purple,
                      ],
                    ),
                  ),
                  accountName: AutoSizeText(
                    usermodel["Name"],
                    style: GoogleFonts.exo(
                        fontSize: size.height * 0.022,
                        fontWeight: FontWeight.w600),
                  ),
                  accountEmail: AutoSizeText(
                    usermodel["Email"],
                    style: GoogleFonts.exo(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w600),
                  ),
                  currentAccountPicture:Stack(
                    children: [
                      CircleAvatar(
                        radius: size.height*0.2,

                        backgroundImage:usermodel["Profile_URL"]!=null?

                        NetworkImage(usermodel["Profile_URL"])
                            :
                        null,
                        // backgroundColor: Colors.teal.shade300,
                        child: usermodel["Profile_URL"]==null?
                        AutoSizeText(
                          usermodel["Name"].toString().substring(0, 1),
                          style: GoogleFonts.exo(
                              fontSize: size.height * 0.05,
                              fontWeight: FontWeight.w600),
                        )
                            :
                        null,
                      ),
                      Positioned(
                        bottom: -5,
                        left: 35,
                        child: IconButton(
                          icon: Icon(Icons.camera_enhance,size:size.height*0.03 ,color: Colors.black,),
                          onPressed: () async {

                            /*ImagePicker imagePicker=ImagePicker();
                            print(imagePicker);
                            XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                            print(file?.path);

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
                              });
                              setState(() {
                                fect_name_email();
                              });
                            });*/
                          },
                        ),
                      )
                    ],
                  )
              ),
              ListTile(
                leading: const Icon(Icons.home,color: Colors.black,),
                title: const Text("Home"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.account_box_outlined,color: Colors.black,),
                title: const Text("My Profile"),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const Profile_page(),
                      type: PageTransitionType.rightToLeftJoined,
                      duration: const Duration(milliseconds: 350),
                      childCurrent: const navigation(),
                    ),
                  );

                },
              ),
              ListTile(
                leading: const Icon(Icons.settings,color: Colors.black),
                title: const Text("Settings"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.contacts,color: Colors.black),
                title: const Text("Contact Us"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout,color: Colors.black),
                title: const Text("Logout"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color:Colors.black38,
          animationCurve: Curves.easeInOut,
          items:  <Widget>[
            Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage("assets/images/assignment_icon.png")
                  ),
                )),
            Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage("assets/images/notes_icon.png"),
                    fit: BoxFit.contain,
                  ),
                )),
            Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage("assets/images/attendance_icon.png"),
                    fit: BoxFit.contain,
                  ),
                )),
            Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage("assets/images/mark_icon.png"),
                    fit: BoxFit.contain,
                  ),
                )),
            Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage("assets/images/performance_icon.png"),
                    fit: BoxFit.contain,
                  ),
                )),
          ],
          onTap: (index) {
            //Handle button tap
            setState(() {
              curr_index=index;
            });
            print(curr_index);
          },
        ),
        body: All_Pages[curr_index],

      )
          :
          Center(child: const CircularProgressIndicator())
      );
  }

}
