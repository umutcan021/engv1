import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DeletedNotificationsPage extends StatefulWidget {
  const DeletedNotificationsPage({super.key});

  @override
  State<DeletedNotificationsPage> createState() => _DeletedNotificationsPage();
}

class _DeletedNotificationsPage extends State<DeletedNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Deleted Notifications"),
      ),
    );
  }



}

