import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Perfomance/quiz_performance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../Constraints.dart';
import '../../Database/database.dart';
import 'assignment_performance.dart';
import 'attendance_performance.dart';
import 'marks_perfomance.dart';




class Performance extends StatefulWidget{
  const Performance({super.key});

  @override
  State<Performance> createState() =>_pieChart();

}
class _pieChart extends State<Performance>{
  Map<String,double> AssignmentdataMap={};
  List <dynamic> percentage=[];
  Map<String,double> quizDataMap={};
  double overallAttendancePercent=0;

  List<String> monthListForAttendance=[];

  Map<String,double> attendanceDataMapforOverAllPerformance={};
  List<Map<String,dynamic>> dataMapList=[];



  List<Color> BigColorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
  ];
  bool dataLoaded=false;
  List<Color> SmallPieChartcolorList=[
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
  ];
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
  bool isExpanded4 = false;
  double overallpercent=0.0;
  double quizPercent =0;

  Map<String, double> BigdataMap = {};

  double sessionalOverallperformance =0;
  Map<String,double> sessionalSubjectwiseperformance ={};
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    generateattendancedata();
    overallAssignmentdata();
  }
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
      child: dataLoaded ?  Scaffold(
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
                        isExpanded4=false;
                        break;
                      case 1:
                        isExpanded2=!isExpanded2;
                        isExpanded1=false;
                        isExpanded3=false;
                        isExpanded4=false;
                        break;
                      case 2:
                        isExpanded3=!isExpanded3;
                        isExpanded1=false;
                        isExpanded2=false;
                        isExpanded4=false;
                        break;
                      case 3:
                        isExpanded4=!isExpanded4;
                        isExpanded1=false;
                        isExpanded2=false;
                        isExpanded3=false;
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
                          width:size.width*0.75,
                          lineHeight: size.height*0.005,
                          percent: overallAttendancePercent,
                          animation: true,
                          animationDuration: 300,
                          progressColor: overallAttendancePercent< 0.50 ? Colors.red : overallAttendancePercent < 0.70 ?  Colors.deepOrange : Colors.green,
                        ),
                      );
                    },
                    body: dataLoaded
                        ?
                    AttendancePerformance(dataMapList: dataMapList, attendanceDataMap: attendanceDataMapforOverAllPerformance,month: monthListForAttendance,)
                        :
                    const SizedBox(),


                    isExpanded:isExpanded1,

                  ),

                  ExpansionPanel(
                    canTapOnHeader: true,
                    backgroundColor:Colors.transparent,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: AutoSizeText("Sessional Performance",style: GoogleFonts.exo(fontSize: size.height*0.03,color: Colors.black,fontWeight: FontWeight.w500),),
                        subtitle: LinearPercentIndicator(
                          width: size.width*0.7,
                          lineHeight: size.height*0.005,
                          percent: sessionalOverallperformance,
                          progressColor: Colors.red,
                        ),
                      );
                    },
                    body: MarksPerformance(
                       MarksdataMap: sessionalSubjectwiseperformance,
                    ),
                    isExpanded:isExpanded2,

                  ),

                  ExpansionPanel(

                    canTapOnHeader: true,
                    backgroundColor:Colors.transparent,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: AutoSizeText("Assignment Performance",style: GoogleFonts.exo(fontSize: size.height*0.03,color: Colors.black,fontWeight: FontWeight.w500),),
                        subtitle: LinearPercentIndicator(
                          width:size.width*0.7,
                          lineHeight: size.height*0.005,
                          percent: overallpercent,
                          progressColor: overallpercent<60 ? Colors.red : overallpercent >=80 ? Colors.deepOrange : Colors.green,
                        )

                        ,
                      )


                      ;
                    },
                    body:  AssignmentPerformance(
                      AssignmentdataMap: AssignmentdataMap,
                    ),

                    isExpanded:isExpanded3,

                  ),
                  ExpansionPanel(

                    canTapOnHeader: true,
                    backgroundColor:Colors.transparent,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: AutoSizeText("Quiz Performance",style: GoogleFonts.exo(fontSize: size.height*0.03,color: Colors.black,fontWeight: FontWeight.w500),),
                        subtitle: LinearPercentIndicator(
                          width:size.width*0.7,
                          lineHeight: size.height*0.005,
                          percent: quizPercent,
                          progressColor: overallpercent<60 ? Colors.red : overallpercent >=80 ? Colors.deepOrange : Colors.green,
                        )

                        ,
                      )


                      ;
                    },
                    body:  QuizPerformance(
                      quizdataMap: quizDataMap,
                    ),

                    isExpanded:isExpanded4,

                  )

                ],
              ),




            ],
          ),
        ),
      ) : const SizedBox(),
    );

  }
  generateattendancedata() async {
    DateTime sessionStart=usermodel["SessionStartDate"].toDate();
    DateTime currentDate=DateTime.now();
    int overallLecture=0;
    int overallAttendance=0;
    for(int year=sessionStart.year ; year<=currentDate.year ; year++){
      int startMonth=0;
      int endMonth=0;

      if(year==sessionStart.year){
        startMonth=sessionStart.month;
      }
      else{
        startMonth=1;
      }

      if(year < currentDate.year){
        endMonth= 12;
      }
      else{
        endMonth= currentDate.month;
      }

      for(int month=startMonth ; month <= endMonth ;month++){
        int days = database().getDaysInMonth(year, month);
        String monthName= "";
        int totalLecture =0;
        int attendance =0;

        switch (month){
          case 1:
            monthName="Jan";
            break;
          case 2:
            monthName="Feb";
            break;
          case 3:
            monthName="Mar";
            break;
          case 4:
            monthName="Apr";
            break;
          case 5:
            monthName="May";
            break;
          case 6:
            monthName="June";
            break;
          case 7:
            monthName="July";
            break;
          case 8:
            monthName="Aug";
            break;
          case 9:
            monthName="Sep";
            break;
          case 10:
            monthName="Oct";
            break;
          case 11:
            monthName="Nov";
            break;
          case 12:
            monthName="Dec";
            break;
        }
        monthListForAttendance.add(monthName);
        for(int i=0;i<usermodel["Subject"].length;i++){
          String subName = usermodel["Subject"][i];
          await FirebaseFirestore.instance.collection("Students").doc(usermodel["Email"]).collection("Attendance").doc("$subName-$month").get().then((value){
            for(int day=1; day<=days ;day++){
              if(value.data()?["$day"] != null){
                for(int lecture=0; lecture < value.data()?["$day"].length ;lecture++){
                  if(value.data()?["$day"][lecture]["Status"] == "Present"){
                    attendance++;
                    overallAttendance++;
                  }
                  totalLecture++;
                  overallLecture++;
                }
              }
            }
          });

        }
        dataMapList.add({"Month" : monthName, "Percent" : attendance/(totalLecture ==0 ?1 : totalLecture)});
        attendanceDataMapforOverAllPerformance[monthName]=attendance/(totalLecture ==0 ? 1 : totalLecture);
      }

    }
    print("setting data loaded to ture");

    overallAttendancePercent=overallAttendance/overallLecture;
    await overallAssignmentdata();

  }

  quizData() async {
    int total=0;
    int score=0;
    for(int i=0;i<usermodel["Subject"].length;i++)
    {
      int subtotal=0;
      int subobtain=0;
      String subName = usermodel["Subject"][i];
      await  FirebaseFirestore
          .instance.collection("Notes")
          .doc("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $subName")
          .get().then((value){
        if(value.data()!=null){
            for(int notes=1;notes<= value.data()?["Total_Notes"];notes++){
              if(value.data()?["Notes-$notes"]["Quiz_Created"] && value.data()?["Notes-$notes"]["Submitted by"] != null && value.data()?["Notes-$notes"]["Submitted by"].contains("${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}")){
                subtotal +=  int.parse("${value.data()?["Notes-$notes"]["Total_Question"]}");
                subobtain += int.parse("${value.data()?["Notes-$notes"]["Response"]["${usermodel["Email"].toString().split("@")[0]}-${usermodel["Name"]}-${usermodel["Rollnumber"]}"]["Score"]}");


              }
            }

          quizDataMap[subName] = subobtain/subtotal;
        }
        else{
          quizDataMap[subName] = 0;
        }

      }
      );
      total+=subtotal;
      score+=subobtain;
    }
    setState(() {
      quizPercent=score/(total==0 ? 1 : total);
      dataLoaded=true;
      BigdataMap={

        "Attendance": overallAttendancePercent,
        "Sessional": sessionalOverallperformance,
        "Assignment": overallpercent,
        "Quiz": quizPercent,
      };
    });
  }

  overallAssignmentdata() async {

    int total=0;
    int submit=0;
    for(int i=0;i<usermodel["Subject"].length;i++)
    {
      int subjectsubmit=0;
      int  subjecttotal=0;
      String subName = usermodel["Subject"][i];
    await  FirebaseFirestore
          .instance.collection("Assignment")
        .doc("${usermodel["University"].toString().split(" ")[0]} ${usermodel["College"].toString().split(" ")[0]} ${usermodel["Course"].toString().split(" ")[0]} ${usermodel["Branch"].toString().split(" ")[0]} ${usermodel["Year"].toString().split(" ")[0]} ${usermodel["Section"].toString().split(" ")[0]} $subName")
          .get().then((value){
      if(value.data()!=null){
        total = total + int.parse("${value.data()?["Total_Assignment"] != null ? value.data()!["Total_Assignment"] : 1}");
        subjecttotal = int.parse("${value.data()?["Total_Assignment"] != null ? value.data()!["Total_Assignment"] : 1}");
       for(int j=1;j<= value.data()?["Total_Assignment"];j++){
         if(value.data()?["Assignment-$j"]["Submitted-by"] != null && value.data()?["Assignment-$j"]["Submitted-by"].contains(usermodel["Email"])){

             print(value.data()!["Assignment-$j"]["submitted-Assignment"]);
             submit  = submit + (value.data()?["Assignment-$j"]["submitted-Assignment"][usermodel["Email"].toString().split("@")[0]]["Status"] == "Accepted" ? 1 :0);
           subjectsubmit  = subjectsubmit + (value.data()?["Assignment-$j"]["submitted-Assignment"][usermodel["Email"].toString().split("@")[0]]["Status"] == "Accepted" ? 1 :0);

         }
       }
        AssignmentdataMap[subName] = subjectsubmit/subjecttotal;
        percentage.add(subjectsubmit/subjecttotal);
      }
      else{
        AssignmentdataMap[subName] = 0;
        percentage.add(0);
      }

      }
      );

    }

    overallpercent=submit/total;
    sesionalData();

  }

  sesionalData() async {
    int total=0;
    int obtained=0;
    for(int sub =0 ; sub < usermodel["Subject"].length; sub++){
      String subj = usermodel["Subject"][sub];
      int subtotal=0;
      int subobtain=0;
      int stop = usermodel["Marks"] != null && usermodel["Marks"][subj] !=null ? usermodel["Marks"][subj]["Total"] : 0 ;
      for(int sessional = 1; sessional <= stop ; sessional++){
        subtotal+= int.parse("${usermodel["Marks"][subj]["Sessional_${sessional}_total"]}");
        subobtain+= int.parse("${usermodel["Marks"][subj]["Sessional_$sessional"]}");

      }
      sessionalSubjectwiseperformance[subj] = subobtain/(subtotal ==0 ? 1 : subtotal);
      total+=subtotal;
      obtained+=subobtain;
    }
    sessionalOverallperformance = total/(obtained ==0 ? 1 : obtained);
    await quizData();
  }

}
