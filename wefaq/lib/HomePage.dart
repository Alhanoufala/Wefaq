import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/FavoritePage.dart';
//import 'package:wefaq/favoriteProject.dart';
import 'package:wefaq/profile.dart';
import 'package:wefaq/profileuser.dart';
import 'RJRprojects.dart';
import 'package:wefaq/backgroundHome.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/myProjects.dart';
import 'package:wefaq/userLogin.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'ProjectsTapScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

//,,,
class HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  String profilepic = "";
  @override
  void initState() {
    getCurrentUser();
    getPhoto();
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

  Future getPhoto() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('users')
          .where('Email', isEqualTo: Email)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var user in snapshot.docs) {
          setState(() {
            profilepic = user["Profile"].toString();
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),
        body: BackgroundHome(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 33,
              ),
              GestureDetector(
                child: Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(left: 350, top: 60),
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        profilepic,
                      ),
                    ),
                  ),
                ),
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => viewprofile(
                              userEmail:
                                  FirebaseAuth.instance.currentUser!.email!)));
                }),
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
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            children: <Widget>[
                              CategoryCard(
                                  title: "My Projects",
                                  icon: Icon(
                                    Icons.lightbulb,
                                    size: 45,
                                    color: Color.fromARGB(221, 73, 105, 119),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                myProjects()));
                                  }),
                              CategoryCard(
                                  title: "Sent Request",
                                  icon: Icon(
                                    Icons.send_outlined,
                                    size: 45,
                                    color: Color.fromARGB(221, 73, 105, 119),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Tabs()));
                                  }),
                              CategoryCard(
                                  title: "Received Request",
                                  icon: Icon(
                                    Icons.add_to_home_screen,
                                    size: 45,
                                    color: Color.fromARGB(221, 73, 105, 119),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RequestListViewPageProject()));
                                  }),
                              CategoryCard(
                                  title: "My Favorites",
                                  icon: Icon(
                                    Icons.star,
                                    size: 45,
                                    color: Color.fromARGB(221, 73, 105, 119),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                favoritePage()));
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
          ),
        ));
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final Function() onTap;

  const CategoryCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(20, 17),
              blurRadius: 30,
              spreadRadius: -23,
              color: Color.fromARGB(255, 46, 36, 50),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              children: <Widget>[
                Spacer(),
                icon,
                Spacer(),
                Text("$title",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(221, 73, 105, 119),
                        fontWeight: FontWeight.bold)),
              ],
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
          context, MaterialPageRoute(builder: (context) => UserLogin()));
    },

    type: CoolAlertType.confirm,
    backgroundColor: Color.fromARGB(221, 212, 189, 227),
    text: "Are you sure you want to log out?",
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
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => HomeScreen()));
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
