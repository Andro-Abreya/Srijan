import 'package:flutter/material.dart';
import 'package:genesis_flutter/appointments/dashboard_screen.dart';
import 'package:genesis_flutter/appointments/storage.dart';
import 'package:lottie/lottie.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation widget
            Lottie.asset('assets/animation/Done_tick_genesis.json',repeat: false,frameRate: FrameRate(390)),
            const SizedBox(height: 20),
            // Text message
            Text(
              'Your appointment is confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Optional: Add details or instructions
            Text(
              'See you soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Done button
            ElevatedButton(
              onPressed: (){
               Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
      (Route<dynamic> route) => route.isFirst || route.settings.name == '/home'
    );
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}