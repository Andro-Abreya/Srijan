import 'package:flutter/material.dart';

class Doctors {
  final String name;
  final String qualification;
  final String imageUrl;
  final String rate;

  Doctors({
    required this.name,
    required this.qualification,
    required this.rate,
    required this.imageUrl,
  });
}

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  List<Doctors> doctors = [
    Doctors(
      name: 'Doctor 1',
      qualification: '35',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/genesis-4e793.appspot.com/o/doctor.png?alt=media&token=133f26e6-5a49-4ef2-ab1c-e9ff2798e01d',
      rate: '2000',
    ),
    Doctors(
      name: 'Doctor 2',
      qualification: '28',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/genesis-4e793.appspot.com/o/doctor.png?alt=media&token=133f26e6-5a49-4ef2-ab1c-e9ff2798e01d',
      rate: '2000',
    ),
    Doctors(
      name: 'Doctor 3',
      qualification: '28',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/genesis-4e793.appspot.com/o/doctor.png?alt=media&token=133f26e6-5a49-4ef2-ab1c-e9ff2798e01d',
      rate: '2000',
    ),
    Doctors(
      name: 'Doctor 4',
      qualification: '28',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/genesis-4e793.appspot.com/o/doctor.png?alt=media&token=133f26e6-5a49-4ef2-ab1c-e9ff2798e01d',
      rate: '2000',
    ),
    Doctors(
      name: 'Doctor 5',
      qualification: '28',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/genesis-4e793.appspot.com/o/doctor.png?alt=media&token=133f26e6-5a49-4ef2-ab1c-e9ff2798e01d',
      rate: '2000',
    ),
    Doctors(
      name: 'Doctor 6',
      qualification: '28',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/genesis-4e793.appspot.com/o/doctor.png?alt=media&token=133f26e6-5a49-4ef2-ab1c-e9ff2798e01d',
      rate: '2000',
    ),
    Doctors(
      name: 'Doctor 7',
      qualification: '42',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/genesis-4e793.appspot.com/o/doctor.png?alt=media&token=133f26e6-5a49-4ef2-ab1c-e9ff2798e01d',
      rate: '2000',
    ),
    // Add more doctors...
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Doctors List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Text(
              'Available Doctors',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            SizedBox(
              height: 12,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final name = doctors[index].name;
                final color = colors[(index % 7)];
                final style = (name.contains('CEO')
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: color,
                  child: InkWell(
                    onTap: () => {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('This is a Bottom Sheet'),
                              ElevatedButton(
                                onPressed: () => {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return GiffyDialog.image(
                                        Image.network(
                                          "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text(
                                          'Image Animation',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          'This is a image animation dialog box. This library helps you easily create fancy giffy dialog.',
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'CANCEL'),
                                            child: const Text('CANCEL'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                },
                                child: Text('Confirm'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    },
                    child: ListTile(
                      leading: Image.network(doctors[index].imageUrl),
                      textColor: Colors.black,
                      subtitle: Text(
                          'Qualification: ${doctors[index].qualification} '),
                      title: Text(
                        name,
                        style: style ?? const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 3),
            ),
          ],
        ),
      ),
    );
  }

  // void showCustomDialog() {
  //   AwesomeDialog(
  //     context: context,
  //     dialogType: DialogType.INFO,
  //     animType: AnimType.BOTTOMSLIDE,
  //     title: 'Awesome Dialog',
  //     desc: 'This is a custom dialog with two buttons.',
  //     btnCancelOnPress: () {},
  //     btnCancelText: 'Cancel',
  //     btnOkOnPress: () {},
  //     btnOkText: 'OK',
  //   )..show();
  // }
}
