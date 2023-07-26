import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:engv1/sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final _user_stream =
      FirebaseFirestore.instance.collection("users").snapshots();

  var departments = ["Computer Engineering","Software Engineering",
    "Civil Engineering", "Electrical and Electronic Engineering","Metallurgy and Material Engineering",
    "Geological Engineering","Mining Engineering"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Create user profile page
      body: StreamBuilder(
        stream: _user_stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Connection Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var currentUserId = FirebaseAuth.instance.currentUser!.uid;
          print(currentUserId);
          //getUsername by currentUserID
          var currentUserDoc = snapshot.data!.docs.where((element) => element.id == currentUserId);
          //return Text('${currentUserDoc}');
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Text("Profile Page",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 50,
                ),
                //Reach data by username

               Container(
                 padding: EdgeInsets.all(20),
                 alignment: Alignment.centerLeft,
                 child:  Text(
                     "Username: ${currentUserDoc.first['email'].toString().split('@')[0]}",
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,

                     )
                 ),
               ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child:  Text(
                      "Email: ${currentUserDoc.first['email']}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,

                      )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child:  Text(
                      "Department: ${departments[currentUserDoc.first['department']]}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,

                      )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Grade: ${currentUserDoc.first['grade'] == 0? "Freshman":currentUserDoc.first['grade'] == 1?
                  "Sophomore":currentUserDoc.first['grade'] == 2? "Junior":"Senior"}" ,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,

                      )
                   ),
                ),
                SizedBox(
                  height: 50,
                ),
                //Update button that opens an pop up
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Update Profile"),
                            content: const Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      hintText: "Enter new username"),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                      hintText: "Enter new email"),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                      hintText: "Enter new department"),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                      hintText: "Enter new grade"),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Update")),

                            ],
                          );
                        });
                  },
                  child: Text("Update Profile"),
                ),
                //Logout button
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    //go to sign in page
                    logout(context);},
                  child: Text("Logout")
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }
}
