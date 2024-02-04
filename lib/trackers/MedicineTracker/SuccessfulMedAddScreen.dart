import 'dart:async';

import 'package:flutter/material.dart';
import 'package:genesis_flutter/trackers/MedicineTracker/AddMedicineScreen.dart';
import 'package:genesis_flutter/trackers/MedicineTracker/Medicine.dart';
import 'package:lottie/lottie.dart';

class SuccessfulMedAddScreen extends StatefulWidget {
  const SuccessfulMedAddScreen({super.key});

  @override
  State<SuccessfulMedAddScreen> createState() => _SuccessfulMedAddScreenState();
}

class _SuccessfulMedAddScreenState extends State<SuccessfulMedAddScreen> {
  @override

  void initState(){
    super.initState();
    Timer(const Duration(milliseconds: 4000), (){
      Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const AddMedicineScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.white,
      child: Center(
        child:  Lottie.asset(
            'assets/animation/Done_tick_genesis.json', // Replace with the path to your downloaded Lottie JSON animation
            width: 500,
            height: 500,
            fit: BoxFit.contain,
        ),
      ),
    );
  }
}
