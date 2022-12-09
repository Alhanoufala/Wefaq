// ignore_for_file: prefer_const_constructors

import 'package:intl/intl.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/eventsTabs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostEvent extends StatefulWidget {
  const PostEvent({Key? key}) : super(key: key);

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> {
  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late User? signedInUser = auth.currentUser;

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  final TextEditingController _lookingForEditingController =
      TextEditingController();
  static final TextEditingController _startSearchFieldController =
      TextEditingController();
  DateTime dateTime = new DateTime.now();

  final TextEditingController _urlEditingController = TextEditingController();

  DetailsResult? startPosition;

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  // Project category list
  List<String> options = [];

  String? selectedCat;

  @override
  void initState() {
    // call the methods to fetch the data from the DB
    getCategoryList();

    super.initState();
    String apiKey = 'AIzaSyCkRaPfvVejBlQIAWEjc9klnkqk6olnhuc';
    googlePlace = GooglePlace(apiKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getCategoryList() async {
    final categoriesE = await _firestore.collection('categoriesE').get();
    for (var category in categoriesE.docs) {
      for (var element in category['catE']) {
        setState(() {
          options.add(element);
        });
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 182, 168, 203),
            title: Text('Post Event',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ))),
        bottomNavigationBar: CustomNavigationBar(
          currentHomeScreen: 2,
          updatePage: () {},
        ),
        body: Scrollbar(
          thumbVisibility: true,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                  children: <Widget>[
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 20,
                        decoration: InputDecoration(
                          hintText: 'AI dilemma',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 202, 198, 198)),
                          label: RichText(
                            text: TextSpan(
                                text: "Event name",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(144, 64, 7, 87)),
                                children: [
                                  TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ))
                                ]),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(144, 64, 7, 87),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(144, 64, 7, 87),
                              width: 2.0,
                            ),
                          ),
                        ),
                        controller: _nameEditingController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim() == '')
                            return 'required';
                          else if (!RegExp(r'^[a-z A-Z . , -]+$')
                                  .hasMatch(value!) &&
                              !RegExp(r'^[, . - أ-ي]+$').hasMatch(value!))
                            return "Only English or Arabic letters";
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _startSearchFieldController,
                        decoration: InputDecoration(
                            hintText: 'Ksu..auto complete',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 202, 198, 198)),
                            label: RichText(
                              text: TextSpan(
                                  text: 'Event location',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(144, 64, 7, 87)),
                                  children: [
                                    TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ))
                                  ]),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black87, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(144, 64, 7, 87),
                                width: 2.0,
                              ),
                            ),
                            suffixIcon: _startSearchFieldController
                                    .text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        predictions = [];
                                        _startSearchFieldController.clear();
                                      });
                                    },
                                    icon: Icon(Icons.clear_outlined),
                                  )
                                : Icon(Icons.location_searching,
                                    color: Color.fromARGB(221, 137, 171, 187))),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 1000), () {
                            if (value.isNotEmpty) {
                              //places api
                              autoCompleteSearch(value);
                            } else {
                              //clear out the results
                              setState(() {
                                predictions = [];
                                startPosition = null;
                              });
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim() == '') {
                            return 'required';
                          }
                        }),
                    Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(221, 137, 171, 187),
                                child: Icon(
                                  Icons.pin_drop,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                predictions[index].description.toString(),
                              ),
                              onTap: () async {
                                final placeId = predictions[index].placeId!;
                                final details =
                                    await googlePlace.details.get(placeId);
                                if (details != null &&
                                    details.result != null &&
                                    mounted) {
                                  setState(() {
                                    startPosition = details.result;
                                    _startSearchFieldController.text =
                                        details.result!.name!;

                                    predictions = [];
                                  });
                                }
                              },
                            );
                          }),
                    ),

                    SizedBox(height: 20.0),

                    DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      hint: RichText(
                        text: TextSpan(
                            text: 'Event catogory',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(144, 64, 7, 87)),
                            children: [
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ))
                            ]),
                      ),
                      items: options
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCat = value as String?;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Color.fromARGB(221, 137, 171, 187),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(144, 64, 7, 87),
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'Required ';
                        }
                      },
                    ),
                    const SizedBox(height: 15.0),

                    Text(
                      '${dateTime.day}-${dateTime.month}-${dateTime.year} | ${dateTime.hour}:${dateTime.minute}',
                      style: const TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 58, 86, 96)),
                    ),
                    //Date and Time8
                    //Date and Time
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      child: RichText(
                        text: TextSpan(
                            text: 'Select Date and Time',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(144, 64, 7, 87)),
                            children: [
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ))
                            ]),
                      ),
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: dateTime,
                            firstDate: dateTime,
                            lastDate: DateTime(2025));
                        if (newDate == null) return;

                        TimeOfDay? newTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (newTime == null) return;

                        final newDateTime = DateTime(
                          newDate.year,
                          newDate.month,
                          newDate.day,
                          newTime.hour,
                          newTime.minute,
                        );
                        setState(() {
                          dateTime = newDateTime;
                        });
                      },
                    ), //URL
                    const SizedBox(height: 20.0),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'https://ksu.edu.sa/',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 202, 198, 198)),
                          label: RichText(
                            text: TextSpan(
                                text: "Regstrition URL",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(144, 64, 7, 87)),
                                children: [
                                  TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ))
                                ]),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(144, 64, 7, 87),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(144, 64, 7, 87),
                              width: 2.0,
                            ),
                          ),
                        ),
                        controller: _urlEditingController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim() == '') {
                            return 'required';
                          }
                        }),

                    SizedBox(height: 25.0),
                    Scrollbar(
                      thumbVisibility: true,
                      child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLength: 500,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'the event will be talking about...',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 202, 198, 198)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(144, 64, 7, 87),
                                width: 2.0,
                              ),
                            ),
                            label: RichText(
                              text: TextSpan(
                                  text: "Event description",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(144, 64, 7, 87)),
                                  children: [
                                    TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ))
                                  ]),
                            ),
                          ),
                          controller: _descriptionEditingController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == '') {
                              return 'required';
                            }
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      width: 50,
                      height: 50.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(144, 64, 7, 87),
                          ),
                          child: Text('Post',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              // for sorting purpose
                              var now = new DateTime.now();
                              var formatter = new DateFormat('yyyy-MM-dd');

                              _firestore
                                  .collection('AllEvent')
                                  .doc(_nameEditingController.text)
                                  .set({
                                'name': _nameEditingController.text,
                                'email': signedInUser?.email,
                                'location': _startSearchFieldController.text,
                                'description':
                                    _descriptionEditingController.text,
                                'category': selectedCat,
                                'regstretion url ': _urlEditingController.text,
                                'date': formatter.format(dateTime),
                                'time': dateTime.hour.toString() +
                                    ":" +
                                    dateTime.minute.toString(),
                                'created': now,
                                'lng': startPosition?.geometry?.location?.lng,
                                'lat': startPosition?.geometry?.location?.lat,
                                'cdate': formatter.format(now),
                                'count': 0
                              });
                              //Clear

                              _nameEditingController.clear();
                              _startSearchFieldController.clear();
                              _descriptionEditingController.clear();
                              _lookingForEditingController.clear();
                              selectedCat = "";

                              //sucess message
                              CoolAlert.show(
                                context: context,
                                title: "Success!",
                                confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
                                onConfirmBtnTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventsTabs()));
                                },
                                type: CoolAlertType.success,
                                backgroundColor:
                                    Color.fromARGB(221, 212, 189, 227),
                                text: "Event posted successfuly",
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
