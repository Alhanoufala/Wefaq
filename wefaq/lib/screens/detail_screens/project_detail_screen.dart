import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

final _formKey = GlobalKey<FormState>();

class projectDetailScreen extends StatefulWidget {
  String projecName;

  projectDetailScreen({required this.projecName});

  @override
  State<projectDetailScreen> createState() =>
      _projectDetailScreenState(projecName);
}

class _projectDetailScreenState extends State<projectDetailScreen> {
  @override
  void initState() {
    getCurrentUser();
    getProjects();
    getRequests();
    //getProfilePhoto();
    super.initState();
  }

  String projecName;
  _projectDetailScreenState(this.projecName);

  final TextEditingController _JoiningASController = TextEditingController();
  final TextEditingController _ParticipantNoteController =
      TextEditingController();
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
  String profile = "";
  List<String> participantNames = [];

  var ProjectTitleList = [];

  var ParticipantEmailList = [];
  bool _isSelected1 = false;
  bool _isSelected2 = false;
  bool _isSelected3 = false;

  bool isPressed = false;
  List<String> splited = [];

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
          splited = lookingForList.split(",");
          profile = project["Profile"].toString();
        });
      }
  }

/*
  Future getProfilePhoto() async {
    var fillterd = _firestore
        .collection('users')
        .where("Email", isEqualTo: ownerEmail)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var user in snapshot.docs) {
        setState(() {
          profile = user["Profile"].toString();
        });
      }
  }
*/
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

  String getRole(int index) {
    if (index < splited.length) return splited[index];

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scrollbar(
      child: CustomScrollView(
        slivers: <Widget>[
          const DetailAppBar(),
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
                                        builder: (context) => viewotherprofile(
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
                                  image: NetworkImage(profile),
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
                  Row(children: [
                    Text(
                      'Looking For',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ))
                  ]),
                  Text('Select the Role you want to join as',
                      style: TextStyle(
                          color: Color.fromARGB(170, 123, 62, 185),
                          fontWeight: FontWeight.bold)),
                  Text(
                      '- You can select multiple roles but if accepted, you will be only accepted in one role',
                      style: TextStyle(
                          color: Color.fromARGB(170, 9, 0, 17),
                          fontWeight: FontWeight.w400)),
                  Column(
                    children: [
                      Row(
                        children: [
                          if (getRole(1) != "")
                            ChoiceChip(
                              elevation: 8.0,
                              padding: EdgeInsets.all(2.0),
                              label: Text(
                                getRole(1),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              selected: _isSelected1,
                              selectedColor: Color.fromARGB(133, 177, 227, 232),
                              onSelected: (bool selected) {
                                setState(() {
                                  _isSelected1 = selected;
                                });
                              },
                              backgroundColor:
                                  Color.fromARGB(170, 123, 62, 185),
                            ),
                          SizedBox(
                            width: 6,
                          ),
                          if (getRole(2) != "")
                            ChoiceChip(
                              elevation: 8.0,
                              padding: EdgeInsets.all(2.0),
                              label: Text(
                                getRole(2),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              selected: _isSelected2,
                              selectedColor: Color.fromARGB(133, 177, 227, 232),
                              onSelected: (bool selected) {
                                setState(() {
                                  _isSelected2 = selected;
                                });
                              },
                              backgroundColor:
                                  Color.fromARGB(170, 123, 62, 185),
                            ),
                          SizedBox(
                            width: 6,
                          ),
                          if (getRole(3) != "")
                            ChoiceChip(
                              elevation: 8.0,
                              padding: EdgeInsets.all(2.0),
                              label: Text(
                                getRole(3),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              selected: _isSelected3,
                              selectedColor: Color.fromARGB(133, 177, 227, 232),
                              onSelected: (bool selected) {
                                setState(() {
                                  _isSelected3 = selected;
                                });
                              },
                              backgroundColor:
                                  Color.fromARGB(170, 123, 62, 185),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (_isSelected1 == false &&
                      _isSelected2 == false &&
                      _isSelected3 == false)
                    Text(' please select one role at least to join the project',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(170, 185, 62, 62),
                            fontWeight: FontWeight.w400)),
                  Container(
                    alignment: Alignment.center,
                    child: Form(
                      // key: _formKey,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 60,
                        decoration: InputDecoration(
                            hintText:
                                "Your Note will be visible with your request",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 202, 198, 198)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: RichText(
                              text: TextSpan(
                                text: 'Note',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(230, 35, 33, 35)),
                              ),
                            )),
                        controller: _ParticipantNoteController,
                        validator: (value) {
                          if (!RegExp(r'^[ , . a-z A-Z]+$').hasMatch(value!) &&
                              !RegExp(r'^[ أ-ي]+$').hasMatch(value!) &&
                              value.isNotEmpty) {
                            return "Only English or Arabic letters";
                          }
                        },
                      ),
                    ),
                  ),
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
                  const SizedBox(height: 37.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                      left: 24,
                      right: 24,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        //disable joining your own projects
                        if (ownerEmail == Email) {
                          CantJoin();
                          return null;
                        }
                        var P;

                        //send a notification to the one who posted the project
                        sendNotification(
                            "You received a join request on your project!",
                            token);
                        //sucess message
                        if (_isSelected1 == true ||
                            _isSelected2 == true ||
                            _isSelected3 == true) {
                          // if (_formKey.currentState!.validate()) {
                          CoolAlert.show(
                            context: context,
                            title: "Success!",
                            confirmBtnColor: Color.fromARGB(174, 111, 78, 161),
                            onConfirmBtnTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProjectsTabs()));
                            },
                            type: CoolAlertType.success,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text: "Your join request is sent successfuly",
                          );
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(signedInUser.email)
                              .get()
                              .then((snapshot) async {
                            String? token_Participant =
                                await FirebaseMessaging.instance.getToken();
                            FirebaseFirestore.instance
                                .collection('AllJoinRequests')
                                .doc(nameList + '-' + signedInUser.email!)
                                .set({
                              'project_title': nameList,
                              'participant_email': signedInUser.email,
                              'owner_email': ownerEmail,
                              'participant_name': FirebaseAuth
                                  .instance.currentUser!.displayName,
                              'participant_token': token_Participant,
                              'Status': 'Pending',
                              'joiningAs': selection(
                                  _isSelected1, _isSelected2, _isSelected3),
                              'Participant_note':
                                  _ParticipantNoteController.text,
                              'Participant_role': "",
                              "Photo": snapshot.data()!['Profile'].toString()
                            });
                          });
                          _JoiningASController.clear();
                          _ParticipantNoteController.clear();
                          // }
                        } else {
                          CoolAlert.show(
                            context: context,
                            title: "No Role Selected",
                            confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                            type: CoolAlertType.error,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text:
                                "please select one role at least to join the project",
                            confirmBtnText: 'Try again',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(204, 109, 46, 154),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          )),
                      child: const Text(
                        "JOIN NOW",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  selection(bool _isSelected1, bool _isSelected2, bool _isSelected3) {
    String JoiningAs;

    if (_isSelected1 == true && _isSelected2 == false && _isSelected3 == false)
      JoiningAs = getRole(1);
    else if (_isSelected1 == false &&
        _isSelected2 == true &&
        _isSelected3 == false)
      JoiningAs = getRole(2);
    else if (_isSelected1 == false &&
        _isSelected2 == false &&
        _isSelected3 == true)
      JoiningAs = getRole(3);
    else if (_isSelected1 == true &&
        _isSelected2 == true &&
        _isSelected3 == false)
      JoiningAs = getRole(1) + " - " + getRole(2);
    else if (_isSelected1 == true &&
        _isSelected2 == false &&
        _isSelected3 == true)
      JoiningAs = getRole(1) + " - " + getRole(3);
    else if (_isSelected1 == false &&
        _isSelected2 == true &&
        _isSelected3 == true)
      JoiningAs = getRole(2) + " - " + getRole(3);
    else if (_isSelected1 == true &&
        _isSelected2 == true &&
        _isSelected3 == true)
      JoiningAs = getRole(1) + " - " + getRole(2) + " - " + getRole(3);
    else
      JoiningAs = 'No Role';

    print(JoiningAs);

    return JoiningAs;
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

void CantJoin() => Fluttertoast.showToast(
      msg: "You can't join your own project",
      fontSize: 18,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color.fromARGB(172, 136, 98, 146),
    );
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