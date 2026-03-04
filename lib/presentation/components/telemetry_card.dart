import 'package:flutter/material.dart';

class TelemetryCard extends StatelessWidget {
  final String title;
  final Widget child;

  const TelemetryCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [
            /// titre
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
