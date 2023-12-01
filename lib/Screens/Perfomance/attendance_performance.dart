import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Screens/Perfomance/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

class AttendancePerformance extends StatefulWidget {
  const AttendancePerformance({super.key});

  @override
  State<AttendancePerformance> createState() => _AttendancePerformanceState();
}

class _AttendancePerformanceState extends State<AttendancePerformance> {
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
  int circleNo=1;
  bool isCircleExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  List<Map<String,dynamic>> dataMapList=[];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Students").doc(usermodel["Email"]).collection("Attendance").snapshots(),
      builder: (context, snapshot) {

      return Column(
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
              piechart(dataMap: AttendancedataMap,),
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
                                color:SmallPieChartcolorList[0]
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
                                color:SmallPieChartcolorList[1]
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
                                color:SmallPieChartcolorList[2]
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
            child: GridView.builder(itemBuilder:(context,index)
            {
              return  CircularPercentIndicator(
                footer: AutoSizeText("Month"),
                radius: size.height*0.035,
                lineWidth: 2,
                percent: 0.65,
                backgroundColor: Colors.grey,
                center:AutoSizeText("50%") ,
                progressColor: Colors.red,
              );
            },
              scrollDirection: Axis.vertical,
              itemCount:10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // number of items in each row
                mainAxisSpacing: size.width*0.05, // spacing between row
              ),



            ),
          ),
        ],
      );
    },);
  }

  //type function ka
  // generatedata(){
  //   DateTime sessionStart=usermodel["SessionStartDate"];
  //   DateTime currentDate=DateTime.now();
  //   for(int year=sessionStart.year;year<=currentDate.year;year++){
  //     for()
  //   }
  //  final snapshot=FirebaseFirestore.instance.collection("Students").doc(usermodel["Email"]).collection("Attendance").get();
  //
  // }

}
