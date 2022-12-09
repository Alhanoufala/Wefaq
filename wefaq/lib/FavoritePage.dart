import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserLogin.dart';
import 'bottom_bar_custom.dart';
import 'package:wefaq/screens/detail_screens/event_detail_screen.dart';

class favoritePage extends StatefulWidget {
  @override
  _favoritePageState createState() => _favoritePageState();
}

class _favoritePageState extends State<favoritePage> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  // Title list
  var nameList = [];

  // Description list
  var descList = [];

  // location list
  var locList = [];

  //url list
  var urlList = [];

  //category list
  var categoryList = [];

  //category list
  var dateTimeList = [];

  var TimeList = [];
  //var latList = [];

  //var lngList = [];
  //List<String> creatDate = [];

  var ownerEmail = [];
  var EventName = [];
  var status = [];
  String? Email;
  @override
  void initState() {
    getCurrentUser();

    getFavoriteEvents();
    super.initState();
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

  //get all projects
  Future getFavoriteEvents() async {
    setState(() {
      nameList = [];
      descList = [];
      locList = [];
      urlList = [];
      categoryList = [];
      dateTimeList = [];
      TimeList = [];
      //latList = [];
      //lngList = [];
      //creatDate = [];
      ownerEmail = [];
      EventName = [];
      status = [];
    });
    if (Email != null) {
      var fillterd = _firestore
          .collection('FavoriteEvents')
          .where('favoriteEmail', isEqualTo: Email)
          .orderBy('date', descending: false)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var events in snapshot.docs) {
          setState(() {
            nameList.add(events['eventName']);
            descList.add(events['description']);
            locList.add(events['location']);
            urlList.add(events['URL']);
            categoryList.add(events['category']);
            dateTimeList.add(events['date']);
            TimeList.add(events['time']);
            EventName.add(events['eventName']);
            ownerEmail.add(events['ownerEmail']);
            status.add(events['status']);
            // latList.add(events['lat']);
            // lngList.add(events['lng']);
            // creatDate.add(events['cdate']);
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
        title: Text('Favorite events',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      //backgroundColor: Color.fromARGB(255, 228, 221, 232),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemBuilder: (context, index) {
            // Card Which Holds Layout Of ListView Item

            return SizedBox(
              height: 100,
              child: GestureDetector(
                  child: Card(
                    //color: const Color.fromARGB(255, 255, 255, 255),
                    //shadowColor: Color.fromARGB(255, 255, 255, 255),
                    //  elevation: 7,
                    color: status[index] == "Active"
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Color.fromARGB(225, 188, 189, 190),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Row(children: <Widget>[
                                Text(
                                  "      " + nameList[index] + " ",
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Color.fromARGB(211, 90, 12, 121),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                    child: SizedBox(
                                  width: 100,
                                )),
                                if (status[index] == "inactive")
                                  Text(
                                    "Deleted  ",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(210, 193, 23, 23),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                /* Text(
                                          creatDate[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 170, 169, 179),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),*/
                              ]),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                const Text("     "),
                                const Icon(Icons.location_pin,
                                    color: Color.fromARGB(173, 64, 7, 87)),
                                Text(locList[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 34, 94, 120),
                                    )),
                                Expanded(
                                    child: SizedBox(
                                  width: 100,
                                )),
                                if (status[index] == "Active")
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color:
                                            Color.fromARGB(255, 170, 169, 179),
                                      ),
                                      onPressed: () {
                                        if (status[index] == "Active")
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      eventDetailScreen(
                                                        eventName:
                                                            nameList[index],
                                                      )));
                                      }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    if (status[index] == "Active")
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => eventDetailScreen(
                                    eventName: nameList[index],
                                  )));
                  }),
            );
          },
          itemCount: nameList.length,
          // itemCount:_textEditingController!.text.isNotEmpty? nameListsearch.length  : nameListsearch.length,
        ),
      ),
    );
  }
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
  //                                     builder: (context) => favoritePage()));
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
