import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/chatDetails.dart';
import 'package:wefaq/chatRoom.dart';
import 'package:wefaq/viewProfileTeamMembers.dart';

class rateTeammates extends StatefulWidget {
  String projectName;
  rateTeammates({
    required this.projectName,
  });
  @override
  _rateTeammates createState() => _rateTeammates(projectName);
}

class _rateTeammates extends State<rateTeammates> {
  String projectName;
  _rateTeammates(this.projectName);
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var Email = FirebaseAuth.instance.currentUser!.email;

  var usersNames = [];
  var usersEmails = [];

  var userWhoRated = [];
  var ratings = [];
  var photos = [];
  var currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    getUsersNames();
    getOwnerNames();
    getPhoto();
    super.initState();
  }

  Future getUsersNames() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('project_title', isEqualTo: projectName)
          .where('Status', isEqualTo: 'Accepted')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            if (Request['participant_email'].toString() != Email) {
              usersNames.add(Request['participant_name'].toString());

              usersEmails.add(Request['participant_email'].toString());
            }
          });
        }
    }
  }

  Future getOwnerNames() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection("AllProjects")
          .where('name', isEqualTo: projectName)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var project in snapshot.docs) {
          setState(() {
            if (project['email'].toString() != Email) {
              usersNames.add(project['fname'].toString() +
                  " " +
                  project['lname'].toString());
              usersEmails.add(project['email'].toString());
            }
          });
        }
    }
  }

  Future getPhoto() async {
    for (var email in usersEmails)
      if (Email != null) {
        var fillterd = _firestore
            .collection("users")
            .where('email', isEqualTo: email)
            .snapshots();
        await for (var snapshot in fillterd)
          for (var user in snapshot.docs) {
            setState(() {
              photos.add(user['Profile'].toString());
            });
          }
      }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Color.fromARGB(255, 85, 85, 85),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Row(
          children: [
            //Image.network('assets/images/logo.png', height: 70),
            SizedBox(width: 5),
            Text(
              "Rate Teammeates",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
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
                              TextButton(
                                  child: Text(
                                    usersNames[index],
                                    style: const TextStyle(
                                      fontSize: 19,
                                      color: Color.fromARGB(212, 82, 10, 111),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                viewProfileTeamMembers(
                                                    userEmail:
                                                        usersEmails[index],
                                                    projectName: projectName)));
                                  }),
                              SizedBox(
                                width: 170,
                              ),
                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.only(left: 0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color.fromARGB(255, 85, 85, 85),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    viewProfileTeamMembers(
                                                        userEmail:
                                                            usersEmails[index],
                                                        projectName:
                                                            projectName)));
                                      }),
                                ),
                              ),
                            ]),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[],
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
                          builder: (context) => viewProfileTeamMembers(
                              userEmail: usersEmails[index],
                              projectName: projectName)));
                },
              ),
            );
          },
          itemCount: usersNames.length,
        ),
      ),
    );
  }
}
