import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
// import "package:latlong/latlong.dart" as ;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

 String _currentPosition = "Unknown";
    double _Lat = 0,_Long = 0;

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
    DartPluginRegistrant.ensureInitialized();
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
    return Scaffold(
      body:_currentPosition != "Unknown"? FlutterMap(
    options:  MapOptions(
      center: LatLng(_Lat, _Long),
      zoom: 13.0,
    ),
    children: [
      TileLayer(
        urlTemplate: "https://api.mapbox.com/styles/v1/abhishekbh349/clrghjplo00jq01p41fyeee0f/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJoaXNoZWtiaDM0OSIsImEiOiJjbHJnaGZqdjcwMDNvMmpvYjVmeGEycnN3In0.6C_FtIoblFyI4xHJ5rvRKg",
        additionalOptions: {
          'accessToken': 'pk.eyJ1IjoiYWJoaXNoZWtiaDM0OSIsImEiOiJjbHJnaGZqdjcwMDNvMmpvYjVmeGEycnN3In0.6C_FtIoblFyI4xHJ5rvRKg',
          'id': 'mapbox.mapbox-streets-v8',
        }
      ),
    ],
  ):Container(color: Colors.grey[100],child: Center(child: CircularProgressIndicator(color: Colors.blue,)),),
    ) ;
  }
}