import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class StarredNotificationsPage extends StatefulWidget {
  const StarredNotificationsPage({super.key});

  @override
  State<StarredNotificationsPage> createState() => _StarredNotificationsPage();
}

class _StarredNotificationsPage extends State<StarredNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Deleted Notifications"),
      ),
    );
  }



}

