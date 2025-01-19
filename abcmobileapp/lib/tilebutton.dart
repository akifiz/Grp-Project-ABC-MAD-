import 'package:flutter/material.dart';

class TileButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const TileButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
