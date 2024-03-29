import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:genesis_flutter/CommonChatPlatform/questions_reply.dart';
import 'package:genesis_flutter/NavScreen/AidPage.dart';
import 'package:genesis_flutter/NavScreen/CommunityPage.dart';
import 'package:genesis_flutter/NavScreen/HomePage.dart';
import 'package:genesis_flutter/NavScreen/ProfilePage.dart';


Color cardColor = const Color(0xFF514B6F);

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<BaseScreen> {
  int _currentIndex = 0;

  final List<Widget> _fragments = [
    const HomePage(initialWeek: 8),
    QnAApp(),
    const AidPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _fragments[_currentIndex],
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: cardColor,
          cornerRadius: 0,
          height: 50, // Navigation bar background color
          style: TabStyle.reactCircle, // Modern style
          curveSize: 90, // Curve size for the icons
          items: const [
            TabItem(
              icon: Icons.home,
              title: 'Home',
            ),
            TabItem(
              icon: Icons.people,
              title: 'Community',
            ),
            TabItem(
              icon: Icons.local_hospital,
              title: 'Aid',
            ),
            TabItem(
              icon: Icons.person,
              title: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}