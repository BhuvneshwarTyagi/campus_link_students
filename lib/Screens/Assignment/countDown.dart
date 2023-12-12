import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key, required this.deadline, });
  final String deadline;
  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  late DateTime deadline;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deadline = DateTime.parse("${widget.deadline.split("-")[2]}-${widget.deadline.split("-")[1]}-${widget.deadline.split("-")[0]}");
  }
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return CountDownText(
      due: deadline,
      finishedText: "Late",
      showLabel: true,
      secondsTextShort: " S",
      style: GoogleFonts.courgette(
          color: Colors.red,
          fontSize: size.width*0.05,
          fontWeight: FontWeight.w400
      ),

    );
  }
}
