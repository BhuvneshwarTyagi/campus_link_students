import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import '../../Constraints.dart';
import '../Chat_tiles/PdfViewer.dart';
import 'download_tile.dart';
import 'notes_list.dart';

class NotesBackTile extends StatefulWidget {
  const NotesBackTile({super.key, required this.alternatives, required this.selectedSubject});
  final List<dynamic> alternatives;
  final String selectedSubject;
  @override
  State<NotesBackTile> createState() => _NotesBackTileState();
}

class _NotesBackTileState extends State<NotesBackTile> {
  bool isExpanded = false;
  String systempath='';
  DateTime currDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setsystemppath();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.alternatives.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              index==0
                  ?
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0,bottom: 5,top: 5),
                  child: AutoSizeText(
                    "Alternative Notes",
                    style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.055,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),),
                ),
              )
              :
              const SizedBox(),
              Card(
                key: const ValueKey(true),
                shape: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    )
                ),
                child: ListTile(
                  focusColor: Colors.green.shade700,
                  title: AutoSizeText(
                    widget.alternatives[index]["Notes_description"],
                    style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.045,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  iconColor: Colors.black,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Uploaded on: ${( widget.alternatives[index]["Stamp"].toDate()).toString().split(" ")[0]}",
                        style: GoogleFonts.tiltNeon(
                            fontSize: size.width*0.035,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),),
                      AutoSizeText(

                        "(${(int.parse( "${widget.alternatives[index]["File_Size"]}")/1048576).toStringAsFixed(2)} MB)",

                        style: GoogleFonts.tiltNeon(
                            fontSize: size.width*0.035,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),),
                    ],
                  ),
                  trailing: DownloadButton(downloadUrl: widget.alternatives[index]["Pdf_URL"], pdfName: "Alternative ${index+1}.pdf", path: "/Campus Link/${widget.selectedSubject}/Notes"),
                  onTap: (){
                    File file=File("$systempath/Campus Link/${widget.selectedSubject}/Notes/Alternative ${index+1}.pdf");
                    if(file.existsSync())
                    {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: PdfViewer(document: "$systempath/Campus Link/${widget.selectedSubject}/Notes/Alternative ${index+1}.pdf",name: "Alternative ${index+1}"),
                          type: PageTransitionType.bottomToTopJoined,
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.bottomCenter,
                          childCurrent: const NotesList(),
                        ),
                      );
                    }
                    else{
                      InAppNotifications.instance
                        ..titleFontSize = 14.0
                        ..descriptionFontSize = 14.0
                        ..textColor = Colors.black
                        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                        ..shadow = true
                        ..animationStyle = InAppNotificationsAnimationStyle.scale;
                      InAppNotifications.show(
                        // title: '',
                        duration: const Duration(seconds: 2),
                        description: "Please download the notes first",
                        // leading: const Icon(
                        //   Icons.error_outline_outlined,
                        //   color: Colors.red,
                        //   size: 55,
                        // )
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  setsystemppath() async {
    Directory? directory;
    if(Platform.isAndroid){
      Directory? directory = await getExternalStorageDirectory();

      systempath = directory!.path.toString().substring(0, 19);

    }
    if(Platform.isIOS){
      directory= await getApplicationDocumentsDirectory();
      systempath = directory.path;
    }
  }
}
