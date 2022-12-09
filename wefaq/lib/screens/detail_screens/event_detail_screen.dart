import 'dart:convert';
//import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/link.dart';
import 'package:wefaq/config/colors.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:wefaq/eventsScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:wefaq/eventsTabs.dart';
import 'package:wefaq/screens/detail_screens/widgets/event_detail_appbar.dart';
import 'package:wefaq/service/local_push_notification.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Report.dart';

class eventDetailScreen extends StatefulWidget {
  String eventName;

  eventDetailScreen({required this.eventName});

  @override
  State<eventDetailScreen> createState() => _eventDetailScreenState(eventName);
}

class _eventDetailScreenState extends State<eventDetailScreen> {
  String? Email;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    getProjects();
    isLiked();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        Email = signedInUser?.email;
        print(signedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  String eventName;
  _eventDetailScreenState(this.eventName);

  // Title list
  String nameList = "";

  // Description list
  String descList = "";

  // location list
  String locList = "";

  //url list
  String urlList = "";

  //category list
  String categoryList = "";

  //category list
  String dateTimeList = "";

  String TimeList = "";
/////////////////////////////////////////////////////////////////////////////////////////
  //String favoriteEmail = "";

  String ownerEmail = "";
  String status = "Active";
  String EventName = "";
  int count = 0;
  bool _isSelected1 = false;
  bool _isSelected2 = false;
  bool _isSelected3 = false;
  bool isPressed = false;

  Future isLiked() async {
    var collectionRef = FirebaseFirestore.instance.collection('FavoriteEvents');

    var docu = await collectionRef
        .doc(Email! + '-' + EventName + '-' + ownerEmail)
        .get();

    if (docu.exists) {
      print("exist");
      setState(() {
        isPressed = true;
      });
    } else {
      print("doesnt exist");
      setState(() {
        isPressed = false;
      });
    }
  }

  var ProjectTitleList = [];

  var ParticipantEmailList = [];

  var ParticipantNameList = [];
  Status() => EventsTabs();

  List DisplayProjectOnce() {
    final removeDuplicates = [
      ...{...ProjectTitleList}
    ];
    return removeDuplicates;
  }

  //project lan
  var creatDate = [];

  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late User? signedInUser = auth.currentUser;

  //get all projects
  Future getProjects() async {
    //clear first
    setState(() {
      nameList = "";
      descList = "";
      locList = "";
      urlList = "";
      categoryList = "";
      dateTimeList = "";
      TimeList = "";
      //favoriteEmail = "";
      ownerEmail = "";
      EventName = "";
      count:
      0;
    });
    await for (var snapshot in _firestore
        .collection('AllEvent')
        .orderBy('created', descending: true)
        .where('name', isEqualTo: eventName)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          nameList = events['name'].toString();
          descList = events['description'].toString();
          locList = events['location'].toString();
          urlList = events['regstretion url '].toString();
          categoryList = events['category'].toString();
          dateTimeList = events['date'].toString();
          TimeList = events['time'].toString();
          EventName = events['name'].toString();
          ownerEmail = events['email'].toString();
          count = events['count'];
          //  dateTimeList.add(project['dateTime ']);
        });
      }
  }
/*
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
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const eventDetailAppBar(),
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
                            margin: EdgeInsets.only(right: 0),
                            height: 56.0,
                            width: 56.0,
                            child: IconButton(
                                icon: Icon(
                                  Icons.error_outline,
                                  color: Color.fromARGB(255, 186, 48, 48),
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => reportEvent(
                                              eventName: nameList,
                                              eventOwner: ownerEmail)));
                                  //showDialogFunc(context);
                                }),
                          ),
                          Container(
                            height: 50.0,
                            width: 50.0,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: (isPressed)
                                  ? const Icon(Icons.favorite,
                                      color: Color.fromARGB(172, 136, 98, 146))
                                  : const Icon(Icons.favorite_border,
                                      color: Color.fromARGB(172, 136, 98, 146)),
                              onPressed: () {
                                setState(() {
                                  print(isPressed);
                                  if (isPressed) {
                                    isPressed = false;
                                    print(isPressed);
                                    ShowToastRemove();

                                    FirebaseFirestore.instance
                                        .collection('FavoriteEvents')
                                        .doc(Email! +
                                            '-' +
                                            EventName +
                                            '-' +
                                            ownerEmail)
                                        .delete();
                                  } else {
                                    isPressed = true;
                                    print(isPressed);
                                    ShowToastAdd();

                                    _firestore
                                        .collection('FavoriteEvents')
                                        .doc(Email! +
                                            '-' +
                                            EventName +
                                            '-' +
                                            ownerEmail)
                                        .set({
                                      'favoriteEmail': Email,
                                      'ownerEmail': ownerEmail,
                                      'eventName': EventName,
                                      'description': descList,
                                      'location': locList,
                                      'URL': urlList,
                                      'category': categoryList,
                                      'date': dateTimeList,
                                      'time': TimeList,
                                      'status': "Active"
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Expanded(
                          child: SizedBox(
                        width: 20,
                      )),
                      Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse(urlList),
                          builder: (context, followLink) => Expanded(
                                child: ElevatedButton(
                                  onPressed: followLink,
                                  child: Icon(
                                    Icons.link,
                                    size: 30,
                                    color: Color.fromARGB(255, 111, 111, 111),
                                  ),
                                ),
                              )),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: kOutlineColor, height: 1.0),
                  const SizedBox(height: 16.0),
                  Text(
                    'Description',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Color.fromARGB(246, 83, 82, 82)),
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
                    'Date and time',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Row(children: <Widget>[
                    const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(172, 136, 98, 146),
                      size: 21,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      dateTimeList,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Color.fromARGB(246, 83, 82, 82)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      TimeList,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Color.fromARGB(246, 83, 82, 82)),
                    ),
                  ]),
                  const SizedBox(height: 16.0),
                  const Divider(color: kOutlineColor, height: 1.0),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

void ShowToastRemove() => Fluttertoast.showToast(
      msg: "Event is removed form favorite",
      fontSize: 18,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color.fromARGB(172, 136, 98, 146),
    );

void ShowToastAdd() => Fluttertoast.showToast(
      msg: "Event is added to favorite",
      fontSize: 18,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color.fromARGB(172, 136, 98, 146),
    );
