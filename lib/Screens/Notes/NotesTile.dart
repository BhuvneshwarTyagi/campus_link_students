
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'NotesFront.dart';

class NotesTile extends StatefulWidget {
  const NotesTile({super.key, required this.deadline, required this.selectedSubject, required this.index, required this.fileName, required this.size, required this.stamp, required this.submittedBy, required this.quizCreated, required this.downloadUrl, required this.Score, required this.totalQuestion, required this.videolinks, required this.description, required this.userFieldExist});
  final Timestamp deadline;
  final String selectedSubject ;
  final int index;
  final String fileName;
  final String description;
  final String size;
  final Timestamp stamp;
  final List<dynamic> submittedBy;
  final bool quizCreated;
  final String downloadUrl;
  final String Score;
  final String totalQuestion;
  final List<dynamic> videolinks;
  final bool userFieldExist;
  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {

  bool showFront=true;
  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(
      switchInCurve: Curves.linear,
    duration: const Duration(milliseconds: 500),
      transitionBuilder: __transitionBuilder,
      child: showFront
          ?
      Front(
        index: widget.index,
        Score: widget.Score,
        downloadUrl: widget.downloadUrl,
        quizCreated: widget.quizCreated,
        stamp: widget.stamp,
        size: widget.size,
        fileName: widget.fileName,
        deadline: widget.deadline,
        description: widget.description,
        selectedSubject: widget.selectedSubject,
        submittedBy: widget.submittedBy,
        totalQuestion: widget.totalQuestion,
        userFieldExist: widget.userFieldExist,
        videolinks: widget.videolinks,
      )
          :
      IconButton(
        key: const ValueKey(false),
          onPressed: (){
            setState(() {
              showFront = !showFront;
            });
          },
          icon: const Icon(Icons.flip_rounded,color: Colors.black,)),
    );
  }

}
Widget __transitionBuilder(Widget widget, Animation<double> animation) {
  final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
  return AnimatedBuilder(
    animation: rotateAnim,
    child: widget,
    builder: (context, widget) {
      return Transform(
        transform: Matrix4.rotationY(0),
        alignment: Alignment.center,
        child: widget,
      );
    },
  );
}