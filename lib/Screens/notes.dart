import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
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
        )
    );
  }
}
