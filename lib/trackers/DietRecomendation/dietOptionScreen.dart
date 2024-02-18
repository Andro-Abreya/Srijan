import 'package:flutter/material.dart';
import 'package:genesis_flutter/DietRecomendation/DietData/breakfastData.dart';

const greyColor = Color(0xFFD9D9D9);

class DietOptionsScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> cardData;

  DietOptionsScreen({
    required this.title,
    required this.cardData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20.0, left: 20),
            child: Text(
              "Your ${title} Options ",
              style: TextStyle(
                color: Color(0xFF393451),
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
          Expanded
            (child: DietOptionsList(cardData: cardData)),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DietOptionsList extends StatelessWidget {
  final List<Map<String, String>> cardData;

  DietOptionsList({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cardData.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, String> data = cardData[index];

        return DayDishesCard(
          cardno: index,
          day: data['day']!,
          option: data['option']!,
          imagePath: data['imagePath']!,
        );
      },
    );
  }
}

class DayDishesCard extends StatelessWidget {
  final int cardno;
  final String day;
  final String option;
  final String imagePath;

  const DayDishesCard({
    required this.day,
    required this.option,
    required this.imagePath,
    required this.cardno,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8),
      child: Container(
        color: Colors.transparent,
        child: Container(
          height: 150, // Set the desired height of the card
          child: Row(
            children: [
              if (cardno.isOdd) // If index is odd, display image first
                Container(
                  width: 150, // Set the desired width of the image container
                  height: double.infinity, // Match the height of the card
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover, // Ensure the image covers the entire container
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            color: Color(0xFF393451),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          option,
                          style: TextStyle(
                            color: Color(0xFF393451),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!cardno.isOdd) // If index is even, display image after text
                Container(
                  width: 150, // Set the desired width of the image container
                  height: double.infinity, // Match the height of the card
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover, // Ensure the image covers the entire container
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}





