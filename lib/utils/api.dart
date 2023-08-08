import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Api {
  var departments = [
    "Computer Engineering",
    "Software Engineering",
    "Civil Engineering",
    "Electrical and Electronic Engineering",
    "Metallurgy and Material Engineering",
    "Geological Engineering",
    "Mining Engineering"
  ];

  getDepartmentName(int index) {
    return departments[index];
  }

  downloadFile(String url, String filename) async {
    //save to downloads folder
    var dir = await getExternalStorageDirectory();
    var file = File("${dir!.path}/$filename");
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    await file.writeAsBytes(bytes);
    print(file.path);
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  delete(DocumentSnapshot ds) async {
    FirebaseFirestore.instance.collection("message").doc(ds.id).delete();

    int intDepartment = ds['department'];


    int intGrade = ds['grade'];
    var docId = ds.id;
    var userIds;

    print(docId.runtimeType);
    if (intGrade == 5 && intDepartment == 7) {
      userIds = await FirebaseFirestore.instance.collection("users").where(
          "role", isEqualTo: "student").get();
    }
    else if (intGrade == 5) {
      userIds = await FirebaseFirestore.instance.collection("users").where(
          "department", isEqualTo: intDepartment).get();
    }
    else if (intDepartment == 7) {
      userIds = await FirebaseFirestore.instance.collection("users").where(
          "grade", isEqualTo: intGrade).get();
    }
    else {
      userIds = await FirebaseFirestore.instance.collection("users").where(
          "grade", isEqualTo: intGrade).where(
          "department", isEqualTo: intDepartment).get();
    }


    for (var userId in userIds.docs) {
      var dc = await FirebaseFirestore.instance.collection('users').doc(
          userId.id).get();
      var message = dc['received_messages'] as List;


      message.removeWhere((element) => element['docId'] == docId.toString());

      await FirebaseFirestore.instance.collection('users')
          .doc(userId.id)
          .update({
        'received_messages': message
      });
    }
  }

  void send_notification(String fileName, File? fileToDisplay,String header, String body, String grade, String department,Timestamp date) async {
    const CircularProgressIndicator();
    // Get user id by their department and grade
    try {
      var intGrade = int.parse(grade);
      var intDepartment = int.parse(department);
      var documentId = Random().nextInt(1000000000);
      var userIds;
      if (intGrade == 5 && intDepartment == 7){
        userIds = await FirebaseFirestore.instance.collection("users").where("role",isEqualTo: "student").get();
      }
      else if (intGrade == 5){
        userIds = await FirebaseFirestore.instance.collection("users").where("department", isEqualTo: intDepartment).get();
      }
      else if (intDepartment == 7){
        userIds = await FirebaseFirestore.instance.collection("users").where("grade", isEqualTo: intGrade).get();
      }

      else{
        userIds = await FirebaseFirestore.instance.collection("users").where("grade", isEqualTo: intGrade).where("department", isEqualTo: intDepartment).get();
      }
      print("user ids: " + userIds.docs.toString());

      print("filename before dot : ${fileName!.split(".")[0]}");
      String filName2Upload = "${fileName!.split(".")[0]}-$documentId.${fileName!.split(".")[1]}";
      print("file name to upload: $filName2Upload");
      //get all user ids with the same grade and department
      Reference imageRef = FirebaseStorage.instance.ref().child(filName2Upload);
      await imageRef.putFile(fileToDisplay!);

      String imageUrl = await imageRef.getDownloadURL();
      print('download utl: $imageUrl');
      fileToDisplay = null;
      // add message to the message collection
      await FirebaseFirestore.instance.collection("message").doc(documentId.toString()).set({
        'header': header,
        'body': body,
        'grade': intGrade,
        'department': intDepartment,
        'date': date,
        'image_url': imageUrl,
        'file_name': fileName,
      });


      // Write message to the user id found
      for (var userId in userIds.docs) {
        await FirebaseFirestore.instance.collection("users").doc(userId.id).update({
          'received_messages': FieldValue.arrayUnion([{
            'header': header,
            'body': body,
            'grade': intGrade,
            'department': intDepartment,
            'date': date,
            'docId' :documentId.toString(),
            'isStarred': false,
            'image_url': imageUrl,
            'file_name':fileName
          }])});
      }
    } catch (e) {
      print("The error is ----> $e");
    }




  }
}