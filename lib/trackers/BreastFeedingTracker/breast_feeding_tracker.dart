import 'dart:async' show Timer;
import 'package:flutter/material.dart';

class Record {
  final String name;
  final String duration;

  Record({
    required this.name,
    required this.duration,
  });
}

class BreastFeedingScreen extends StatefulWidget {
  const BreastFeedingScreen({super.key});

  @override
  _BreastFeedingScreenState createState() => _BreastFeedingScreenState();
}

class _BreastFeedingScreenState extends State<BreastFeedingScreen> {
  int _seconds1 = 0, _seconds2 = 0;
  late Timer _timer1, _timer2;
  bool _isTimerRunning1 = false, _isTimerRunning2 = false;

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
    _timer1.cancel();
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
    _timer2.cancel();
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
    _resetTimer1();
    _resetTimer2();
    _textFieldController.text="";
  }

  String _formattedTime() {
    // Format the time as "mm:ss"
    int minutes = (_seconds2 + _seconds1) ~/ 60;
    int seconds = (_seconds2 + _seconds1) % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

 

  List<Record> records = [
    Record(
      name: 'Session 1',
      duration: '35',
    ),
    Record(
      name: 'Session 2',
      duration: '28',
    ),
    Record(
      name: 'Session 3',
      duration: '28',
    ),
    Record(
      name: 'Session 4',
      duration: '28',
    ),
    Record(
      name: 'Session 5',
      duration: '28',
    ),
    Record(
      name: 'Session 6',
      duration: '28',
    ),
    Record(
      name: 'Session 7',
      duration: '42',
    ),
    // Add more patients...
  ];

  final colors = [
    Colors.red[100],
    Colors.blue[100],
    Colors.green[100],
    Colors.pink[100],
    Colors.yellow[100],
    Colors.purple[100],
    Colors.orange[100],
  ];

  @override
  Widget build(BuildContext context) {

   _timer1 = Timer.periodic(const Duration(seconds: 0), (timer) {
    print("");
   });
   _timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
    print("");
   });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Breastfeeding Tracker'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SingleChildScrollView(
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
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
                            tooltip:
                                _isTimerRunning1 ? 'Stop Timer' : 'Start Timer',
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
                            tooltip:
                                _isTimerRunning2 ? 'Stop Timer' : 'Start Timer',
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
                  onPressed: _storeData,
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
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final name = records[index].name;
                final color = colors[(index % 7)];
                final style = (name.contains('CEO')
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null);
                return Card(
                  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),),
                  color: color,
                  child: ExpansionTile(
                    textColor: Colors.black,
                    expandedAlignment: Alignment.topLeft,
                    subtitle:
                        Text('Duration: ${records[index].duration} minutes'),
                    title: Text(
                      name,
                      style: style ?? const TextStyle(fontSize: 18.0),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left:18.0, right: 18,bottom: 12),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Left Breast: 32 minutes'),
                            Text('Right Breast: 3 minutes'),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1.0),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _timer1.cancel();
    _timer2.cancel();
    super.dispose();
  }
}
