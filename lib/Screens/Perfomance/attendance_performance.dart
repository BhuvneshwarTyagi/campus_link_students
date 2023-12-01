import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Screens/Perfomance/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      height: size.height*0.4,
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
                piechart(dataMap: widget.attendanceDataMap,),
                SizedBox(width: size.width*0.05,),
                SizedBox(
                  height: size.height*0.15,
                  width: size.width*0.5,
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.month.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.month.length>2 ? 2: 1,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 5.0, // number of items in each row
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
            SizedBox(height: size.height*0.02,),
            SizedBox(
              height: size.height*0.2,
              width: size.width*0.9,
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.dataMapList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // number of items in each row
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 4.0, // spacing between row
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
