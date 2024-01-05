import 'package:flutter/material.dart';

class AidPage extends StatelessWidget {
  const AidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text(
          'Aid Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}