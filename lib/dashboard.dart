import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class StudentDashBoard extends StatefulWidget {
  const StudentDashBoard({Key? key}) : super(key: key);

  @override
  State<StudentDashBoard> createState() => _StudentDashBoardState();
}


class _StudentDashBoardState extends State<StudentDashBoard> {
  List<String> userdetail=[];
  @override
  void initState() {
    fetchdetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(

        iconTheme: const IconThemeData(color: Colors.white,),
        backgroundColor: Colors.deepPurple,
        title: AutoSizeText("Campus Link",
          style: GoogleFonts.gfsDidot(
            fontWeight: FontWeight.w700,
            fontSize: size.height*0.033,
            color: Colors.white,



          ),

        ),

      ),
      endDrawer: Drawer(

        child: ListView(

          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration:const BoxDecoration(
                gradient: LinearGradient(

                  begin: Alignment.topRight,

                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.black,

                    Colors.blueAccent,
                    Colors.purple,



                  ],

                ),
              ) ,

              accountName:  Text("priyanka"),
              accountEmail: Text("gupta200priyanka@gmail.com"),
              currentAccountPicture: CircleAvatar(
                // backgroundColor: Colors.teal.shade300,
                child: Text(
                  "P",
                  style: GoogleFonts.exo(
                      fontSize: size.height*0.05,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home), title: const Text("Home"),
              onTap: () {

              },
            ),
            ListTile(
              leading: const Icon(Icons.settings), title: const Text("Settings"),
              onTap: () {

              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts), title: const Text("Contact Us"),
              onTap: () {

              },
            ),
            ListTile(
              leading: const Icon(Icons.logout), title: const Text("Sign Out"),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height * 1,
          width: size.width * 1,
          color: Colors.white,
          child: Stack(
            children: [

              Container(
                height: size.height * 0.22,
                width: size.width*1,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [

                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.04,
                        ),
                        CircleAvatar(
                          radius: 45,

                          backgroundColor: Colors.teal,
                          child: Text(
                            "P",
                            style: GoogleFonts.exo(
                                fontSize: size.height*0.05,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText("Welcome",
                                style: GoogleFonts.exo(
                                  fontSize: size.height*0.022,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              AutoSizeText("Priyanka Gupta",
                                style: GoogleFonts.exo(
                                    fontSize: size.height*0.03,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: size.height*0.13),
                child: Container(
                  height: size.height ,
                  width: size.width * 1,
                  color: Colors.transparent,
                  child: Column(

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: size.height * 0.1,
                                      width: size.width * 0.2,
                                      decoration:    BoxDecoration(
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/attendance_icon.png"),
                                          fit: BoxFit.fill,


                                        ),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.black,

                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),

                                        ),

                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          "View Attendance",
                                          style: GoogleFonts.exo(
                                              fontSize: size.height*0.02,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        AutoSizeText(
                                          "Click to See Your Attendance",
                                          style: GoogleFonts.exo(
                                              fontSize: size.height*0.01,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon:
                                        const Icon(Icons.arrow_forward_ios))
                                  ],

                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    decoration:  BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          "assets/images/assignment_icon.png",
                                        ),


                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,

                                      ),

                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "View Assignment",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height*0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      AutoSizeText(
                                        "Click to See Your Assignment",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height*0.01,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon:
                                      const Icon(Icons.arrow_forward_ios))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => const Loginpage(),
                              //     ));
                            },
                            child: Card(
                              elevation: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    decoration:  BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/notes_icon.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,

                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "View Notes",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height*0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      AutoSizeText(
                                        "Click to see notes",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height*0.01,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon:
                                      const Icon(Icons.arrow_forward_ios))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    decoration:  BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/mark_icon.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,

                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "View Mark",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height*0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      AutoSizeText(
                                        "Click to See Your Mark",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height*0.01,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon:
                                      const Icon(Icons.arrow_forward_ios))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.93,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.2,
                                    decoration:BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/performance_icon.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,

                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "View Performance",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height*0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      AutoSizeText(
                                        "Click to See Your Performance",
                                        style: GoogleFonts.exo(
                                            fontSize: size.height*0.01,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon:
                                      const Icon(Icons.arrow_forward_ios))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 fetchdetail() async {

   final ref= await  FirebaseFirestore.instance.collection("Student_record").doc("Email").get();
   setState(() {
     userdetail.add(ref.data()!["Email"]) ;
     userdetail.add(ref.data()!["Name"]);

   });
 }

}
