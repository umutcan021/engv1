import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> {
  final _notification_stream =
      FirebaseFirestore.instance.collection("message").snapshots();
  bool starred = false;
  @override
  Widget build(BuildContext context) {
    String convertDateTimeDisplay(String date) {
      final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
      final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
      final DateTime displayDate = displayFormater.parse(date);
      final String formatted = serverFormater.format(displayDate);
      return formatted;
    }

    return Scaffold(
        body: StreamBuilder(
      stream: _notification_stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Connection Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );

        }
        var docs = snapshot.data!.docs;
        if (docs.length == 0) {
          return Center(child: Text("There is not any notification"));
        }
        // return Text('${docs.length}');
        return ListView.builder(
            itemCount: docs.length,

            itemBuilder: (context, index) {

              return ListTile(
                  title: Text(docs[index]['header']),
                  subtitle: Text(convertDateTimeDisplay(
                      '${DateUtils.dateOnly(docs[index]["date"].toDate())}')),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children:
                  [
                    IconButton(onPressed: () async {
                      DocumentSnapshot? ds = snapshot.data!.docs[index];

                      FirebaseFirestore.instance.collection("message").doc(ds.id).delete();

                      int intDepartment = ds['department'];



                      int intGrade = ds['grade'];

                      var docId = ds.id;
                      print(docId);
                      //print the type of docId
                      print(docId.runtimeType);
                      var userIds = await FirebaseFirestore.instance.collection("users").where("grade", isEqualTo: intGrade).where("department", isEqualTo: intDepartment).get();
                      //delete element from users array of map that same with docId
                      print(userIds.docs.length);

                      for(var userId in userIds.docs){

                        var dc = await FirebaseFirestore.instance.collection('users').doc(userId.id).get();
                        var message = dc['received_messages'] as List;



                        message.removeWhere((element) => element['docId'] == docId.toString());

                        await FirebaseFirestore.instance.collection('users').doc(userId.id).update({
                          'received_messages': message
                        });
                        }
                      },
                        icon: Icon(Icons.delete_forever)),
                  ]),
                  onTap: () {
                    //Open a pop up to show the message
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(docs[index]['header']),
                            content: Text(docs[index]['body']),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Close"))
                            ],
                          );
                        });
                  });
            });
      },
    ));
  }
}
