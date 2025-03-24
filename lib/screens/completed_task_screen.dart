import 'package:flutter/material.dart';

class CompletedTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Workouts')),
      body: Center(
        child: Text(
          'List of completed workouts will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
