import 'dart:async' show Timer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name;
  final String time;
  final String duration;
  final String left;
  final String right;

  Record({
    required this.name,
    required this.time,
    required this.duration,
    required this.left,
    required this.right,
  });

  Record.fromFirestore(Map<String, dynamic> data)
      : name = data['name'],
        left = data['left'],
        time = data['time'],
        right = data['right'],
        duration = data['duration'];
}

class BreastFeedingScreen extends StatefulWidget {
  const BreastFeedingScreen({super.key});

  @override
  _BreastFeedingScreenState createState() => _BreastFeedingScreenState();
}

class _BreastFeedingScreenState extends State<BreastFeedingScreen> {
  int _seconds1 = 0, _seconds2 = 0;
  Timer? _timer1, _timer2;
  bool _isTimerRunning1 = false, _isTimerRunning2 = false;
  //List<Record> items = [];

  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _startTimer1() {
    _timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds1++;
      });
    });
  }

  void _stopTimer1() {
    _timer1?.cancel();
  }

  void _resetTimer1() {
    setState(() {
      _seconds1 = 0;
    });
    _stopTimer1();
    _isTimerRunning1 = false;
  }

  void _toggleTimer1() {
    if (_isTimerRunning1) {
      _stopTimer1();
    } else {
      _startTimer1();
    }

    setState(() {
      _isTimerRunning1 = !_isTimerRunning1;
    });
  }

  String _formattedTime1() {
    // Format the time as "mm:ss"
    int minutes = _seconds1 ~/ 60;
    int seconds = _seconds1 % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startTimer2() {
    _timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds2++;
      });
    });
  }

  void _stopTimer2() {
    _timer2?.cancel();
  }

  void _resetTimer2() {
    setState(() {
      _seconds2 = 0;
    });
    _stopTimer2();
    _isTimerRunning2 = false;
  }

  void _toggleTimer2() {
    if (_isTimerRunning2) {
      _stopTimer2();
    } else {
      _startTimer2();
    }
    setState(() {
      _isTimerRunning2 = !_isTimerRunning2;
    });
  }

  String _formattedTime2() {
    // Format the time as "mm:ss"
    int minutes = _seconds2 ~/ 60;
    int seconds = _seconds2 % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _storeData() {
    addDataToCollection();
    _resetTimer1();
    _resetTimer2();
    _textFieldController.text = "";
  }

  String _formattedTime() {
    // Format the time as "mm:ss"
    int minutes = (_seconds2 + _seconds1) ~/ 60;
    int seconds = (_seconds2 + _seconds1) % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  final colors = [
    Colors.red[100],
    Colors.blue[100],
    Colors.green[100],
    Colors.pink[100],
    Colors.yellow[100],
    Colors.purple[100],
    Colors.orange[100],
  ];

  Future<List<Record>> getData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth mAuth = FirebaseAuth.instance;

      List<Record> items = [];
      CollectionReference usersRef = firestore
          .collection('Users')
          .doc('${mAuth.currentUser?.uid}')
          .collection("BreastFeedingData");

      QuerySnapshot querySnapshot =
          await usersRef.orderBy('time', descending: true).get();

      for (var doc in querySnapshot.docs) {
        Record item = Record.fromFirestore(doc.data() as Map<String, dynamic>);
        items.add(item);
      }
      // print(items);
      return items;
    } catch (error) {
      rethrow;
    }
  }

  void addDataToCollection() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth mAuth = FirebaseAuth.instance;

    CollectionReference usersRef = firestore
        .collection('Users')
        .doc('${mAuth.currentUser?.uid}')
        .collection("BreastFeedingData");

    String name;
    if (_textFieldController.text != '') {
      name = _textFieldController.text;
    } else {
      final amPm = DateTime.now().hour >= 12 ? 'PM' : 'AM';
      name =
          "Session on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}  ${DateTime.now().hour}:${DateTime.now().minute} $amPm";
    }

    Map<String, dynamic> userData = {
      'name': name,
      'time': DateTime.now().microsecondsSinceEpoch.toString(),
      'duration': _formattedTime(),
      'left': _formattedTime1(),
      'right': _formattedTime2(),
    };

    await usersRef.add(userData);
    _showMyDialog(context);
    print('User data added to collection!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Breastfeeding Tracker',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextField(
                      controller: _textFieldController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.edit_note,
                          size: 30,
                        ),
                        hintText: 'Name your Session Mama...',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _formattedTime(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formattedTime1(),
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 10),
                            IconButton(
                              onPressed: _toggleTimer1,
                              icon: _isTimerRunning1
                                  ? const Icon(
                                      Icons.pause,
                                      color: Colors.purple,
                                    )
                                  : const Icon(
                                      Icons.play_arrow,
                                      color: Colors.purple,
                                    ),
                              iconSize: 72,
                              tooltip: _isTimerRunning1
                                  ? 'Stop Timer'
                                  : 'Start Timer',
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Left Breast',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              onPressed: _resetTimer1,
                              icon: const Icon(Icons.replay),
                              iconSize: 36,
                              tooltip: 'Reset Timer',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formattedTime2(),
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 10),
                            IconButton(
                              onPressed: _toggleTimer2,
                              icon: _isTimerRunning2
                                  ? const Icon(
                                      Icons.pause,
                                      color: Colors.purple,
                                    )
                                  : const Icon(
                                      Icons.play_arrow,
                                      color: Colors.purple,
                                    ),
                              iconSize: 72,
                              tooltip: _isTimerRunning2
                                  ? 'Stop Timer'
                                  : 'Start Timer',
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Right Breast',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              onPressed: _resetTimer2,
                              icon: const Icon(Icons.replay),
                              iconSize: 36,
                              tooltip: 'Reset Timer',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      if (_seconds1 + _seconds2 > 0)
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                child: contentBox(context),
                              );
                            },
                          )
                        }
                      else
                        {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Save Session'),
                                  content:
                                      Text('First Record a session Mama...'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              })
                        }
                    },
                    child: const Text('Save'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Previous Sessions',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Record>>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length != 0) {
                    return Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final items = snapshot.data![index];
                          final name = items.name;
                          final color = colors[(index % 7)];
                          final style = (name.contains('CEO')
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : null);
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: color,
                            child: ExpansionTile(
                              textColor: Colors.black,
                              expandedAlignment: Alignment.topLeft,
                              shape: Border.all(color: Colors.white10),
                              subtitle:
                                  Text('Duration: ${items.duration} minutes'),
                              title: Text(
                                name,
                                style: style ?? const TextStyle(fontSize: 18.0),
                              ),
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, right: 18, bottom: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Left Breast: ${items.left} min'),
                                      Text('Right Breast: ${items.right} min'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 2.0),
                      ),
                    );
                  } else {
                    return Center(
                        child:
                            Text("You haven't recorded a session yet Mama..."));
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: contentBox2(context),
        );
      },
    );
  }

  Widget contentBox2(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: 150,
              child: Lottie.asset(
                'assets/animation/Done_tick_genesis.json', // Replace with your animation file path
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Session saved successfully Mama...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15,),
            ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    // Add your action here for the second button
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ]),),);
            }

  Widget contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              width: 120,
              child: Lottie.asset(
                'assets/animation/caution.json', // Replace with your animation file path
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Save Record',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Are you sure you want to continue ?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _resetTimer1();
                    _resetTimer2();
                    Navigator.of(context).pop(); // Close the dialog
                    // Add your action here for the first button
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _storeData();
                    Navigator.of(context).pop(); // Close the dialog
                    // Add your action here for the second button
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    super.dispose();
  }
}
