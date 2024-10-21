import 'package:flutter/material.dart';

class SupervisorScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Supervisor Screen'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }
}
