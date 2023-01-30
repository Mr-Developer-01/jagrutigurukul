import 'package:flutter/material.dart';
import '../modals/UserModal.dart';
import 'complateprofile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SingupScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Singup();
 
}

class Singup extends State<SingupScreen>{
  TextEditingController emailcontroller = TextEditingController();
   TextEditingController passcontroller = TextEditingController();
    TextEditingController cpasscontroller = TextEditingController();

   
    void checkValus(){
      String email = emailcontroller.text.trim();
      String pass = passcontroller.text.trim();
      String cpass = cpasscontroller.text.trim();
      if(email == "" || pass == "" || cpass == ""){
        Fluttertoast.showToast(
              msg: 'Please fill all the fields !',
              backgroundColor: Color.fromARGB(255, 124, 91, 1),
              gravity: ToastGravity.TOP,
            );
          
      }else if(pass != cpass){
        Fluttertoast.showToast(
              msg: 'Passwords do not match !',
              backgroundColor: Color.fromARGB(255, 124, 91, 1),
              gravity: ToastGravity.TOP,
            );
      }else{
       /* Fluttertoast.showToast(
              msg: 'Singup Successful !',
              backgroundColor: Color.fromARGB(255, 11, 219, 21),
              gravity: ToastGravity.TOP,
            );*/
        createAccount(email,pass);
      }
    }
    void createAccount(String email , String pass) async{
      UserCredential? credential; 
      try {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      }on FirebaseAuthException catch (e) {
         Fluttertoast.showToast(
              msg:e.code.toString(),
              backgroundColor: Color.fromARGB(255, 255, 4, 4),
              gravity: ToastGravity.TOP,
            );
      }
      if(credential != null){
        String uid = credential.user!.uid;
        UserModal newUser = UserModal(
          uid: uid,
          email: email,
          fullName: "",
          profilepic: ""
        );
        await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value){
            Fluttertoast.showToast(
                msg: 'New User Created Successfully !',
                backgroundColor: Color.fromARGB(255, 11, 219, 21),
                gravity: ToastGravity.TOP,
              );
              Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  complateProfile(userModal: newUser, firebaseUser: credential!.user!)),
            );
              
        } );
      }
    }
GlobalKey form = GlobalKey();
@override
Widget build(BuildContext context) {
return Scaffold(
body:SingleChildScrollView(

child: Container(
child: SafeArea(
  child:Form(
    key:form,
    child:Padding(
      padding: const EdgeInsets.all(15.0),
        child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:CrossAxisAlignment.stretch,
      
      children: [
          SizedBox(
          height: 50,
        ),
        Container(
    width: 200.0,
    height: 200.0,
        child: Image.asset("assets/images/homeicon.png"),
        ),
      Text(
        "Jagruti Gurukul",
        textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:40.0,
             fontFamily: 'OoohBaby',
              fontWeight: FontWeight.bold
            ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(Radius.circular(60.0))
          ),
        child:TextFormField(
          controller: emailcontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 212, 43, 13),
                            ),
                            labelStyle:TextStyle(
                              color:  Color.fromARGB(255, 212, 43, 13),
                            ),
                            border: InputBorder.none,
                            labelText: "Email"
                        ),
                      )
        ),
        
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(Radius.circular(60.0))
          ),
        child:TextFormField(
          controller: passcontroller,
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 212, 43, 13),
                            ),
                            labelStyle:TextStyle(
                              color:  Color.fromARGB(255, 212, 43, 13),
                            ),
                            border: InputBorder.none,
                            labelText: "Password",
                            
                        ),
                        
                      )
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(Radius.circular(60.0))
          ),
        child:TextFormField(
          controller: cpasscontroller,
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 212, 43, 13),
                            ),
                            labelStyle:TextStyle(
                              color:  Color.fromARGB(255, 212, 43, 13),
                            ),
                            border: InputBorder.none,
                            labelText: "Confirm Password",
                            
                        ),
                        
                      )
        ),
        SizedBox(
          height: 15,
        ),
        SizedBox(width: 10),
      TextButton(
child: Text(
  "Create Account".toUpperCase(),
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
  checkValus();
         /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  complateProfile()),
            );*/
        }
),
              
    ],
    )
    ),
  )
    
),
 
)
),
 bottomNavigationBar: Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Already have an account ?"),
       TextButton(
  onPressed: () { 
    Navigator.pop(context);
   },
  child: Text(
    "Login",
    style: TextStyle(
      fontSize: 14,
      color: Color.fromARGB(255, 233, 76, 14)),
      )
  ),
    
    ]
  ),
 ),
);
}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

