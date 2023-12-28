import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/Screens/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/Screens/SignInPage.dart';
import 'package:genesis_flutter/Screens/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


Color purple = Color(0xFF514B6F);
Color textCol = Color(0xFF393451);
Color pinkColor = const Color(0xFFEDA8CC);

final TextEditingController nameController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController childAgeController = TextEditingController();
final TextEditingController pregnancyMonthController = TextEditingController();






class CreateProfileScreen extends StatefulWidget {
  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  String name = '';
  String age = '';
  bool isPregnant = false;
  bool hasChild = false;
  int pregnancyMonth = 0;
  int childAge = 0;
  bool profileCreated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: Container(
          decoration: BoxDecoration(
            color: purple,
           // borderRadius: BorderRadius.only(topRight: Radius.circular(400)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top:30, right:30),
            child: ListView(
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 19.0),
                      hintStyle: TextStyle(color: textCol), // Set hint text color to a lighter shade
                      fillColor: Colors.white, // Set the background color of the text box
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Set border color
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Age',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(right:20.0),
                  child: TextField(
                    controller: ageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your age',
                      contentPadding: EdgeInsets.symmetric(horizontal: 19.0),
                      hintStyle: TextStyle(color: textCol), // Set hint text color to a lighter shade
                      fillColor: Colors.white, // Set the background color of the text box
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Set border color
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        age = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Select an option:',
                  style: TextStyle(fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isPregnant) {
                        isPregnant = false;
                      } else {
                        isPregnant = true;
                        hasChild = false;
                      }
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 300,
                    child: Card(
                      color: isPregnant ? Colors.pink[100] : null,
                      child: Row(
                          children:[
                            Padding(
                              padding: const  EdgeInsets.only(left:20.0),
                              child: Text(
                                'Are you Pregnant?',
                                style: TextStyle(fontSize: 16.0,
                                  color: textCol,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                            SizedBox(width: 80),

                            Image.asset(
                              'assets/images/pregnant.png', // Replace with the path to your local image asset
                              width: 80, // Set the width as needed
                              height: 80, // Set the height as needed
                              fit: BoxFit.cover, // Adjust the BoxFit property as needed
                            ),

                          ]

                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (hasChild) {
                        hasChild = false;
                      } else {
                        hasChild = true;
                        isPregnant = false;
                      }
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 300,
                    child: Card(
                      color: hasChild ? Colors.pink[100] : null,
                      child: Row(
                        children:[
                          Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Text(
                              'Are you a mother?',
                              style: TextStyle(fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: textCol,
                              ),
                            ),
                          ),
                          SizedBox(width: 80),
                          Image.asset(
                            'assets/images/mother_child.png', // Replace with the path to your local image asset
                            width: 80, // Set the width as needed
                            height: 80, // Set the height as needed
                            fit: BoxFit.cover, // Adjust the BoxFit property as needed
                          ),

                        ]

                      ),
                    ),
                  ),
                ),
                if (isPregnant)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Enter Pregnancy Month:',
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                         ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(right:20.0),
                        child: TextField(
                          controller: pregnancyMonthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter pregnancy month',
                            contentPadding: EdgeInsets.symmetric(horizontal: 19.0),
                            hintStyle: TextStyle(color: textCol), // Set hint text color to a lighter shade
                            fillColor: Colors.white, // Set the background color of the text box
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set border color
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              pregnancyMonth = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                if (hasChild)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Enter Child Age:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(right:20.0),
                        child: TextField(
                          controller: childAgeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter child age',
                            contentPadding: EdgeInsets.symmetric(horizontal: 19.0),
                            hintStyle: TextStyle(color: textCol), // Set hint text color to a lighter shade
                            fillColor: Colors.white, // Set the background color of the text box
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set border color
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              childAge = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: ()

          async {

            var sharedPref = await SharedPreferences.getInstance();
            sharedPref.setBool(SplashScreenState.KEYPROF,true );
            final name = nameController.text;
            final age = ageController.text;
            final pregnancyMon = pregnancyMonthController.text;
            final childAge = childAgeController.text;
            if (name.isNotEmpty &&
                age.isNotEmpty &&
                pregnancyMon.isNotEmpty ||
                childAge.isNotEmpty) {
              final user = FirebaseAuth.instance.currentUser;
              print(user?.email.toString());
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user?.uid)
                  .set({
                "name": name,
                "age": age,
                "pregnancy month": pregnancyMon,
                "child age": childAge,
              });

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => BaseScreen()));
              //   print(
              //       'Name: $name, Roll Number: $rollNumber, Hostel: $hostel');
            }
          },
          child: Container(

            width: 140, // Set the width of the circular button
            height: 60, // Set the height of the circular button
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text("Save Profile",
              style: TextStyle(
                fontSize: 20.0, // Optional: Set font size
                color: Colors.white, // Optional: Set text color
                fontWeight: FontWeight.bold, // Optional: Set font weight
              ),
            ),
            decoration: BoxDecoration(// Make it circular
              color: purple,
              borderRadius: BorderRadius.circular(20),
              // Set the background color to white
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2), // Add a shadow to the button (optional)
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}