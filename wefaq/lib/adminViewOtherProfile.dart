import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/ReportedAcc.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/adminAccountTap.dart';
import 'package:wefaq/userReport.dart';
import 'adminUserProjectsTap.dart';
import 'bottom_bar_custom.dart';

class adminviewotherprofile extends StatefulWidget {
  String userEmail;
  adminviewotherprofile({required this.userEmail});

  @override
  State<adminviewotherprofile> createState() =>
      _viewprofileState(this.userEmail);
}

class _viewprofileState extends State<adminviewotherprofile> {
  String userEmail;
  _viewprofileState(this.userEmail);
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;
  String fname = "";
  String lname = "";
  String about = "";
  String experince = "";
  String cerifi = "";
  String skills = "";
  String role = "";
  String gitHub = "";
  String photo = '';
  int count = 0;
  double rating = 0.0;
  List<String> selectedOptionList = [];
  List<String> user_who_reporting_List = [];
  List<String> Reporter = [];
  @override
  void initState() {
    getUser();
    getReportedEvents();
    super.initState();
  }

  Future getReportedEvents() async {
    //clear first
    setState(() {
      user_who_reporting_List = [];
      Reporter = [];
    });

    await for (var snapshot in _firestore
        .collection('reportedUsers')
        .orderBy('created', descending: true)
        .snapshots()) {
      for (var report in snapshot.docs) {
        setState(() {
          user_who_reporting_List.add(report['user_who_reported']);
          Reporter.add(report['user_who_reporting']);
        });
      }
    }
  }

  Future getUser() async {
    var fillterd = _firestore
        .collection('users')
        .where("Email", isEqualTo: userEmail)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var user in snapshot.docs) {
        setState(() {
          photo = user["Profile"].toString();
          fname = user["FirstName"].toString();
          lname = user["LastName"].toString();
          about = user["about"].toString();
          experince = user["experince"].toString();
          cerifi = user["cerifi"].toString();
          role = user["role"].toString();
          gitHub = user["gitHub"].toString();
          rating = user["rating"];
          count = user["count"];

          for (var skill in user["skills"])
            selectedOptionList.add(skill.toString());
        });
      }
  }

  showDialogFunc2(context) {
    CoolAlert.show(
      context: context,
      title: "",
      confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
      //  cancelBtnColor: Colors.black,
      //  cancelBtnTextStyle: TextStyle(color: Color.fromARGB(255, 237, 7, 7), fontWeight:FontWeight.w600,fontSize: 18.0),
      confirmBtnText: 'Delete ',
      //cancelBtnText: 'Delete' ,
      onConfirmBtnTap: () {
        if (count >= 1) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userEmail)
              .update({'status': 'deletedByAdmin'});
          for (var i = 0; i < Reporter.length; i++)
            FirebaseFirestore.instance
                .collection('reportedUsers')
                .doc(userEmail + '-' + Reporter[i]!)
                .update({'status': 'resolved'});

          CoolAlert.show(
            context: context,
            title: "the account was deleted successfully ",
            confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
            onConfirmBtnTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminAccountTabs()));
            },
            type: CoolAlertType.success,
            backgroundColor: Color.fromARGB(221, 212, 189, 227),
          );
        } else
          CoolAlert.show(
            context: context,
            title:
                "You can not  delete the account because there is no reports on it",
            confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
            onConfirmBtnTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminAccountTabs()));
            },
            type: CoolAlertType.error,
            backgroundColor: Color.fromARGB(221, 212, 189, 227),
          );
      },

      type: CoolAlertType.confirm,
      backgroundColor: Color.fromARGB(221, 212, 189, 227),
      text: "Are you sure you want to delete account?",
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
    //                 height: 190,
    //                 width: MediaQuery.of(context).size.width * 0.85,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: <Widget>[
    //                     // Code for acceptance role

    //                     Row(children: <Widget>[
    //                       Expanded(
    //                         flex: 2,
    //                         child: GestureDetector(
    //                           child: Text(
    //                             "Are you sure you want to delete account?",
    //                             style: const TextStyle(
    //                               fontSize: 18,
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
    //                         Text(""),
    //                         Text("        "),
    //                         ElevatedButton(
    //                           onPressed: () async {
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
    //                                   color:
    //                                       Color.fromARGB(255, 255, 255, 255)),
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           margin: EdgeInsets.only(left: 40),
    //                           child: ElevatedButton(
    //                             onPressed: () {
    //                               FirebaseFirestore.instance
    //                                   .collection('users')
    //                                   .doc(userEmail)
    //                                   .update({'status': 'deletedByAdmin'});

    //                               CoolAlert.show(
    //                                 context: context,
    //                                 title:
    //                                     "the account was deleted successfully ",
    //                                 confirmBtnColor:
    //                                     Color.fromARGB(144, 64, 7, 87),
    //                                 onConfirmBtnTap: () {
    //                                   Navigator.push(
    //                                       context,
    //                                       MaterialPageRoute(
    //                                           builder: (context) =>
    //                                               ReportedAccList()));
    //                                 },
    //                                 type: CoolAlertType.success,
    //                                 backgroundColor:
    //                                     Color.fromARGB(221, 212, 189, 227),
    //                               );

    //                               /*FirebaseFirestore.instance
    //                                   .collection('FavoriteEvents')
    //                                   .doc(favoriteEmail +
    //                                       "-" +
    //                                       eventName +
    //                                       "-" +
    //                                       ownerEmail)
    //                                   .delete();*/

    //                               /*CoolAlert.show(
    //                                   context: context,
    //                                   title:
    //                                       "You cannot delete the event because the number of reports is less than 3",
    //                                   confirmBtnColor:
    //                                       Color.fromARGB(144, 64, 7, 87),
    //                                   onConfirmBtnTap: () {
    //                                     Navigator.push(
    //                                         context,
    //                                         MaterialPageRoute(
    //                                             builder: (context) =>
    //                                                 ReportedAccList()));
    //                                   },
    //                                   type: CoolAlertType.error,
    //                                   backgroundColor:
    //                                       Color.fromARGB(221, 212, 189, 227),
    //                                 );*/
    //                               // deleteprofile();
    //                               // Navigator.push(context,
    //                               // MaterialPageRoute(builder: (context) => UserLogin()));
    //                             },
    //                             style: ElevatedButton.styleFrom(
    //                               surfaceTintColor: Colors.white,
    //                               shape: RoundedRectangleBorder(
    //                                   borderRadius:
    //                                       BorderRadius.circular(80.0)),
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
    //                                 "Delete",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AdminCustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      backgroundColor: Color.fromARGB(255, 238, 237, 240),
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                showDialogFunc(context);
              }),
        ],
        backgroundColor: Color.fromARGB(255, 162, 148, 183),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image(
                image: AssetImage(
                  "assets/images/header_profile.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 120),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text("      " + "$fname" + " $lname",
                                      style: TextStyle(fontSize: 18)),
                                  Expanded(
                                    child: SizedBox(
                                      width: 20,
                                    ),
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Column(children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),

                                      //You can add Subtitle here
                                    ),
                                  ])),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      adminuserProjectsTabs(
                                                          userEmail:
                                                              userEmail)),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  201, 231, 229, 229),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "View projects",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 96, 51, 104),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(left: 15, top: 140),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.15),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(photo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("About"),
                        subtitle: Text("$about"),
                        leading: Icon(Icons.format_align_center),
                      ),
                      ListTile(
                        title: Text("GitHub"),
                        onTap: () => launch("$gitHub"),
                        leading: Icon(
                          LineIcons.github,
                          size: 35,
                          color: Color.fromARGB(255, 93, 18, 107),
                        ),
                      ),
                      ListTile(
                        title: Text("Experience"),
                        subtitle: Text("$experince"),
                        leading: Icon(Icons.calendar_view_day),
                      ),
                      ListTile(
                        title: Text("Skills"),
                        subtitle: Text(selectedOptionList.join(",")),
                        leading: Icon(Icons.schema_rounded),
                      ),
                      ListTile(
                        title: Text("Licenses & certifications"),
                        subtitle: Text("$cerifi"),
                        leading: Icon(
                          Icons.workspace_premium,
                          size: 33,
                        ),
                      ),
                      ListTile(
                          title: Text("Rating"),
                          subtitle: Text("$rating/5.0"),
                          leading: Icon(
                            Icons.star,
                            size: 33,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                  width: 80,
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialogFunc2(context);
                      //  showDialogFunc(context);
                      // deleteprofile();
                      //   Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => UserLogin()));
                    },
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: 150,
                      // width: size.width * 0.5,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        color: Color.fromARGB(204, 109, 46, 154),
                      ),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Delete account",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
