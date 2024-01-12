import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/CommunityReq/helper_function.dart';
import 'package:genesis_flutter/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/Style/widgets.dart';
import 'package:genesis_flutter/onboarding/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


Color purple = const Color(0xFF514B6F);
Color textCol =  const Color(0xFF393451);
Color pinkColor = const Color(0xFFEDA8CC);

final TextEditingController nameController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController childAgeController = TextEditingController();
final TextEditingController pregnancyMonthController = TextEditingController();






class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
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
        title: const Text('Create Profile'),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Color(0xFF393451)),):
      Container(
          decoration: BoxDecoration(
            color: Colors.white10,
           // borderRadius: BorderRadius.only(topRight: Radius.circular(400)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top:30, right:30),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(
                      color: Color(0xFF393451),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: TextFormField(
                      controller: nameController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter your Name',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 19.0),
                        hintStyle: TextStyle(color: textCol), // Set hint text color to a lighter shade
                        fillColor: Colors.white, // Set the background color of the text box
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Set border color
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Name cannot be empty";
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Age',
                    style: TextStyle(
                      color: Color(0xFF393451),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(right:20.0),
                    child: TextFormField(
                      controller: ageController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter your age',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 19.0),
                        hintStyle: TextStyle(color: textCol), // Set hint text color to a lighter shade
                        fillColor: Colors.white, // Set the background color of the text box
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Set border color
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          age = value;
                        });
                      },

                      validator: (value) {
                        if(value!.isEmpty) {
                          return "Age cannot be empty";
                        } else if (int.tryParse(value!)! <21 ) {
                          return "You are underage to bear a baby";
                        } else{
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Select an option:',
                    style: TextStyle(fontSize: 16.0,
                      color: Color(0xFF393451),
                    ),
                  ),
                  const SizedBox(height: 8.0),
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
                    child: SizedBox(
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
                              const SizedBox(width: 80),
              
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
                  const SizedBox(height: 8.0),
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
                    child: SizedBox(
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
                            const SizedBox(width: 80),
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
                        const SizedBox(height: 16.0),
                        const Text(
                          'Enter Pregnancy Month:',
                           style: TextStyle(
                             color: Color(0xFF393451),
                             fontWeight: FontWeight.bold,
                             fontSize: 16.0,
                           ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.only(right:20.0),
                          child: TextFormField(
                            controller: pregnancyMonthController,
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Enter pregnancy month',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 19.0),
                              hintStyle: TextStyle(color: textCol), // Set hint text color to a lighter shade
                              fillColor: Colors.white, // Set the background color of the text box
                              filled: true,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Set border color
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                pregnancyMonth = int.tryParse(value) ?? 0;
                              });
                            },
                            validator: (value) {
                              int? intPregnancyMonth = int.tryParse(value!);
                              if (intPregnancyMonth == null || intPregnancyMonth < 1 || intPregnancyMonth > 9) {
                                return 'Please enter a valid pregnancy month between 1 and 9';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  if (hasChild)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16.0),
                        const Text(
                          'Enter Child Age:',
                          style: TextStyle(
                            color: Color(0xFF393451),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.only(right:20.0),
                          child: TextFormField(
                            controller: childAgeController,
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Enter child age',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 19.0),
                              hintStyle: TextStyle(color: textCol), // Set hint text color to a lighter shade
                              fillColor: Colors.white, // Set the background color of the text box
                              filled: true,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Set border color
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                childAge = int.tryParse(value) ?? 0;
                              });
                            },
                            validator: (value) {
                              final intChildAge = int.tryParse(value!);
                              if (intChildAge == null || intChildAge < 0 || intChildAge > 4) {
                                return 'Please enter a valid child age between 0 and 4';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: ()


       async {

            if(formKey.currentState!.validate()){

              setState(() {
                _isLoading = true;
              });

              var sharedPref = await SharedPreferences.getInstance();

              final name = nameController.text;
              final age = ageController.text;
              final pregnancyMon = pregnancyMonthController.text;
              final childAge = childAgeController.text;
              if (name.isNotEmpty &&
                  age.isNotEmpty &&
                  pregnancyMon.isNotEmpty ||
                  childAge.isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;
                final uid =user?.uid;
                sharedPref.setBool(SplashScreenState.KEYPROF,true);
                await HelperFunctions.saveUserEmailSF(user!.email.toString());
                await HelperFunctions.saveUserNameSF(name);
                //print(user?.email.toString());
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user?.uid)
                    .set({
                  "name": name,
                  "age": age,
                  "pregnancy month": pregnancyMon,
                  "child age": childAge,
                  "groups": [],
                  "uid": uid,
                });

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const BaseScreen()));

              }else{
                  showSnackbar(context,Color(0xFF393451) ,"Error in saving data in Firebase");
                setState(() {
                  _isLoading = false;
                });
              }

            }


          },
          child: Container(

            width: 140, // Set the width of the circular button
            height: 60, // Set the height of the circular button
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(// Make it circular
              color: purple,
              borderRadius: BorderRadius.circular(20),
              // Set the background color to white
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // Add a shadow to the button (optional)
                ),
              ],

            ),
            child: const Text("Save Profile",
              style: TextStyle(
                fontSize: 20.0, // Optional: Set font size
                color: Colors.white, // Optional: Set text color
                fontWeight: FontWeight.bold, // Optional: Set font weight
              ),
            ),
          ),
        ),
      ),
    );
  }
}