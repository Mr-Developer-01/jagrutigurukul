import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../modals/ChatRoomModel.dart';
import '../modals/UserModal.dart';
import 'ChatRoomPage.dart';
import 'message_screen.dart';
enum Menu { itemOne, itemTwo, itemThree, itemFour }
// ignore: camel_case_types
class searchScreen extends StatefulWidget{
  final UserModal userModal;
  final User firebaseUser;
 

  const searchScreen({Key? key, required this.userModal, required this.firebaseUser}):super(key: key);
   
 @override
  State<StatefulWidget> createState() => searchScreenPage();
  
}

class searchScreenPage extends State<searchScreen>{
  TextEditingController searchController = TextEditingController();
   String _selectedMenu = '';
    String serchResult = '';
   
void searchResult(String text){
    //serchResult = ;
}
Future<ChatRoomModel?>getChatRoomModal(UserModal targetUser) async{
  ChatRoomModel? chatRoom;
QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModal.uid}",isEqualTo: true).where("participants.${targetUser.uid}",isEqualTo: true).get();
if(snapshot.docs.length >0){
  log("Chat Room Create}"+targetUser.uid.toString());
  var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
}else{
  
   ChatRoomModel newChatRoom = ChatRoomModel(
     chatroomid:uuid.v1(),
   lastMessage:"",
   participants:{
      widget.userModal.uid.toString():true,
      targetUser.uid.toString():true,
   },
   );
  await FirebaseFirestore.instance.collection("chatrooms").doc(newChatRoom.chatroomid).set(newChatRoom.toMap());
  chatRoom = newChatRoom;

      log("New Chatroom Created!"+newChatRoom.chatroomid.toString());
}
return chatRoom;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 212, 43, 13),
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Email Address"
                ),
              ),

              SizedBox(height: 20,),

              CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                color: Color.fromARGB(255, 212, 43, 13),
                child: Text("Search"),
              ),

              SizedBox(height: 20,),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").where("email", isEqualTo: searchController.text).where("email", isNotEqualTo: widget.userModal.email).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.active) {
                    if(snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                      if(dataSnapshot.docs.length > 0) {
                        Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;

                        UserModal searchedUser = UserModal.fromMap(userMap);

                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatroomModel = await getChatRoomModal(searchedUser);

                            if(chatroomModel != null) {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ChatRoomPage(
                                    targetUser: searchedUser,
                                    userModel: widget.userModal,
                                    firebaseUser: widget.firebaseUser,
                                    chatroom: chatroomModel,
                                  );
                                }
                              ));
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(searchedUser.profilepic!),
                            backgroundColor: Colors.grey[500],
                          ),
                          title: Text(searchedUser.fullName!),
                          subtitle: Text(searchedUser.email!),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        );
                      }
                      else {
                        return Text("No results found!");
                      }
                      
                    }
                    else if(snapshot.hasError) {
                      return Text("An error occured!");
                    }
                    else {
                      return Text("No results found!");
                    }
                  }
                  else {
                    return CircularProgressIndicator();
                  }
                }
              ),

            ],
          ),
        ),
      ),
    );
  }

}
