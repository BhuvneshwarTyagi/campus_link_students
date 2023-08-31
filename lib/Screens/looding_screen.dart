import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class looding_screen extends StatefulWidget {
  const looding_screen({Key? key}) : super(key: key);

  @override
  State<looding_screen> createState() => looding_screenState();
}

class looding_screenState extends State<looding_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height*0.12,
                width: MediaQuery.of(context).size.width*0.4,
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        image: AssetImage("assets/icon/ellipse-dots.gif"),
                        //assets/icon/11645-no-internet-animation.gif
                        fit: BoxFit.fill
                    )
                )
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.05,
            ),
            Text("Loading......",style: GoogleFonts.abel(
                color: Colors.black54,
                fontSize: 45,
                fontWeight: FontWeight.w800
            ),)
          ],
        ),
      ),
    );
  }
}
