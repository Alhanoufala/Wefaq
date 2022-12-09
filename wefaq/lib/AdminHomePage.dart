import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/AdminBackground.dart';
import 'package:wefaq/AdminEventList.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/AdminProjectList.dart';
import 'package:wefaq/FavoritePage.dart';
import 'package:wefaq/ReportedEvents.dart';
import 'package:wefaq/eventsTabs.dart';
//import 'package:wefaq/favoriteProject.dart';
import 'package:wefaq/profile.dart';
import 'package:wefaq/profileuser.dart';
import 'RJRprojects.dart';
import 'package:wefaq/backgroundHome.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/myProjects.dart';
import 'package:wefaq/userLogin.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:wefaq/adminAccountTap.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'ProjectsTapScreen.dart';

class adminHomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

//,,,
class HomeScreenState extends State<adminHomeScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  @override
  void initState() {
    getCurrentUser();
    getProjectTitle();
    getProjectTitleOwner();
    super.initState();
  }

  static List<String> ProjectTitleList = [];
  String? Email;
  final _firestore = FirebaseFirestore.instance;
  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get FName => name.first;
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

  Future getProjectTitleOwner() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('owner_email', isEqualTo: Email)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            if (!ProjectTitleList.contains(Request['project_title'].toString()))
              ProjectTitleList.add(Request['project_title'].toString());
          });
        }
    }
  }

  Future getProjectTitle() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('participant_email', isEqualTo: Email)
          .where('Status', isEqualTo: 'Accepted')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            if (!ProjectTitleList.contains(Request['project_title'].toString()))
              ProjectTitleList.add(Request['project_title'].toString());
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AdminCustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),
        // bottomNavigationBar: CustomNavigationBar(
        //   currentHomeScreen: 0,
        //   updatePage: () {},
        // ),
        backgroundColor: Color.fromARGB(255, 245, 244, 255),
        body: adminBackgroundHome(
            child: Stack(
          children: <Widget>[
            SizedBox(
              height: 33,
            ),
            Container(
              margin: EdgeInsets.only(left: 310, top: 40),
              child: IconButton(
                  icon: Icon(
                    Icons.logout,
                    size: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    showDialogFunc(context);
                  }),
            ),
            SizedBox(
              height: 130,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 125),
              alignment: Alignment.topCenter,
            ),
            SizedBox(
              height: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 290),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 70,
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 50,
                          children: <Widget>[
                            CategoryCard(
                                title: "Upcoming Projects",
                                imgSrc: "01.png",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              adminProjectsListViewPage()));
                                }),
                            CategoryCard(
                                title: "Upcoming Events",
                                imgSrc: "02.png",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              adminEventsListViewPage()));
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )));
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imgSrc;

  final Function() onTap;

  const CategoryCard({
    required this.title,
    required this.imgSrc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(40, 20),
              blurRadius: 30,
              spreadRadius: -23,
              color: Color.fromARGB(218, 161, 158, 162),
            ),
          ],
          image: new DecorationImage(
            image: new AssetImage("assets/images/$imgSrc"),
          ),
        ),
        child: Material(
          color: Color.fromARGB(0, 167, 22, 22),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Spacer(),
                  Text("$title",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 61, 132, 163),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

showDialogFunc(context) {
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
