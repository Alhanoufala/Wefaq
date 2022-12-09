import 'dart:convert';
import 'dart:math';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;


class repotedeventsScreen extends StatefulWidget {
  @override
  _repotedeventsScreen createState() => _repotedeventsScreen();
}


 class _repotedeventsScreen extends State<repotedeventsScreen> {
 @override
  void initState() {
    getCurrentUser();
    getreportedevents();
    getreasonList();
    
   
    super.initState();
  }

  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;
  

  List<String> reportedEventsName = [];
  List<String> eventOwner = [];
  List<String> Notes = [];
  //not important 
  List<String> userWhoreported = [];
  List<String> reasonList = [];

 
  List<String> options = [];
  


  // we may not need it since it's the admin page only 
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



 void getreasonList() async {
    final reasons = await _firestore.collection('reportreasons').get();
    for (var category in reasons.docs) {
      for (var element in category['reportreasons']) {
        setState(() {
          options.add(element);
        });
      }
    }
  }
 

 
  Future getreportedevents() async {
  
    setState(() {
   
   reportedEventsName = [];
   eventOwner = [];
   Notes = [];
   //not important 
   userWhoreported = [];
   reasonList = [];

    });

    await for (var snapshot in _firestore
        .collection('reportedevents')
        .orderBy('created', descending: true)
        .snapshots())
      for (var reportedEvents in snapshot.docs) {
        setState(() {        
          reportedEventsName.add(reportedEvents['reported event name']);
          Notes.add(reportedEvents['note']);
          userWhoreported.add(reportedEvents['user who reported']);
          reasonList.add(reportedEvents['reason']);    
          eventOwner.add(reportedEvents['event owner']);
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    

    return Column(
     
    );
  }

 
 }
