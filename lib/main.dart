import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jagrutigurukul/modals/FirebaseHalper.dart';
import 'package:jagrutigurukul/modals/UserModal.dart';
import 'package:jagrutigurukul/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '/screens/LoginScreen.dart';

var uuid = Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
   // systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  User? currentuers = FirebaseAuth.instance.currentUser;
  if(currentuers != null  ){
    UserModal? getUser = await FirebaseHelper.getuserModalById(currentuers.uid);
    if(getUser != null){

      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home:HomeScreen(userModal: getUser, firebaseUser: currentuers)));
    }else{
       runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home:MyApp()));
    }
  }else{
  runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home:MyApp()));
}
  }
  

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
class MyApploggedin extends StatelessWidget{
  final UserModal userModal;
  final User firebaseUser;

  const MyApploggedin({Key? key, required this.userModal, required this.firebaseUser}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomeScreen(userModal: userModal, firebaseUser: firebaseUser),
    );
  }
}