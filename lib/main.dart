import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/Screens/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/Screens/SignInPage.dart';
import 'package:genesis_flutter/Screens/SplashScreen.dart';
import 'package:genesis_flutter/Screens/CreateProfile.dart';



Future  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          color: Colors.white, // Set the background color of the app bar to white
          elevation: 2,
        )
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => BaseScreen(),
      },
    );
  }
}




