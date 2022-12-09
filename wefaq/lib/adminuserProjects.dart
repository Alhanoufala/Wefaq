import 'dart:convert';
import 'dart:math';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wefaq/ProjectsTapScreen.dart';
import 'package:wefaq/service/local_push_notification.dart';
import 'package:http/http.dart' as http;

import 'AdminProjectDetails.dart';
import 'UserLogin.dart';

// Main Stateful Widget Start
class adminuserProjects extends StatefulWidget {
  String userEmail;
  adminuserProjects({required this.userEmail});

  ListViewPageState createState() => ListViewPageState(this.userEmail);
}

class ListViewPageState extends State<adminuserProjects> {
  String userEmail;
  ListViewPageState(this.userEmail);

  final TextEditingController _JoiningASController = TextEditingController();
  final TextEditingController _ParticipantNoteController =
      TextEditingController();
  @override
  void initState() {
    getCurrentUser();
    getProjects();

    super.initState();
  }

  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  // Title list
  List<String> nameList = [];

  List<String> joiningAs = [];

  String? Email;
  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        Email = signedInUser.email;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //get all projects
  Future getProjects() async {
    await for (var snapshot in _firestore
        .collection("AllJoinRequests")
        .where("participant_email", isEqualTo: userEmail)
        .where("Status", isEqualTo: "Accepted")
        .snapshots())
      for (var r in snapshot.docs) {
        setState(() {
          nameList.add(r['project_title']);
          joiningAs.add(r["joiningAs"]);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width

    return Column(
      children: [
        Expanded(
          child: Scaffold(
            // Main List View With Builder
            body: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                //itemCount: tokens.length,

                itemBuilder: (context, index) {
                  // Card Which Holds Layout Of ListView Item

                  return SizedBox(
                    height: 100,
                    child: GestureDetector(
                        child: Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          //shadowColor: Color.fromARGB(255, 255, 255, 255),
                          //  elevation: 7,

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Row(children: <Widget>[
                                      Text(
                                        "      " + nameList[index] + " ",
                                        style: const TextStyle(
                                          fontSize: 19,
                                          color:
                                              Color.fromARGB(212, 82, 10, 111),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 240,
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      const Text("     "),
                                      const Icon(Icons.person,
                                          color:
                                              Color.fromARGB(173, 64, 7, 87)),
                                      Text(joiningAs[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 34, 94, 120),
                                          )),
                                      Expanded(
                                          child: SizedBox(
                                        width: 100,
                                      )),
                                      IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color.fromARGB(
                                                255, 170, 169, 179),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        adminprojectDetailScreen(
                                                            projecName:
                                                                nameList[
                                                                    index])));
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      adminprojectDetailScreen(
                                          projecName: nameList[index])));
                        }),
                  );
                },
                itemCount: nameList.length,
                // itemCount:_textEditingController!.text.isNotEmpty? nameListsearch.length  : nameListsearch.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

showDialogFunc(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: const EdgeInsets.all(15),
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Code for acceptance role
                      Row(children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Text(
                              " Are you sure you want to log out? ",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(159, 64, 7, 87),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              // go to participant's profile
                            },
                          ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                      ]),
                      SizedBox(
                        height: 35,
                      ),
                      //----------------------------------------------------------------------------
                      Row(
                        children: <Widget>[
                          Text("   "),
                          Text("     "),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40.0,
                              width: 100,
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(9.0),
                                  gradient: new LinearGradient(colors: [
                                    Color.fromARGB(144, 176, 175, 175),
                                    Color.fromARGB(144, 176, 175, 175),
                                  ])),
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            child: ElevatedButton(
                              onPressed: () {
                                _signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserLogin()));
                                // CoolAlert.show(
                                //   context: context,
                                //   title: "Success!",
                                //   confirmBtnColor:
                                //       Color.fromARGB(144, 64, 6, 87),
                                //   type: CoolAlertType.success,
                                //   backgroundColor:
                                //       Color.fromARGB(221, 212, 189, 227),
                                //   text: "You have logged out successfully",
                                //   confirmBtnText: 'Done',
                                //   onConfirmBtnTap: () {
                                //     //send join requist
                                //     _signOut();
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => UserLogin()));
                                //   },
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: const EdgeInsets.all(0),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                width: 100,
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    gradient: new LinearGradient(colors: [
                                      Color.fromARGB(144, 210, 2, 2),
                                      Color.fromARGB(144, 210, 2, 2)
                                    ])),
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  "Log out",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )));
      });
}
