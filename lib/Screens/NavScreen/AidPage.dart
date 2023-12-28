import 'package:flutter/material.dart';

class AidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text(
          'Aid Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}