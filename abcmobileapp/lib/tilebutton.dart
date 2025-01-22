import 'package:flutter/material.dart';
import 'app_colors.dart';

class TileButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  const TileButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.onDelete,
  }) : super(key: key);

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Delete Event',
            style: TextStyle(color: AppColors.text),
          ),
          content: Text(
            'Are you sure you want to delete this event?',
            style: TextStyle(color: AppColors.main),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.text),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.subAlt,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.main),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: AppColors.main),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }
}