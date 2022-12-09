import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/RJRprojects.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/projectsScreen.dart';
import 'bottom_bar_custom.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:wefaq/service/local_push_notification.dart';
import 'package:http/http.dart' as http;

class RequestListViewPage extends StatefulWidget {
  String projectName;
  RequestListViewPage({required this.projectName});

  @override
  _RequestListState createState() => _RequestListState(projectName);
}

final TextEditingController _AcceptingAsASController = TextEditingController();

class _RequestListState extends State<RequestListViewPage> {
  String projectName;
  _RequestListState(this.projectName);
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = [];

  var ParticipantEmailList = [];

  var ParticipantNameList = [];

  var ParticipantNoteList = [];

  var ParticipantJoiningAsList = [];

  var tokens = [];

  Status() => ProjectsListViewPage();

  String? Email;
  @override
  void initState() {
    getCurrentUser();
    getRequests();
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

//          .where('participant_email', isNotEqualTo: Email)
  //get all projects
  Future getRequests() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('owner_email', isEqualTo: Email)
          .where('Status', isEqualTo: 'Pending')
          .where('project_title', isEqualTo: projectName)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            ProjectTitleList.add(Request['project_title']);
            ParticipantEmailList.add(Request['participant_email']);
            ParticipantNameList.add(Request['participant_name']);
            ParticipantNoteList.add(Request['Participant_note']);
            ParticipantJoiningAsList.add(Request['joiningAs']);
            tokens.add(Request['participant_token']);
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(tokens);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestListViewPageProject()));
            }),
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Text(ProjectTitleList.first,
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
                _signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
              }),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: ProjectTitleList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 100,
              child: GestureDetector(
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
                            Expanded(
                              flex: 3,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.account_circle,
                                  color: Color.fromARGB(255, 112, 82, 149),
                                  size: 52,
                                ),
                                onPressed: () {
                                  // go to participant's profile
                                },
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: GestureDetector(
                                child: Text(
                                  "" + ParticipantNameList[index] + "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(159, 64, 7, 87),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  // go to participant's profile
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 140),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color.fromARGB(255, 112, 82, 149),
                                  size: 28,
                                ),
                                onPressed: () {
                                  showDialogFunc(
                                      context,
                                      ParticipantNameList[index],
                                      ParticipantNoteList[index],
                                      ParticipantJoiningAsList[index],
                                      ParticipantEmailList[index],
                                      ProjectTitleList[index],
                                      tokens[index],
                                      signedInUser);
                                },
                              ),
                            )
                          ]),

                          ////////////// accept/decline ------------------------------------------
                          /* Row(
                          children: <Widget>[
                            Text("   "),
                            Container(
                              margin: EdgeInsets.only(left: 120),
                              child: ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('joinRequests')
                                      .doc(ProjectTitleList[index] +
                                          '-' +
                                          ParticipantEmailList[index])
                                      .update({'Status': 'Accepted'});
              
                                  CoolAlert.show(
                                    context: context,
                                    title: "Success!",
                                    confirmBtnColor:
                                        Color.fromARGB(144, 64, 6, 87),
                                    type: CoolAlertType.success,
                                    backgroundColor:
                                        Color.fromARGB(221, 212, 189, 227),
                                    text: "You have accepted " +
                                        ParticipantNameList[index] +
                                        " to be part of your team.",
                                    confirmBtnText: 'Done',
                                    onConfirmBtnTap: () {
                                      //send join requist
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestListViewPage()));
                                    },
                                  );
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
                                        Color.fromARGB(144, 7, 133, 57),
                                        Color.fromARGB(144, 7, 133, 57),
                                      ])),
                                  padding: const EdgeInsets.all(0),
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ),
                            ),
                            Text("     "),
                            ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('joinRequests')
                                    .doc(ProjectTitleList[index] +
                                        '-' +
                                        ParticipantEmailList[index])
                                    .update({'Status': 'Declined'});
                                CoolAlert.show(
                                  context: context,
                                  title: "Success!",
                                  confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                                  type: CoolAlertType.success,
                                  backgroundColor:
                                      Color.fromARGB(221, 212, 189, 227),
                                  text: "You have rejected " +
                                      ParticipantNameList[index] +
                                      ", hope you find a better match.",
                                  confirmBtnText: 'Done',
                                  onConfirmBtnTap: () async {
                                    //saving the request in join request collection
              
                                    //send join requist
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RequestListViewPage()));
                                  },
                                );
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
                                  "Decline",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ],
                        )*/
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialogFunc(
                        context,
                        ParticipantNameList[index],
                        ParticipantNoteList[index],
                        ParticipantJoiningAsList[index],
                        ParticipantEmailList[index],
                        ProjectTitleList[index],
                        tokens[index],
                        signedInUser);
                  }),
            );
          },
        ),
      ),
    );
  }
}

showDialogFunc(context, ParticipantName, ParticipantNote, ParticipantJoiningAs,
    ParticipantEmail, ProjectTitle, tokens, signedInUser) {
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
            height: 500,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Code for acceptance role
                Row(children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 0, top: 0),
                      child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 112, 82, 149),
                            size: 26,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RequestListViewPageProject()));
                          }))
                ]),
                // Row(children: <Widget>[
                //   Container(
                //     margin: EdgeInsets.only(left: 115),
                //     child: IconButton(
                //       icon: const Icon(
                //         Icons.account_circle,
                //         color: Color.fromARGB(255, 112, 82, 149),
                //         size: 52,
                //       ),
                //       onPressed: () {
                //         // go to participant's profile
                //       },
                //     ),
                //   )
                // ]),
                // Row(children: <Widget>[
                //   // flex: 6,
                //   Container(
                //     margin: EdgeInsets.only(left: 60),
                //     child: GestureDetector(
                //       child: Text(
                //         " " + ParticipantName + ProjectTitle + " ",
                //         style: const TextStyle(
                //           fontSize: 20,
                //           color: Color.fromARGB(159, 35, 4, 47),
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       onTap: () {
                //         // go to participant's profile
                //       },
                //     ),
                //   ),
                // ]),
                Expanded(
                  flex: 3,
                  child: IconButton(
                    icon: const Icon(
                      Icons.account_circle,
                      color: Color.fromARGB(255, 112, 82, 149),
                      size: 78,
                    ),
                    onPressed: () {
                      // go to participant's profile
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    child: Text(
                      " " + ParticipantName + " ",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(159, 64, 7, 87),
                        fontWeight: FontWeight.w600,
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
                // const Divider(
                //   color: Color.fromARGB(255, 74, 74, 74),
                // ),

                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Joining As: " + ParticipantJoiningAs + " ",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(159, 30, 3, 41),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
                Row(
                  children: <Widget>[
                    if (ParticipantNote != null)
                      Text(
                        "Note: " + ParticipantNote + " ",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(159, 30, 3, 41),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 45,
                ),
                Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 60,
                    decoration: InputDecoration(
                        hintText: "Developer,Designer",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 202, 198, 198)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: RichText(
                          text: TextSpan(
                              text: 'Accepting As',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(230, 64, 7, 87)),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ))
                              ]),
                        )),
                    controller: _AcceptingAsASController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "required";
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!) &&
                          !RegExp(r'^[أ-ي]+$').hasMatch(value!)) {
                        return "Only English or Arabic letters";
                      }
                    },
                  ),
                ),

                //----------------------------------------------------------------------------
                Row(
                  children: <Widget>[
                    Text("   "),
                    Container(
                      margin: EdgeInsets.only(left: 40),
                      child: ElevatedButton(
                        onPressed: () {
                          sendNotification(
                              "Your Request has been Accepted on " +
                                  ProjectTitle +
                                  " project!",
                              tokens);
                          FirebaseFirestore.instance
                              .collection('AllJoinRequests')
                              .doc(ProjectTitle + '-' + ParticipantEmail)
                              .update({
                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('AllJoinRequests')
                              .doc(ProjectTitle + '-' + ParticipantEmail)
                              .update({
                            'Participant_role': _AcceptingAsASController.text
                          });
                          CoolAlert.show(
                            context: context,
                            title: "Success!",
                            confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                            type: CoolAlertType.success,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text: "You have accepted " +
                                ParticipantName +
                                " to be part of your team.",
                            confirmBtnText: 'Done',
                            onConfirmBtnTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                          );
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
                                Color.fromARGB(144, 7, 133, 57),
                                Color.fromARGB(144, 7, 133, 57),
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "Accept",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                    Text("     "),
                    ElevatedButton(
                      onPressed: () {
                        sendNotification(
                            "Sorry, Your request has been Rejected on " +
                                ProjectTitle +
                                "project!",
                            tokens);
                        FirebaseFirestore.instance
                            .collection('AllJoinRequests')
                            .doc(ProjectTitle + '-' + ParticipantEmail)
                            .update({
                          'Status': 'Declined',
                        });

                        CoolAlert.show(
                          context: context,
                          title: "Success!",
                          confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                          type: CoolAlertType.success,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          text: "You have rejected " +
                              ParticipantName +
                              ", hope you find a better match.",
                          confirmBtnText: 'Done',
                          onConfirmBtnTap: () async {
                            //saving the request in join request collection

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                        );
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
                          "Decline",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

void sendNotification(String title, String token) async {
  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
  };

  try {
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAshcbmas:APA91bGwyZZKhGUguFmek5aalqcySgs3oKgJmra4oloSpk715ijWkf4itCOuGZbeWbPBmHWKBpMkddsr1KyEq6uOzZqIubl2eDs7lB815xPnQmXIEErtyG9wpR9Q4rXdzvk4w6BvGQdJ'
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{
                'title': title,
                'body': 'You received a join request on your project!'
              },
              'priority': 'high',
              'data': data,
              'to': '$token'
            }));

    if (response.statusCode == 200) {
      print("Yeh notificatin is sended");
    } else {
      print("Error");
    }
  } catch (e) {}
}
