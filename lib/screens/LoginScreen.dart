import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jagrutigurukul/modals/UserModal.dart';
import './home.dart';
import 'signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Login();
 
}

class Login extends State<LoginScreen>{
   var isVisible = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  void checkValus(){
    String email = emailcontroller.text.trim();
    String pass = passwordcontroller.text.trim();
    if(email == "" || pass == ""){
    Fluttertoast.showToast(
                  msg: 'Please fill all the fields !',
                  backgroundColor: Color.fromARGB(255, 124, 91, 1),
                  gravity: ToastGravity.TOP,
                );
    }else{
      login(email,pass);
    }
  }
  void login(String email,String pass) async{
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
              msg:e.message.toString(),
              backgroundColor: Color.fromARGB(255, 255, 4, 4),
              gravity: ToastGravity.TOP,
            );
    }
    if(credential != null){
      String uid = credential.user!.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModal louser = UserModal.fromMap(userData.data() as Map<String,dynamic>);
      Fluttertoast.showToast(
              msg: 'Login Successful !',
              backgroundColor: Color.fromARGB(255, 11, 219, 21),
              gravity: ToastGravity.TOP,
            );
           Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  HomeScreen(userModal: louser, firebaseUser: credential!.user!)),
            );
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
          controller: passwordcontroller,
                        obscureText: isVisible,
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
                            suffixIcon:GestureDetector(
                              onTap: (){
                                  print(isVisible);
                                  setState(() {
                                     isVisible = !isVisible;
                                  });
                               print(isVisible);
                              },
                              child: Icon(
                                 isVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                        color: Color.fromARGB(255, 43, 41, 40),
                                ),
                                
                              )
                        ),
                        
                        
                      )
        ),
        SizedBox(
          height: 15,
        ),
        SizedBox(width: 10),
      TextButton(
child: Text(
  "Login".toUpperCase(),
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
              MaterialPageRoute(builder: (context) =>  Online()),
            );*/
            checkValus();
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
      Text("Don't have an account ?"),
       TextButton(
  onPressed: () { 
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SingupScreen()),
            );
   },
  child: Text(
    "Sing up",
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
}
