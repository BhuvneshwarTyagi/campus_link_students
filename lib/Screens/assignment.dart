import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Assignment extends StatefulWidget {
  const Assignment({Key? key}) : super(key: key);

  @override
  State<Assignment> createState() => _AssignmentState();
}


PageController pageController=PageController();
bool active = false;
int currIndex=0;


class _AssignmentState extends State<Assignment> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            // Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            //Color.fromRGBO(118, 78, 232, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(

           elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [

            SizedBox(
              width: size.width,
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: size.height * 0.048,
                    width: size.width * 0.45,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.purpleAccent],
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.black, width: 2)),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        onPressed: () {
                          setState(() {

                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.linear);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: size.height * 0.09,
                                width: size.width * 0.08,
                                child: const Image(
                                  image: AssetImage(
                                      "assets/images/view_assignment.png"),
                                  fit: BoxFit.contain,
                                )),
                            const AutoSizeText("View Assignment"),
                          ],
                        )),
                  ),
                  Container(
                      height: size.height * 0.048,
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
                          borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.black, width: 2)),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent),
                          onPressed: () {

                            setState(() {

                              pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear);
                            });
                            // Navigator.push(
                            //     context,
                            //     PageTransition(
                            //         type: PageTransitionType.leftToRight,
                            //         child: const uploadAssignment()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: size.height * 0.09,
                                  width: size.width * 0.05,
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/images/upload-icon.png"),
                                    fit: BoxFit.contain,
                                  )),
                              const AutoSizeText("Upload Assignment"),
                            ],
                          ))),
                ],
              ),
            ),
          ],
        ),
        extendBody: true,
         backgroundColor: Colors.transparent,
        body:PageView(
          controller: pageController,
          children:  [
            Scaffold(

              backgroundColor: Colors.transparent,
              body: Container(
                height: size.height*0.8,
                child: const Center(child: Text("View Assignment")),
              ),

            ),
          Scaffold(

            backgroundColor: Colors.transparent,
            body: Container(
              height: size.height*0.8,
              child: const Center(child: Text("Upload Assignment")),
            ),
            floatingActionButton: Padding(
              padding:  EdgeInsets.only(bottom: size.height*0.07),
              child: Container(
                height: size.height * 0.04,
                width: size.height * 0.2,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.purpleAccent],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.black, width: 2)),

                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child:const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.upload,
                        color: Colors.white70,
                      ),
                      AutoSizeText("Upload File")
                    ],
                  ),
                  onPressed: () {

                  },
                ),
              ),
            ),
          ),


          ],
        ),
      ),
    );
  }
}



//
// class uploadAssignment extends StatefulWidget {
//   const uploadAssignment({super.key});
//
//   @override
//   State<uploadAssignment> createState() => _uploadAssignmentState();
// }
//
// class _uploadAssignmentState extends State<uploadAssignment> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//
//       backgroundColor: Colors.transparent,
//       body: Container(
//         height: size.height*0.8,
//         child: const Center(child: Text("Upload Assignment")),
//       ),
//       floatingActionButton: Padding(
//         padding:  EdgeInsets.only(bottom: size.height*0.07),
//         child: Container(
//           height: size.height * 0.04,
//           width: size.height * 0.2,
//           decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Colors.blue, Colors.purpleAccent],
//               ),
//               borderRadius: const BorderRadius.all(Radius.circular(20)),
//               border: Border.all(color: Colors.black, width: 2)),
//
//           child: FloatingActionButton(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             child:const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Icon(
//                   Icons.upload,
//                   color: Colors.white70,
//                 ),
//                 AutoSizeText("Upload File")
//               ],
//             ),
//             onPressed: () {
//
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

