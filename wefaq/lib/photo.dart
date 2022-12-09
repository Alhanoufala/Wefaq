import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PhotoDisplay extends StatefulWidget {
  PhotoDisplay(
      {required this.photoURL,
      required this.date,
      required this.time,
      required this.name});
  String photoURL;
  String date;
  String time;
  String name;

  @override
  State<PhotoDisplay> createState() => photoState(photoURL, date, time, name);
}

class photoState extends State<PhotoDisplay> {
  String photoURL;
  String date;
  String time;
  String name;
  photoState(this.photoURL, this.date, this.time, this.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 182, 168, 203),
        title: Text(
          name + " on " + date + " ," + time,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Center(
        child: Image.network(
          photoURL,
        ),
      ),
    );
  }
}
