import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:genesis_flutter/appointments/SelectDetails.dart';
import 'package:genesis_flutter/map/MapPage.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class AidPage extends StatefulWidget {
  const AidPage({super.key});

  @override
  State<AidPage> createState() => _AidPageState();
}

class _AidPageState extends State<AidPage> {
  String _currentPosition = "Unknown";
  double _Lat = 0, _Long = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    // Check for permissions
    await _checkPermission();

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    setState(() {
      _Lat = position.latitude;
      _Long = position.longitude;
      _currentPosition =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }

  _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Handle denied forever case
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // _getCurrentLocation();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aid Page'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.red[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              Offset(2, 4), // Adjust offset for shadow position
                        )
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapPage()))
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: _currentPosition != "Unknown"
                              ? FlutterMap(
                                  options: MapOptions(
                                    onTap: (tapPosition, latlng) => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MapPage()))
                                    },
                                    initialCenter: LatLng(_Lat, _Long),
                                    initialZoom: 14.0,
                                  ),
                                  children: [
                                    TileLayer(
                                        urlTemplate:
                                            "https://api.mapbox.com/styles/v1/abhishekbh349/clrghjplo00jq01p41fyeee0f/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJoaXNoZWtiaDM0OSIsImEiOiJjbHJnaGZqdjcwMDNvMmpvYjVmeGEycnN3In0.6C_FtIoblFyI4xHJ5rvRKg",
                                        additionalOptions: const {
                                          'accessToken':
                                              'pk.eyJ1IjoiYWJoaXNoZWtiaDM0OSIsImEiOiJjbHJnaGZqdjcwMDNvMmpvYjVmeGEycnN3In0.6C_FtIoblFyI4xHJ5rvRKg',
                                          'id': 'mapbox.mapbox-streets-v8',
                                        }),
                                  ],
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  )),
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Locate Nearby Hospitals',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.home_work_rounded)
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Locate Nearby Pharmacy',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.medical_services)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.red[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              Offset(2, 4), // Adjust offset for shadow position
                        )
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectDetails()))
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                                width: double.maxFinite,
                                color: Colors.grey[300],
                                child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/genesis-4e793.appspot.com/o/doctor_page.jpg?alt=media&token=cd57fc3c-7c31-4a51-b19f-6ce386183535',
                                  fit: BoxFit.fitWidth,
                                )),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Book An Appointment',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
