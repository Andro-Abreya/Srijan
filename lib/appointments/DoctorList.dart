//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';

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

   Doctors.fromFirestore(Map<String, dynamic> data)
      : name = data['name'],
        qualification = data['qualification'],
        imageUrl = data['imageUrl'],
        rate = data['rate'];
}

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
 
  final colors = [
    Colors.red[100],
    Colors.blue[100],
    Colors.green[100],
    Colors.pink[100],
    Colors.yellow[100],
    Colors.purple[100],
    Colors.orange[100],
  ];

 Future<List<Doctors>> getData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
    //  FirebaseAuth mAuth = FirebaseAuth.instance;

      List<Doctors> doctors = [];
      CollectionReference usersRef = firestore
          .collection('Doctors');

      QuerySnapshot querySnapshot = await usersRef.get();

      for (var doc in querySnapshot.docs) {
        Doctors item = Doctors.fromFirestore(doc.data() as Map<String, dynamic>);
        doctors.add(item);
      }
      // print(items);
      return doctors;
    } catch (error) {
      rethrow;
    }
  }

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
            FutureBuilder<List<Doctors>>(
              future: getData(),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final doctors = snapshot.data![index];
                    final name = doctors.name;
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
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                   Row(
                                     children: [
                                       Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(70)),
                                        width: 70,
                                        height: 70,
                                        child: Image.network(doctors.imageUrl)),
                                        SizedBox(width: 20,),
                                       Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(doctors.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                                          Text('${doctors.qualification}',style: TextStyle(fontWeight: FontWeight.w600,fontSize:18)),
                                          Text('₹ ${doctors.rate}/session',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
                                        ],
                                       )
                                     ],
                                   ),
                                   SizedBox(height: 20,),
                                    InkWell(
                                      onTap: () => {
                                        _showMyDialog(context)
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.purple[700],borderRadius: BorderRadius.circular(12)),
                                        width: MediaQuery.of(context).size.width,
                                        child: Text('Confirm',style: TextStyle(color: Colors.white),)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        },
                        child: ListTile(
                          leading: Image.network(doctors.imageUrl),
                          textColor: Colors.black,
                          subtitle: Text(
                              'Qualification: ${doctors.qualification} '),
                          title: Text(
                            name,
                            style: style ?? const TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 3),
                );
              }else if(snapshot.hasError){
                return Center(child: Text('Error Loading Data'));
              }else{
                return Center(child: CircularProgressIndicator());
              }
              }
            ),
           ],
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
          child: contentBox(context),
        );
      },
    );
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
              'Book Appountment',
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
}