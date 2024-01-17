import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/onboarding/SignInPage.dart';
import 'package:genesis_flutter/onboarding/SplashScreen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

// Color cardColor = const Color(0xFF514B6F);
// Color textCol = const Color(0xFF393451);

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                            top: 8, bottom: 8, right: 15, left: 15),
                        decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(15)),
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
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Background color of the container
                      borderRadius: BorderRadius.circular(20.0),
                      // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          // Shadow color
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(0, 3), // Shadow offset
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 8),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            // Adjust the radius as needed
                            child: Image.network(
                              '${auth.currentUser!.photoURL}',
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.grey),
                                textAlign: TextAlign.start,
                              ),
                              Text('Abhishek Bharti',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black),
                                  textAlign: TextAlign.start),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Roll No',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Colors.grey),
                                  textAlign: TextAlign.start),
                              Text('21124004',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black),
                                  textAlign: TextAlign.start),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Hostel & Room No',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Colors.grey),
                                  textAlign: TextAlign.start),
                              Text('MBH-A 332',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black),
                                  textAlign: TextAlign.start),
                            ],
                          )
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Stats Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Background color of the container
                      borderRadius: BorderRadius.circular(20.0),
                      // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          // Shadow color
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(0, 3), // Shadow offset
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 8),
                    child: Column(children: [
                      Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 110),
                            child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text('Money Spent',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '25000',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.black),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 30, bottom: 30),
                            child: Padding(
                              padding: EdgeInsets.only(right: 24),
                              child: Transform.rotate(
                                angle: -1.57,
                                child: LottieBuilder.asset(
                                  'assets/animation/barchart.json', // Replace with your animation file path
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  repeat: false,
                                ),
                              ),
                              // BarChart(

                              //   BarChartData(
                              //     titlesData: FlTitlesData(show: true),
                              //     borderData: FlBorderData(show: false),
                              //     barGroups: [
                              //       BarChartGroupData(
                              //         x: 3,
                              //         barRods: [
                              //           BarChartRodData(
                              //               toY: 15, color: Colors.blue),
                              //           BarChartRodData(
                              //               toY: 25, color: Colors.green),
                              //           BarChartRodData(
                              //               toY: 30, color: Colors.orange),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue,
                                ),
                                width: 25,
                                height: 25,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Normal Meal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    '₹ 12000',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.yellow,
                                ),
                                width: 25,
                                height: 25,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Extra Items',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    '₹ 4000',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Container(
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20),
                      //             color: Colors.green,
                      //           ),
                      //           width: 25,
                      //           height: 25,
                      //         ),
                      //         SizedBox(
                      //           width: 8,
                      //         ),
                      //         const Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               'Extra charges',
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w500,
                      //                   color: Colors.grey,
                      //                   fontSize: 14),
                      //             ),
                      //             Text(
                      //               '₹ 3300',
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: 18),
                      //             ),
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         Container(
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20),
                      //             color: Colors.red,
                      //           ),
                      //           width: 25,
                      //           height: 25,
                      //         ),
                      //         SizedBox(
                      //           width: 8,
                      //         ),
                      //         const Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               'Mess Fine',
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w500,
                      //                   color: Colors.grey,
                      //                   fontSize: 14),
                      //             ),
                      //             Text(
                      //               '₹ 1200',
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: 18),
                      //             ),
                      //           ],
                      //         )
                      //       ],
                      //     )
                      //   ],
                      // ),
                      // 
                      SizedBox(
                        height: 12,
                      ),
                    ])), //Money Spent Container
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    print('Button Tapped');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Breast Feeding History',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    print('Button Tapped');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vaccination History',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    print('Button Tapped');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Appointment History',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          )),
        ));
  }
}
