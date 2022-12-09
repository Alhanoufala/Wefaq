import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AsentJoinRequestListViewPage extends StatefulWidget {
  @override
  _sentRequestListState createState() => _sentRequestListState();
}

class _sentRequestListState extends State<AsentJoinRequestListViewPage> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = [];

  var status = [];
  var role = [];

  var Email = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    getRequests();
    super.initState();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //get all projects
  Future getRequests() async {
    var fillterd = _firestore
        .collection('AllJoinRequests')
        .where('participant_email', isEqualTo: Email)
        .where('Status', isEqualTo: "Accepted")
        .snapshots();
    await for (var snapshot in fillterd)
      for (var Request in snapshot.docs) {
        setState(() {
          ProjectTitleList.add(Request['project_title']);
          status.add(Request['Status']);
          role.add(Request['Participant_role']);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: ProjectTitleList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 80,
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Row(children: <Widget>[
                        Text(
                          " " +
                              ProjectTitleList[index] +
                              " project | As a " +
                              role[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(159, 64, 7, 87),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
