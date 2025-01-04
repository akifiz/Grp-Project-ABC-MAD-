import 'package:flutter/material.dart';
import 'event_details.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:[
        Text(
          "Event Page",
          style: Theme.of(context).textTheme.bodyLarge,
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
