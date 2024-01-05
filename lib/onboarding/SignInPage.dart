import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genesis_flutter/onboarding/CreateProfile.dart';
import 'package:genesis_flutter/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/onboarding/SplashScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:genesis_flutter/onboarding/Auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


Color cardColor = const Color(0xFF514B6F);
Color textCol = const Color(0xFF393451);
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>{
  @override
  Widget build(BuildContext context) {
    final AuthMethods authMethods = AuthMethods();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    //AuthService authService = AuthService();
    double screenWidth = MediaQuery.of(context).size.width;
    return
      Scaffold(
        body: Container(// Adjust the height as needed

          // Space between illustration and button
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.center,
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:EdgeInsets.all(20),
                      child:
                      Text('Welcome to the \n         Genesis!',style:TextStyle(fontSize: 50,fontWeight:FontWeight.bold,color: Colors.white, ),),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    color: Colors.white,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await googleSignIn.signOut();
                      //await _googleSignIn.disconnect();
                      //authService.handleSignOut();
                      //GoogleSignIn().disconnect();
                      final user = FirebaseAuth.instance.currentUser;
                      int res = await authMethods.signInWithGoogle();
                      var sharedPref = await SharedPreferences.getInstance();
                      sharedPref.setString(SplashScreenState.KEYSIGNIN, (user?.uid).toString() );
                      navigateFromSignIn();
                    },

                    child: Column(
                      children: [
                        const SizedBox(height: 130),
                        Padding(
                          padding:const EdgeInsets.all(2.0) ,
                          child:
                          Image.asset(
                            'assets/images/mother_preg_login.png',
                            width: 500,

                          ),),
                        Text(
                          "Healthy Mama's Child",
                          style: TextStyle(fontSize: 24,
                              fontWeight: FontWeight.bold, color:textCol),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0,right: 20, top: 180, bottom: 30),
                          child: Container(
                            width: double.infinity, // Set the width of the circular button
                            height: 60, // Set the height of the circular button
                            decoration: BoxDecoration( // Make it circular
                              color: cardColor, // Set the background color to white
                            ),
                            child: Row(
                                children :[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 55, // Set the width of the circular button
                                      height: 55, // Set the height of the circular button
                                      decoration: const BoxDecoration( // Make it circular
                                        color: Colors.white, // Set the background color to white
                                      ),
                                      child:
                                      Padding(
                                        padding:const EdgeInsets.all(2.0) ,
                                        child:
                                        Image.asset(
                                          'assets/images/google_icon.png',
                                          width: 40,
                                          height: 40,
                                        ),),

                                    ),
                                  ),

                                  const SizedBox(width: 40,) ,
                                  const Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),);
  }



  void navigateFromSignIn() async{

    var sharedPref = await  SharedPreferences.getInstance();
    var isProfCreated =  sharedPref.getBool(SplashScreenState.KEYPROF);

    if(isProfCreated != null){

      if(isProfCreated){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const BaseScreen()));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const CreateProfileScreen()));
      }

    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const CreateProfileScreen()));
    }
  }



}






























