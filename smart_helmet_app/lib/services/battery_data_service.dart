import 'package:firebase_database/firebase_database.dart';

class BatteryDataService {
  final dbRef = FirebaseDatabase.instance.ref('Devices/IRQgSMRaKZltXjuUhgc3/Battery Information');

  Stream<Map<String, dynamic>> get batteryStream => dbRef.onValue.map((event) {
    return Map<String, dynamic>.from(event.snapshot.value as Map);
  });
}
