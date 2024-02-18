// import 'package:flutter/material.dart';
// import 'package:genesis_flutter/appointments/color.dart';
// import 'package:genesis_flutter/appointments/storage.dart';
// import 'package:google_meet_sdk/google_meet_sdk.dart';
// import 'package:intl/intl.dart';

// class CreateScreen extends StatefulWidget {
//   const CreateScreen({super.key});

//   @override
//   State<CreateScreen> createState() => _CreateScreenState();
// }

// class _CreateScreenState extends State<CreateScreen> {
//   Storage storage = Storage();
//   CalendarClient calendarClient = CalendarClient();

//   TextEditingController? textControllerDate;
//   TextEditingController? textControllerStartTime;
//   TextEditingController? textControllerEndTime;
//   TextEditingController? textControllerTitle;
//   TextEditingController? textControllerDesc;
//   TextEditingController? textControllerLocation;
//   TextEditingController? textControllerAttendee;

//   FocusNode? textFocusNodeTitle;
//   FocusNode? textFocusNodeDesc;
//   FocusNode? textFocusNodeLocation;
//   FocusNode? textFocusNodeAttendee;

//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedStartTime = TimeOfDay.now();
//   TimeOfDay selectedEndTime = TimeOfDay.now();

//   String? currentTitle = "Abhishek";
//   String? currentDesc = "Bharti";
//   String? currentLocation="Srijan";
//   String? currentEmail="abhishekbhartirocks1@gmail.com";
//   String errorString = '';
//   List<String> attendeeEmails = ["abhishekbhartirocks1@gmail.com","abhishekb.it.21@nitj.ac.in"];
//   bool isEditingDate = false;
//   bool isEditingStartTime = false;
//   bool isEditingEndTime = false;
//   bool isEditingBatch = false;
//   bool isEditingTitle = false;
//   bool isEditingEmail = false;
//   bool isEditingLink = false;
//   bool isErrorTime = false;
//   bool shouldNofityAttendees = false;
//   bool hasConferenceSupport = false;

//   bool isDataStorageInProgress = false;

//   _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         textControllerDate?.text = DateFormat.yMMMMd().format(selectedDate);
//       });
//     }
//   }

//   _selectStartTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedStartTime,
//     );
//     if (picked != null && picked != selectedStartTime) {
//       setState(() {
//         selectedStartTime = picked;
//         textControllerStartTime?.text = selectedStartTime.format(context);
//       });
//     } else {
//       setState(() {
//         textControllerStartTime?.text = selectedStartTime.format(context);
//       });
//     }
//   }

//   _selectEndTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedEndTime,
//     );
//     if (picked != null && picked != selectedEndTime) {
//       setState(() {
//         selectedEndTime = picked;
//         textControllerEndTime?.text = selectedEndTime.format(context);
//       });
//     } else {
//       setState(() {
//         textControllerEndTime?.text = selectedEndTime.format(context);
//       });
//     }
//   }

//   String? _validateTitle(String value) {
//     if (value.isNotEmpty) {
//       value = value.trim();
//       if (value.isEmpty) {
//         return 'Title can\'t be empty';
//       }
//     } else {
//       return 'Title can\'t be empty';
//     }

//     return null;
//   }

//   String? _validateEmail(String value) {
//     if (value.isNotEmpty) {
//       value = value.trim();

//       if (value.isEmpty) {
//         return 'Can\'t add an empty email';
//       } else {
//         final regex = RegExp(
//             r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
//         final matches = regex.allMatches(value);
//         for (Match match in matches) {
//           if (match.start == 0 && match.end == value.length) {
//             return null;
//           }
//         }
//       }
//     } else {
//       return 'Can\'t add an empty email';
//     }

//     return 'Invalid email';
//   }

//   @override
//   void initState() {
//     textControllerDate = TextEditingController();
//     textControllerStartTime = TextEditingController();
//     textControllerEndTime = TextEditingController();
//     textControllerTitle = TextEditingController();
//     textControllerDesc = TextEditingController();
//     textControllerLocation = TextEditingController();
//     textControllerAttendee = TextEditingController();

//     textFocusNodeTitle = FocusNode();
//     textFocusNodeDesc = FocusNode();
//     textFocusNodeLocation = FocusNode();
//     textFocusNodeAttendee = FocusNode();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(
//           color: Colors.grey, //change your color here
//         ),
//         title: const Text(
//           'Create Event',
//           style: TextStyle(
//             color: CustomColor.darkBlue,
//             fontSize: 22,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.white,
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
                  
//                     SizedBox(
//                       width: double.maxFinite,
//                       child: ElevatedButton(
//                         // elevation: 0,
//                         // focusElevation: 0,
//                         // highlightElevation: 0,
//                         // color: CustomColor.seaBlue,
//                         onPressed: isDataStorageInProgress
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

                                  
//                                   int endTimeInEpoch = selectedStartTime.minute + 30 > 60 ?DateTime(
//                                     selectedDate.year,
//                                     selectedDate.month,
//                                     selectedDate.day,
//                                     selectedStartTime.hour +1,
//                                     selectedStartTime.minute - 30,
//                                   ).millisecondsSinceEpoch
//                                   :
//                                   DateTime(
//                                     selectedDate.year,
//                                     selectedDate.month,
//                                     selectedDate.day,
//                                     selectedStartTime.hour ,
//                                     selectedStartTime.minute + 30,
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
//                                                   true,
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
//                     Visibility(
//                       visible: isErrorTime,
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             errorString,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
