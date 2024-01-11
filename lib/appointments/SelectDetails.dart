import 'package:flutter/material.dart';
import 'package:lightweight_calendar/lightweight_calendar.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:genesis_flutter/appointments/DoctorList.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class SelectDetails extends StatefulWidget {
  const SelectDetails({super.key});

  @override
  State<SelectDetails> createState() => _SelectDetailsState();
}

class _SelectDetailsState extends State<SelectDetails> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  String amPm = DateTime.now().hour < 12 ? 'AM' : 'PM';

  Time _time = Time(hour: TimeOfDay.now().hour, minute:TimeOfDay.now().minute);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
      amPm = _time.hour < 12 ? 'AM' : 'PM';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book an appointment',
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Select Date',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            CalendarApp(
              startDate: DateTime(2024, 1, 1),
              selectedDecoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              onSelectedDate: (date) {
                print(date);
              },
              endDate: DateTime.now().add(const Duration(days: 10)),
              enablePredicate: (date) {
                if (date.isAfter(DateTime.now())) {
                  return true;
                } else {
                  if (checkSameDay(date, DateTime.now())) {
                    return true;
                  }
                  return false;
                }
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Select Time :',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  InkWell(
                    onTap: () async{
                    Navigator.of(context).push(
                      await showPicker(
                        showSecondSelector: false,
                        context: context,
                        value: _time,

                        onChange: onTimeChanged,
                        minuteInterval: TimePickerInterval.THIRTY,
                        // Optional onChange to receive value as DateTime
                        onChangeDateTime: (DateTime dateTime) {
                          // print(dateTime);
                          debugPrint("[debug datetime]:  $dateTime");
                        },
                      ),
                    );
                  },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            '${_time.hour <= 12 ? (_time.hour < 10?"0${_time.hour.toString()}":_time.hour.toString()) : (_time.hour-12 < 10?"0${(_time.hour-12).toString()}":(_time.hour-12).toString())} : ${_time.minute < 10?"0${_time.minute.toString()}":_time.minute.toString()} $amPm',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.purple[700]),),
                            SizedBox(width: 10,),
                  Icon(Icons.edit_note,size: 30,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => DoctorList()))
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.purple[700],
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
