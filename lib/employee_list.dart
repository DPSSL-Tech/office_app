import 'package:flutter/material.dart';

class EmployeeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: Center(
        child: Text('List of employees goes here'),
      ),
    );
  }
}

class EmployeeDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Detail'),
      ),
      body: Center(
        child: Text('Employee details go here'),
      ),
    );
  }
}
