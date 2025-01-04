import 'package:flutter/material.dart';
import 'event_details.dart';
import 'app_colors.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Events',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppColors.pagen,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10),
        TileButton(
          text: "example",
          icon: IconData(0),
          onPressed: () {
            // Navigate to the second page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventDetailsPage()),
            );
          },
        ),
        SizedBox(height: 10),
        TileButton(
          text: "example",
          icon: IconData(0),
          onPressed: () {
            // Navigate to the second page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventDetailsPage()),
            );
          },
        )
      ] ,
    );
  }
}

class TileButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const TileButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(320, 80), // Full width and height of 80
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 32),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
