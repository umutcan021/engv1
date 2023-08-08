import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:engv1/utils/api.dart';

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
    final Api _api = Api();

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
                  subtitle: Text(_api.convertDateTimeDisplay(
                      '${DateUtils.dateOnly(docs[index]["date"].toDate())}')),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children:
                  [
                    IconButton(onPressed: () async {
                      DocumentSnapshot? ds = snapshot.data!.docs[index];
                      _api.delete(ds);
                      },
                        icon: Icon(Icons.delete_forever)),
                  ]),
                  onTap: () {
                    //Open a pop up to show the message
                    print("object");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(docs[index]['header']),
                            content: Container(
                              height: MediaQuery.sizeOf(context).height*0.4,
                              child: Column(
                                children: [
                                  Text(docs[index]['body']),
                                  Text(_api.convertDateTimeDisplay(
                                      '${DateUtils.dateOnly(docs[index]["date"].toDate())}')),
                                 docs[index]['image_url'] != null?TextButton(onPressed: (){
                                   String link = docs[index]['image_url'];
                                   String filename= docs[index]['file_name'];
                                    _api.downloadFile(link,filename);
                                    print("launched");


                                 }, child: Text("Download material")):SizedBox(height: 0,),
                                ],
                              ),
                            ),
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
