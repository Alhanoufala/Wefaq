import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/AdminProjectDetailsAppBar.dart';
import 'package:wefaq/AdminProjectList.dart';
import 'package:wefaq/ProjectsTapScreen.dart';
import 'package:wefaq/config/colors.dart';
import 'package:wefaq/profileuser.dart';
import 'package:wefaq/screens/detail_screens/widgets/project_detail_appbar.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:wefaq/projectsScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:wefaq/service/local_push_notification.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../viewOtherProfile.dart';
import 'adminViewOtherProfile.dart';

final _formKey = GlobalKey<FormState>();

class adminprojectDetailScreen extends StatefulWidget {
  String projecName;

  adminprojectDetailScreen({required this.projecName});

  @override
  State<adminprojectDetailScreen> createState() =>
      _projectDetailScreenState(projecName);
}

class _projectDetailScreenState extends State<adminprojectDetailScreen> {
  @override
  void initState() {
    getCurrentUser();
    getProjects();

    getRequests();
    super.initState();
  }

  String projecName;
  _projectDetailScreenState(this.projecName);

  // Title list
  String nameList = "";

  // Description list
  String descList = "";

  // location list
  String locList = "";

  //Looking for list
  String lookingForList = "";

  String Duration = "";

  //category list
  String categoryList = "";

  //project owners emails
  String ownerEmail = "";

  String token = " ";
  String duration = "";
  String fName = "";
  String Lname = "";
  String Photo = ' ';

  List<String> participantNames = [];

  var ProjectTitleList = [];

  var ParticipantNameList = [];
  Status() => ProjectsListViewPage();

  List DisplayProjectOnce() {
    final removeDuplicates = [
      ...{...ProjectTitleList}
    ];
    return removeDuplicates;
  }

  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  //get all projects
  Future getProjects() async {
    await for (var snapshot in _firestore
        .collection('AllProjects')
        .where('name', isEqualTo: projecName)
        .snapshots())
      for (var project in snapshot.docs) {
        setState(() {
          nameList = project['name'].toString();
          descList = project['description'].toString();
          locList = project['location'].toString();
          lookingForList = project['lookingFor'].toString();
          categoryList = project['category'].toString();
          token = project['token'].toString();
          ownerEmail = project['email'].toString();
          fName = project['fname'].toString();
          Lname = project['lname'].toString();
          duration = project["duration"].toString();
        });
      }
  }

  Future getRequests() async {
    if (signedInUser.email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('owner_email', isEqualTo: Email)
          .where('Status', isEqualTo: 'Accepted')
          .where('project_title', isEqualTo: projecName)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            ParticipantNameList.add(Request['participant_name']);
          });
        }
    }
  }

  final auth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    Future getPhoto() async {
      await for (var snapshot in _firestore
          .collection('users')
          .where('Email', isEqualTo: ownerEmail)
          .snapshots())
        for (var Profile in snapshot.docs) {
          setState(() {
            Photo = Profile['Profile'].toString();
          });
        }
    }

    getPhoto();
    adminDetailAppBar();

    return Scaffold(
        bottomNavigationBar: AdminCustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              const adminDetailAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            nameList,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8.0),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Container(
                                height: 50.0,
                                width: 50.0,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                /* child: IconButton(
                              icon: (isPressed)
                                  ? const Icon(Icons.favorite,
                                      color: Color.fromARGB(172, 136, 98, 146))
                                  : const Icon(Icons.favorite_border,
                                      color: Color.fromARGB(172, 136, 98, 146)),
                              onPressed: () {
                                setState(() {
                                  if (isPressed) {
                                    isPressed = false;
                                    ShowToastRemove();
                                  } else {
                                    isPressed = true;
                                    ShowToastAdd();
                                  }
                                });
                              },
                            ),*/
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (ownerEmail == Email) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => viewprofile(
                                                userEmail: FirebaseAuth.instance
                                                    .currentUser!.email!)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                adminviewotherprofile(
                                                  userEmail: ownerEmail,
                                                )));
                                  }
                                },
                                child: Container(
                                  height: 35.0,
                                  width: 35.0,
                                  margin: const EdgeInsets.only(right: 8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(Photo),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 4),
                                        blurRadius: 4.0,
                                        color: Colors.black.withOpacity(0.25),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                fName + " " + Lname,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 32.0,
                                width: 32.0,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_pin,
                                    color: Color.fromARGB(172, 136, 98, 146)),
                              ),
                              Text(
                                locList,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const Divider(color: kOutlineColor, height: 1.0),
                      const SizedBox(height: 16.0),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        descList,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: kSecondaryTextColor),
                      ),
                      const SizedBox(height: 16.0),
                      const Divider(color: kOutlineColor, height: 1.0),
                      const SizedBox(height: 16.0),
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16.0),
                      _buildIngredientItem(context, categoryList),
                      const Divider(color: kOutlineColor, height: 1.0),
                      const SizedBox(height: 16.0),
                      Text(
                        'Looking For',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Row(children: <Widget>[
                        Text(
                          lookingForList,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: kSecondaryTextColor),
                        ),
                      ]),
                      const Divider(color: kOutlineColor, height: 1.0),
                      const SizedBox(height: 16.0),
                      Text(
                        'Duration',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Row(children: <Widget>[
                        const Icon(
                          Icons.timelapse_outlined,
                          color: Color.fromARGB(172, 136, 98, 146),
                          size: 21,
                        ),
                        Text(
                          duration,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: kSecondaryTextColor),
                        ),
                      ]),
                      const SizedBox(height: 16.0),
                      const Divider(color: kOutlineColor, height: 1.0),
                      const SizedBox(height: 16.0),
                      Text(
                        "Team Members ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 35.0,
                                width: 35.0,
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/team.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 4.0,
                                      color: Colors.black.withOpacity(0.25),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ParticipantNameList.join(","),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              SizedBox(
                                width: 130,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildIngredientItem(
    BuildContext context,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            height: 24.0,
            width: 24.0,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 229, 214, 237),
            ),
            child: const Icon(
              Icons.check,
              color: Color.fromARGB(172, 113, 60, 127),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

// void CantJoin() => Fluttertoast.showToast(
//       msg: "You can't join your own project",
//       fontSize: 18,
//       gravity: ToastGravity.CENTER,
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Color.fromARGB(172, 136, 98, 146),
//     );
/*
void ShowToastRemove() => Fluttertoast.showToast(
      msg: "Project is removed form favorite",
      fontSize: 18,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color.fromARGB(172, 136, 98, 146),
    );

void ShowToastAdd() => Fluttertoast.showToast(
      msg: "Project is added to favorite",
      fontSize: 18,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color.fromARGB(172, 136, 98, 146),
    );
*/