import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/main_provider.dart';
import 'package:todoapp/shared/appbar.dart';

class DetailScreen extends StatefulWidget {
  final String taskTitle;
  final String? taskContent;
  final VoidCallback? onPop;
  const DetailScreen({
    super.key,
    required this.taskTitle,
    required this.taskContent,
    this.onPop,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        leading: GestureDetector(
          onTap: () {
            if (widget.onPop != null) widget.onPop!();
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.grey[900],
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Text(
              mainProvider.capitalizeFirstLetter(widget.taskTitle),
              style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              mainProvider.capitalizeFirstLetter(widget.taskContent ?? ''),
              style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
