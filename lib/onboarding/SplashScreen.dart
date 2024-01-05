import 'dart:async';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/onboarding/CreateProfile.dart';
import 'package:genesis_flutter/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/onboarding/SignInPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}



Color purple = const Color(0xFF514B6F);
Color textCol = const Color(0xFF393451);
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genesis App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


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
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/genesis_title.png",
              width: 120,
            ),
            const SizedBox(height: 150),


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
      Timer(const Duration(seconds: 3),(){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignInPage(),));

            },);
    }else{
      if(isProfCreated != null){
        if(isProfCreated){

          Timer(const Duration(seconds: 3),(){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BaseScreen(),));

          },);


        }else{

          Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context ,
              MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
            );
          });
        }
      }else{

        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context ,
            MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
          );
        });


      }

    }



  }

}
















