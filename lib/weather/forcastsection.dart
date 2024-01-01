import 'package:flutter/material.dart';

class ForcastSection extends StatelessWidget {
  const ForcastSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: const Column(
          children: [
            Text(
              "2:00",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Icon(Icons.cloud, size: 32),
            SizedBox(height: 8),
            Text("303.17"),
          ],
        ),
      ),
    );
  }
}
