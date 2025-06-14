import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  const CustomAlertDialog(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
            color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 25),
      ),
      content: Text(content),
      actions: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text('Close',
              style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
      ],
    );
  }
}
