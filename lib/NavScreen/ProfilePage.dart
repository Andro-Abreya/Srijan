import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/CommonChatPlatform/firestore_service.dart';
import 'package:genesis_flutter/onboarding/SignInPage.dart';
import 'package:genesis_flutter/onboarding/SplashScreen.dart';
import 'package:genesis_flutter/trackers/BreastFeedingTracker/breast_feeding_tracker.dart';
import 'package:genesis_flutter/trackers/MedicineTracker/AddMedicineScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:fl_chart/fl_chart.dart';

Color cardColor = const Color(0xFF514B6F);
Color textCol = const Color(0xFF393451);

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<FlSpot> generateDummyData() {
    return [
      FlSpot(0, 2),
      FlSpot(1, 2),
      FlSpot(2, 4),
      FlSpot(3, 1),
      FlSpot(4, 4),
      FlSpot(5, 1),
      FlSpot(6, 3),
      FlSpot(7, 2),
      // Add more data points as needed
    ];
  }
  @override
  final FirestoreService _firestoreService = FirestoreService();
  String? Name;
  String? Age;
  String? ChildAge;
  String? PregMon;

  Future<void> fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        if (userSnapshot.exists) {
          Name = userSnapshot.get('name');
          Age = userSnapshot.get('age');
          ChildAge = userSnapshot.get('child age') ?? "";
          PregMon = userSnapshot.get('pregnancy month') ?? "";
        } else {
          // User document does not exist, initialize with default values or empty strings
          Name = "Default Name";
          Age = "";
          ChildAge = "";
          PregMon = "";
        }
      } catch (e) {
        print("Error fetching user data: $e");
        // Handle the error, initialize with default values or empty strings
        Name = "Default Name";
        Age = "";
        ChildAge = "";
        PregMon = "";
      }
    } else {
      // User is not authenticated
      // Handle accordingly
      Name = "Default Name";
      Age = "";
      ChildAge = "";
      PregMon = "";
    }


    setState(() {}); // Trigger a rebuild after data is fetched
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Account',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      child:
                      Center(
                        child: Column(

                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(80.0),
                              // Adjust the radius as needed
                              child: Image.network(
                                '${auth.currentUser!.photoURL}',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(Name??"User Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black),
                                  textAlign: TextAlign.start),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "$Age years old",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            ChildAge!=""?
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "Baby of $ChildAge years",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey),
                                textAlign: TextAlign.start,
                              ),
                            ):
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "Pregnancy week $PregMon",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey),
                                textAlign: TextAlign.start,
                              ),
                            ),

                            SizedBox(height: 10,),
                            GestureDetector(
                              onTap: () async {
                                var sharedPref = await SharedPreferences.getInstance();
                                // sharedPref.setBool(SplashScreenState.KEYPROF,false );
                                sharedPref.setString(SplashScreenState.KEYSIGNIN, "");
                                auth.signOut();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (_) => const SignInPage()));
                              },
                              child: Container(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, right: 45, left: 45),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.4),
                                      borderRadius: BorderRadius.circular(10)),

                                  child: Center(
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )

                              ),
                            ),

                            SizedBox(height: 20),
                            Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // Adjust the radius as needed
                                    child: Image.asset(
                                      'assets/images/med_store.png',
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: 350,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left:12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Medicine List",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text("View your medicine list",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                              textAlign: TextAlign.start),
                                          SizedBox(height: 35,),
                                          GestureDetector(
                                            onTap: () async {
                                              var sharedPref = await SharedPreferences.getInstance();
                                              // sharedPref.setBool(SplashScreenState.KEYPROF,false );
                                              sharedPref.setString(SplashScreenState.KEYSIGNIN, "");
                                              auth.signOut();
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (_) => const AddMedicineScreen()));
                                            },
                                            child: Container(
                                                width: 80,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15)),

                                                child: Center(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'See all',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w500,
                                                        ),),
                                                      SizedBox(width: 2,),
                                                      Icon(Icons.arrow_forward, color: Colors.grey,size: 18,),

                                                    ],
                                                  ),
                                                )

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),



                                ]
                            ),

                          ],
                        ),
                      ),

                    ),


                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: const Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3), // Shadow offset
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(top: 8),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top:12, bottom: 12, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Meet with Dr. John',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Container(
                                  width: 130,
                                  child: Text(
                                    'Tuesday August 20 at 10:00 am',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),

                                InkWell(
                                  onTap: () async {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => const AddMedicineScreen()));//Add meeting link
                                  },
                                  child: Container(
                                    width: 120,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'Join Meeting',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                    ),

                                  ),
                                ),
                              ],
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, top: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              // Adjust the radius as needed
                              child: Image.asset(
                                'assets/images/doc.png',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            ),
                          )


                        ],
                      ),

                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: const Text(
                        'Breast Feeding Tracks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3), // Shadow offset
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(top: 8),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top:12, bottom: 12, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BreastFeeding Duration',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),



                                Text(
                                  '34mins',
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, top: 70),
                            child:  InkWell(
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const BreastFeedingScreen()));//Add meeting link
                              },
                              child: Container(
                                width: 120,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'See history',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      SizedBox(width: 2,),
                                      Icon(Icons.keyboard_double_arrow_right_outlined)
                                    ],
                                  ),
                                ),

                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              )),
        ));
  }
}
