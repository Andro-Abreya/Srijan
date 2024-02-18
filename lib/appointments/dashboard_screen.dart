import 'package:flutter/material.dart';
import 'package:genesis_flutter/NavScreen/AidPage.dart';
import 'package:genesis_flutter/NavScreen/BaseScreen.dart';
import 'package:genesis_flutter/appointments/SelectDetails.dart';
import 'package:genesis_flutter/appointments/color.dart';
import 'package:genesis_flutter/appointments/create_screen.dart';
import 'package:genesis_flutter/appointments/edit_screen.dart';
import 'package:genesis_flutter/appointments/storage.dart';
import 'package:google_meet_sdk/google_meet_sdk.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => (BaseScreen())));
            },
            icon: Icon(Icons.arrow_back)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: const Text(
          'Your Appointments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.darkCyan,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SelectDetails(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 8.0),
          color: Colors.white,
          child: StreamBuilder(
            stream: storage.retrieveEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> eventInfo1 =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                      Map<String, dynamic> eventInfo =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;

                      GoogleMeetEventInfo event =
                          GoogleMeetEventInfo.fromMap(eventInfo);
                      DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
                          event.startTimeInEpoch);
                      DateTime endTime = DateTime.fromMillisecondsSinceEpoch(
                          event.endTimeInEpoch);

                      String startTimeString =
                          DateFormat.jm().format(startTime);
                      String endTimeString = DateFormat.jm().format(endTime);
                      String dateString = DateFormat.yMMMMd().format(startTime);

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Card(
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditScreen(event: event),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                          bottom: 6.0,
                                          top: 6.0,
                                          left: 16.0,
                                          right: 16.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Meet with Dr Abhishek',
                                              style: const TextStyle(
                                                color: CustomColor.darkBlue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            // Text(
                                            //   event.description,
                                            //   maxLines: 2,
                                            //   overflow: TextOverflow.ellipsis,
                                            //   style: const TextStyle(
                                            //     color: Colors.black38,
                                            //     fontWeight: FontWeight.bold,
                                            //     fontSize: 16,
                                            //     letterSpacing: 1,
                                            //   ),
                                            // ),

                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       top: 8.0, bottom: 8.0),
                                            //   child: Text(
                                            //     'ahabh',

                                            //    // event.link,
                                            //     style: TextStyle(
                                            //       color: CustomColor.darkBlue
                                            //           .withOpacity(0.5),
                                            //       fontWeight: FontWeight.bold,
                                            //       fontSize: 16,
                                            //       letterSpacing: 0.5,
                                            //     ),
                                            //   ),
                                            // ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 3,
                                                  color: CustomColor.neonGreen,
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dateString,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'OpenSans',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$startTimeString - $endTimeString',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'OpenSans',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 30),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.blue[300]),
                                                child: Text(
                                                  'Join Meeting',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                            height: 80,
                                            width: 80,
                                            child: Image.asset(
                                              'assets/images/baby_image.png',
                                              fit: BoxFit.cover,
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No Events',
                      style: TextStyle(
                        color: Colors.black38,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(CustomColor.seaBlue),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
// Container(
//                                               width: double.infinity,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(20.0),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Colors.grey
//                                                         .withOpacity(0.5),
//                                                     spreadRadius: 3,
//                                                     blurRadius: 4,
//                                                     offset: Offset(
//                                                         0, 3), // Shadow offset
//                                                   ),
//                                                 ],
//                                               ),
//                                               margin: EdgeInsets.only(top: 8),
//                                               child: Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 20.0,
//                                                             top: 12,
//                                                             bottom: 12,
//                                                             right: 8),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                           'Meet with Dr. John',
//                                                           style: TextStyle(
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           width: 130,
//                                                           child: Text(
//                                                             'Tuesday August 20 at 10:00 am',
//                                                             style: TextStyle(
//                                                               fontSize: 14,
//                                                               color:
//                                                                   Colors.grey,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         InkWell(
//                                                           onTap: () async {
//                                                             // Navigator.of(context).push(MaterialPageRoute(
//                                                             //     builder: (_) => const AddMedicineScreen()));//Add meeting link
//                                                           },
//                                                           child: Container(
//                                                             width: 120,
//                                                             padding:
//                                                                 EdgeInsets.all(
//                                                                     8),
//                                                             decoration: BoxDecoration(
//                                                                 color: Colors.grey
//                                                                     .withOpacity(
//                                                                         0.3),
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10)),
//                                                             child: Center(
//                                                               child: Text(
//                                                                 'Join Meeting',
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize: 14,
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             right: 20.0,
//                                                             top: 12),
//                                                     child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20.0),
//                                                       // Adjust the radius as needed
//                                                       child: Image.asset(
//                                                         'assets/images/nadi.png',
//                                                         fit: BoxFit.cover,
//                                                         height: 100,
//                                                         width: 100,
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
                                            