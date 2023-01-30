import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jagrutigurukul/modals/UserModal.dart';

import 'home.dart';

class complateProfile extends StatefulWidget{
  final UserModal userModal;
  final User firebaseUser;

  const complateProfile({Key? key, required this.userModal, required this.firebaseUser}):super(key: key);
 @override
  State<StatefulWidget> createState() => complateProfileScreen();
  
}

class complateProfileScreen extends State<complateProfile>{
  File? imageFile;
  TextEditingController fullnameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if(pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20
    );

    if(croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }
  void showPhotoOption(){
    showDialog(context: context, builder: (builder){
      return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                  Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Choose Photo"),
                ),
                ListTile(
                   onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take  Photo"),
                )
              ],
            ),
      );
    });
  }
  void checkvalues(){
    String fullName  = fullnameController.text.trim();
    if(fullName == ""){
          Fluttertoast.showToast(
                  msg: 'Please fill Full Name !',
                  backgroundColor: Color.fromARGB(255, 124, 91, 1),
                  gravity: ToastGravity.TOP,
                );
    }else if(imageFile == Null){
    Fluttertoast.showToast(
                    msg: 'Please Upload Profile Picture!',
                    backgroundColor: Color.fromARGB(255, 124, 91, 1),
                    gravity: ToastGravity.TOP,
                  );
    }
    else{
      uploadData();
    }
  }
  void uploadData() async{
    UploadTask uploadTask =  FirebaseStorage .instance.ref("profilepictures").child(widget.userModal.uid.toString()).putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String filePath = await snapshot.ref.getDownloadURL();
    String fullName = fullnameController.text.trim();
    widget.userModal.fullName = fullName;
    widget.userModal.profilepic = filePath;
    await FirebaseFirestore.instance.collection("users").doc(widget.userModal.uid).set(widget.userModal.toMap()).then((value) {
     Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  HomeScreen(userModal: widget.userModal, firebaseUser: widget.firebaseUser)),
            );
      
    });
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
       backgroundColor: Color.fromARGB(255, 233, 76, 14),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text("Complete Profile"),
    ),
    body: SafeArea(
      child:Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40
        ),
        
        child: ListView(
          children: [
              SizedBox(height: 20,),
              CupertinoButton(
                child: CircleAvatar(
                  backgroundImage: (imageFile != null)?FileImage(imageFile!):null,
                  backgroundColor:Color.fromARGB(255, 233, 76, 14),
                  radius: 60,
                  child: (imageFile == null)?Icon(Icons.person,size: 60,):null,
                ), 
              onPressed:() {
                showPhotoOption();
              }
              ),
              Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(Radius.circular(60.0))
          ),
        child:TextFormField(
          controller: fullnameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 212, 43, 13),
                            ),
                            labelStyle:TextStyle(
                              color:  Color.fromARGB(255, 212, 43, 13),
                            ),
                            border: InputBorder.none,
                            labelText: "Full Name ",
                            
                        ),
                        
                      )
        ),
           SizedBox(height: 20,),
            TextButton(
child: Text(
  "Complete Profile".toUpperCase(),
  style: TextStyle(fontSize: 14)
),
style: ButtonStyle(
  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
  foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 233, 76, 14)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: Color.fromARGB(255, 212, 43, 13))
    )
  )
),
onPressed: () {
         /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ),
            );*/
            checkvalues();
        }
),
          ],
        ),
      ),
    
    )
   );
  }

}
