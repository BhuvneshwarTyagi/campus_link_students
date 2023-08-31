import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';
import '../Registration/registration.dart';
//TextEditingController _Controller=TextEditingController();

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
          elevation: 0,
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
                          height: size.height * 0.04,
                        ),




                        AutoSizeText(
                          "Profile photo",
                          style: GoogleFonts.exo(
                              fontSize: size.height * 0.023,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: size.height * 0.08,

                            backgroundImage: usermodel["Profile_URL"] != null
                                ? NetworkImage(usermodel["Profile_URL"])
                                : null,
                            // backgroundColor: Colors.teal.shade300,
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
                        height: size.height*0.06,
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(

                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("Name :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["Name"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("Email:",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["Email"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("University :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["University"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("College :",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["College"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("Branch",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["Branch"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("Year ",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["Year"],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText("Subjects ",
                                  style: GoogleFonts.exo(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: AutoSizeText(
                                usermodel["Subject"][0],
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: size.height * 0.0014,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(right: size.height * 0.04),
          width: size.width,
          height: size.height * 0.08,
          decoration: const BoxDecoration(
              color:  Color.fromRGBO(40, 130, 146, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: size.width * 0.2,
                height: size.height * 0.05,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentDetails(),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: AutoSizeText(
                      "Edit",
                      style: GoogleFonts.exo(
                          fontSize: 18, fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(40, 130, 146, 1),),

                    )),
              ),
            ],
          ),
        ));
  }

}
