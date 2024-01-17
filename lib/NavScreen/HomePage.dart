import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genesis_flutter/CommunityReq/helper_function.dart';
import 'package:genesis_flutter/appointments/SelectDetails.dart';
import 'package:genesis_flutter/chatbot/ChatBot.dart';
import 'package:genesis_flutter/trackers/YogaTracker/YogaPoseDetection/Views/PoseDetectorView.dart';
import 'package:genesis_flutter/trackers/YogaTracker/YogaTypesUI/yoga_tipes.dart';
import '../trackers/BreastFeedingTracker/breast_feeding_tracker.dart';
import 'package:genesis_flutter/trackers/MedicineTracker/AddMedicineScreen.dart';

Color lightPurple = const Color(0xFFB2B2FF).withOpacity(0.8);
Color purpleColor1 = Color(0xFF9A4EAE);
Color purpleColor2 = Color(0xFF9A4EAE).withOpacity(0.8);
Color purpleColor3 = Color(0xFF9A4EAE).withOpacity(0.6);
Color customPurpleColor = Color(0xFF4E2A84);
Color darkPink = const Color(0xFFD34389);
Color pink1 = const Color(0xFFFF69B4);
Color lightPink = const Color(0xFFFF69B4).withOpacity(0.8);
Color pinkColor = const Color(0xFFEDA8CC);
Color pinkColor2 = const Color(0xFFEDA8CC).withOpacity(0.6);
Color pinkColor3 = const Color(0xFFEDA8CC).withOpacity(0.4);

class HomePage extends StatefulWidget {
  final int initialWeek;
  const HomePage({Key? key, required this.initialWeek}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double progress;
  late int currentWeek;

  @override
  void initState() {
    super.initState();
    loadJoinDate();
  }
  Future<void> loadJoinDate() async {
    DateTime? joinDate = await HelperFunctions.getJoinDate();

    if (joinDate != null) {
      calculateProgress(joinDate);
    } else {
      // If join date is not available, set default progress
      setDefaultProgress();
    }
  }
  void calculateProgress(DateTime joinDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(joinDate);
    currentWeek = (difference.inDays / 7).ceil();
    progress = (currentWeek+widget.initialWeek) / 40.0;
  }
  void setDefaultProgress() {
    progress = widget.initialWeek/ 40.0;
  }

  Widget build(BuildContext context) {

    double progress = widget.initialWeek / 40.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [


              Stack(
                  alignment: Alignment.topCenter,
                  children: [

                    OverlappingBackground(),


                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CenterPicture(progress: progress),
                        ),

                        WeekScroll(currentWeek: widget.initialWeek),
                        SizedBox(height: 15,),
                        Text("Week: ${widget.initialWeek}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                      ],
                    ),
                  ]
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const YogaTypes()));
                          },
                          child: Container(

                            child: Column(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.asset(
                                        'assets/images/yoga_card.png',
                                        width: 80, // Adjust the width as needed
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 120,
                                  child: Center(
                                    child: Text('Yoga Tracker',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),),
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AddMedicineScreen()));
                          },
                          child: Container(
                            // width: 200,
                            // height: 150,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.asset(
                                        'assets/images/medicine.png',
                                        width: 80, // Adjust the width as needed
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 120,
                                  child: Center(
                                    child: Text('Medicine Store',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),),
                                  ),
                                ),


                              ],
                            ),
                          ),
                        )
                      ],

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right:20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const   BreastFeedingScreen()));
                          },
                          child: Container(
                            // width: 100,
                            // height: 150,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.asset(
                                        'assets/images/bf.png',
                                        width: 80, // Adjust the width as needed
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 120,
                                  child: Center(
                                    child: Text('BreastFeeding',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),),
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ChatBot()));
                          },
                          child: Container(
                            // width: 100,
                            // height: 150,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.asset(
                                        'assets/images/chat_bot.png',
                                        width: 80, // Adjust the width as needed
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 120,
                                  child: Center(
                                    child: Text('Chat Bot',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),),
                                  ),
                                ),


                              ],
                            ),
                          ),
                        )

                      ],

                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );


  }

}


class WeekScroll extends StatelessWidget {
  final int currentWeek;

  const WeekScroll({Key? key, required this.currentWeek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set the initial scroll offset to center the currentWeek
    final initialScrollOffset = (currentWeek - 1) * 44.0; // Adjust the item width and margin

    return Stack(
      children: [
        Container(
          height: 90,
          width: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 40,
            controller: ScrollController(initialScrollOffset: initialScrollOffset),
            itemBuilder: (context, index) {
              final isCurrentWeek = index == currentWeek - 1;

              return Container(
                width: isCurrentWeek ? 70 : 50, // Adjust the width of each week item
                height: 70,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentWeek ? Colors.white : (index < currentWeek ? purpleColor1 : Colors.pink[100]),
                ),
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                    color: isCurrentWeek ? purpleColor1 : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
class OverlappingBackground extends StatelessWidget {
  const OverlappingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[

          Container(
            height:380,
            width: double.infinity,
            decoration: BoxDecoration(
              color:pinkColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(200.0,80),bottomRight: Radius.elliptical(200,80)),
            ),
          ),

          Container(
            height:395,
            width: double.infinity,
            decoration: BoxDecoration(
              color:pinkColor2,
              borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(200.0,80),bottomRight: Radius.elliptical(200,80)),
            ),
          ),

          Container(
            height:410,
            width: double.infinity,
            decoration: BoxDecoration(
              color:pinkColor3,
              borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(200.0,80),bottomRight: Radius.elliptical(200,80)),
            ),
          ),

        ]

    );
  }
}
class CenterPicture extends StatelessWidget {
  final double progress;
  const CenterPicture({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height:180,
      child: Stack(
        children: [

          CustomPaint(
            painter: ProgressPainter(progress),
            child: const SizedBox(
              width: double.infinity, // Adjust the size of the progress bar
              height: double.infinity,
            ),
          ),

          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
                color: Colors.transparent
            ),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: ClipOval(
                child: Container(
                  width: 160, // Adjust the size of the baby picture
                  height: 160,
                  child: Image.asset(
                    'assets/images/baby_image.png', // Replace with the actual path to your baby image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );

  }
}
class ProgressPainter extends CustomPainter {
  final double progress;

  ProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 180 / 2;

    // Draw the unprogressed portion in grey
    Paint greyPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10 // Adjust the thickness of the progress bar
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(radius, radius), radius, greyPaint);

    // Draw the progressed portion in blue
    Paint bluePaint = Paint()
      ..color =Colors.pinkAccent
      ..strokeWidth = 10 // Adjust the thickness of the progress bar
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double angle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: Offset(radius, radius), radius: radius), -pi / 2, angle, false, bluePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
