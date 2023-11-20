import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StreamLocation extends StatefulWidget{
  const StreamLocation({super.key});

  @override 
  State<StreamLocation> createState() => _StreamLocationState();
}

class _StreamLocationState extends State<StreamLocation> {
  final db = FirebaseDatabase.instance.ref('Devices/IRQgSMRaKZltXjuUhgc3/GPS Data');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase'),
      ),
      body: StreamBuilder(
        stream: db.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if(snapshot.hasData && snapshot.data!.snapshot.value != null) {
           DataSnapshot dataSnapshot = snapshot.data!.snapshot;

            // Print the raw data snapshot for further inspection
            if (kDebugMode) {
              print('Raw Data Snapshot: ${dataSnapshot.value}');
            }

            dynamic latValue = dataSnapshot.child('Latitude').value;
            dynamic lngValue = dataSnapshot.child('Longitude').value;

            // Print the values before parsing
            if (kDebugMode) {
              print('Latitude value: $latValue');
            }
            if (kDebugMode) {
              print('Longitude value: $lngValue');
            }

            // Check if latValue and lngValue are not null before parsing
            double lat = latValue != null ? double.tryParse(latValue as String) ?? 0.0 : 0.0;
            double lng = lngValue != null ? double.tryParse(lngValue as String) ?? 0.0 : 0.0;


            // Print the parsed values
            if (kDebugMode) {
              print('Parsed Latitude: $lat');
            }
            if (kDebugMode) {
              print('Parsed Longitude: $lng');
            }
            return Text('Latitude: $lat, Longitude: $lng');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}