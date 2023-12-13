import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import '../loadingscreen.dart';

class NotesQuery extends StatefulWidget {
  const NotesQuery({super.key, required this.index, required this.subject});
  final int index;
  final String subject;
  @override
  State<NotesQuery> createState() => _NotesQueryState();
}

class _NotesQueryState extends State<NotesQuery> {
  TextEditingController msgController = TextEditingController();

  final chatController = ChatController(
    initialMessageList: [],
    scrollController: ScrollController(),
    chatUsers: [],
  );
  final currentUser = ChatUser(
    id: '${usermodel["Email"]}',
    name: '${usermodel["Name"]}',
    profilePhoto: usermodel["Profile_URL"],
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/${usermodel["bg"]}"),
                fit: BoxFit.fill,
            ),
        ),
        width: size.width,
        child: StreamBuilder(
            stream:  FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.subject}").snapshots(),
            builder: (context, snapshot) {
              print(">>>>>>>>>>>>>>>>>>>Chat");
              if(snapshot.hasData){
                if(snapshot.data!.data()![usermodel["Email"].toString().split("@")[0]]!=null){
                  print("reloaded");
                  //chatController.chatUsers.clear();

                  chatController.chatUsers.add(
                    ChatUser(
                      id: snapshot.data!.data()?["Teacher"]["Email"],
                      name: snapshot.data!.data()?["Teacher"]['Name'],
                      profilePhoto: snapshot.data!.data()?["Teacher"]["Profile_URL"],
                    ),
                  );
                  //chatController.initialMessageList.clear();
                  for (var msg in snapshot.data!.data()!["Notes-${widget.index}"]["Query"][usermodel["Email"].toString().split("@")[0]]["Msg"]) {
                    print("insideloop");
                    final message1 = Message(

                        id: msg['Stamp'].toDate().toString(),
                        message: msg['text'],
                        createdAt: msg['Stamp'].toDate(),
                        sendBy: msg['UID'],
                        messageType: MessageType.text,
                        replyMessage: ReplyMessage(
                          message: msg['ReplyMessage'],
                          messageId: msg["ReplyMessageId"] ?? "",
                          messageType: MessageType.text,
                          replyTo: msg['ReplyTo'],
                          replyBy: msg['ReplyBy'],
                          voiceMessageDuration: Duration(seconds: msg['ReplyVoiceDuration'] ?? 0),
                        )
                    );
                    chatController.initialMessageList.add(message1);
                  }
                }
              }
              return snapshot.hasData
                  ?
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                        AssetImage("assets/images/${usermodel["bg"]}"),
                        fit: BoxFit.fill)),
                child: ChatView(
                  appBar: AppBar(
                    backgroundColor: Colors.black87,

                    titleSpacing: 0,
                    title: AutoSizeText(
                            "${widget.subject} Notes ${widget.index} Query Section",
                           style: GoogleFonts.tiltNeon(
                             color: Colors.white,
                             fontSize: size.width*0.055
                           ),
                        ),
                    elevation: 0,
                    leading: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  profileCircleConfig: ProfileCircleConfiguration(
                    circleRadius: size.width*0.035,
                    profileImageUrl: usermodel["Profile_URL"],
                  ),
                  chatBackgroundConfig: ChatBackgroundConfiguration(
                      backgroundColor: Colors.black38,
                      defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
                          textStyle: GoogleFonts.tiltNeon(
                            color: const Color.fromRGBO(211, 211, 211, 1),
                            //const Color.fromRGBO(150, 150, 150, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: size.width*0.035,
                          )
                      )
                  ),
                  currentUser: currentUser,
                  chatController: chatController,
                  onSendTap: (message, replyMessage, messageType) {
                    sendMsg(
                        snapshot.data!.data()?["Notes-${widget.index}"]["Query"][usermodel["Email"].toString().split("@")[0]]["Status"],
                      message,
                      replyMessage,
                      messageType
                    );
                  },
                  featureActiveConfig: const FeatureActiveConfig(
                      lastSeenAgoBuilderVisibility: true,
                      enableOtherUserProfileAvatar: true,
                      enablePagination: true,
                      enableSwipeToSeeTime: true,
                      enableCurrentUserProfileAvatar: true,
                      enableDoubleTapToLike: true,
                      receiptsBuilderVisibility: true,
                      enableChatSeparator: true,
                      enableReactionPopup: true,
                      enableReplySnackBar: true,
                      enableTextField: true
                  ),
                  loadingWidget:  const loading(text: "Syncronizing with the server please wait..."),
                  reactionPopupConfig: ReactionPopupConfiguration(
                    backgroundColor: Colors.black54,
                    showGlassMorphismEffect: true,
                    glassMorphismConfig: const GlassMorphismConfiguration(
                      borderColor: Color.fromRGBO(3, 178, 183, 1),
                      backgroundColor: Colors.black54,
                      strokeWidth: 4,
                    ),
                    userReactionCallback: (message, emoji) {
                      //reaction(message,emoji);
                    },
                  ),
                  sendMessageConfig: SendMessageConfiguration(
                      closeIconColor: const Color.fromRGBO(3, 178, 183, 1),
                      imagePickerConfiguration: ImagePickerConfiguration(),
                      imagePickerIconsConfig: const ImagePickerIconsConfiguration(
                        cameraIconColor: Color.fromRGBO(3, 178, 183, 1),
                        galleryIconColor: Color.fromRGBO(3, 178, 183, 1),
                      ),
                      enableGalleryImagePicker: false,
                      enableCameraImagePicker: false,
                      allowRecordingVoice: false,
                      defaultSendButtonColor: const Color.fromRGBO(3, 178, 183, 1),
                      textFieldConfig: TextFieldConfiguration(
                        textStyle: GoogleFonts.aBeeZee(
                          fontSize: size.width*0.04,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        contentPadding: EdgeInsets.all(size.width*0.04),

                      )
                  ),
                  chatViewState: ChatViewState.hasMessages,
                  chatBubbleConfig:  ChatBubbleConfiguration(
                    maxWidth: size.width*0.6,
                    receiptsWidgetConfig: const ReceiptsWidgetConfig(
                      showReceiptsIn: ShowReceiptsIn.all,

                    ),
                    outgoingChatBubbleConfig: ChatBubble(
                        senderNameTextStyle: GoogleFonts.aBeeZee(
                          fontSize: size.width*0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),// demonstrates as current user chat bubble
                        margin: EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.005),
                        linkPreviewConfig: LinkPreviewConfiguration(
                          loadingColor: Colors.grey,
                          linkStyle: GoogleFonts.exo(
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                          ),
                          //proxyUrl: "Proxy URL", // Need for web
                          backgroundColor: Color(0xff272336),
                          bodyStyle: TextStyle(color: Colors.white),
                          titleStyle: TextStyle(color: Colors.white),
                        ),
                        color: const Color.fromRGBO(3, 178, 183, 1),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(3),
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        textStyle: GoogleFonts.aBeeZee(
                          fontSize: size.width*0.035,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                    inComingChatBubbleConfig: ChatBubble(// demonstrates as current user chat bubble
                        margin: EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.005),
                        linkPreviewConfig: LinkPreviewConfiguration(
                          loadingColor: Colors.grey,
                          linkStyle: GoogleFonts.exo(
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                          ),
                          proxyUrl: "Proxy URL", // Need for web
                          backgroundColor: Color(0xff272336),
                          bodyStyle: TextStyle(color: Colors.white),
                          titleStyle: TextStyle(color: Colors.white),
                        ),
                        color: const Color.fromRGBO(221, 227, 239, 1),
                        senderNameTextStyle: GoogleFonts.aBeeZee(
                            color: const Color.fromRGBO(3, 178, 183, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: size.width*0.03
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(3),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        textStyle: GoogleFonts.aBeeZee(
                          fontSize: size.width*0.035,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                  ),
                  // Add this state once data is available.

                  messageConfig:  MessageConfiguration(
                    messageReactionConfig: MessageReactionConfiguration(
                        backgroundColor: Colors.black54,

                        borderColor: const Color.fromRGBO(3, 178, 183, 1),
                        borderWidth: 1.5,
                        reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
                            backgroundColor: Colors.black87,
                            reactedUserTextStyle: GoogleFonts.tiltNeon(
                              color: Colors.black,
                              //const Color.fromRGBO(150, 150, 150, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: size.width*0.04,
                            ),
                            reactionWidgetDecoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            reactionSize: size.width*0.06
                        ),
                        margin: EdgeInsets.only(top: size.height*0.01,left: size.width*0.04)
                    ),
                  ),
                  repliedMessageConfig: RepliedMessageConfiguration(
                    repliedMsgAutoScrollConfig: const RepliedMsgAutoScrollConfig(
                      enableHighlightRepliedMsg: true,
                      enableScrollToRepliedMsg: true,
                      highlightScrollCurve: accelerateEasing,
                      highlightColor: Colors.green,
                      highlightScrollDuration: Duration(milliseconds: 100),
                    ),
                    textStyle: GoogleFonts.aBeeZee(
                      fontSize: size.width*0.03,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    verticalBarColor: const Color.fromRGBO(3, 178, 183, 1).withOpacity(0.5),
                    backgroundColor: const Color.fromRGBO(3, 178, 183, 1).withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    replyTitleTextStyle: GoogleFonts.aBeeZee(
                      fontSize: size.width*0.032,
                      color: const Color.fromRGBO(3, 178, 183, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
                  :
              const SizedBox();
            }
        ),
      ),
    );
  }

  Future<void> sendMsg(String status,String message, ReplyMessage replyMessage,MessageType messageType) async{
    final check = await FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.subject}").get();


    check.data()?[usermodel["Email"].toString().split("@")[0]] ==null
        ?
    await FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.subject}").update({
      usermodel["Email"].toString().split("@")[0] : {
        "Name" : usermodel["Name"],
        "Email" : usermodel["Email"],
        "Profile_URL":usermodel["Profile_URL"]
      }
    })
    :
        null;


    await FirebaseFirestore.instance.collection("Notes").doc("${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.subject}").update({
      "Notes-${widget.index}.QueryBy" : FieldValue.arrayUnion([usermodel["Email"]]),
      "Notes-${widget.index}.Query.${usermodel["Email"].toString().split("@")[0]}.Msg" : FieldValue.arrayUnion([
        {
              "UID": usermodel["Email"].toString(),
              "text": message,
              "Stamp": DateTime.now(),
              "Type": messageType.name,
              "ReplyMessage" : replyMessage.message,
              "ReplyMessageId" : replyMessage.messageId,
              "ReplyMessageType" : replyMessage.messageType.name,
              "ReplyTo" : replyMessage.replyTo,
              "ReplyBy" : replyMessage.replyBy,
              "ReplyVoiceDuration" : replyMessage.voiceMessageDuration?.inSeconds,
        }
      ]),
      "Notes-${widget.index}.Query.${usermodel["Email"].toString().split("@")[0]}.load" : true,
    "Notes-${widget.index}.Query.${usermodel["Email"].toString().split("@")[0]}.Status" :
      check.data()?["Notes-${widget.index}"]["QueryBy"] != null && check.data()?["Notes-${widget.index}"]["QueryBy"].contains(usermodel["Email"])
          ?
     status
          :
      "Pending" ,
    });
  }
}
