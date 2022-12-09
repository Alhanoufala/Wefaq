import 'package:flutter/material.dart';
import 'package:wefaq/postEvent.dart';
import 'package:wefaq/postProject.dart';
import 'bottom_bar_custom.dart';
import 'package:wefaq/userLogin.dart';

class selectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Post', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                MaterialPageRoute(builder: (context) => UserLogin());
              }),
        ],
        backgroundColor: Color.fromARGB(255, 182, 168, 203),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 2,
        updatePage: () {},
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Profile.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80),
            profileMenuItem(
                text: 'Post Project', icon: Icons.lightbulb, arrowShown: true),
            SizedBox(height: 80),
            profileMenuItem(
                text: 'Post Event', icon: Icons.post_add, arrowShown: true),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class profileMenuItem extends StatelessWidget {
  const profileMenuItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.arrowShown,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final bool arrowShown;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)),
            textStyle: TextStyle(color: Colors.white),
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () {
            if (text == 'Post Project')
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostProject()));
            else
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostEvent()));
          },
          child: Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  gradient: new LinearGradient(colors: [
                    Color.fromARGB(144, 64, 7, 87),
                    Color.fromARGB(221, 137, 171, 187)
                  ])), // BoxDecoration
              height: 80,
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Icon(
                          icon,
                          size: 35,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ), // Icon
                      ), // Padding
                      SizedBox(width: 10),
                      Text(
                        "$text",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(197, 255, 255, 255),
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ), // Text
                    ],
                  ),
                  arrowShown
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 40,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ), // Icon
                        )
                      : Container(), // Padding
                ],
              )),
        ));
  }
}
