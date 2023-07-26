import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewNotificationPage extends StatefulWidget {
  const NewNotificationPage({super.key});

  @override
  State<NewNotificationPage> createState() => _NewNotificationPage();
}

class _NewNotificationPage extends State<NewNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Deleted Notifications"),
      ),
    );
  }



}

