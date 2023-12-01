import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Screens/Perfomance/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AttendancePerformance extends StatefulWidget {
  const AttendancePerformance({super.key, required this.dataMapList});
  final List<Map<String,dynamic>> dataMapList;
  @override
  State<AttendancePerformance> createState() => _AttendancePerformanceState();
}

class _AttendancePerformanceState extends State<AttendancePerformance> {
  Map<String,double> attendanceDataMap={
    "May":55,
    "june":16,
    "july":36
  };
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
    return
    SizedBox(
      height: size.height*0.3,
      width: size.width*0.95,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Students").doc(usermodel["Email"]).collection("Attendance").snapshots(),
        builder: (context, snapshot) {

        return snapshot.hasData
            ?
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // PieChart(
                //   dataMap: AttendancedataMap,
                //   colorList: SmallPieChartcolorList,
                //   chartRadius: size.width/4,
                //   chartValuesOptions: const ChartValuesOptions(showChartValueBackground: false,showChartValuesInPercentage: true,),
                //   legendOptions: const LegendOptions(showLegends: false,legendShape: BoxShape.rectangle,),
                //
                // ),
                piechart(dataMap: attendanceDataMap,),
                SizedBox(width: size.width*0.05,),
                Padding(
                  padding:EdgeInsets.only(top:size.height*0.01),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height*0.034,
                        child: Row(
                          children: [
                            Container(
                              height:size.height*0.02,
                              width: size.width*0.05,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color:smallPieChartColorList[0]
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  circleNo++;
                                },
                                child: const Text("Maths",style: TextStyle(color: Colors.black),))
                          ],

                        ),
                      ),
                      SizedBox(
                        height: size.height*0.034,
                        child: Row(
                          children: [
                            Container(
                              height:size.height*0.02,
                              width: size.width*0.05,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color:smallPieChartColorList[1]
                              ),
                            ),
                            TextButton(onPressed: () {
                              isCircleExpanded=!isCircleExpanded;

                            }, child: const Text("Maths",style: TextStyle(color: Colors.black),))
                          ],

                        ),
                      ),
                      SizedBox(
                        height: size.height*0.034,
                        child: Row(
                          children: [
                            Container(
                              height:size.height*0.02,
                              width: size.width*0.05,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color:smallPieChartColorList[2]
                              ),
                            ),
                            TextButton(onPressed: () {
                              isCircleExpanded=!isCircleExpanded;

                            }, child: const Text("Maths",style: TextStyle(color: Colors.black),))
                          ],

                        ),
                      ),
                    ],

                  ),
                ),
              ],
            ),
            SizedBox(height: size.height*0.02,),
            SizedBox(
              height: size.height*0.2,
              width: size.width*0.9,
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.dataMapList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // number of items in each row
                  mainAxisSpacing: size.width*0.05, // spacing between row
                ),
                itemBuilder:(context,index) {

                  return  CircularPercentIndicator(
                    footer: AutoSizeText( widget.dataMapList[index]["Month"]),
                    radius: size.height*0.035,
                    lineWidth: 2,
                    percent: widget.dataMapList[index]["Percent"],
                    backgroundColor: Colors.grey,
                    center: AutoSizeText("${double.parse("${widget.dataMapList[index]["Percent"]*100}").toStringAsPrecision(2)}%") ,
                    progressColor: Colors.red,
                );
              },




              ),
            ),
          ],
        )
            :
        const SizedBox();
      },
      ),
    );
  }



}
