import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/Screens/MedicineTracker/MedicineDetail.dart';
import 'package:genesis_flutter/Screens/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/Screens/SignInPage.dart';
import 'package:genesis_flutter/Screens/SplashScreen.dart';
import 'package:genesis_flutter/Screens/MedicineTracker/AddMedicineScreen.dart';
import 'package:genesis_flutter/common/new_entery.dart';
import 'package:genesis_flutter/global_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:genesis_flutter/color.dart';
import 'package:provider/provider.dart';




Color purple = Color(0xFF514B6F);
Color textCol = Color(0xFF393451);
Color pinkColor = const Color(0xFFEDA8CC);
Color myTealColor = Color(0xFF40ABA6);
Color darkPink = Color(0xFFD34389);
Color pink1 = Color(0xFFFF69B4);
Color lightPink = Color(0xFFFF69B4).withOpacity(0.8);
Color lightPurple = Color(0xFFB2B2FF).withOpacity(0.8);

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
                appBarTheme: AppBarTheme(
                  color: Colors.white,
                  // Set the background color of the app bar to white
                  elevation: 2,
                ),
                textTheme: TextTheme(
                    headline4: TextStyle(
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
            home: AddMedicineScreen(),
            routes: {
              '/home': (context) => BaseScreen(),
            },
          ),
        );

  }
}