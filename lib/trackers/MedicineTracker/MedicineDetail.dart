import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_flutter/trackers/MedicineTracker/Medicine.dart';
import 'package:genesis_flutter/NavScreen/HomePage.dart';
import 'package:genesis_flutter/common/convert_time.dart';
import 'package:genesis_flutter/common/new_entery.dart';
import 'package:genesis_flutter/global_bloc.dart';
import 'package:genesis_flutter/model/error.dart';
import 'package:genesis_flutter/model/medicine_type.dart';
import 'package:genesis_flutter/trackers/MedicineTracker/SuccessfulMedAddScreen.dart';
import 'package:provider/provider.dart';


Color purple = const Color(0xFF514B6F);
Color textCol = const Color(0xFF393451);
Color pinkColor =  const Color(0xFFEDA8CC);
Color myTealColor = const Color(0xFF40ABA6);

class MedicineDetails extends StatefulWidget {
  const MedicineDetails( {Key? key}) : super(key: key);

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  late TextEditingController medNameController;
  late TextEditingController dosageController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NewEntryBloc _newEntryBloc;

  @override
  void dispose() {
    super.dispose();
    medNameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    medNameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initialisedNotifications();
    _newEntryBloc = NewEntryBloc();
    initialiseErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Tracker'),
      ),
      body: SingleChildScrollView(
        child: Provider<NewEntryBloc>.value(
          value: _newEntryBloc,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input fields for medicine name and dosage
                const SizedBox(height: 20,),
                TextField(
                  controller: medNameController,
                  decoration: InputDecoration(
                    labelText: 'Medicine Name',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    hintStyle: TextStyle(
                        color: textCol,
                        fontWeight: FontWeight
                            .w500), // Set hint text color to a lighter shade
                    fillColor:
                        Colors.white, // Set the background color of the text box
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: dosageController,
                  decoration: const InputDecoration(labelText: 'Dosage (mg)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 40.0),

                // Medicine options in cards

                Text(
                  "Select Medicine type",
                  style: TextStyle(
                      color: textCol, fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15.0),
                StreamBuilder<MedicineType>(
                  stream: _newEntryBloc.selectedMedicineType,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MedicineTypeColumn(
                            medicineType: MedicineType.pills,
                            name: "Pills",
                            iconValue: "assets/icons/pills_icon.svg",
                            isSelected: snapshot.data == MedicineType.pills
                                ? true
                                : false),
                        MedicineTypeColumn(
                            medicineType: MedicineType.tablet,
                            name: "Tablets",
                            iconValue: "assets/icons/tablet_icon.svg",
                            isSelected: snapshot.data == MedicineType.tablet
                                ? true
                                : false),
                        MedicineTypeColumn(
                            medicineType: MedicineType.vaccine,
                            name: "Vaccine",
                            iconValue: "assets/icons/vacine_icon.svg",
                            isSelected: snapshot.data == MedicineType.vaccine
                                ? true
                                : false),
                        MedicineTypeColumn(
                            medicineType: MedicineType.syrup,
                            name: "Syrup",
                            iconValue: "assets/icons/syrup_icon.svg",
                            isSelected: snapshot.data == MedicineType.syrup
                                ? true
                                : false),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40.0),

                Text(
                  "Select Interval",
                  style: TextStyle(
                      color: textCol, fontSize: 18, fontWeight: FontWeight.w500),
                ),

                const IntervalSelection(),

                const SizedBox(height: 40.0),
                Text(
                  "Starting Time",
                  style: TextStyle(
                      color: textCol, fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SelectTime(),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 50, right: 50),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: purple,
                      shape: const StadiumBorder(),
                      elevation: 8,
                    ),
                    onPressed: () {

                      String? medicineName;
                      int? dosage;
                      if(medNameController.text == ""){
                        _newEntryBloc.submitError(EntryError.nameNull);
                        return;
                      }
                      if(medNameController.text != ""){
                        medicineName = medNameController.text;
                      }
                      if(dosageController.text == ""){
                         dosage=0;
                      }
                      if(dosageController.text != ""){
                        dosage = int.parse(dosageController.text);
                      }


                      for(var medicine in globalBloc.medicineList$!.value) {

                        if (medicineName == medicine.medicineName) {
                          _newEntryBloc.submitError(EntryError.nameDuplicate);
                          return;
                        }

                      }
                        if(_newEntryBloc.selectedIntervals!.value == 0){
                          _newEntryBloc.submitError(EntryError.interval);
                          return ;
                        }
                        if(_newEntryBloc.selectedTimeOfDay$!.value == 'none'){
                          _newEntryBloc.submitError(EntryError.startTime);
                          return ;
                        }

                        String medicineType = _newEntryBloc
                        .selectedMedicineType!.value
                        .toString()
                        .substring(13);

                        int interval = _newEntryBloc.selectedIntervals!.value;
                        print("interval: $interval");
                        String startTime = _newEntryBloc.selectedTimeOfDay$!.value;
                        print("start time: $startTime");

                        List<int> intIDs = makeIDs(
                          24/_newEntryBloc.selectedIntervals!.value
                        );
                        List<String> notificationIDs =
                        intIDs. map((i)=>i.toString()).toList();


                        Medicine newEntryMedicine = Medicine(
                          notificationIDs: notificationIDs,
                          medicineName: medicineName,
                          dosage: dosage,
                          medicineType: medicineType,
                          interval: interval,
                          startTime: startTime
                        );

                        globalBloc.updateMedicineList(newEntryMedicine);
                        scheduleNotification(newEntryMedicine);

                      Navigator.push(
                        context, MaterialPageRoute(builder: (context)=>const SuccessfulMedAddScreen()),
                      );



                    },
                    child: const Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initialiseErrorListen(){
    _newEntryBloc.errorState$!.listen((EntryError error) {
      switch(error){
        case EntryError.nameNull:displayError("Please enter the medicine's name");
        break;
        case EntryError.nameDuplicate:displayError("Medicine name already exists");
        break;
        case EntryError.type:displayError("Medicine type not selected");
        break;
        case EntryError.interval:displayError("Please select the reminder's interval");
        break;
        case EntryError.startTime:displayError("Please select the reminder's starting time");
        break;
        default:

      }
    });
  }

  void displayError(String error){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: pinkColor,
          content: Text(error),
        duration: const Duration(milliseconds: 2000),
      )
    );
  }

  List<int>makeIDs(double n){

    var rnd = Random();
    List<int> ids =[];
    for(int i=0 ; i<n; i++){
      ids.add(rnd.nextInt(1000000000));
    }
      return ids;
  }

  initialisedNotifications() async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initialisationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initialisationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future onSelectNotification(String? payload) async{
    if(payload !=null){
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context,MaterialPageRoute(
        builder:(context)=> const HomePage(initialWeek: 8,)) );
  }

  Future<void > scheduleNotification(Medicine medicine) async{
    var hour = int.parse(medicine.startTime![0]+ medicine.startTime![1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime![2]+medicine.startTime![3]);

    var androidPlatformChannelSpecifies = const AndroidNotificationDetails(
    'repeatDailyAtTime channel id', 'repeatDailyAtTime channel name',
    importance: Importance.max,
     // ledColor: Colors.pink[100],
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifies,
      iOS: iOSPlatformChannelSpecifics
    );

    for(int i = 0;i<(24/medicine.interval!).floor();i++){
      if(hour + (medicine.interval! * i)> 23){
        hour = hour +(medicine.interval!*i)-24;
      }else{
        hour= hour +(medicine.interval! * i);
      }
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        int .parse(medicine.notificationIDs![i]),
          'Reminder: ${medicine.medicineName}',
          medicine.medicineType.toString() !=MedicineType.none.toString()?
          'It is time to take your ${medicine.medicineType!.toLowerCase()}, according to schedule':
          'It is time to take your medicine, according to schedule',
          Time(hour, minute, 0),
          platformChannelSpecifics);
      hour = ogValue;
    }
  }



}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _interval = [6, 8, 10, 12];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {

    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Remind me everyday: ",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          DropdownButton(
              iconEnabledColor: myTealColor,
              dropdownColor: Colors.white,
              hint: _selected == 0
                  ? Text(
                      "Select an Interval",
                      style: TextStyle(
                        fontSize: 14,
                        color: myTealColor,
                      ),
                    )
                  : null,
              elevation: 4,
              value: _selected == 0 ? null : _selected,
              items: _interval.map((int value) {
                return DropdownMenuItem(
                    value: value,
                    child: Text(value.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: textCol,
                        )));
              }).toList(),
              onChanged: (newVal) {
                setState(
                  () {
                    _selected = newVal!;
                    newEntryBloc.updateInterval(newVal);
                  },
                );
              }),
          Text(
            _selected == 1 ? "hour" : "hours",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectTime extends StatefulWidget {
  const SelectTime({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime() async {

    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context, listen: false);
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
         newEntryBloc.updateTime(convertTime(_time.hour.toString())+convertTime(_time.minute.toString()));
      });
    }
    return picked!;
  }

  @override
  Widget build(BuildContext context) {
   // final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);

    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: purple, shape: const StadiumBorder()),
          onPressed: () {
            _selectTime();
            // String newTime = convertTime(_time.hour.toString())+convertTime(_time.minute.toString());
            // newEntryBloc.updateTime(newTime);
          },
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(
              _clicked == false
                  ? "Select Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {Key? key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected})
      : super(key: key);

  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);

    return GestureDetector(
      onTap: () {
        //isSelected = !isSelected;
        newEntryBloc.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                  color: isSelected ? pinkColor : Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  iconValue,
                  width: 50, // Adjust the width as needed
                  height: 50,
                  color: isSelected ? Colors.white : pinkColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8), // Adjust the spacing between the icon and text
          Container(
            decoration: BoxDecoration(
                color: isSelected ? pinkColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
