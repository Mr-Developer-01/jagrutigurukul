
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../modals/ChatRoomModel.dart';
import '../modals/UserModal.dart';

class MessagesScreenPage extends StatefulWidget {
  final UserModal targetuser;
  final ChatRoomModel chatrRoom;
  final UserModal userModal;
  final User firebaseuser;

  const MessagesScreenPage({super.key, required this.targetuser, required this.chatrRoom, required this.userModal, required this.firebaseuser});

 @override
  MessageScreen createState() => MessageScreen();
}
  class MessageScreen extends State<MessagesScreenPage>{
 @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar:AppBar(
       automaticallyImplyLeading: false,
     
       backgroundColor: Color.fromARGB(255, 233, 76, 14),
     
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            //backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          SizedBox( width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Deepu Singh",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        SizedBox(),
      ],
    ),
    body: SafeArea(
      child: Container(
        child: Column(
          children: [

            Expanded(
              child: Container()
              ),


               Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
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
                padding: EdgeInsets.symmetric(
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
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: 20.0 / 4),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
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
                      IconButton(
                     icon:Icon(Icons.send),
                     iconSize: 30,
                      color:Color.fromARGB(255, 233, 76, 14),
                           onPressed: () {  },
                    ),
                  ],
                ),
              ),
              
            ),
          ],
        ),
      ),
    )
          ],
        ),
      ),
    ),
    );
    
  }
}
