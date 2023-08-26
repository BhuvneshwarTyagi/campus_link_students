import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({Key? key}) : super(key: key);

  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {
  final TextStyle _st=GoogleFonts.exo(
    color: Colors.white,
    fontSize: 22,

  );
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient:LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.pinkAccent,
            Colors.indigoAccent
          ]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height*0.055,
            ),
            Center(
              child: CircleAvatar(
                radius: size.height*0.1,

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
            ),
            SizedBox(
              height: size.height*0.055,
            ),
            AutoSizeText(
              usermodel["Name"],
              style: _st,
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            AutoSizeText(
              usermodel["Email"],
              style: _st,
            ),
            SizedBox(
              height: size.height*0.05,
            ),
            AutoSizeText(
              "Personal Information",
              style: _st,
            ),
            SizedBox(
              height: size.height*0.05,
            ),
          AutoSizeText(
            "University ",
            style: _st,
          ),
          SizedBox(
            height: size.height*0.012,
          ),
          AutoSizeText(
            usermodel["University"],
            style: _st,
          ),
            Divider(
              height: 5,
              thickness: 2,
              color: Colors.black87,
              endIndent: size.width*0.082,
              indent: size.width*0.082,
            ),
            SizedBox(
              height: size.height*0.03,
            ),
            AutoSizeText(
              "College ",
              style: _st,
            ),
            SizedBox(
              width: size.width*0.06,
            ),
            FittedBox(
              child: AutoSizeText(
                usermodel["College"],
                style: GoogleFonts.exo(
                  color: Colors.white,
                  fontSize: 16,
                ),
                maxLines: 1,
              ),
            ),

            SizedBox(
              height: size.height*0.03,
            ),
            SizedBox(
              width: size.width*0.06,
            ),
            AutoSizeText(
              "Branchh ",
              style: _st,
            ),
            SizedBox(
              width: size.width*0.06,
            ),
            AutoSizeText(
              usermodel["Branch"],
              style: _st,
            ),

            SizedBox(
              height: size.height*0.03,
            ),
            SizedBox(
              width: size.width*0.06,
            ),
            AutoSizeText(
              "Year ",
              style: _st,
            ),
            SizedBox(
              width: size.width*0.06,
            ),
            AutoSizeText(
              usermodel["Year"],
              style: _st,
            ),
            SizedBox(
              height: size.height*0.03,
            ),
            SizedBox(
              width: size.width*0.06,
            ),
            AutoSizeText(
              "Subjects ",
              style: _st,
            ),
            SizedBox(
              width: size.width*0.06,
            ),
            AutoSizeText(
              usermodel["Subject"][0],
              style: _st,
            ),
            ]
        ),
      ),
    );
  }
}
