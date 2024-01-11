import 'package:flutter/material.dart';
import 'package:genesis_flutter/appointments/SelectDetails.dart';
import 'package:genesis_flutter/chatbot/Chatbot.dart';
import '../trackers/BreastFeedingTracker/breast_feeding_tracker.dart';
import 'package:genesis_flutter/trackers/MedicineTracker/AddMedicineScreen.dart';

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
        MaterialPageRoute(builder: (_) => const SelectDetails()))
                },
                child: const Text('Book an Appointment')),
             ElevatedButton(
                onPressed:() => {
                   Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatBot()))
                },
                child: const Text('ChatBot')),
             
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
