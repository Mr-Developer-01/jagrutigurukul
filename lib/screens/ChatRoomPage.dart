import 'dart:developer';
import '../modals/ChatRoomModel.dart';
import '../modals/messageModal.dart';
import '/main.dart';
import '/modals/UserModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addCall.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModal targetUser;
  final ChatRoomModel chatroom;
  final UserModal userModel;
  final User firebaseUser;

  const ChatRoomPage({Key? key, required this.targetUser, required this.chatroom, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != "") {
      // Send Message
      messageModal newMessage = messageModal(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon:  DateTime.now(),
        text: msg,
        seen: false
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());

      log("Message Sent!"+widget.chatroom.chatroomid.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 233, 76, 14),
        title: Row(
          children: [

            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(widget.targetUser.profilepic.toString()),
            ),

            SizedBox(width: 10,),

            Text(widget.targetUser.fullName.toString()),

          ],
        ),
        actions: [
        IconButton(
          icon: Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home(widget.targetUser.fullName.toString())),
            );
          },
        ),
        SizedBox(),
      ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children:[
              // This is where the chats will go
              Expanded(
                child: Container(
                  
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  // decoration: BoxDecoration(
                    
                  //     image: DecorationImage(
                        
                  //       image: AssetImage("assets/images/homeicon.png"),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.active) {
                        if(snapshot.hasData) {
                          QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              messageModal currentMessage = messageModal.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment: (currentMessage.sender == widget.userModel.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Container(
                                   width: currentMessage.text.toString().length<=30?80:200,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (currentMessage.sender == widget.userModel.uid) ? Color.fromARGB(255, 212, 43, 13).withOpacity(currentMessage.sender == widget.userModel.uid? 1 : 0.1) : Theme.of(context).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      currentMessage.text.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else if(snapshot.hasError) {
                          return const Center(
                            child: Text("An error occured! Please check your internet connection."),
                          );
                        }
                        else {
                          return const Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      }
                      else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),

 // ===============================================================
 Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color.fromARGB(255, 252, 251, 251),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            //Icon(Icons.mic, color: Color(0xFF00BF6D)),
            SizedBox(width: 20.0),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF00BF6D).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Color.fromARGB(255, 212, 43, 13)
                          .withOpacity(0.64),
                    ),
                    const SizedBox(width: 20.0 / 4),
                    Expanded(
                      child: TextField(
                         controller: messageController,
                         maxLines: null,
                        decoration: const InputDecoration(
                           hintStyle: TextStyle(color: Color.fromARGB(255, 212, 43, 13)),
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // Icon(
                    //   Icons.attach_file,
                    //   color: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1!
                    //       .color!
                    //       .withOpacity(0.64),
                    // ),
                    SizedBox(width: 23.0 / 4),
                    // Icon(
                    //   Icons.camera_alt_outlined,
                    //   color: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1!
                    //       .color!
                    //       .withOpacity(0.64),
                    // ),
                     TextButton(
child: Text(
  "Send",
  style: TextStyle(
    fontSize: 16,
    )
),
style: ButtonStyle(
  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(2)),
  foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 233, 76, 14)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: Color.fromARGB(255, 212, 43, 13))
    )
  )
),
onPressed: () {
   sendMessage();
         /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Online()),
            );*/
        }
),
                  ],
                ),
              ),
              
            ),
          ],
        ),
      ),
    )
    // ======================================================
            ],
          ),
        ),
      ),
    );
  }
}