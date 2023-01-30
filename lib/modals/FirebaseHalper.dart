import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jagrutigurukul/modals/UserModal.dart';

class FirebaseHelper{
  static Future<UserModal?> getuserModalById(String uid) async{
    UserModal? userModal;
    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if(docSnap.data() != Null){
        userModal = UserModal.fromMap(docSnap.data() as Map<String,dynamic>);
          log("Get user");
      
    }
    return userModal;
  }
}