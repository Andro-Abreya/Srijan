import 'package:flutter/material.dart';
import 'package:genesis_flutter/DietRecomendation/DietData/dinnerData.dart';
import 'package:genesis_flutter/DietRecomendation/DietData/lunchData.dart';
import 'package:genesis_flutter/DietRecomendation/DietData/snacksData.dart';
import 'package:genesis_flutter/trackers/DietRecomendation/DietData/breakfastData.dart';
import 'package:genesis_flutter/trackers/DietRecomendation/DietData/dinnerData.dart';
import 'package:genesis_flutter/trackers/DietRecomendation/DietData/lunchData.dart';
import 'package:genesis_flutter/trackers/DietRecomendation/DietData/snacksData.dart';
import 'package:genesis_flutter/trackers/DietRecomendation/dietOptionScreen.dart';


class DietsPage extends StatelessWidget {
  const DietsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moms Diet'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 20),
            child: Text(
              "Mumma's Diet",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          SizedBox(height: 10,),
          DietCards(),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}

class DietCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          DietCard(
            title: 'Pre Breakfast',
            gradientColors: [Colors.purple, Colors.purpleAccent],
            image: 'assets/images/snacks.png', // Replace with the actual image path
            details: "It's essential for you to stay hydrated, so start the day with a glass of water.",
            cardData: BreakfastCardData.cardData,
          ),
          DietCard(
            title: 'Breakfast',
            gradientColors: [Colors.pink, Colors.pinkAccent],
            image: 'assets/images/breakfast2.png', // Replace with the actual image path
            details: 'Aim for a balanced meal to provide sustained energy throughout the morning.',
            cardData: BreakfastCardData.cardData,
          ),
          DietCard(
            title: 'Mid Morning Snacks',
            gradientColors: [Colors.teal, Colors.tealAccent],
            image: 'assets/images/breakfast2.png', // Replace with the actual image path
            details: 'Include protein and fiber to keep energy levels stable.',
            cardData: BreakfastCardData.cardData,
          ),
          DietCard(
            title: 'Lunch',
            gradientColors: [Colors.blue, Colors.blueAccent],
            image: 'assets/images/lunch2.png', // Replace with the actual image path
            details: 'Prioritize lean proteins like chicken, fish, or beans for fetal development.',
            cardData: LunchCardData.cardData,
          ),
          DietCard(
            title: 'Snacks',
            gradientColors: [Colors.orange, Colors.deepOrange],
            image: 'assets/images/snacks.png', // Replace with the actual image path
            details: 'Opt for nutrient-dense snacks to support energy levels between meals.',
            cardData: SnacksCardData.cardData,
          ),
          DietCard(
            title: 'Dinner',
            gradientColors: [Colors.green, Colors.greenAccent],
            image: 'assets/images/dinner.png', // Replace with the actual image path
            details: 'Be mindful of portion sizes and avoid heavy, rich, or spicy foods close to bedtime',
            cardData: DinnerCardData.cardData,
          ),
        ],
      ),
    );
  }
}

class DietCard extends StatelessWidget {
  final String title;
  final List<Color> gradientColors;
  final String image;
  final String details;
  final List<Map<String, String>> cardData;

  const DietCard({
    required this.title,
    required this.gradientColors,
    required this.image,
    required this.details,
    required this.cardData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DietOptionsScreen(title: title, cardData: cardData),
            ),
          );
        },
        child: Container(
          height: 140,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: 200,
                    child: Text(
                      details,
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Image.asset(
                image,
                width: 80.0, // Adjust the width as needed
                height: 80.0, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

