import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/Screens/CreateProfile.dart';
import 'package:genesis_flutter/Screens/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/Screens/SignInPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}



Color purple = Color(0xFF514B6F);
Color textCol = Color(0xFF393451);
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genesis App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  static const String KEYPROF= "profilecreated" ;
  static const String KEYSIGNIN= "signin" ;
  @override
  void initState() {
    super.initState();
    // Simulating some initialization process or fetching data
    //You can replace this with your actual initialization logic
       navigateFromSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/splash_img.png",
              width: 240,
              height: 240,
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/images/genesis_title.png",
              width: 120,
            ),
            SizedBox(height: 150),


            //  InkWell(
            //    onTap: () {
            //      if(profCreatedFromFirestore()==true){
            //
            //        Navigator.pushReplacement(
            //          context,
            //          MaterialPageRoute(builder: (context) => BaseScreen()),
            //        );
            //      }else{
            //        Navigator.pushReplacement(
            //          context,
            //          MaterialPageRoute(builder: (context) => SignInPage()),
            //        );
            //
            //      }
            //    },
            //    child: Container(
            //
            //     width: 280, // Set the width of the circular button
            //     height: 60, // Set the height of the circular button
            //      padding: EdgeInsets.all(16.0),
            //      alignment: Alignment.center,
            //      child: Text("Let's Start",
            //          style: TextStyle(
            //          fontSize: 24.0, // Optional: Set font size
            //          color: Colors.white, // Optional: Set text color
            //          fontWeight: FontWeight.bold, // Optional: Set font weight
            //        ),
            //      ),
            //     decoration: BoxDecoration(// Make it circular
            //       color: purple,
            //       borderRadius: BorderRadius.circular(20),
            //       // Set the background color to white
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.5),
            //           spreadRadius: 2,
            //           blurRadius: 5,
            //           offset: Offset(0, 2), // Add a shadow to the button (optional)
            //         ),
            //       ],
            //
            //     ),
            // ),
            //  ),
          ],
        ),
      ),
    );
  }




  void navigateFromSplash() async{

    var sharedPref = await  SharedPreferences.getInstance();

    var isProfCreated =  sharedPref.getBool(KEYPROF);
    var isLoggedIn = sharedPref.getString(KEYSIGNIN);


    if(isLoggedIn == null){
      Timer(Duration(seconds: 3),(){
              Navigator.pushReplacement(context as BuildContext,
                  MaterialPageRoute(builder: (context) => SignInPage(),));

            },);
    }else{
      if(isProfCreated != null){
        if(isProfCreated){

          Timer(Duration(seconds: 3),(){
            Navigator.pushReplacement(context as BuildContext,
                MaterialPageRoute(builder: (context) => BaseScreen(),));

          },);


        }else{

          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context as BuildContext ,
              MaterialPageRoute(builder: (context) => CreateProfileScreen()),
            );
          });
        }
      }else{

        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context as BuildContext ,
            MaterialPageRoute(builder: (context) => CreateProfileScreen()),
          );
        });


      }

    }



  }

}
















