import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewNotification extends StatefulWidget {
  const NewNotification({super.key});
  @override
  _NewNotificationState createState() => _NewNotificationState();
}



class _NewNotificationState extends State<NewNotification> {

  bool showProgress = false;

  bool select_all = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController notificaiton_header_controller = TextEditingController();
  final TextEditingController body_controller = TextEditingController();
  String department = "0";
  String grade = "0";
  @override
  Widget build(BuildContext context) {
    void send_notification(String header, String body, String grade, String department,Timestamp date) async {
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

        //get all user ids with the same grade and department

        // add message to the message collection
        await FirebaseFirestore.instance.collection("message").doc(documentId.toString()).set({
          'header': header,
          'body': body,
          'grade': intGrade,
          'department': intDepartment,
          'date': date,
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
           }])});
        }
      } catch (e) {
        print(e);
      }




    }
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 60,
                        ),

                       Container(
                         alignment: Alignment.centerLeft,
                         child:  const Text("Create Notification",
                           style: TextStyle(
                             fontSize: 30,
                             fontWeight: FontWeight.bold,
                             color: Colors.black,

                           ),

                         ),

                       ),
                        SizedBox(
                          height: 20,
                        ),
                        //Header
                        TextFormField(
                          controller: notificaiton_header_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Header of Notification',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Header cannot be empty";
                            }
                            else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        //Body
                        TextFormField(
                          controller: body_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Body of Notification',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          minLines: 10,
                          maxLines: 13,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Body cannot be empty";
                            }
                            else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),


                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width*0.6,
                              child: DropdownButtonFormField(
                                  decoration: InputDecoration(

                                    filled: true,
                                    fillColor: Colors.white,
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.black),
                                      borderRadius: new BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.black),
                                      borderRadius: new BorderRadius.circular(10),
                                    ),
                                  ),
                                  hint: Text("Department"),
                                  items:
                                  const [
                                    DropdownMenuItem(value: "7",child: Text("Select All"),),
                                    DropdownMenuItem(value: "0",child: Text("Computer E."),),
                                    DropdownMenuItem(value: "1",child: Text("Software E."),),
                                    DropdownMenuItem(value: "2",child: Text("Civil E."),),
                                    DropdownMenuItem(value: "3",child: Text("Electrical and Electronics E."),),
                                    DropdownMenuItem(value: "4",child: Text("Metallurgy and Materials E."),),
                                    DropdownMenuItem(value: "5",child: Text("Geological E."),),
                                    DropdownMenuItem(value: "6",child: Text("Mining E."),),
                                  ], onChanged:  (value){
                                setState(() {
                                  department = value.toString();
                                });}),),

                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child:
                              DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabled: true,


                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.black),
                                      borderRadius: new BorderRadius.circular(5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.black),
                                      borderRadius: new BorderRadius.circular(5),
                                    ),
                                  ),
                                  hint: Text("Grade"),
                                  items: const [
                                    DropdownMenuItem(value: "5",child: Text("Select All"),
                                    ),
                                    DropdownMenuItem(value: "0",child: Text("Prep School"),
                                    ),
                                    DropdownMenuItem(value: "1",child: Text("1st Grade"),
                                    ),
                                    DropdownMenuItem(value: "2",child: Text("2nd Grade"),
                                    ),
                                    DropdownMenuItem(value: "3",child: Text("3rd Grade"),
                                    ),
                                    DropdownMenuItem(value: "4",child: Text("4th Grade"),
                                    ),

                                  ], onChanged: (value){
                                setState(() {
                                  grade = value.toString();
                                });
                              }),)
                          ],
                        ),

                        SizedBox(
                          height: 40,
                        ),



                        Row(

                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                           /* Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Checkbox(value: select_all,
                                    onChanged:(value) {
                                      setState(() {
                                        select_all = value!;
                                      });
                                    }),
                            ),

                            Text("Select All"),*/
                            SizedBox(
                              width: 140,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child:   MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {

                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      showProgress = true;
                                    });
                                    send_notification(notificaiton_header_controller.text,
                                        body_controller.text,grade.toString(),department.toString(),Timestamp.now());
                                  }
                                  else {
                                    setState(() {
                                      showProgress = false;
                                    });
                                  }

                                  _formkey.currentState?.reset();
                                  notificaiton_header_controller.clear();
                                  body_controller.clear();
                                  //reset dropdown
                                  department = "0";
                                  grade = "0";
                                  select_all = false;
                                  setState(() {
                                    showProgress = true;
                                  });


                                },
                                child: Text(
                                  "Send",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
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