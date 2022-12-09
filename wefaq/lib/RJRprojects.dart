import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/config/colors.dart';
import 'package:wefaq/viewOtherProfile.dart';
import 'bottom_bar_custom.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;
import 'package:wefaq/service/local_push_notification.dart';

class RequestListViewPageProject extends StatefulWidget {
  @override
  _RequestListProject createState() => _RequestListProject();
}

String P = '-';

final TextEditingController _AcceptingAsASController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _RequestListProject extends State<RequestListViewPageProject> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController? _searchEditingController = TextEditingController();
  var ProjectTitleListController = [];

  List<String> options = [];
  String? selectedOp;
  var ProjectTitleList = [];
  var ProjectTitleListForDisplay = [];
  var ParticipantNoteList = [];
  var ParticipantEmailList = [];
  var ParticipantjoiningAsList = [];
  var ParticipantNameList = [];
  var tokens = [];
  var ProfilePicList = [];

  String? Email;
  @override
  void initState() {
    getCurrentUser();
    getRequests();
    getCategoryList();
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  void getCategoryList() async {
    final categories = await _firestore.collection('AcceptedAs').get();
    for (var category in categories.docs) {
      for (var element in category['AcceptedAs']) {
        setState(() {
          options.add(element);
        });
      }
    }
  }
  //----

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
  //get all requests
  Future getRequests() async {
    setState(() {
      ProjectTitleList = [];
      ParticipantEmailList = [];
      ParticipantNameList = [];
      tokens = [];
      ProfilePicList = [];
    });
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('owner_email', isEqualTo: Email)
          .where('Status', isEqualTo: 'Pending')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            ProjectTitleList.add(Request['project_title']);
            ParticipantEmailList.add(Request['participant_email']);
            ParticipantNameList.add(Request['participant_name']);
            ParticipantjoiningAsList.add(Request['joiningAs']);
            ParticipantNoteList.add(Request['Participant_note']);
            tokens.add(Request['participant_token']);
            ProfilePicList.add(Request['Photo']);
          });
        }
    }
  }

  Future getProjectTitle(String title) async {
    if (title == "") return;
    if (ProjectTitleList.where((element) => element == (title)).isEmpty) {
      CoolAlert.show(
        context: context,
        title: "No such project title!",
        confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
        onConfirmBtnTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RequestListViewPageProject()));
        },
        type: CoolAlertType.error,
        backgroundColor: Color.fromARGB(221, 212, 189, 227),
        text:
            "Please search for a valid project title, valid categories are specified in the drop-down menu below",
      );
      return;
    }
    setState(() {
      ProjectTitleList = [];
      ParticipantEmailList = [];
      ParticipantNameList = [];
      tokens = [];
    });
    var fillterd = _firestore
        .collection('AllJoinRequests')
        .where('owner_email', isEqualTo: Email)
        .where('Status', isEqualTo: 'Pending')
        .where('project_title', isEqualTo: title)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var Request in snapshot.docs) {
        setState(() {
          ProjectTitleList.add(Request['project_title']);
          ParticipantEmailList.add(Request['participant_email']);
          ParticipantNameList.add(Request['participant_name']);
          ParticipantjoiningAsList.add(Request['joiningAs']);
          ParticipantNoteList.add(Request['Participant_note']);
          tokens.add(Request['participant_token']);
          ProfilePicList.add(Request['Photo']);
        });
      }
  }

  _searchBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: TextFormField(
            controller: _searchEditingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Colors.black87, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Color.fromARGB(144, 64, 7, 87),
                ),
              ),
              labelText: "search for project title",
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    getProjectTitle(_searchEditingController!.text);
                  });
                },
              ),
              suffixIcon: _searchEditingController!.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          getRequests();

                          _searchEditingController?.clear();
                        });
                      },
                    )
                  : null,

              //    suffixIcon :IconButton(
              //                onPressed: () {
              //                setState(() {
              //               // _searchEditingController.clear();
              //            });
              //        },
              //      icon: Icon(Icons.clear_outlined),
              //  )
            ),
            onChanged: (text) {
              setState(() {});
              ProjectTitleListController = ProjectTitleList;
            },
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: _searchEditingController!.text.isEmpty
              ? 0
              : ProjectTitleListController.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 40),
              visualDensity: VisualDensity(vertical: -4),
              //leading: CircleAvatar(
              //  backgroundColor: Color.fromARGB(221, 137, 171, 187),
              // child: Icon(
              //    Icons.category_rounded,
              //    color: Colors.white,
              //  ),
              //  ),
              title: Text(
                ProjectTitleList[index].toString(),
              ),
              onTap: () {
                setState(() {
                  _searchEditingController?.text =
                      ProjectTitleListController[index].toString();
                  ProjectTitleListController = [];
                });
              },
            );
          },
          separatorBuilder: (context, index) {
            //<-- SEE HERE
            return Divider(
              thickness: 0,
              color: Color.fromARGB(255, 194, 195, 194),
            );
          },
        )
      ],
    );
  }

  String Photo = "";

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Text('Received Join Requests',
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
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: ProjectTitleList.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 120,
                    child: GestureDetector(
                        child: Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Text(
                                    " " + ProjectTitleList[index] + " Project",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Color.fromARGB(159, 35, 86, 84),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      // var fillterd = _firestore
                                      //     .collection('users')
                                      //     .where("Email",
                                      //         isEqualTo:
                                      //             ParticipantEmailList[index])
                                      //     .snapshots();
                                      // await for (var snapshot in fillterd)
                                      //   for (var user in snapshot.docs) {
                                      //     setState(() {
                                      //       Photo = user["Profile"].toString();
                                      //     });
                                      //   }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  viewotherprofile(
                                                    userEmail:
                                                        ParticipantEmailList[
                                                            index],
                                                  )));
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                          NetworkImage(ProfilePicList[index]),
                                    ),
                                  ),
                                  Text(
                                    ParticipantNameList[index],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Color.fromARGB(159, 32, 3, 43),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                    width: 210,
                                  )),
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color:
                                            Color.fromARGB(255, 170, 169, 179),
                                      ),
                                      onPressed: () {
                                        showDialogFunc(
                                            context,
                                            index,
                                            ProjectTitleList[index],
                                            ParticipantNameList[index],
                                            ParticipantEmailList[index],
                                            ParticipantjoiningAsList[index],
                                            ParticipantNoteList[index],
                                            tokens[index],
                                            signedInUser,
                                            ParticipantEmailList,
                                            ParticipantjoiningAsList,
                                            ProjectTitleList);
                                      }),
                                ]),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialogFunc(
                              context,
                              index,
                              ProjectTitleList[index],
                              ParticipantNameList[index],
                              ParticipantEmailList[index],
                              ParticipantjoiningAsList[index],
                              ParticipantNoteList[index],
                              tokens[index],
                              signedInUser,
                              ParticipantEmailList,
                              ParticipantjoiningAsList,
                              ProjectTitleList);
                        }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// getImage(email) async {
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(email)
//       .get()
//       .then((snapshot) {
//     P = snapshot.data()!['Profile'].toString();
//   });
// }

// This is a block of Model Dialog
showDialogFunc(
    context,
    index,
    title,
    Name,
    email,
    JoinAs,
    Note,
    token,
    signedInUser,
    ParticipantEmailList,
    ParticipantjoiningAsList,
    ProjectTitleList) {
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
            height: 350,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 270, top: 0),
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
                            _AcceptingAsASController.clear();
                          }))
                ]),
                Row(children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Text(
                      " Name:  " + Name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(159, 30, 27, 31),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 10.0),
                const Divider(color: kOutlineColor, height: 1.0),
                const SizedBox(height: 10.0),
                Row(children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Text(
                      " Joining As:  " + JoinAs,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(159, 30, 27, 31),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 10.0),
                const Divider(color: kOutlineColor, height: 1.0),
                const SizedBox(height: 10.0),
                Row(children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Text(
                      " Note:  " + Note,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(159, 30, 27, 31),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 10.0),
                const Divider(color: kOutlineColor, height: 1.0),
                const SizedBox(height: 10.0),
                //TEXTFIELD
                Container(
                  alignment: Alignment.center,
                  child: Form(
                    // key: _formKey,
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
                                text: ' Accepting As',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(159, 30, 27, 31),
                                  fontWeight: FontWeight.bold,
                                ),
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
                        if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value!) &&
                            !RegExp(r'^[ أ-ي]+$').hasMatch(value!)) {
                          return "Only English or Arabic letters";
                        }
                      },
                    ),
                  ),
                ),

                //   //DROPDOWN LIST
                //       Form(child:
                // DropdownButtonFormField(
                //   hint: RichText(
                //     text: TextSpan(
                //         text: 'Accepting As',
                //         style: const TextStyle(
                //             fontSize: 18, color: Color.fromARGB(144, 64, 7, 87)),
                //         children: [
                //           TextSpan(
                //               text: ' *',
                //               style: TextStyle(
                //                 color: Colors.red,
                //               ))
                //         ]),
                //   ),
                //   items: options
                //       .map((e) => DropdownMenuItem(
                //             value: e,
                //             child: Text(e),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       selectedOp = value as String?;
                //     });
                //   },
                //   icon: Icon(
                //     Icons.arrow_drop_down_circle,
                //     color: Color.fromARGB(221, 137, 171, 187),
                //   ),
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide(width: 2.0),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Color.fromARGB(144, 64, 7, 87),
                //         width: 2.0,
                //       ),
                //     ),
                //   ),
                //   validator: (value) {
                //     if (value == null || value == "") {
                //       return 'required';
                //     }
                //   },
                // ),),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          // this will changw to new roles once editted
                          List<String> Roles = JoinAs.split(" - ");
                          if (_AcceptingAsASController.text != "" &&
                                  Roles.contains(
                                      _AcceptingAsASController.text.toString())

                              //     _AcceptingAsASController.text == "Tester" ||
                              // _AcceptingAsASController.text == "Designer" ||
                              // _AcceptingAsASController.text == "Developer"

                              ) {
                            sendNotification(
                                "Your Join request has been accepted ", token);
                            // // ACCEPT ONE Reject ALL
                            // for (var i = 0;
                            //     i < ParticipantEmailList.length;
                            //     i++) {
                            //   if (i != index &&
                            //       ParticipantjoiningAsList[i] ==
                            //           _AcceptingAsASController) {
                            //     FirebaseFirestore.instance
                            //         .collection('AllJoinRequests')
                            //         .doc(title + "-" + ParticipantEmailList[i])
                            //         .update({'Status': 'Rejected'});
                            //   }
                            // }
                            FirebaseFirestore.instance
                                .collection('AllJoinRequests')
                                .doc(ProjectTitleList[index] +
                                    '-' +
                                    ParticipantEmailList[index])
                                .update({'Status': 'Accepted'});
                            FirebaseFirestore.instance
                                .collection('AllJoinRequests')
                                .doc(ProjectTitleList[index] +
                                    '-' +
                                    ParticipantEmailList[index])
                                .update({
                              'Participant_role': _AcceptingAsASController.text
                            });

                            CoolAlert.show(
                                context: context,
                                title: "Success!",
                                confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                                type: CoolAlertType.success,
                                backgroundColor:
                                    Color.fromARGB(221, 212, 189, 227),
                                text: "You have accepted " +
                                    Name +
                                    " to be part of your team.",
                                confirmBtnText: 'Done',
                                onConfirmBtnTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RequestListViewPageProject()));
                                });
                            _AcceptingAsASController.clear();
                          } else {
                            print(Roles);

                            CoolAlert.show(
                              context: context,
                              title: "Choose Role",
                              confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                              type: CoolAlertType.error,
                              backgroundColor:
                                  Color.fromARGB(221, 212, 189, 227),
                              text:
                                  "please choose one of the roles the participant requested to join as, and enter it as its shown in (joining as)",
                              confirmBtnText: 'Try again',
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
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
                            "Sorry, Your join request has been Rejected ",
                            token);
                        FirebaseFirestore.instance
                            .collection('AllJoinRequests')
                            .doc(ProjectTitleList[index] +
                                '-' +
                                ParticipantEmailList[index])
                            .update({'Status': 'Declined'});
                        CoolAlert.show(
                            context: context,
                            title: "Success!",
                            confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                            type: CoolAlertType.success,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text: "You have rejected " +
                                Name +
                                ", hope you find a better match.",
                            confirmBtnText: 'Done',
                            onConfirmBtnTap: () {
                              // if (ProjectTitleList.length == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RequestListViewPageProject()));
                              // } else {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               RequestListViewPage(
                              //                 projectName:
                              //                     projectName,
                              //               )));
                              // }
                            });
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

//Notification

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

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
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
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         RequestListViewPageProject()));
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
