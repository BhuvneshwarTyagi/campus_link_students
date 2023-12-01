import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';

import 'assignment_performance.dart';
import 'attendance_performance.dart';
import 'marks_perfomance.dart';
class Performance extends StatefulWidget{
  @override
  State<Performance> createState() =>_pieChart();

}
class _pieChart extends State<Performance>{
  Map<String, double> BigdataMap = {
    "Attendance": 18.47,
    "Marks": 17.70,
    "Assignment": 4.25,
    "Others": 3.51,

  };

  List<Color> BigColorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
  ];
  Map<String,double> AttendancedataMap={
    "May":55,
    "june":16,
    "july":36
  };
  List<Color> SmallPieChartcolorList=[
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
  ];
  Map<String,double> MarksdataMap={
    "Maths":55,
    "DAA":16,
    "Compiler":36
  };
  Map<String,double> AssignmentdataMap={
    "Maths":55,
    "DAA":16,
    "Compiler":36

  };
  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ]
  ];


  int circleNo=1;
  bool isCircleExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*1,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),

            const Color.fromRGBO(68, 174, 218, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.only(left: size.width*0.05),
                child: Text("Overall Performance",style: GoogleFonts.exo2(fontSize: size.height*0.03,fontWeight: FontWeight.w500),),
              ),
              SizedBox(height:size.height*0.01),
              PieChart(
                dataMap: BigdataMap,
                colorList: BigColorList,
                //gradientList: gradientList,
                chartRadius: size.width/2.5,
                animationDuration: const Duration(seconds: 2),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValuesInPercentage: true,
                ),
                legendOptions: LegendOptions(
                    showLegends:true,
                    legendShape:BoxShape.rectangle,
                    legendTextStyle: GoogleFonts.exo(fontWeight:FontWeight.w600,fontSize: size.height*0.015)
                ),


              ),
          ExpansionPanelList(
            elevation: 0,
            expansionCallback: (int index,bool isExpanded){
              setState(() {
                switch(index){
                  case 0:

                    isExpanded1=!isExpanded1;
                    isExpanded2=false;
                    isExpanded3=false;
                    break;
                  case 1:
                    isExpanded2=!isExpanded2;
                    isExpanded1=false;
                    isExpanded3=false;
                    break;
                  case 2:
                    isExpanded3=!isExpanded3;
                    isExpanded1=false;
                    isExpanded2=false;
                    break;

                }

              });

            },
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor:Colors.transparent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: AutoSizeText("Attendance",style: GoogleFonts.exo(fontSize: size.height*0.03,color: Colors.black,fontWeight: FontWeight.w500),),
                    subtitle: LinearPercentIndicator(
                      width:size.width*0.7,
                      lineHeight: size.height*0.005,
                      percent: 0.9,
                      progressColor: Colors.red,
                    ),
                  );
                },
                body: const AttendancePerformance(),


                isExpanded:isExpanded1,

              ),

              ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor:Colors.transparent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: AutoSizeText("Marks",style: GoogleFonts.exo(fontSize: size.height*0.03,color: Colors.black,fontWeight: FontWeight.w500),),
                    subtitle: LinearPercentIndicator(
                      width:size.width*0.7,
                      lineHeight: size.height*0.005,
                      percent: 0.9,
                      progressColor: Colors.red,
                    ),
                  );
                },
                body:const MarksPerformance(),
                isExpanded:isExpanded2,

              ),
              ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor:Colors.transparent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: AutoSizeText("Assignment",style: GoogleFonts.exo(fontSize: size.height*0.03,color: Colors.black,fontWeight: FontWeight.w500),),
                    subtitle: LinearPercentIndicator(
                      width:size.width*0.7,
                      lineHeight: size.height*0.005,
                      percent: 0.9,
                      progressColor: Colors.red,
                    ),
                  );
                },
                body: const AssignmentPerformance(),

                isExpanded:isExpanded3,

              ),
            ],
          ),




            ],
          ),
        ),
      ),
    );

  }

}
