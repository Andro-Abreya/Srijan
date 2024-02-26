import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:genesis_flutter/appointments/appointment_info.dart';
import 'package:genesis_flutter/appointments/color.dart';
import 'package:genesis_flutter/appointments/confirmation_page.dart';
import 'package:genesis_flutter/appointments/dashboard_screen.dart';
import 'package:genesis_flutter/appointments/storage.dart';
import 'package:google_meet_sdk/google_meet_sdk.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AppointmentDetails extends StatefulWidget {
  const AppointmentDetails({super.key});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  int selectedOption = 0;
  int step = 0;

  DocumentSnapshot<Map<String, dynamic>>? docSnapshot;

  Storage storage = Storage();
  CalendarClient calendarClient = CalendarClient();

  TextEditingController? textControllerDate;
  TextEditingController? textControllerStartTime;
  TextEditingController? textControllerEndTime;
  TextEditingController? textControllerTitle;
  TextEditingController? textControllerDesc;
  TextEditingController? textControllerLocation;
  TextEditingController? textControllerAttendee;

  FocusNode? textFocusNodeTitle;
  FocusNode? textFocusNodeDesc;
  FocusNode? textFocusNodeLocation;
  FocusNode? textFocusNodeAttendee;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  String? currentTitle = "";
  String? currentDesc = "";
  String? currentLocation = "Srijan App";
  String errorString = '';
  List<String> attendeeEmails = ["abhishekb.it.21@nitj.ac.in.com"];
  // FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  bool isEditingDate = false;
  bool isEditingStartTime = false;
  bool isEditingEndTime = false;
  bool isEditingBatch = false;
  bool isEditingTitle = false;
  bool isEditingEmail = false;
  bool isEditingLink = false;
  bool isErrorTime = false;
  bool shouldNofityAttendees = false;
  bool hasConferenceSupport = false;

  bool isDataStorageInProgress = false;
  Map<String,dynamic>? paymentIntent;

  makePayment()async{
    try {
      //  Future<Map<String, dynamic>> paymentIntent = createPaymentIntent();
       paymentIntent = await createPaymentIntent();
        var gpay = const PaymentSheetGooglePay(merchantCountryCode: "IN",
        currencyCode: "INR",
        testEnv: true);

       await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          // customFlow: true,
          // customerId: data['customer'],
          style: ThemeMode.dark,
          merchantDisplayName: "Srijan",
          googlePay: gpay
        ));

        displayPaymentSheet();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  
  void displayPaymentSheet() async
  {
    try{
      
      await Stripe.instance.presentPaymentSheet();
      print("Done");
    }catch(e){
      print("Failed+ ${e}");
    }
  }

 createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "1000",
        "currency": "INR",
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer sk_test_51OkaGqSHCLJG2NE0q78fwKo1xvzLji61EZHxacL11e0T0FOIDYRS4FkjMxziISvCMk7zqIDSYXmaiTorC2VVOmr600YSYVfQsb",
            "Content-Type": "application/x-www-form-urlencoded",
          });
          return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        textControllerDate?.text = DateFormat.yMMMMd().format(selectedDate);
      });
    }
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        textControllerStartTime?.text = selectedStartTime.format(context);
      });
    } else {
      setState(() {
        textControllerStartTime?.text = selectedStartTime.format(context);
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
        textControllerEndTime?.text = selectedEndTime.format(context);
      });
    } else {
      setState(() {
        textControllerEndTime?.text = selectedEndTime.format(context);
      });
    }
  }

  String? _validateTitle(String value) {
    if (value.isNotEmpty) {
      value = value.trim();
      if (value.isEmpty) {
        return 'Title can\'t be empty';
      }
    } else {
      return 'Title can\'t be empty';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isNotEmpty) {
      value = value.trim();
      if (value.isEmpty) {
        return 'Can\'t add an empty email';
      } else {
        final regex = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
        final matches = regex.allMatches(value);
        for (Match match in matches) {
          if (match.start == 0 && match.end == value.length) {
            return null;
          }
        }
      }
    } else {
      return 'Can\'t add an empty email';
    }
    return 'Invalid email';
  }

  @override
  void initState()  {
    getData();
    textControllerDate = TextEditingController();
    textControllerStartTime = TextEditingController();
    textControllerEndTime = TextEditingController();
    textControllerTitle = TextEditingController();
    textControllerDesc = TextEditingController();
    textControllerLocation = TextEditingController();
    textControllerAttendee = TextEditingController();

    textFocusNodeTitle = FocusNode();
    textFocusNodeDesc = FocusNode();
    textFocusNodeLocation = FocusNode();
    textFocusNodeAttendee = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final uid = user?.displayName;
    print(docSnapshot?.data());

    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    attendeeEmails.add(data['email']);
    debugPrint(attendeeEmails.toString());
    currentTitle = "Appointment of ${uid} with ${data['name']}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Appointment Details')),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              data['imageUrl'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('${data['speciality']} - ${data['qual']}'),
                              // More details...
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Appointment details section
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.purple,
                                  ),
                                  child: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '${data['date'].day} / ${data['date'].month} / ${data['date'].year}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.purple,
                                  ),
                                  child: Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  data['time']!.hour >= 12
                                      ? data['time'].hour > 12
                                          ? '${data['time'].hour - 12} : ${data['time'].minute} PM'
                                          : '${data['time'].hour} : ${data['time'].minute}'
                                      : '${data['time'].hour} : ${data['time'].minute} AM',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            'Choose your plan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Card 1
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedOption = 0),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 156, 39, 176),
                                          width: 2),
                                      color: selectedOption == 0
                                          ? Colors.purple
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '30 Minute Online Video Appointment\n₹ 500',
                                          style: TextStyle(
                                              color: selectedOption != 0
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        Radio(
                                          activeColor: Colors.white,
                                          value: 0,
                                          groupValue: selectedOption,
                                          onChanged: (value) => setState(() =>
                                              selectedOption = value! as int),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                // Card 2
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedOption = 1),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 156, 39, 176),
                                          width: 2),
                                      color: selectedOption == 1
                                          ? Colors.purple
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '30 Minute Online Video Appointment \n+ Chat Support for 3 days \n₹ 600',
                                          style: TextStyle(
                                              color: selectedOption == 0
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        Radio(
                                          value: 1,
                                          activeColor: Colors.white,
                                          groupValue: selectedOption,
                                          onChanged: (value) => setState(() =>
                                              selectedOption = value! as int),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, right: 32, left: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount payable',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  selectedOption == 0 ? '₹ 500' : '₹ 600',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(12)),
                      width: double.maxFinite,
                      child: InkWell(
                        // elevation: 0,
                        // focusElevation: 0,
                        // highlightElevation: 0,
                        // color: CustomColor.seaBlue,
                        onTap: isDataStorageInProgress
                            ? null
                            : () async {

                              //await makePayment();

                                setState(() {
                                  isErrorTime = false;
                                  isDataStorageInProgress = true;
                                });

                                textFocusNodeTitle?.unfocus();
                                textFocusNodeDesc?.unfocus();
                                textFocusNodeLocation?.unfocus();
                                textFocusNodeAttendee?.unfocus();

                                if (currentTitle != null) {
                                  int startTimeInEpoch = DateTime(
                                    data['date'].year,
                                    data['date'].month,
                                    data['date'].day,
                                    data['time'].hour,
                                    data['time'].minute,
                                  ).millisecondsSinceEpoch;

                                  int endTimeInEpoch =
                                      data['time'].minute + 30 > 60
                                          ? DateTime(
                                              data['date'].year,
                                              data['date'].month,
                                              data['date'].day,
                                              data['time'].hour + 1,
                                              data['time'].minute - 30,
                                            ).millisecondsSinceEpoch
                                          : DateTime(
                                              data['date'].year,
                                              data['date'].month,
                                              data['date'].day,
                                              data['time'].hour,
                                              data['time'].minute + 30,
                                            ).millisecondsSinceEpoch;
                                  if (endTimeInEpoch - startTimeInEpoch > 0) {
                                    if (_validateTitle(currentTitle ?? "") ==
                                        null) {
                                      await calendarClient
                                          .insert(
                                              title: currentTitle ?? "",
                                              description: currentDesc ?? '',
                                              location: currentLocation ?? "",
                                              attendeeEmailList: attendeeEmails,
                                              shouldNotifyAttendees: true,
                                              hasConferenceSupport: true,
                                              startTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      startTimeInEpoch),
                                              endTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      endTimeInEpoch))
                                          .then((eventData) async {
                                        String eventId = eventData!['id'] ?? "";
                                        String eventLink =
                                            eventData['link'] ?? "";

                                        List<String> emails = [];
                                        for (int i = 0;
                                            i < attendeeEmails.length;
                                            i++) {
                                          emails.add(attendeeEmails[i]);
                                        }

                                        AppointmentInfo eventInfo =
                                            AppointmentInfo(
                                          id: eventId,
                                          name: currentTitle ?? "",
                                          description: currentDesc ?? '',
                                          location: currentLocation ?? "",
                                          link: eventLink,
                                          attendeeEmails: emails,
                                          shouldNotifyAttendees: true,
                                          hasConferencingSupport: true,
                                          startTimeInEpoch: startTimeInEpoch,
                                          endTimeInEpoch: endTimeInEpoch,
                                          speciality: data['speciality'],
                                          dName: data['name'],
                                          dQual: data['qual'],
                                          dImage: data['imageUrl'],
                                          hasChatEnabled: selectedOption == 1
                                              ? true
                                              : false,
                                        );

                                        await storage
                                            .storeEventData(eventInfo)
                                            .whenComplete(() => Navigator.of(
                                                    context)
                                                .pushReplacement(MaterialPageRoute(
                                                    builder: (_) =>
                                                        const ConfirmationPage())));
                                      }).catchError(
                                        (e) {
                                          debugPrint(e);
                                        },
                                      );

                                      setState(() {
                                        isDataStorageInProgress = false;
                                      });
                                    } else {
                                      setState(() {
                                        isEditingTitle = true;
                                        isEditingLink = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      isErrorTime = true;
                                      errorString =
                                          'Invalid time! Please use a proper start and end time';
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isEditingDate = true;
                                    isEditingStartTime = true;
                                    isEditingEndTime = true;
                                    isEditingBatch = true;
                                    isEditingTitle = true;
                                    isEditingLink = true;
                                  });
                                }
                                setState(() {
                                  isDataStorageInProgress = false;
                                });
                               },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: isDataStorageInProgress
                                ? const SizedBox(
                                    height: 28,
                                    width: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Proceed',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isErrorTime,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorString,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

getData() async {
 var collection = FirebaseFirestore.instance.collection('Users');
docSnapshot = await collection.doc('${user?.uid}').get();
if (docSnapshot!.exists) {
  Map<String, dynamic>? data = docSnapshot?.data();
  //var value = data?['some_field']; // <-- The value you want to retrieve. 
  // Call setState if needed.
}
}
}


//   @override
//   Widget build(BuildContext context) {
//     currentTitle = "Appointment";
//     return Scaffold(
//       appBar: AppBar(title: Text('Appointment Details'),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image widget
//               // Doctor details section
//               Padding(
//                 padding: const EdgeInsets.only(top:32.0, left: 16,right: 16),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(40),
//                       child: Image.asset(
//                                       'assets/images/baby_image.png',
//                                       width: 70,
//                                       height: 70,
//                                       fit: BoxFit.cover,
//                                     ),
//                     ),
//                     SizedBox(width: 12,),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Dr. Alice Smith',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text('Gynaecologist - MBBS'),
//                         // More details...
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Appointment details section
//               Padding(
//                 padding:  const EdgeInsets.only(top:32.0, left: 16,right: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Appointment Details',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                      SizedBox(height: 20,),
//                     Container(
//                       child: Row(
//                       children: [
//                         Container(height: 45,
//                         width: 45,
//                         padding: EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.blue[300],
//                         ),
//                         child: Icon(Icons.calendar_month_outlined,color: Colors.white,),
//                         ),
//                        SizedBox(width: 12,), 
//                         Text('20 th February 2024',style: TextStyle( fontWeight: FontWeight.w600, fontSize: 16 ),),
//                       ],
//                     ),),
//                      SizedBox(height: 20,),
//                     Container(
//                       child: Row(
//                       children: [
//                         Container(height: 45,
//                         width: 45,
//                         padding: EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.blue[300],
//                         ),
//                         child: Icon(Icons.access_time,color: Colors.white,),
//                         ),
//                        SizedBox(width: 12,), 
//                         Text('10:00 AM',style: TextStyle( fontWeight: FontWeight.w600, fontSize: 16 ),),
//                       ],
//                     ),),
//                     SizedBox(height: 32,),
//                    Text(
//                       'Choose your plan',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     // More details...
//                   ],
//                 ),
//               ),
//               // Rating selection
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                 // Card 1
//                 GestureDetector(
//                   onTap: () => setState(() => selectedOption = 0),
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: const Color.fromARGB(255, 100, 181, 246),width: 2),
//                       color: selectedOption == 0 ? Colors.blue[300] : Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('30 Minute Online Video Appointment\n₹ 500',
//                         style: TextStyle(color: selectedOption != 0?Colors.black : Colors.white),),
//                         Radio(
//                           activeColor:Colors.white,
//                           value: 0,
//                           groupValue: selectedOption,
//                           onChanged: (value) => setState(() => selectedOption = value! as int),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 // Card 2
//                 GestureDetector(
//                   onTap: () => setState(() => selectedOption = 1),
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: const Color.fromARGB(255, 100, 181, 246),width: 2),
//                       color: selectedOption == 1 ? Colors.blue[300] : Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('30 Minute Online Video Appointment \n+ Chat Support for 3 days \n₹ 600',style: TextStyle(color: selectedOption == 0?Colors.black : Colors.white),),
//                         Radio(
//                           value: 1,
//                           activeColor:Colors.white,
//                           groupValue: selectedOption,
//                           onChanged: (value) => setState(() => selectedOption = value! as int),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                             ],
//                           ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.only(top:16.0,right:32,left:32),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                             'Total Amount payable',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                     Text(selectedOption == 0?
//                             '₹ 500':'₹ 600',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//               // Confirm button
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: 
//                 SizedBox(
//                       width: double.maxFinite,
//                       child: ElevatedButton(
//                         // elevation: 0,
//                         // focusElevation: 0,
//                         // highlightElevation: 0,
//                         // color: CustomColor.seaBlue,
//                         onPressed: 
//                         isDataStorageInProgress
//                             ? null
//                             : () async {
//                                 setState(() {
//                                   isErrorTime = false;
//                                   isDataStorageInProgress = true;
//                                 });

//                                 textFocusNodeTitle?.unfocus();
//                                 textFocusNodeDesc?.unfocus();
//                                 textFocusNodeLocation?.unfocus();
//                                 textFocusNodeAttendee?.unfocus();

//                                 if (currentTitle != null) {
//                                   int startTimeInEpoch = DateTime(
//                                     selectedDate.year,
//                                     selectedDate.month,
//                                     selectedDate.day,
//                                     selectedStartTime.hour,
//                                     selectedStartTime.minute,
//                                   ).millisecondsSinceEpoch;

//                                   int endTimeInEpoch = DateTime(
//                                     selectedDate.year,
//                                     selectedDate.month,
//                                     selectedDate.day,
//                                     selectedEndTime.hour,
//                                     selectedEndTime.minute,
//                                   ).millisecondsSinceEpoch;
//                                   if (endTimeInEpoch - startTimeInEpoch > 0) {
//                                     if (_validateTitle(currentTitle ?? "") ==
//                                         null) {
//                                       await calendarClient
//                                           .insert(
//                                               title: currentTitle ?? "",
//                                               description: currentDesc ?? '',
//                                               location: currentLocation ?? "",
//                                               attendeeEmailList: attendeeEmails,
//                                               shouldNotifyAttendees:
//                                                   true,
//                                               hasConferenceSupport:
//                                                 true,
//                                               startTime: DateTime
//                                                   .fromMillisecondsSinceEpoch(
//                                                       startTimeInEpoch),
//                                               endTime: DateTime
//                                                   .fromMillisecondsSinceEpoch(
//                                                       endTimeInEpoch))
//                                           .then((eventData) async {
//                                         String eventId = eventData!['id'] ?? "";
//                                         String eventLink =
//                                             eventData['link'] ?? "";

//                                         List<String> emails = [];

//                                         for (int i = 0;
//                                             i < attendeeEmails.length;
//                                             i++) {
//                                           emails.add(attendeeEmails[i]);
//                                         }

//                                         GoogleMeetEventInfo eventInfo =
//                                             GoogleMeetEventInfo(
//                                           id: eventId,
//                                           name: currentTitle ?? "",
//                                           description: currentDesc ?? '',
//                                           location: currentLocation ?? "",
//                                           link: eventLink,
//                                           attendeeEmails: emails,
//                                           shouldNotifyAttendees:
//                                               true,
//                                           hasConferencingSupport:
//                                               true,
//                                           startTimeInEpoch: startTimeInEpoch,
//                                           endTimeInEpoch: endTimeInEpoch,
//                                         );

//                                         await storage
//                                             .storeEventData(eventInfo)
//                                             .whenComplete(() =>
//                                                 Navigator.of(context).pop())
//                                             .catchError(
//                                               (e) => debugPrint(e),
//                                             );
//                                       }).catchError(
//                                         (e) {
//                                           debugPrint(e);
//                                         },
//                                       );

//                                       setState(() {
//                                         isDataStorageInProgress = false;
//                                       });
//                                     } else {
//                                       setState(() {
//                                         isEditingTitle = true;
//                                         isEditingLink = true;
//                                       });
//                                     }
//                                   } else {
//                                     setState(() {
//                                       isErrorTime = true;
//                                       errorString =
//                                           'Invalid time! Please use a proper start and end time';
//                                     });
//                                   }
//                                 } else {
//                                   setState(() {
//                                     isEditingDate = true;
//                                     isEditingStartTime = true;
//                                     isEditingEndTime = true;
//                                     isEditingBatch = true;
//                                     isEditingTitle = true;
//                                     isEditingLink = true;
//                                   });
//                                 }
//                                 setState(() {
//                                   isDataStorageInProgress = false;
//                                 });
//                               },
//                         child: Padding(
//                           padding:
//                               const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                           child: isDataStorageInProgress
//                               ? const SizedBox(
//                                   height: 28,
//                                   width: 28,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   ),
//                                 )
//                               : const Text(
//                                   'Proceed',
//                                   style: TextStyle(
//                                     fontFamily: 'Raleway',
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     letterSpacing: 1.5,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }