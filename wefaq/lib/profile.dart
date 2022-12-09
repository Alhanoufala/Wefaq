import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/background.dart';
import 'bottom_bar_custom.dart';

class profileScreen extends StatefulWidget {
  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  @override
  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get FName => name.first;
  get LName => name.last;

  // String Lname = name[1];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
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
        backgroundColor: Color.fromARGB(255, 182, 168, 203),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Background(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 100),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 143, 132, 159), width: 5),
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/PlaceHolder.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 290),
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 159, 185, 185),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        //sprint two :)
                      },
                    ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("First Name:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(144, 64, 7, 87),
                            fontSize: 19),
                        textAlign: TextAlign.left),
                    alignment: Alignment.topLeft),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text("$FName",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 93, 89, 104),
                                fontSize: 19),
                            textAlign: TextAlign.left),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 164, 192)),
                        ),
                        color: Color.fromARGB(23, 255, 255, 255))),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("Last Name:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(144, 64, 7, 87),
                            fontSize: 19),
                        textAlign: TextAlign.left),
                    alignment: Alignment.topLeft),
                SizedBox(height: 0.90),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text("$LName",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(118, 117, 121, 1),
                                fontSize: 19),
                            textAlign: TextAlign.left),
                        SizedBox(width: 260),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 164, 192)),
                        ),
                        color: Color.fromARGB(23, 255, 255, 255))),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("Email:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(144, 64, 7, 87),
                            fontSize: 19),
                        textAlign: TextAlign.left),
                    alignment: Alignment.topLeft),
                SizedBox(height: 0.90),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text('${FirebaseAuth.instance.currentUser!.email}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(118, 117, 121, 1),
                                fontSize: 19),
                            textAlign: TextAlign.left),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 164, 192)),
                        ),
                        color: Color.fromARGB(23, 255, 255, 255))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("Experience:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(144, 64, 7, 87),
                            fontSize: 19),
                        textAlign: TextAlign.left),
                    alignment: Alignment.topLeft),
                SizedBox(height: 0.90),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text('Web Development',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(118, 117, 121, 1),
                                fontSize: 19),
                            textAlign: TextAlign.left),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 164, 192)),
                        ),
                        color: Color.fromARGB(23, 255, 255, 255))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("Skills:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(144, 64, 7, 87),
                            fontSize: 19),
                        textAlign: TextAlign.left),
                    alignment: Alignment.topLeft),
                SizedBox(height: 0.90),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text('Html & Css',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(118, 117, 121, 1),
                                fontSize: 19),
                            textAlign: TextAlign.left),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 164, 192)),
                        ),
                        color: Color.fromARGB(23, 255, 255, 255))),
                SizedBox(height: 60),
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      deleteprofile();
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
                      width: size.width * 0.5,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: new LinearGradient(colors: [
                            Color.fromARGB(144, 67, 7, 87),
                            Color.fromARGB(221, 137, 171, 187)
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Delete Account",
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> deleteprofile() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }
}
