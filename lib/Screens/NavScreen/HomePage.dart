

import 'package:flutter/material.dart';
import 'package:genesis_flutter/Screens/BreastFeedingTracker/breast_feeding_tracker.dart';
import 'package:genesis_flutter/Screens/MedicineTracker/AddMedicineScreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed:() => {
                   Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddMedicineScreen()))
                },
                child: const Text('Medicine Tracker')),
             ElevatedButton(
                onPressed:() => {
                   Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BreastFeedingScreen()))
                },
                child: const Text('Breast Feeding Tracker')),
            const Text(
              'HomePage',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

   void navigateToMedicineTracker() {
   
  }
}
