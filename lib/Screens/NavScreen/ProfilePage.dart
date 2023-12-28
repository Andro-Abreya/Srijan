import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/Screens/SignInPage.dart';
import 'package:genesis_flutter/Screens/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


Color cardColor = const Color(0xFF514B6F);
Color textCol = Color(0xFF393451);

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async{
            var sharedPref = await SharedPreferences.getInstance();
            // sharedPref.setBool(SplashScreenState.KEYPROF,false );
            sharedPref.setString(SplashScreenState.KEYSIGNIN,"");
            _auth.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> SignInPage()));
          },
          child: Container(
            width: 120,
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 15,left: 15),
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10,),
                Icon(Icons.arrow_forward,color: Colors.white,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}