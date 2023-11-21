import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';


class LocationDataService {
  final dbRef = FirebaseDatabase.instance.ref('Devices/IRQgSMRaKZltXjuUhgc3/GPS Data');

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return "Failed to get address";
    }
  }

  Stream<LatLng> get locationStream => dbRef.onValue.map((event) {
    final data = Map<String, dynamic>.from(event.snapshot.value as Map);
    double latitude = double.parse(data['Latitude']);
    double longitude = double.parse(data['Longitude']);
    return LatLng(latitude, longitude);
  });
}

class BatteryDataService {
  final dbRef = FirebaseDatabase.instance.ref('Devices/IRQgSMRaKZltXjuUhgc3/Battery Information');

  Stream<Map<String, dynamic>> get batteryStream => dbRef.onValue.map((event) {
    return Map<String, dynamic>.from(event.snapshot.value as Map);
  });
}


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng initialPosition = const LatLng(0, 0);
  String address = "";
  double batteryPercentage = 0.0;
  bool isCharging = false;

  final LocationDataService _locationDataService = LocationDataService();
  final BatteryDataService _batteryDataService = BatteryDataService();


  @override
  void initState(){
    super.initState();

   _locationDataService.locationStream.listen((newPosition) async {
      String address = await _locationDataService.getAddressFromLatLng(newPosition.latitude, newPosition.longitude);
      
      setState(() {
        initialPosition = newPosition;
        address = address;
        markers.clear();
        markers.add(Marker(markerId: const MarkerId('deviceLocation'), position: newPosition));
      });

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: newPosition, zoom: 17)),
      );
    });

    _batteryDataService.batteryStream.listen((data) {
      setState(() {
        batteryPercentage = double.tryParse(data['Percentage'].toString()) ?? 0.0;
        isCharging = data['Charging'] == true;
      });
    });
}
  
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Rider Location'),
      backgroundColor: Colors.black,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text('Battery: ${batteryPercentage.toInt()}%', style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 10), // Spacing between the two texts
              Text(isCharging ? "Charging" : "Not Charging", style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text('Address: $address', style: const TextStyle(fontSize: 14)),
        ),
        Expanded(
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(target: initialPosition, zoom: 2),
            markers: markers,
          ),
        ),
      ],
    ),
  );
}  
}
