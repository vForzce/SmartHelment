import 'package:flutter/material.dart';

class InfoPanel extends StatelessWidget {
  final double batteryPercentage;
  final bool isCharging;
  final String address;
  final bool crashDetected;

  const InfoPanel({
    super.key,
    required this.batteryPercentage,
    required this.isCharging,
    required this.address,
    required this.crashDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Adjust the elevation as needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Battery & Charging Status
            _buildBubble(
                'Battery: ${batteryPercentage.toInt()}% ${isCharging ? "Charging" : "Not Charging"}'),

            // Address
            _buildBubble('Address: $address'),

            // Crash Detection
            if (crashDetected)
              _buildBubble(
                'Crash Detected!',
                textColor: Colors.red,
                fontWeight: FontWeight.bold,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(String text,
      {Color textColor = Colors.black,
      FontWeight fontWeight = FontWeight.normal}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Change the background color as needed
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
