import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:engv1/teacher/new_notification.dart';
import 'package:engv1/teacher/old_notifications.dart';

import 'sign_in.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    const List<Widget> widgetOptions = <Widget>[
      NewNotification(),
      OldNotifications(),
    ];
    void _onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_notifications),
            label: 'New Notification',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_paused),
            label: 'Old Notifications',
            backgroundColor: Colors.green,
          ),

        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }
}
