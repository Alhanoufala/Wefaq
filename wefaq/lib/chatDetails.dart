// import '../app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/chats.dart';
import '../models/user_model.dart';
// import '../widgets/widgets.dart';
import 'screens/detail_screens/Conversation.dart';
import 'chat_composer.dart';

class ChatRoom extends StatefulWidget {
  // const ChatRoom({Key key, @required this.user}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
  // final User user;
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        actions: <Widget>[
          // Container(
          //   // margin: EdgeInsets.only(right: 300),
          //   child: IconButton(
          //     icon: const Icon(
          //       Icons.arrow_back_ios_new,
          //       color: Color.fromARGB(255, 112, 82, 149),
          //       size: 28,
          //     ),
          //     onPressed: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => chatScreen()));
          //     },
          //   ),
          // ),
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 70, 61, 83),
              ),
              onPressed: () {
                _signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
              }),
        ],
        title: Text("Chat",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )),
      ),

      // backgroundColor: MyTheme.kPrimaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Conversation(),
                ),
              ),
            ),
            buildChatComposer()
          ],
        ),
      ),
    );
  }
}
