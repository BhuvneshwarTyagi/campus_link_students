
import 'dart:math';
import 'package:campus_link_student/Screens/Notes/NotesBacktile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'NotesFront.dart';

class NotesTile extends StatefulWidget {
  const NotesTile({super.key, required this.deadline, required this.selectedSubject, required this.index, required this.fileName, required this.size, required this.stamp, required this.submittedBy, required this.quizCreated, required this.downloadUrl, required this.Score, required this.totalQuestion, required this.videolinks, required this.description, required this.userFieldExist, required this.alternatives});
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
  final List<dynamic> alternatives;
  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> with SingleTickerProviderStateMixin{

  bool _isFlipped = false;

  late AnimationController _controller;
  late Animation<double> _rotation;
  void _toggleCard() {
    setState(() {
      _isFlipped = !_isFlipped;
      if (_isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
  Widget _getcardSide() {
    return _isFlipped ? NotesBackTile(alternatives: widget.alternatives, selectedSubject: widget.selectedSubject ,) : Front(
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
    );
  }
  bool showFront=true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _rotation = Tween(begin: 0.0, end: 3.141592).animate(_controller);
  }
  double _getTextRotation() {
    return _isFlipped ? 3.141592 : 0.0;
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return  Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_rotation.value),
              alignment: Alignment.center,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(_getTextRotation()),
                child: _getcardSide(),
              ),
            );
          },
        ),
        widget.alternatives.isNotEmpty ?
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(onPressed: _toggleCard, icon: const Icon(Icons.flip,color: Colors.black,)),
        )
            :
        const SizedBox(),
      ],
    );
  }

}