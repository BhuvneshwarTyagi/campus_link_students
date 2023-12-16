import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Perfomance/pie_chart.dart';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../Constraints.dart';

class MarksPerformance extends StatefulWidget {
  const MarksPerformance({super.key, required this.MarksdataMap,});
  final Map<String,double> MarksdataMap;



  @override
  State<MarksPerformance> createState() => _MarksPerformanceState();
}

class _MarksPerformanceState extends State<MarksPerformance> {

  List<Color> SmallPieChartcolorList=[
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
  ];


  int circleNo=1;
  bool isCircleExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  List<dynamic> subjects = usermodel["Subject"];

  bool data=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  SizedBox(
      width: size.width*0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:  EdgeInsets.only(left: size.width*0.05),
              child: AutoSizeText("Overall sessional performance",
                style: GoogleFonts.tiltNeon(
                    fontSize: size.width*0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          SizedBox(height: size.height*0.01,),
          Card(
            child: Padding(
              padding:  const EdgeInsets.all(8),
              child: AutoSizeText("This chart shows that how much your each subject contributes in your overall Sessional performance",
                style: GoogleFonts.tiltNeon(
                    fontSize: size.width*0.035,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              piechart(dataMap: widget.MarksdataMap,),

              SizedBox(width: size.width*0.05,),
              SizedBox(
                height: size.height*0.15,
                width: size.width*0.5,
                child: GridView.builder(

                  scrollDirection: Axis.vertical,
                  itemCount:usermodel["Subject"].length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 5.0,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: size.height*0.03,
                      child: Row(
                        children: [
                          Container(
                            width: size.width*0.07,
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              color:SmallPieChartcolorList[index],
                            ),
                          ),
                          SizedBox(width: size.width*0.03,),
                          AutoSizeText("${usermodel["Subject"][index]}"),
                        ],
                      ),
                    );
                  },
                ),
              )

            ],
          ),
          SizedBox(height: size.height*0.01,),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:  EdgeInsets.only(left: size.width*0.05),
              child: AutoSizeText("Subject wise sessional performance",
                style: GoogleFonts.tiltNeon(
                    fontSize: size.width*0.04,
                    color: Colors.black
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height*0.1,
                width: size.width*0.7,
                child: GridView.builder(

                  itemCount: widget.MarksdataMap.length,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // number of items in each row
                    mainAxisSpacing: size.width*0.05, // spacing between row
                  ),

                  itemBuilder:(context,index)
                  {
                    return  CircularPercentIndicator(
                      radius: size.height*0.035,
                      lineWidth: 2,
                      percent: widget.MarksdataMap[usermodel["Subject"][index]] ?? 0,

                      backgroundColor: Colors.grey,
                      center:  AutoSizeText("${(widget.MarksdataMap[usermodel["Subject"][index]]!*100).toStringAsFixed(2)}%",
                          style: GoogleFonts.gfsDidot(
                              fontSize: size.height*0.01,
                              fontWeight: FontWeight.w400
                          )),

                      progressColor: Colors.green.shade800,
                      footer: AutoSizeText("${usermodel["Subject"][index]}",
                          style: GoogleFonts.gfsDidot(
                              fontSize: size.height*0.01,
                              fontWeight: FontWeight.w400
                          )),
                    );
                  },
                  scrollDirection: Axis.horizontal,




                ),
              ),
            ],
          )

        ],
      ),
    );
  }




}




