import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_place/google_place.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:url_launcher/link.dart';
import 'package:wefaq/photo.dart';
import 'package:wefaq/rateTeammates.dart';
import 'package:wefaq/service/local_push_notification.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wefaq/viewOtherProfile.dart';
import 'package:wefaq/viewProfileTeamMembers.dart';
import 'package:voice_message_package/voice_message_package.dart';

// import 'package:open_file/open_file.dart';

String FileText = 'test';
late User signedInUser;
late String userEmail;
var tokens = [];

class ChatScreen extends StatefulWidget {
  String projectName;

  ChatScreen({
    required this.projectName,
  });
  static const String screenRoute = 'chat_screen';

  @override
  ChatScreenState createState() => ChatScreenState(projectName);
}

class ChatScreenState extends State<ChatScreen> {
  String projectName;

  ChatScreenState(this.projectName);

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  TextEditingController messageTextEditingControlle = TextEditingController();

  String? messageText;
  var _picurl;
  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get FName => name.first;
  get LName => name.last;
  var senderEmail;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getTokens();
    getTokensOwner();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  PlatformFile? pickedFile;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        userEmail = signedInUser.email.toString();
      }
    } catch (e) {
      print(e);
    }
  }
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   ?.dispose();
  //   _audioRecorder.dispose();
  // }

  bool startRecord = false;
  final _audioRecorder = Record();
  File? imageFile;
  ImagePicker _picker = ImagePicker();
  String uploadedFileURL = '';

  Future uploadAudioToFirebase(@required bool start) async {
    if (start) {
      ///
      if (await _audioRecorder.hasPermission()) {
        try {
          if (await _audioRecorder.hasPermission()) {
            final isSupported = await _audioRecorder.isEncoderSupported(
              AudioEncoder.aacLc,
            );
            if (kDebugMode) {
              print('${AudioEncoder.aacLc.name} supported: $isSupported');
            }
            await _audioRecorder.start();
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    } else {
      final path = await _audioRecorder.stop();
      print("Getting recording");

      if (path != null) {
        print(path);
        setState(() {
          imageFile = File(path);
        });
        String fileName = imageFile!.path;
        final reference =
            FirebaseStorage.instance.ref().child('Recordings/$fileName');
        UploadTask uploadTask = reference.putFile(imageFile!);
        await uploadTask.whenComplete(() => null);
        print('File Uploaded');
        reference.getDownloadURL().then((fileURL) {
          setState(() {
            uploadedFileURL = fileURL;
            messageText = uploadedFileURL;

            _firestore.collection(projectName + " project").add({
              "message": messageText,
              "senderName": FName + " " + LName,
              "email": userEmail,
              "time": FieldValue.serverTimestamp(),
              "FileNameI": '',
            });
          });
        });
        print(
            "--------------------------------------- Url $uploadedFileURL -------------------------------------");
      }
    }
  }

  Future uploadImageToFirebase() async {
    print("Getting Image from Gallery.");
    XFile? result = await _picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    if (result != null) {
      print(result);
      setState(() {
        imageFile = File(result!.path);
      });
      String fileName = imageFile!.path;
      final reference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile!);
      await uploadTask.whenComplete(() => null);
      print('File Uploaded');
      reference.getDownloadURL().then((fileURL) {
        setState(() {
          uploadedFileURL = fileURL;
          messageText = uploadedFileURL;

          _firestore.collection(projectName + " project").add({
            "message": messageText,
            "senderName": FName + " " + LName,
            "email": userEmail,
            "time": FieldValue.serverTimestamp(),
            "FileNameI": '',
          });
        });
      });
      print(
          "--------------------------------------- Url $uploadedFileURL -------------------------------------");
    } else
      Navigator.of(context).pop();
  }

  Future uploadCameraImageToFirebase() async {
    print("Getting Image from Gallery.");
    XFile? result = await _picker.pickImage(source: ImageSource.camera);
    Navigator.of(context).pop();

    if (result != null) {
      print(result);
      setState(() {
        imageFile = File(result!.path);
      });
      String fileName = imageFile!.path;
      final reference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile!);
      await uploadTask.whenComplete(() => null);
      print('File Uploaded');
      reference.getDownloadURL().then((fileURL) {
        setState(() {
          uploadedFileURL = fileURL;

          messageText = uploadedFileURL;

          _firestore.collection(projectName + " project").add({
            "message": messageText,
            "senderName": FName + " " + LName,
            "email": userEmail,
            "time": FieldValue.serverTimestamp(),
            "FileNameI": '',
          });
        });
      });
      print(
          "--------------------------------------- Url $uploadedFileURL -------------------------------------");
    } else
      Navigator.of(context).pop();
  }

  Future uploadFileToFirebase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    Navigator.of(context).pop();
    if (result != null) {
      PlatformFile f = result.files.first;
      print(f.name);
      print(f.bytes);
      print(f.size);
      print(f.extension);
      print(f.path);
      File file = File(result.files.single.path!);
      setState(() {
        FileText = file.path;
      });
      String fileName = result.files.first.name;
      final storageReference =
          FirebaseStorage.instance.ref().child('files/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() => null);
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          uploadedFileURL = fileURL;
          messageText = uploadedFileURL;
          _firestore.collection(projectName + " project").add({
            "message": messageText,
            "senderName": FName + " " + LName,
            "email": userEmail,
            "time": FieldValue.serverTimestamp(),
            "FileNameI": f.name,
          });
        });
      });
      print(
          "--------------------------------------- Url $uploadedFileURL -------------------------------------");
    } else
      Navigator.of(context).pop();
  }

  Future selectMultiFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> Files = result.paths.map((path) => File(path!)).toList();

      setState(() {
        FileText = Files.toString();
      });
      Navigator.of(context).pop();
    } else
      Navigator.of(context).pop();
  }

  // Future Camera() async {
  //   XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     imageFile = File(image!.path);
  //   });
  //   fileUrl = uploadImageToFirebase(imageFile!).toString();
  //   Navigator.of(context).pop();
  // }

  // Future selectSingleImage() async {
  //   print("Getting Image from Gallery.");
  //   XFile? result = await _picker.pickImage(source: ImageSource.gallery);
  //   if (result != null) {
  //     print(result);
  //     setState(() {
  //       imageFile = File(result!.path);
  //     });
  //     Navigator.of(context).pop();
  //     fileUrl = uploadImageToFirebase(imageFile!).toString();
  //     Navigator.of(context).pop();
  //   } else
  //     Navigator.of(context).pop();
  // }
  options(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text("Choose",
                          style: TextStyle(
                              color: Color.fromARGB(255, 127, 127, 127),
                              fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.only(
                          left: 134,
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close),
                          color: Color.fromARGB(255, 141, 168, 170),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.photo_library_sharp,
                          color: Color.fromARGB(255, 141, 168, 170),
                        ),
                        title: Text("Browse Gallery",
                            style: TextStyle(
                                color: Color.fromARGB(255, 141, 114, 151))),
                        onTap: () => uploadImageToFirebase(),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.camera_alt,
                          color: Color.fromARGB(255, 141, 168, 170),
                        ),
                        title: Text("Take a photo",
                            style: TextStyle(
                                color: Color.fromARGB(255, 141, 114, 151))),
                        onTap: () => uploadCameraImageToFirebase(),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.library_books,
                          color: Color.fromARGB(255, 141, 168, 170),
                        ),
                        title: Text("Send a file",
                            style: TextStyle(
                                color: Color.fromARGB(255, 141, 114, 151))),
                        onTap: () => uploadFileToFirebase(),
                      ),
                    ],
                  ),
                ],
              )),
            ));
  }

  Future getTokens() async {
    var fillterd = _firestore
        .collection('AllJoinRequests')
        .where('project_title', isEqualTo: projectName)
        .where('Status', isEqualTo: 'Accepted')
        .snapshots();
    await for (var snapshot in fillterd)
      for (var Request in snapshot.docs) {
        setState(() {
          tokens.add(Request['participant_token']);
        });
      }
  }

  bool played = false;

  Future getTokensOwner() async {
    var fillterd = _firestore
        .collection("AllProjects")
        .where('project_title', isEqualTo: projectName)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var p in snapshot.docs) {
        setState(() {
          tokens.add(p['token']);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Row(
          children: [
            Image.asset('assets/images/teams.png', height: 40),
            SizedBox(width: 10),
            Text(
              projectName,
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 190),
              child: IconButton(
                  icon: const Icon(Icons.star_border_purple500_outlined,
                      color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => rateTeammates(
                                  projectName: projectName,
                                )));
                  }),
            ))
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection(projectName + " project")
                    .orderBy(
                      "time",
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  List<MessageLine> messageWidgets = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(221, 81, 122, 140),
                      ),
                    );
                  }
                  var timeH;
                  var timeM;
                  String? dateM;
                  Timestamp? timestamp;
                  final messages = snapshot.data!.docs.reversed;
                  for (var message in messages) {
                    var messageText = message.get("message");
                    final messageSender = message.get("senderName");
                    final messageFileName = message.get("FileNameI");

                    senderEmail = message.get("email");
                    if (message.get("time") != null) {
                      timeH = message.get("time").toDate().hour;
                      timeM = message.get("time").toDate().minute;
                      timestamp = message.get("time");
                      dateM = DateFormat.yMMMd()
                          .format(message.get("time").toDate());
                    }
                    if (messageText == null) messageText = ' ';

                    final messageWidget = MessageLine(
                        hour: timeH,
                        minute: timeM,
                        text: messageText,
                        sender: messageSender,
                        filename: messageFileName,
                        img: imageFile,
                        isMe: signedInUser.email == senderEmail,
                        date: dateM.toString(),
                        time: timestamp,
                        email: senderEmail.toString());
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: GroupedListView<MessageLine, String>(
                      reverse: true,
                      elements: messageWidgets,
                      groupBy: (message) => message.date.toString(),
                      itemComparator: (item1, item2) =>
                          item1.time!.compareTo(item2.time!),
                      order: GroupedListOrder.DESC,
                      groupSeparatorBuilder: (String groupByValue) => SizedBox(
                          height: 40,
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    groupByValue == "null" ? "" : groupByValue,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 144, 120, 155),
                                    ),
                                  )))),
                      itemBuilder: (context, MessageLine message) => (Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: message.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            if (message.isMe)
                              Text("You",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 147, 160, 166),
                                  )),
                            if (!message.isMe)
                              Row(
                                children: [
                                  if (!message.isMe)
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    viewProfileTeamMembers(
                                                      userEmail: message.email,
                                                      projectName: projectName,
                                                    )));
                                      },
                                      // child: Container(
                                      //   height: 22.0,
                                      //   width: 22.0,
                                      //   margin:
                                      //       const EdgeInsets.only(right: 8.0),
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //     image: const DecorationImage(
                                      //       image: AssetImage(
                                      //           'assets/images/PlaceHolder.png'),
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //     boxShadow: [
                                      //       BoxShadow(
                                      //         offset: const Offset(0, 4),
                                      //         blurRadius: 4.0,
                                      //         color: Colors.black
                                      //             .withOpacity(0.25),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      child: Text(message.sender.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 84, 17, 115),
                                          )),
                                    ),
                                ],
                              ),
                            if (!message.text!.startsWith(
                                'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/'))
                              Container(
                                margin: message.isMe
                                    ? EdgeInsets.only(left: 80)
                                    : EdgeInsets.only(right: 80),
                                child: Material(
                                  borderRadius: message.isMe
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        )
                                      : BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                  color: message.isMe
                                      ? Color.fromARGB(255, 182, 168, 203)
                                      : Color.fromARGB(255, 178, 195, 202),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Text(
                                      message.text.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (message.text!.startsWith(
                                'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/Recordings'))
                              VoiceMessage(
                                audioSrc: message.text.toString(),
                                played: played, // To show played badge or not.
                                me: message.isMe ? true : false,
                                onPlay: () {
                                  played = true;
                                },
                                meBgColor: Color.fromARGB(255, 182, 168, 203),
                                contactBgColor:
                                    Color.fromARGB(255, 178, 195, 202),
                                contactFgColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                meFgColor: Color.fromARGB(255, 255, 255, 255),
                              ),
                            // VoiceMessage(
                            //   audioSrc: message.text.toString(),
                            //   played: played,
                            //   me: message.isMe ? true : false,
                            //   onPlay: () {
                            //     played = true;
                            //   },
                            //   meFgColor: Colors.white,
                            //   meBgColor: Colors.transparent,
                            // ),
                            if (message.text!.startsWith(
                                'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/images'))
                              Material(
                                borderRadius: message.isMe
                                    ? BorderRadius.only(
                                        topLeft: Radius.zero,
                                        bottomLeft: Radius.zero,
                                        bottomRight: Radius.zero,
                                      )
                                    : BorderRadius.only(
                                        topRight: Radius.zero,
                                        bottomLeft: Radius.zero,
                                        bottomRight: Radius.zero,
                                      ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PhotoDisplay(
                                                  photoURL:
                                                      message.text.toString(),
                                                  date: message.date,
                                                  time: message.hour
                                                          .toString() +
                                                      ":" +
                                                      message.minute.toString(),
                                                  name:
                                                      message.sender.toString(),
                                                )));
                                  },
                                  child: Image.network(
                                    message.text.toString(),
                                    height: 280,
                                    width: 150,
                                  ),
                                ),
                              ),
                            if (message.text!.startsWith(
                                'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/files'))
                              Material(
                                borderRadius: message.isMe
                                    ? BorderRadius.only(
                                        topLeft: Radius.zero,
                                        bottomLeft: Radius.zero,
                                        bottomRight: Radius.zero,
                                      )
                                    : BorderRadius.only(
                                        topRight: Radius.zero,
                                        bottomLeft: Radius.zero,
                                        bottomRight: Radius.zero,
                                      ),
                                // child: TextButton(
                                //   onPressed: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => PhotoDisplay(
                                //                   photoURL:
                                //                       message.text.toString(),
                                //                   date: message.date,
                                //                   time: message.hour
                                //                           .toString() +
                                //                       ":" +
                                //                       message.minute.toString(),
                                //                   name:
                                //                       message.sender.toString(),
                                //                 )));
                                //   },
                                //   child: Image.network(
                                //     message.text.toString(),
                                //     height: 280,
                                //     width: 150,
                                //   ),
                                // ),
                                child: Container(
                                  child: Link(
                                    target: LinkTarget.blank,
                                    uri: Uri.parse(
                                      message.text.toString(),
                                    ),
                                    builder: (context, followLink) => Column(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              launch(message.text.toString()),
                                          icon: Icon(
                                            Icons.file_present_outlined,
                                            size: 40,
                                          ),
                                          color: Color.fromARGB(
                                              255, 150, 138, 169),
                                        ),
                                        Text(message.filename.toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Color.fromARGB(
                                                  255, 109, 107, 110),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (message.hour != null && message.minute != null)
                              Text(
                                  message.hour.toString() +
                                      ":" +
                                      message.minute.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromARGB(255, 109, 107, 110),
                                  )),
                          ],
                        ),
                      )),
                    ),
                  );
                }),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(172, 136, 98, 146),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: null,
                      controller: messageTextEditingControlle,
                      onChanged: (value) {
                        setState(() {
                          messageText = value;
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: messageTextEditingControlle.text.isNotEmpty
                            ? TextButton(
                                onPressed: () async {
                                  setState(() {
                                    messageTextEditingControlle.clear();
                                  });

                                  _firestore
                                      .collection(projectName + " project")
                                      .add({
                                    "message": messageText!.contains('https')
                                        ? uploadedFileURL
                                        : messageText,
                                    "senderName": FName + " " + LName,
                                    "email": userEmail,
                                    "time": FieldValue.serverTimestamp(),
                                    "FileNameI": '',
                                  });
                                  String? token = await FirebaseMessaging
                                      .instance
                                      .getToken();
                                  for (int i = 0; i < tokens.length; i++) {
                                    if (messageText!.contains(
                                        'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/images')) {
                                      messageText = ' Photo';
                                    } else if (messageText!.contains(
                                        'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/files')) {
                                      messageText = 'File';
                                    } else if (messageText!.contains(
                                        'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/Recordings')) {
                                      messageText = ' VoiceNote';
                                    }
                                    if (tokens[i].toString() != token)
                                      sendNotification(
                                          FName + ":" + messageText, tokens[i]);
                                  }
                                  setState(() {
                                    messageText = "";
                                  });
                                },
                                child: CircleAvatar(
                                  // backgroundColor: MyTheme.kAccentColor,
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 182, 168, 203),
                                ))
                            : Row(children: [
                                IconButton(
                                    onPressed: () {
                                      uploadAudioToFirebase(
                                          startRecord ? false : true);
                                      setState(() {
                                        startRecord =
                                            startRecord ? false : true;
                                      });
                                    },
                                    icon: Icon(startRecord
                                        ? Icons.stop_circle
                                        : Icons.mic)),
                                IconButton(
                                  onPressed: () => options(context),
                                  icon: Icon(Icons.attach_file_outlined),
                                ),
                              ]),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine {
  const MessageLine(
      {this.img,
      this.text,
      this.hour,
      this.minute,
      this.sender,
      this.filename,
      required this.isMe,
      required this.date,
      required this.time,
      required this.email});
  final File? img;
  final int? hour;
  final int? minute;
  final String? sender;
  final String? filename;

  final String? text;
  final String date;
  final String email;

  final bool isMe;
  final Timestamp? time;
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
              'notification': <String, dynamic>{'title': title, 'body': ''},
              'priority': 'high',
              'data': data,
              'to': '$token'
            }));

    if (response.statusCode == 200) {
      print("Your notificatin is sent");
    } else {
      print("Error");
    }
  } catch (e) {}
}
