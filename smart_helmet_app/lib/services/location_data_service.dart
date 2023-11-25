import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
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