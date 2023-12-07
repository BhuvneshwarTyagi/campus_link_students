import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Perfomance/pie_chart.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

class MarksPerformance extends StatefulWidget {
  const MarksPerformance({super.key});

  @override
  State<MarksPerformance> createState() => _MarksPerformanceState();
}

class _MarksPerformanceState extends State<MarksPerformance> {

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
  int circleNo=1;
  bool isCircleExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // PieChart(
            //   dataMap: MarksdataMap,
            //   colorList: SmallPieChartcolorList,
            //   chartRadius: size.width/4,
            //   chartValuesOptions: const ChartValuesOptions(showChartValueBackground: false,showChartValuesInPercentage: true,),
            //   legendOptions: const LegendOptions(showLegends: false,legendShape: BoxShape.rectangle,),
            //
            // ),
            piechart(dataMap: MarksdataMap,),
            SizedBox(width: size.width*0.05,),
            Padding(
              padding:  EdgeInsets.only(top:size.height*0.01),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height*0.07,
              width: size.width*0.7,
              child: GridView.builder(itemBuilder:(context,index)
              {
                return  CircularPercentIndicator(radius: size.height*0.035,
                  lineWidth: 2,
                  percent: 0.65,
                  backgroundColor: Colors.grey,
                  center: const Text("May"),
                  progressColor: Colors.red,
                );
              },
                scrollDirection: Axis.horizontal,
                itemCount:3,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // number of items in each row
                  mainAxisSpacing: size.width*0.05, // spacing between row
                ),



              ),
            ),
          ],
        ),
      ],
    );
  }
}
