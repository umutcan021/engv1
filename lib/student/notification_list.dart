import 'package:firebase_auth/firebase_auth.dart';
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

  //get current user fields on the users document
   final _user_stream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
       .snapshots();


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
      stream: _user_stream,
      builder: (context, snapshot)  {
        if (snapshot.hasError) {
          return const Center(child: Text("Connection Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var docs = snapshot.data!.get('received_messages');

        if(docs.length == 0){
          return Center(child: Text("There is not any notification"));
        }
        //return Text('${docs.length}');
        return ListView.builder(
            itemCount: docs.length,

            itemBuilder: (context, index) {

              return ListTile(
                  title: Text(docs[index]['header']),
                  subtitle: Text(convertDateTimeDisplay(
                      '${DateUtils.dateOnly(docs[index]["date"].toDate())}')),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children:
                  [
                     IconButton(onPressed: (){
                      setState(() async {
                        var dc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();
                        //Update starred
                        var message = dc['received_messages'] as List;
                        message[index]['isStarred'] = !message[index]['isStarred'];
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'received_messages': message});


                        //update isStarred field
                        docs[index]['isStarred'] = !docs[index]['isStarred'];
                      });}, icon: Icon(docs[index]['isStarred']?Icons.star :Icons.star_border)),
                    IconButton(onPressed: () async {
                      print('here');
                      var message = docs as List;
                      message.removeAt(index);
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({'received_messages': message});

                        }, icon: Icon(Icons.delete_forever))
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
