import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Screens/Perfomance/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AttendancePerformance extends StatefulWidget {
  const AttendancePerformance({super.key, required this.dataMapList, required this.attendanceDataMap, required this.month});
  final List<Map<String,dynamic>> dataMapList;
  final Map<String,double> attendanceDataMap;
  final List<String> month;
  @override
  State<AttendancePerformance> createState() => _AttendancePerformanceState();
}

class _AttendancePerformanceState extends State<AttendancePerformance> {

  List<Color> smallPieChartColorList=[
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
  ];
  int circleNo=1;
  bool isCircleExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width*0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:  EdgeInsets.only(left: size.width*0.05),
              child: AutoSizeText("Overall attendance performance",
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
              child: AutoSizeText("This chart shows that how much your each month attendance contributes in your overall attendance",
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

              piechart(dataMap: widget.attendanceDataMap,),
              SizedBox(width: size.width*0.05,),
              SizedBox(
                height: size.height*0.15,
                width: size.width*0.5,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.month.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.month.length>2 ? 2: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 5
                    // number of items in each row
                    //mainAxisSpacing: 5, // spacing between row
                  ),
                  itemBuilder:(context,index) {
                    return SizedBox(
                      height: size.height*0.03,
                      child: Row(
                        children: [
                          Container(
                            width: size.width*0.07,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:smallPieChartColorList[index]
                            ),
                          ),
                          SizedBox(width: size.width*0.03,),
                          Text( widget.month[index],style: const TextStyle(color: Colors.black),)
                        ],

                      ),
                    );
                  },




                ),
              ),
            ],
          ),
          SizedBox(height: size.height*0.01,),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:  EdgeInsets.only(left: size.width*0.05),
              child: AutoSizeText("Months wise attendance",
                style: GoogleFonts.tiltNeon(
                    fontSize: size.width*0.04,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.dataMapList.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // spacing between row
            ),
            itemBuilder:(context,index) {

              return  CircularPercentIndicator(
                footer: AutoSizeText( widget.dataMapList[index]["Month"]),
                radius: size.height*0.04,
                lineWidth: 2,
                percent: widget.dataMapList[index]["Percent"],
                backgroundColor: Colors.grey,
                center: AutoSizeText("${double.parse("${widget.dataMapList[index]["Percent"]*100}").toStringAsFixed(2)}%") ,
                progressColor: Colors.red,
              );
            },




          ),
        ],
      ),
    );
  }



}
