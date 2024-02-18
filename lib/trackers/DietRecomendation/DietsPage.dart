import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mom Diet App'),
      ),
      body: DietCards(),
    );
  }
}

class DietCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DietCard(title: 'Breakfast'),
        DietCard(title: 'Lunch'),
        DietCard(title: 'Snacks'),
        DietCard(title: 'Dinner'),
      ],
    );
  }
}

class DietCard extends StatelessWidget {
  final String title;

  const DietCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DietOptionsScreen(title: title)),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DietOptionsScreen extends StatelessWidget {
  final String title;

  const DietOptionsScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    // You can fetch diet options based on the selected time (title) here
    // and display them on this screen.
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Diet options for $title will be displayed here.'),
      ),
    );
  }
}