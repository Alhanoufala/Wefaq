import 'dart:ffi';
import 'dart:math';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wefaq/AdminEventDetails.dart';
import 'package:wefaq/AdminHomePage.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/eventsTabs.dart';
import 'package:url_launcher/link.dart';
import 'package:wefaq/screens/detail_screens/event_detail_screen.dart';

// Main Stateful Widget Start
class adminEventsListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<adminEventsListViewPage> {
  @override
  void initState() {
    getProjects();
    getCategoryList();
    _getCurrentPosition();

    super.initState();
  }

  TextEditingController? _searchEditingController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  var categoryListDisplay = [];
  var categoryListController = [];
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

  List<String> ownerEmail = [];

  var TimeList = [];
  var latList = [];

  var lngList = [];
  List<int> countlist = [];

  List<String> creatDate = [];
  Position? _currentPosition;
  var lat;
  var lng;

  void getCategoryList() async {
    final categories = await _firestore.collection('categoriesE').get();
    for (var category in categories.docs) {
      for (var element in category['catE']) {
        setState(() {
          categoryListDisplay.add(element);
        });
      }
    }
  }

  // Future getCategory(String category) async {
  //   if (category == "") return;
  //   if (categoryListDisplay.where((element) => element == (category)).isEmpty) {
  //     CoolAlert.show(
  //       context: context,
  //       title: "No such category!",
  //       confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
  //       onConfirmBtnTap: () {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => EventsTabs()));
  //       },
  //       type: CoolAlertType.error,
  //       backgroundColor: Color.fromARGB(221, 212, 189, 227),
  //       text:
  //           "Please search for a valid category, valid categories are specified in the drop-down menu below",
  //     );
  //     return;
  //   }
  //   if (categoryList.where((element) => element == (category)).isEmpty) {
  //     CoolAlert.show(
  //       context: context,
  //       title: "Sorry!",
  //       confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
  //       onConfirmBtnTap: () {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => EventsTabs()));
  //       },
  //       type: CoolAlertType.error,
  //       backgroundColor: Color.fromARGB(221, 212, 189, 227),
  //       text: "No events are under this category yet ",
  //     );
  //     return;
  //   }
  //   //clear first
  //   setState(() {
  //     nameList = [];
  //     descList = [];
  //     locList = [];
  //     urlList = [];
  //     categoryList = [];
  //     dateTimeList = [];
  //     TimeList = [];
  //     latList = [];
  //     lngList = [];
  //     creatDate = [];
  //     ownerEmail = [];
  //   });

  //   await for (var snapshot in _firestore
  //       .collection('AllEvent')
  //       .where('category', isEqualTo: category)
  //       .snapshots())
  //     for (var events in snapshot.docs) {
  //       setState(() {
  //         nameList.add(events['name']);
  //         descList.add(events['description']);
  //         locList.add(events['location']);
  //         urlList.add(events['regstretion url ']);
  //         categoryList.add(events['category']);
  //         dateTimeList.add(events['date']);
  //         TimeList.add(events['time']);
  //         ownerEmail.add(events['email']);
  //         latList.add(events['lat']);
  //         lngList.add(events['lng']);
  //         creatDate.add(events['cdate']);
  //       });
  //     }
  // }

//get all projects
  Future getProjectsHi() async {
    //clear first
    setState(() {
      nameList = [];
      descList = [];
      locList = [];
      urlList = [];
      categoryList = [];
      dateTimeList = [];
      TimeList = [];
      latList = [];
      lngList = [];
      creatDate = [];
      ownerEmail = [];
      countlist = [];
    });
    await for (var snapshot in _firestore
        .collection('AllEvent')
        .orderBy('count', descending: true)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          nameList.add(events['name']);
          descList.add(events['description']);
          locList.add(events['location']);
          urlList.add(events['regstretion url ']);
          categoryList.add(events['category']);
          dateTimeList.add(events['date']);
          TimeList.add(events['time']);
          latList.add(events['lat']);
          lngList.add(events['lng']);
          creatDate.add(events['cdate']);
          ownerEmail.add(events['email']);
          countlist.add(events['count']);

          //  dateTimeList.add(project['dateTime ']);
        });
      }
  }

  Future getProjects() async {
    //clear first
    setState(() {
      nameList = [];
      descList = [];
      locList = [];
      urlList = [];
      categoryList = [];
      dateTimeList = [];
      TimeList = [];
      latList = [];
      lngList = [];
      creatDate = [];
      ownerEmail = [];
      countlist = [];
    });
    await for (var snapshot in _firestore
        .collection('AllEvent')
        .orderBy('created', descending: true)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          nameList.add(events['name']);
          descList.add(events['description']);
          locList.add(events['location']);
          urlList.add(events['regstretion url ']);
          categoryList.add(events['category']);
          dateTimeList.add(events['date']);
          TimeList.add(events['time']);
          latList.add(events['lat']);
          lngList.add(events['lng']);
          creatDate.add(events['cdate']);
          ownerEmail.add(events['email']);
          countlist.add(events['count']);

          //  dateTimeList.add(project['dateTime ']);
        });
      }
  }

  //get all projects
  Future getEventsLoc() async {
    //clear first
    setState(() {
      nameList = [];
      descList = [];
      locList = [];
      urlList = [];
      categoryList = [];
      dateTimeList = [];
      TimeList = [];
      latList = [];
      lngList = [];
      creatDate = [];
      countlist = [];
    });

    await for (var snapshot in _firestore
        .collection('AllEvent')
        .orderBy('dis', descending: false)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          nameList.add(events['name']);
          descList.add(events['description']);
          locList.add(events['location']);
          urlList.add(events['regstretion url ']);
          categoryList.add(events['category']);
          dateTimeList.add(events['date']);
          TimeList.add(events['time']);
          latList.add(events['lat']);
          lngList.add(events['lng']);
          creatDate.add(events['cdate']);
          countlist.add(events['count']);
        });
      }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  } //permission

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
    setState(() {
      lat = _currentPosition?.latitude;
      lng = _currentPosition?.longitude;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  setDistance() {
    for (var i = 0; i < latList.length; i++) {
      setState(() {
        FirebaseFirestore.instance
            .collection('AllEvent')
            .doc(nameList[i].toString())
            .set({'dis': calculateDistance(latList[i], lngList[i], lat, lng)},
                SetOptions(merge: true));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width
    double width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      bottomNavigationBar: AdminCustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => adminHomeScreen()));
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
        title: Text('Upcoming Events',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )),
      ),

      floatingActionButton: PopupMenuButton(
        tooltip: "Filter by",
        icon: CircleAvatar(
          radius: 27,
          backgroundColor: Color.fromARGB(255, 97, 144, 164),
          child: Icon(
            Icons.filter_list,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 40,
          ),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: ListTile(
              leading:
                  Icon(Icons.date_range, color: Color.fromARGB(144, 64, 7, 87)),
              title: Text(
                'Latest',
                style: TextStyle(
                  color: Color.fromARGB(221, 81, 122, 140),
                ),
              ),
              onTap: () {
                setState(() {
                  //Filter by created date
                  getProjects();
                });
              },
              selectedTileColor: Color.fromARGB(255, 252, 243, 243),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading:
                  Icon(Icons.date_range, color: Color.fromARGB(144, 64, 7, 87)),
              title: Text(
                'Highest reports',
                style: TextStyle(
                  color: Color.fromARGB(221, 81, 122, 140),
                ),
              ),
              onTap: () {
                setState(() {
                  //Filter by created date
                  getProjectsHi();
                });
              },
              selectedTileColor: Color.fromARGB(255, 252, 243, 243),
            ),
          ),
        ],
      ),

      // Main List View With Builder
      body: Column(
        children: [
          // _searchBar(),
          Expanded(
            child: Scaffold(
              // floatingActionButton: PopupMenuButton(
              //   tooltip: "Filter by",
              //   icon: Icon(
              //     Icons.filter_list,
              //     color: Color.fromARGB(221, 81, 122, 140),
              //     size: 40,
              //   ),
              //   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              //     PopupMenuItem(
              //       child: ListTile(
              //         leading: Icon(Icons.date_range,
              //             color: Color.fromARGB(144, 64, 7, 87)),
              //         title: Text(
              //           'Created date',
              //           style: TextStyle(
              //             color: Color.fromARGB(221, 81, 122, 140),
              //           ),
              //         ),
              //         onTap: () {
              //           setState(() {
              //             //Filter by created date
              //             getProjects();
              //           });
              //         },
              //         selectedTileColor: Color.fromARGB(255, 252, 243, 243),
              //       ),
              //     ),
              //     PopupMenuItem(
              //       child: ListTile(
              //         leading: Icon(Icons.location_on,
              //             color: Color.fromARGB(144, 64, 7, 87)),
              //         title: Text(
              //           'Nearest',
              //           style: TextStyle(
              //             color: Color.fromARGB(221, 81, 122, 140),
              //           ),
              //         ),
              //         onTap: () {
              //           //Filter by nearest
              //           setDistance();
              //           getEventsLoc();
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // Main List View With Builder
              body: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    // Card Which Holds Layout Of ListView Item
                    int count = countlist[index];
                    return SizedBox(
                      height: 100,
                      child: GestureDetector(
                          child: Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            //shadowColor: Color.fromARGB(255, 255, 255, 255),
                            //  elevation: 7,

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
                                            color: Color.fromARGB(
                                                212, 82, 10, 111),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: 240,
                                          ),
                                        ),
                                        Text(
                                          creatDate[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 170, 169, 179),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        const Text("     "),
                                        const Icon(Icons.location_pin,
                                            color:
                                                Color.fromARGB(173, 64, 7, 87)),
                                        Text(locList[index],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 34, 94, 120),
                                            )),
                                        Expanded(
                                            child: SizedBox(
                                          width: 100,
                                        )),
                                        const Icon(Icons.report_gmailerrorred,
                                            color: Color.fromARGB(
                                                238, 212, 18, 4)),
                                        Text("$count",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 34, 94, 120),
                                            )),
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Color.fromARGB(
                                                  255, 170, 169, 179),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdmineventDetailScreen(
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdmineventDetailScreen(
                                          eventName: nameList[index],
                                        )));
                          }),
                    );
                  },
                  itemCount: nameList.length,
                  // itemCount:_textEditingController!.text.isNotEmpty? nameListsearch.length  : nameListsearch.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _searchBar() {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(7.0),
  //         child: TextFormField(
  //           controller: _searchEditingController,
  //           decoration: InputDecoration(
  //             contentPadding: EdgeInsets.symmetric(vertical: 15.0),

  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(15.0),
  //               borderSide: BorderSide(color: Colors.black87, width: 2.0),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(15.0),
  //               borderSide: BorderSide(
  //                 color: Color.fromARGB(144, 64, 7, 87),
  //               ),
  //             ),
  //             labelText: "search for a specific category",
  //             prefixIcon: IconButton(
  //               icon: Icon(Icons.search),
  //               onPressed: () {
  //                 setState(() {
  //                   getCategory(_searchEditingController!.text);
  //                 });
  //               },
  //             ),
  //             suffixIcon: _searchEditingController!.text.isNotEmpty
  //                 ? IconButton(
  //                     icon: Icon(Icons.cancel),
  //                     onPressed: () {
  //                       setState(() {
  //                         getProjects();
  //                         _searchEditingController?.clear();
  //                       });
  //                     },
  //                   )
  //                 : null,

  //             hintText: 'Gaming , web  ...',
  //             //    suffixIcon :IconButton(
  //             //                onPressed: () {
  //             //                setState(() {
  //             //               // _searchEditingController.clear();
  //             //            });
  //             //        },
  //             //      icon: Icon(Icons.clear_outlined),
  //             //  )
  //           ),
  //           onChanged: (text) {
  //             setState(() {
  //               categoryListController = categoryListDisplay;
  //             });
  //           },
  //         ),
  //       ),
  //       ListView.separated(
  //         shrinkWrap: true,
  //         itemCount: _searchEditingController!.text.isEmpty
  //             ? 0
  //             : categoryListController.length,
  //         itemBuilder: (context, index) {
  //           return ListTile(
  //             contentPadding: EdgeInsets.symmetric(horizontal: 40),
  //             visualDensity: VisualDensity(vertical: -4),
  //             //leading: CircleAvatar(
  //             //  backgroundColor: Color.fromARGB(221, 137, 171, 187),
  //             // child: Icon(
  //             //    Icons.category_rounded,
  //             //    color: Colors.white,
  //             //  ),
  //             //  ),
  //             title: Text(
  //               categoryListController[index].toString(),
  //             ),
  //             onTap: () {
  //               setState(() {
  //                 _searchEditingController?.text =
  //                     categoryListController[index].toString();
  //                 categoryListController = [];
  //               });
  //             },
  //           );
  //         },
  //         separatorBuilder: (context, index) {
  //           //<-- SEE HERE
  //           return Divider(
  //             thickness: 0,
  //             color: Color.fromARGB(255, 194, 195, 194),
  //           );
  //         },
  //       )
  //     ],
  //   );
  // }

}

// This is a block of Model Dialog
showDialogFunc(context, title, desc, category, loc, date, time, urlregstrtion) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Scrollbar(
            thumbVisibility: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              padding: EdgeInsets.all(15),
              height: 500,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(230, 64, 7, 87),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 74, 74, 74),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.location_pin,
                          color: Color.fromARGB(173, 64, 7, 87)),
                      Text(loc,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(230, 64, 7, 87),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.timelapse_outlined,
                        color: Color.fromARGB(248, 170, 167, 8),
                        size: 28,
                      ),
                      Text(date,
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(221, 79, 128, 151),
                              fontWeight: FontWeight.normal),
                          maxLines: 2,
                          overflow: TextOverflow.clip),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "About Event ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(230, 64, 7, 87),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        desc,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(144, 64, 7, 87)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(230, 64, 7, 87),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        category,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(144, 64, 7, 87)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Center(
                    child: Link(
                        target: LinkTarget.blank,
                        uri: Uri.parse(urlregstrtion),
                        builder: (context, followLink) => ElevatedButton(
                            onPressed: followLink,
                            child: Text(
                              'Registration link',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(195, 117, 45, 141),
                            ))),
                  ),

                  /* Container(
                    alignment: Alignment.center,
                    height: 40.0,
                    width: 200,
                    margin: EdgeInsets.only(top: 20),
          
                    // width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(colors: [
                          Color.fromARGB(197, 67, 7, 87),
                          Color.fromARGB(195, 117, 45, 141),
                        ])),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Regstrition Link",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(fontWeight: FontWeight.bold ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
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
          context, MaterialPageRoute(builder: (context) => UserLogin()));
    },

    type: CoolAlertType.confirm,
    backgroundColor: Color.fromARGB(221, 212, 189, 227),
    text: "Are you sure you want to log out?",
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
  //                             Navigator.pop(context);
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
