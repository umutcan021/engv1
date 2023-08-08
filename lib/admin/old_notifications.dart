import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:engv1/teacher/notification_list.dart';

class OldNotifications extends StatefulWidget {
  const OldNotifications({super.key});
  @override
  _OldNotifications createState() => _OldNotifications();
}

class _OldNotifications extends State<OldNotifications> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0,60,0,0),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,

                        child: Center(
                          child:NotificationList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}