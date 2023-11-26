import 'package:flutter/material.dart';

class InfoPanel extends StatelessWidget {
  final double batteryPercentage;
  final bool isCharging;
  final String address;
  final bool crashDetected; // Add this new field

  const InfoPanel({
    super.key,
    required this.batteryPercentage,
    required this.isCharging,
    required this.address,
    required this.crashDetected, // Add this new parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Rest of your container decoration
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Battery: ${batteryPercentage.toInt()}%',
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 10),
              Text(isCharging ? "Charging" : "Not Charging",
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Address: $address', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          if (crashDetected) // Conditionally display crash information
            const Text('Crash Detected!',
                style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


