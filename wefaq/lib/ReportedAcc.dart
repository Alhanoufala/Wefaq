import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/AdminEventDetails.dart';
import 'package:wefaq/AdminHomePage.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'dart:async';
import 'package:wefaq/UserLogin.dart';

import 'adminViewOtherProfile.dart';

//import 'package:wefaq/adminViewOtherProfile.dart';

class ReportedAccList extends StatefulWidget {
  @override
  ReportedAccState createState() => ReportedAccState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class ReportedAccState extends State<ReportedAccList> {
  void initState() {
    getCurrentUser();
    getReportedEvents();
    super.initState();
  }

  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  List<String> user_who_reporting_List = [];
  List<String> Reason = [];
  List<String> Note = [];
  List<String> status = [];
  List<String> name = [];

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

  Future getReportedEvents() async {
    //clear first
    setState(() {
      user_who_reporting_List = [];
      Reason = [];
      Note = [];
    });

    await for (var snapshot in _firestore
        .collection('reportedUsers')
        .orderBy('created', descending: true)
        .snapshots()) {
      for (var report in snapshot.docs) {
        setState(() {
          user_who_reporting_List.add(report['user_who_reported']);
          Reason.add(report['reason']);
          Note.add(report['note']);
          name.add(report['name']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AdminCustomNavigationBar(
          currentHomeScreen: 2,
          updatePage: () {},
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 145, 124, 178),
          title: Text('Reported Accounts',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              )),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  showDialogFunc2(context);
                }),
          ],
        ),
        body: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
                //itemCount: tokens.length,
                itemCount: user_who_reporting_List.length,
                itemBuilder: (context, index) {
                  // Card Which Holds Layout Of ListView Item

                  return SizedBox(
                    height: 180,
                    child: GestureDetector(
                        child: Card(
                            color: Color.fromARGB(235, 255, 255, 255),
                            //shadowColor: Color.fromARGB(255, 255, 255, 255),
                            //  elevation: 7,

                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(name[index],
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      212, 82, 10, 111),
                                                )),
                                          ),
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
                                                            adminviewotherprofile(
                                                              userEmail:
                                                                  user_who_reporting_List[
                                                                      index],
                                                            )));
                                              }),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 156, 185, 182),
                                          height: 1.0),
                                      const SizedBox(height: 16.0),
                                      Expanded(
                                        child: Row(children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.report_gmailerrorred,
                                            color: Color.fromARGB(
                                                255, 202, 51, 41),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Report Reason: ",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  212, 82, 10, 111),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              Reason[index],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    212, 82, 10, 111),
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ]),
                                      ),
                                      const SizedBox(height: 16.0),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 156, 185, 182),
                                          height: 1.0),
                                      Row(children: <Widget>[
                                        SizedBox(
                                          width: 10,
                                          height: 40,
                                        ),
                                        Icon(
                                          Icons.event_note_outlined,
                                          color: Color.fromARGB(
                                              255, 156, 185, 182),
                                        ),
                                        SizedBox(
                                          width: 10,
                                          height: 40,
                                        ),
                                        Text(
                                          "Report Note: ",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                212, 82, 10, 111),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            Note[index] == ''
                                                ? "No note"
                                                : Note[index],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  212, 82, 10, 111),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        )
                                      ]),
                                    ]))),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => adminviewotherprofile(
                                        userEmail:
                                            user_who_reporting_List[index],
                                      )));
                        }),
                  );
                })));
  }
}

showDialogFunc2(context) {
   CoolAlert.show(
                          context: context,
                          title: "",
                          confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
                        //  cancelBtnColor: Colors.black,
                        //  cancelBtnTextStyle: TextStyle(color: Color.fromARGB(255, 237, 7, 7), fontWeight:FontWeight.w600,fontSize: 18.0),
                          confirmBtnText: 'log out ',
                          //cancelBtnText: 'Delete' ,
                             onConfirmBtnTap: () {
                 
                           _signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserLogin()));
                              
                          },
                    
                          type: CoolAlertType.confirm,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          text:
                              "Are you sure you want to log out?",
                        );
  // return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //           child: Material(
  //               type: MaterialType.transparency,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: const Color.fromARGB(255, 255, 255, 255),
  //                 ),
  //                 padding: const EdgeInsets.all(15),
  //                 height: 150,
  //                 width: MediaQuery.of(context).size.width * 0.9,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: <Widget>[
  //                     // Code for acceptance role
  //                     Row(children: <Widget>[
  //                       Expanded(
  //                         flex: 2,
  //                         child: GestureDetector(
  //                           child: Text(
  //                             " Are you sure you want to log out? ",
  //                             style: const TextStyle(
  //                               fontSize: 14,
  //                               color: Color.fromARGB(159, 64, 7, 87),
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           onTap: () {
  //                             // go to participant's profile
  //                           },
  //                         ),
  //                       ),
  //                       // const SizedBox(
  //                       //   height: 10,
  //                       // ),
  //                     ]),
  //                     SizedBox(
  //                       height: 35,
  //                     ),
  //                     //----------------------------------------------------------------------------
  //                     Row(
  //                       children: <Widget>[
  //                         Text("   "),
  //                         Text("     "),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             surfaceTintColor: Colors.white,
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(80.0)),
  //                             padding: const EdgeInsets.all(0),
  //                           ),
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             height: 40.0,
  //                             width: 100,
  //                             decoration: new BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(9.0),
  //                                 gradient: new LinearGradient(colors: [
  //                                   Color.fromARGB(144, 176, 175, 175),
  //                                   Color.fromARGB(144, 176, 175, 175),
  //                                 ])),
  //                             padding: const EdgeInsets.all(0),
  //                             child: Text(
  //                               "Cancel",
  //                               style: TextStyle(
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Color.fromARGB(255, 255, 255, 255)),
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           margin: EdgeInsets.only(left: 40),
  //                           child: ElevatedButton(
  //                             onPressed: () {
  //                               _signOut();
  //                               Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => UserLogin()));
  //                               // CoolAlert.show(
  //                               //   context: context,
  //                               //   title: "Success!",
  //                               //   confirmBtnColor:
  //                               //       Color.fromARGB(144, 64, 6, 87),
  //                               //   type: CoolAlertType.success,
  //                               //   backgroundColor:
  //                               //       Color.fromARGB(221, 212, 189, 227),
  //                               //   text: "You have logged out successfully",
  //                               //   confirmBtnText: 'Done',
  //                               //   onConfirmBtnTap: () {
  //                               //     //send join requist
  //                               //     _signOut();
  //                               //     Navigator.push(
  //                               //         context,
  //                               //         MaterialPageRoute(
  //                               //             builder: (context) => UserLogin()));
  //                               //   },
  //                               // );
  //                             },
  //                             style: ElevatedButton.styleFrom(
  //                               surfaceTintColor: Colors.white,
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(80.0)),
  //                               padding: const EdgeInsets.all(0),
  //                             ),
  //                             child: Container(
  //                               alignment: Alignment.center,
  //                               height: 40.0,
  //                               width: 100,
  //                               decoration: new BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(9.0),
  //                                   gradient: new LinearGradient(colors: [
  //                                     Color.fromARGB(144, 210, 2, 2),
  //                                     Color.fromARGB(144, 210, 2, 2)
  //                                   ])),
  //                               padding: const EdgeInsets.all(0),
  //                               child: Text(
  //                                 "Log out",
  //                                 style: TextStyle(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.w600,
  //                                     color:
  //                                         Color.fromARGB(255, 255, 255, 255)),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               )));
  //     });
}
