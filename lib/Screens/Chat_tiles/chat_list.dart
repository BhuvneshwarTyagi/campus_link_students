import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constraints.dart';
import 'chat.dart';

class chatsystem extends StatefulWidget {
  const chatsystem({super.key});

  @override
  State<chatsystem> createState() => _chatsystemState();
}

class _chatsystemState extends State<chatsystem> {
  String channel_perfix =
      "${usermodel["University"].toString().trim().split(" ")[0]} "
      "${usermodel["College"].toString().trim().split(" ")[0]} "
      "${usermodel["Course"].toString().trim().split(" ")[0]} "
      "${usermodel["Branch"].toString().trim().split(" ")[0]} "
      "${usermodel["Year"].toString().trim().split(" ")[0]} "
      "${usermodel["Section"].toString().trim().split(" ")[0]} ";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(63, 63, 63, 1),
        leadingWidth: size.width * 0.07,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Campus Link"),
      ),
      body:
         ! no_subjects
        ?
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Students")
            .doc(usermodel["Email"])
            .snapshots(),
        builder: (context, snapshot) {

          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.data()!["Subject"].length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Messages").doc(channel_perfix+snapshot.data?.data()!["Subject"][index]).snapshots(),
                      builder: (context, snapshot2) {
                        int readCount = 0;
                        int count = 0;
                        snapshot2.hasData
                            ? readCount = snapshot2.data?.data()!["Messages"].length
                            : null;
                        snapshot2.hasData
                            ? count =
                            int.parse(
                                "${snapshot2.data?.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"]}")
                            : null;
                        return InkWell(

                          onTap: () async {
                            int readCount1 = 0;
                            int count1 = 0;
                            readCount1 = snapshot2.data?.data()!["Messages"].length;
                            count1 = int.parse("${snapshot2.data?.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"]}");
                            for (int i = readCount1; i > count1; i--) {
                              print(".............${snapshot2.data!.data()?["Messages"]}");
                              String? stamp = snapshot2.data!.data()?["Messages"][i-1]["Stamp"].toDate().toString().split('.')[0];
                              String? email = snapshot2.data!.data()?["Messages"][i-1]["UID"];

                              if (email != usermodel["Email"]) {
                                await FirebaseFirestore.instance
                                    .collection("Messages")
                                    .doc(channel_perfix+snapshot.data?.data()!["Subject"][index])
                                    .collection("Messages_Detail")
                                    .doc("Messages_Detail")
                                    .update({
                                  "${email?.split('@')[0]}_${stamp}_Seen" : FieldValue.arrayUnion([
                                    {
                                      "Email": usermodel["Email"],
                                      "Stamp": DateTime.now()
                                    }
                                  ]),
                                });
                              }
                            }
                            await FirebaseFirestore.instance
                                .collection("Messages")
                                .doc(channel_perfix+snapshot.data?.data()!["Subject"][index])
                                .update({
                              usermodel["Email"].toString().split("@")[0]: {
                                "Last_Active": DateTime.now(),
                                "Read_Count": readCount1,
                                "Active": true,
                                "Token": FieldValue.arrayUnion([usermodel["Token"]])
                              }
                            }).whenComplete(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => chat_page(
                                        channel: channel_perfix +
                                            snapshot.data?.data()!["Subject"]
                                                [index]),
                                  ));
                            });
                          },
                          child: Container(
                            height: 90,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                            padding: EdgeInsets.all(size.width * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color.fromRGBO(86, 149, 178, 1),
                                  radius: 30,
                                  child: Text(
                                    "P",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                      "${snapshot.data?.data()!["Subject"][index]}",
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.03,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      )
             :
         SizedBox(
           width: size.width*1,
           height: size.height*1,
           child: const Center(
             child: Image(
               image: AssetImage("assets/icon/No_data_found.png"),
               fit: BoxFit.cover,
             ),
           ),
         )
    );
  }
}
