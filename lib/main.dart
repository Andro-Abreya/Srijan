import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/onboarding/CreateProfile.dart';
import 'package:genesis_flutter/onboarding/SplashScreen.dart';
import 'package:genesis_flutter/global_bloc.dart';
import 'package:genesis_flutter/trackers/YogaTracker/YogaTypesUI/yoga_tipes.dart';
import 'package:provider/provider.dart';




Color purple = const Color(0xFF514B6F);
Color textCol = const Color(0xFF393451);
Color pinkColor = const Color(0xFFEDA8CC);
Color myTealColor = const Color(0xFF40ABA6);
Color darkPink = const Color(0xFFD34389);
Color pink1 = const Color(0xFFFF69B4);
Color lightPink = const Color(0xFFFF69B4).withOpacity(0.8);
Color lightPurple = const Color(0xFFB2B2FF).withOpacity(0.8);

Future  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() =>_MyAppState();
}

class _MyAppState extends State<MyApp>{
  GlobalBloc?globalBloc;

  @override
  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

        return Provider<GlobalBloc>.value(
            value: globalBloc!,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  color: Colors.white,
                  // Set the background color of the app bar to white
                  elevation: 2,
                ),
                textTheme: TextTheme(
                    headlineMedium: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: textCol,
                    )),
                timePickerTheme: TimePickerThemeData(
                  dialHandColor: Colors.white,
                  hourMinuteColor: pinkColor,
                  hourMinuteTextColor: Colors.white,
                  dayPeriodColor: pinkColor,
                  dayPeriodTextColor: Colors.white,
                  dialTextColor: purple,
                  entryModeIconColor: myTealColor,
                  dialBackgroundColor: pinkColor,
                )),
            home: SplashScreen(),//const SplashScreen(),
            routes: {
              '/home': (context) => const BaseScreen(),
            },
          ),
        );

  }
}