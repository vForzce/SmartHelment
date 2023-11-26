
import 'package:firebase_database/firebase_database.dart';

class CrashDetectionService{
  final dbRef = FirebaseDatabase.instance.ref('Devices/IRQgSMRaKZltXjuUhgc3/Crash Detection');
  
  Stream<bool> get crashDetectedStream => dbRef.child('Crash Detected?').onValue.map((event) {
    final crashDetected = event.snapshot.value as bool? ?? false;
    return crashDetected;
  });
}