import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Perfomance/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../Constraints.dart';

class AssignmentPerformance extends StatefulWidget {
  const AssignmentPerformance({super.key});

  @override
  State<AssignmentPerformance> createState() => _AssignmentPerformanceState();
}

class _AssignmentPerformanceState extends State<AssignmentPerformance> {

  List<Color> SmallPieChartcolorList=[
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
  ];
   Map<String,double> AssignmentdataMap={};
   List <dynamic>persentage=[];

  int circleNo=1;
  bool isCircleExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
   List<dynamic> subjects = usermodel["Subject"];

  bool data=false;
  late DocumentSnapshot<Map<String, dynamic>> snapshot1;
  late DocumentSnapshot<Map<String, dynamic>> snapshot2;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    overallAssignmentdata(AssignmentdataMap,persentage);



  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Subject").doc("${usermodel["Branch"]}").snapshots(),
      builder:(context, snapshot) {
        return snapshot.hasData
        ?
        SizedBox(
          height: size.height*0.4,
          width: size.width*0.95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  piechart(dataMap: AssignmentdataMap,),

                  SizedBox(width: size.width*0.05,),
                  SizedBox(
                    height: size.height*0.15,
                    width: size.width*0.5,
                    child: GridView.builder(

                      scrollDirection: Axis.vertical,
                      itemCount:snapshot.data!.data()?["Subject"].length,
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
                              InkWell(
                                onTap: (){

                                  setState(() {
                                   // selectedSubject=usermodel["Subject"][index];
                                    //assignmentdata(selectedSubject);
                                  });
                                },
                                  child: AutoSizeText("${snapshot.data!.data()?["Subject"][index]}")),
                            ],
                          ),
                        );
                      },
                    ),
                  )

                ],
              ),
              SizedBox(height: size.height*0.02,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height*0.1,
                    width: size.width*0.7,
                    child: GridView.builder(

                      itemCount:usermodel["Subject"].length,

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // number of items in each row
                        mainAxisSpacing: size.width*0.05, // spacing between row
                      ),

                      itemBuilder:(context,index)
                    {
                      return  CircularPercentIndicator(
                        radius: size.height*0.035,
                        lineWidth: 2,
                        percent: persentage[index],

                        backgroundColor: Colors.grey,
                        center:  AutoSizeText("${(persentage[index]*100).toStringAsFixed(2)}%",
                            style: GoogleFonts.gfsDidot(
                                fontSize: size.height*0.01,
                                fontWeight: FontWeight.w400
                            )),

                        progressColor: Colors.green.shade800,
                        footer: AutoSizeText("${snapshot.data!.data()?["Subject"][index]}",
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
        )
        :
            const SizedBox()
        ;
      },
    );
  }


// assignmentdata(selectedSubject){
//   FirebaseFirestore
//       .instance
//       .collection("Assignment")
//       .doc("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $selectedSubject",)
//       .get().then((value) {
//        snapshot1=value;
//
//   }).whenComplete(() {
//
//     if(snapshot1.data()!=null) {
//       setState(() {
//         data = true;
//       });
//     }
//   },);
// }
  
}
overallAssignmentdata( Map<String,double> AssignmentDataMap,List persentage){
  for(int i=0;i<usermodel["Subject"].length;i++)
  {
    String subName = usermodel["Subject"][i];
    FirebaseFirestore
        .instance
        .collection("Assignment")
        .doc("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $subName",)
        .get().then((value){
         if(value.data()!=null){

           AssignmentDataMap.addAll({subName:  double.parse("${value.data()?["Total_Submitted_Assignment"][usermodel["Email"]]}"),});

           persentage.add(double.parse("${value.data()?["Total_Submitted_Assignment"][usermodel["Email"]]}")/double.parse("${value.data()?["Total_Assignment"]}") );



         }
    }
    );
  }
}



