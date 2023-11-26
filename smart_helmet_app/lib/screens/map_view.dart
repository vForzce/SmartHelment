import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_helmet_app/reusable_widgets/info_panel.dart';
import 'package:smart_helmet_app/services/battery_data_service.dart';
import 'package:smart_helmet_app/services/crash_detection_service.dart';
import 'package:smart_helmet_app/services/location_data_service.dart';
<<<<<<< HEAD
import 'package:smart_helmet_app/services/permissions_services.dart';
=======
import 'package:smart_helmet_app/services/color_utils.dart';
>>>>>>> 636e5c2b82c01cd57ef34236871e314202f70d4b

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng initialPosition = const LatLng(0, 0);
  String address = "";
  double batteryPercentage = 0.0;
  bool isCharging = false;
  bool crashDetected = false;

  final LocationDataService _locationDataService = LocationDataService();
  final BatteryDataService _batteryDataService = BatteryDataService();
  final CrashDetectionService _crashDetectionService = CrashDetectionService();

  @override
  void initState() {
    super.initState();
    PermissionsUtil.requestLocationPermission(); // Request permission

    _locationDataService.locationStream.listen((newPosition) async {
      String address = await _locationDataService.getAddressFromLatLng(
          newPosition.latitude, newPosition.longitude);

      setState(() {
        initialPosition = newPosition;
        address = address;
        markers.clear();
        markers.add(Marker(
            markerId: const MarkerId('deviceLocation'), position: newPosition));
      });

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: newPosition, zoom: 17)),
      );
    });

    _batteryDataService.batteryStream.listen((data) {
      setState(() {
        batteryPercentage =
            double.tryParse(data['Percentage'].toString()) ?? 0.0;
        isCharging = data['Charging?'] == true;
      });
    });

    // Listen for crash detection updates
    _crashDetectionService.crashDetectedStream.listen((bool detected) {
      if (detected) {
        // React to crash being detected
        setState(() {
          crashDetected = detected;
        });
        // Here you can also trigger any alerts or notifications
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Location'),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Set the gradient background color for the entire page
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("86EA87"),
              hexStringToColor("83CF77"),
              hexStringToColor("ACDFA4"),
              hexStringToColor("FFFFFF"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container with curved edges
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 400, // Adjust the height as needed
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      initialCameraPosition:
                          CameraPosition(target: initialPosition, zoom: 2),
                      markers: markers,
                    ),
                  ),
                ),
              ),
              InfoPanel(
                batteryPercentage: batteryPercentage,
                isCharging: isCharging,
                address: address,
                crashDetected: crashDetected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
