import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jagrutigurukul/screens/LoginScreen.dart';
import 'package:jagrutigurukul/screens/searchScreen.dart';
import '../modals/ChatRoomModel.dart';
import '../modals/FirebaseHalper.dart';
import '../modals/UserModal.dart';
import 'ChatRoomPage.dart';

class HomeScreen extends StatefulWidget{
  final UserModal userModal;
  final User firebaseUser;

  const HomeScreen({Key? key, required this.userModal, required this.firebaseUser}):super(key: key);
 @override
  HomeScreenPage createState() => HomeScreenPage();
  
}

class HomeScreenPage extends State<HomeScreen>{

 @override
  Widget build(BuildContext context) {
   return MediaQuery(
    
    data: MediaQueryData(),
    
          child: MaterialApp( 
            debugShowCheckedModeBanner: false,
               home: Scaffold(
                appBar: AppBar(
          
                backgroundColor: Color.fromARGB(255, 233, 76, 14),
                  centerTitle: true,
                  title: Text(
                    "Jagruti Chat",
                    style: TextStyle(
            fontSize:30.0,
             fontFamily: 'OoohBaby',
              fontWeight: FontWeight.bold,
              
            ),
                  ),
                  actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => searchScreen(userModal: widget.userModal, firebaseUser: widget.firebaseUser,))),
              icon: const Icon(Icons.search))
        ],
                ),
               body: SafeArea(
                child: Container(
                   child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModal.uid}", isEqualTo: true).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active) {
                if(snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);

                      Map<String, dynamic> participants = chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModal.uid);

                      return FutureBuilder(
                        future: FirebaseHelper.getuserModalById(participantKeys[0]),
                        builder: (context, userData) {
                          if(userData.connectionState == ConnectionState.done) {
                            if(userData.data != null) {
                              UserModal targetUser = userData.data as UserModal;

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChatRoomPage(
                                        chatroom: chatRoomModel,
                                        firebaseUser: widget.firebaseUser,
                                        userModel: widget.userModal,
                                        targetUser: targetUser,
                                      );
                                    }),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(targetUser.profilepic.toString()),
                                ),
                                title: Text(targetUser.fullName.toString()),
                                subtitle: (chatRoomModel.lastMessage.toString() != "") ? Text(chatRoomModel.lastMessage.toString()) : Text("Say hi to your new friend!", style: TextStyle(
                                  color: Color.fromARGB(255, 233, 76, 14),
                                ),),
                              );
                            }
                            else {
                              return Container();
                            }
                          }
                          else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                }
                else if(snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                else {
                  return Center(
                    child: Text("No Chats"),
                  );
                }
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
                ),
               ),
              floatingActionButton: FloatingActionButton(
        onPressed: () async{
         await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  }
                ),
              );
        },
        child: Icon(Icons.logout),
      ),
               )
             //MediaQuery methods in use
       )
   );
   
  }
}