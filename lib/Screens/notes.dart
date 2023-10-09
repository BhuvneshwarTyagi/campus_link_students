

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Constraints.dart';
import '../QuizScreen.dart';
import '../push_notification/Storage_permission.dart';
import 'Chat_tiles/PdfViewer.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  var checkALLPermissions = CheckPermission();
  bool permissionGranted=false;
  bool docExists=false;
  Directory? directory;
  bool fileAlreadyExists=false;

  List<String> Subject = ['DBMS','ML','DAA'];
  int ind=0;
  bool a=true;

  bool ispdfExpanded=false;
  final dio=Dio();

  double percent=0.0;
  String filePath="";
  //String selectedSubject="DBMS";

  List<bool>isExpanded=[];
  List<bool>isDownloaded=[];
  List<bool>isDownloading=[];


  List<bool> selected = List.filled(usermodel["Subject"].length, false);

  List<dynamic> subjects = usermodel["Subject"];
  String selectedSubject = usermodel["Subject"][0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkExists();
    setState(() {
      selected[0]=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    BorderRadiusGeometry radiusGeomentry=BorderRadius.circular(size.width*0.09);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body:Container(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.12,
                  width: size.width * 1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * 0.016,
                                right: size.width * 0.016),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    var preIndex = index;

                                    setState(() {
                                      docExists=false;
                                      selected =
                                          List.filled(subjects.length, false);
                                      selected[index] = true;
                                      // previousIndex = index;
                                      print(subjects[index]);
                                      selectedSubject = subjects[index];
                                      checkExists();

                                    });
                                  },
                                  child: Container(
                                    height: size.height * 0.068,
                                    width: size.width * 0.2,
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color.fromRGBO(169, 169, 207, 1),
                                            // Color.fromRGBO(86, 149, 178, 1),
                                            Color.fromRGBO(189, 201, 214, 1),
                                            //Color.fromRGBO(118, 78, 232, 1),
                                            Color.fromRGBO(175, 207, 240, 1),

                                            // Color.fromRGBO(86, 149, 178, 1),
                                            Color.fromRGBO(189, 201, 214, 1),
                                            Color.fromRGBO(169, 169, 207, 1),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        border: selected[index]
                                            ? Border.all(
                                            color: Colors.white, width: 2)
                                            : Border.all(
                                            color: Colors.blueAccent,
                                            width: 1)),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.008,
                                ),
                                AutoSizeText(
                                  "${subjects[index]}",
                                  style: GoogleFonts.openSans(
                                      color: selected[index]
                                          ? Colors.white
                                          : Colors.black87),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.03,
                  thickness: MediaQuery.of(context).size.height * 0.001,
                ),
                docExists
                    ?
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: StreamBuilder
                    (
                    stream: FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
                    {
                      return  snapshot.hasData
                          ?
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: snapshot.data["Total_Notes"],
                          itemBuilder: (context, index) {

                            String? dir=directory?.path.toString().substring(0,19);
                            print("////////////////////$dir");
                            String path="$dir/Campus Link/${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject/Notes/";

                            File newPath=File("${path}${snapshot.data["Notes-${index+1}"]["File_Name"]}");
                            newPath.exists().then((value) async  {
                              if(!value)
                              {

                                setState(() {
                                  isDownloaded[index]=false;
                                });
                              }
                              else{

                                setState(() {
                                  isDownloaded[index]=true;
                                });
                              }
                            });
                            return Padding(
                              padding:  EdgeInsets.all(size.width*0.032),
                              child: Container(
                                width: size.width*0.85,
                                decoration: BoxDecoration(
                                  color:Colors.blue,
                                  borderRadius: radiusGeomentry,
                                ),
                                child: Column(

                                  children: [
                                    SizedBox(
                                      height: size.height*0.18,
                                      width: size.width*0.93,
                                      child: Padding(
                                          padding:  EdgeInsets.only(top:size.height*0.01,left:size.height*0.01,right:size.height*0.01),
                                          child: InkWell(
                                            onTap: (){
                                              if(isDownloaded[index])
                                              {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: PdfViewer(document: newPath.path,name:snapshot.data["Notes-${index+1}"]["File_Name"] ),
                                                    type: PageTransitionType.bottomToTopJoined,
                                                    duration: const Duration(milliseconds: 200),
                                                    alignment: Alignment.bottomCenter,
                                                    childCurrent: const Notes(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:BorderRadius.only(
                                                      topLeft: Radius.circular(size.width*0.05),
                                                      topRight: Radius.circular(size.width*0.05)),
                                                  image: DecorationImage(
                                                    image: NetworkImage("${snapshot.data["Notes-${index+1}"]["thumbnailURL"]}",
                                                    ),fit: BoxFit.cover,
                                                  )
                                              ),),
                                          )
                                      ),
                                    ),
                                    AnimatedContainer(
                                      height: isExpanded[index] ? size.height*0.22 :size.height*0.12,
                                      width:size.width*0.98,
                                      duration: const Duration(milliseconds: 1),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: radiusGeomentry

                                      ),
                                      child: SingleChildScrollView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: size.height*0.018,
                                            ),
                                            ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.only(
                                                    bottomLeft: Radius.circular(size.width*0.1),
                                                    bottomRight: Radius.circular(size.width*0.12)),),
                                              title: Container(
                                                  height: size.height*0.07,
                                                  width: size.width*0.45,
                                                  //ssscolor: Colors.redAccent,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: AutoSizeText(
                                                          snapshot.data["Notes-${index+1}"]["File_Name"]!=null
                                                              ?
                                                          snapshot.data["Notes-${index+1}"]["File_Name"].toString()
                                                              :
                                                          "",
                                                          style: GoogleFonts.exo(
                                                              fontSize: size.height*0.02,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500),),
                                                      ),
                                                      SizedBox(
                                                        height: size.height*0.01,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          AutoSizeText(
                                                            snapshot.data["Notes-${index+1}"]["File_Size"]!=null
                                                                ?
                                                            "Size:${(int.parse(snapshot.data["Notes-${index+1}"]["File_Size"].toString())/1048576).toStringAsFixed(2)} MB"
                                                                :
                                                            "",
                                                            style: GoogleFonts.exo(
                                                                fontSize: size.height*0.016,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500),),
                                                          AutoSizeText(
                                                            snapshot.data["Notes-${index+1}"]["Stamp"]!=null
                                                                ?
                                                            "Date: ${(snapshot.data["Notes-${index+1}"]["Stamp"].toDate()).toString().split(" ")[0]}"
                                                                :
                                                            "",
                                                            style: GoogleFonts.exo(
                                                                fontSize: size.height*0.016,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500),),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                              ),
                                              leading:Container(
                                                  height: size.width*0.07,
                                                  width: size.width*0.07,
                                                  decoration:  const BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    /*image:DecorationImage(
                                                image: fileAlreadyExists
                                                    ?
                                                const AssetImage("assets/icon/pdf.png"):
                                                const AssetImage("assets/icon/download-button.png"),
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center, )*/
                                                  ),
                                                  child:isDownloaded[index]
                                                      ?
                                                  Image.asset("assets/icon/pdf.png")
                                                      :
                                                  isDownloading[index]
                                                      ?
                                                  Center(
                                                    child: Center(
                                                      child: CircularPercentIndicator(
                                                        percent: percent,
                                                        radius: size.width*0.035,
                                                        animation: true,
                                                        animateFromLastPercent: true,
                                                        curve: accelerateEasing,
                                                        progressColor: Colors.green,
                                                        center: Text((percent*100).toDouble().toStringAsFixed(0),style: GoogleFonts.openSans(fontSize: size.height*0.024),),
                                                        //footer: const Text("Downloading"),
                                                        backgroundColor: Colors.transparent,
                                                      ),
                                                    ),
                                                  )
                                                      :
                                                  IconButton(
                                                      onPressed: ()
                                                      async {
                                                        setState(() {
                                                          isDownloading[index]=true;
                                                        });

                                                        String path="$dir/Campus Link/${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject/Notes/";

                                                        File newPath=File("$path${snapshot.data["Notes-${index+1}"]["File_Name"]}");
                                                        await newPath.exists().then((value) async {
                                                          if(!value)
                                                          {
                                                            print(".Start");
                                                            await dio.download(snapshot.data["Notes-${index+1}"]["Pdf_URL"],newPath.path,onReceiveProgress: (count, total) {
                                                              if(count==total){
                                                                setState(() {
                                                                  filePath=newPath.path;
                                                                  isDownloaded[index]=true;
                                                                  isDownloading[index]=false;
                                                                });
                                                              }
                                                              else{
                                                                setState(() {
                                                                  percent = (count/total);
                                                                });
                                                              }
                                                            },);
                                                          }
                                                          else{
                                                            print("..Already Exsist");
                                                          }
                                                        });

                                                      },
                                                      icon: Icon(Icons.download,color: Colors.black87,size:size.width*0.1))

                                              ),

                                              // subtitle: AutoSizeText('DEADLIiNE',style: GoogleFonts.exo(fontSize: size.height*0.015,color: Colors.black,fontWeight: FontWeight.w400),),
                                              trailing:  FloatingActionButton(
                                                backgroundColor: Colors.lightBlueAccent,
                                                elevation: 0,
                                                onPressed: (){
                                                  setState(() {
                                                    isExpanded[index]= !isExpanded[index];
                                                  });

                                                },
                                                child:Image.asset("assets/icon/speech-bubble.png",
                                                  width: size.height*0.045,
                                                  height: size.height*0.045,),
                                              ),

                                            ),
                                            isExpanded[index]
                                                ?
                                            Padding(
                                                padding: EdgeInsets.only(top: size.height*0.022),
                                                child:  snapshot.data["Notes-${index+1}"]["Submitted by"]!=null &&  snapshot.data["Notes-${index+1}"]["Submitted by"].contains(usermodel["Email"])
                                                    ?
                                                Container(
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.45,
                                                  decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Colors.blue,
                                                          Colors.purpleAccent,
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                      border: Border.all(color: Colors.black, width: 2)
                                                  ),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                      ),

                                                      onPressed: (){

                                                      },
                                                      child: AutoSizeText(
                                                        "Submitted",
                                                        style: GoogleFonts.openSans(
                                                            fontSize: size.height * 0.022,
                                                            color: Colors.white
                                                        ),


                                                      )),
                                                )
                                                    :
                                                Container(
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.45,
                                                  decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Colors.blue,
                                                          Colors.purpleAccent,
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)),
                                                      border: Border.all(color: Colors.black, width: 2)
                                                  ),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(size.width*0.035)))
                                                      ),

                                                      onPressed: (){
                                                        Navigator.pushReplacement(context,
                                                            PageTransition(
                                                                child:  QuizScreen(subject: selectedSubject, notesId: index+1),
                                                                type: PageTransitionType.bottomToTopJoined,
                                                                childCurrent: const Notes(),
                                                                duration: const Duration(milliseconds: 300)
                                                            )
                                                        );
                                                      },
                                                      child: AutoSizeText(
                                                        "Take Quiz",
                                                        style: GoogleFonts.openSans(
                                                            fontSize: size.height * 0.022,
                                                            color: Colors.white
                                                        ),


                                                      )),
                                                )
                                            ):
                                            const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                          },),
                      )
                          :
                      const SizedBox(
                        child: Center(child: Text("No Data Found")),
                      );
                    },),
                )
                    :
                Center(
                    child: AutoSizeText("No data Found Yet",
                      style: GoogleFonts.poppins(
                          color: Colors.black26,
                          fontSize: size.height*0.03
                      ),))
              ],
            ),
          ),
        )


    );

  }
  Future<void> checkAndRequestPermissions() async {
    directory = await getExternalStorageDirectory();
    var permission = await checkALLPermissions.isStoragePermission();
    if (permission) {
      String? dir = directory?.path.toString().substring(0, 19);
      String path = "$dir/Campus Link/${usermodel["University"].split(
          " ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"]
          .split(" ")[0]} ${usermodel["Branch"].split(
          " ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject/Notes/";
      Directory(path).exists().then((value) async {
        if (!value) {
          await Directory(path).create(recursive: true).then((value) =>
              print("........................Created File ${value.path}"));
        }
      });
      setState(() {
        permissionGranted = true;
        print("........................Permission Granted");
      });
    }
    else {
      print("........................$permission");
    }
  }

  Future<void>checkExists()
  async {
    await FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} $selectedSubject")
        .get().then((value) {
      if(value.exists)
      {
        setState(() {
          isExpanded=List.generate(value.data()?["Total_Notes"], (index) =>  false);
          isDownloaded=List.generate(value.data()?["Total_Notes"], (index) =>  false);
          isDownloading=List.generate(value.data()?["Total_Notes"], (index) =>  false);
          docExists=true;
        });
        checkAndRequestPermissions();
      }
      else{
        setState(() {
          docExists=false;
        });
      }

    });
  }
}

