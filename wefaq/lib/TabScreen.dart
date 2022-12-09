import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/AcceptedSentJoinRequest.dart';
import 'package:wefaq/DeclinedSentJoinRequest.dart';
import 'package:wefaq/PendingSentJoinRequest.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

// Main Stateful Widget Start
class Tabs extends StatefulWidget {
  @override
  _ListViewTabsState createState() => _ListViewTabsState();
}

class _ListViewTabsState extends State<Tabs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width
    double width = MediaQuery.of(context).size.width * 0.6;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
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
            title: Text('Sent Join Requests',
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
                    showDialogFunc(context);
                  }),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 145, 124, 178),
            bottom: const TabBar(
              indicatorColor: Color.fromARGB(255, 84, 53, 134),
              indicatorWeight: 6,
              labelStyle: TextStyle(
                  fontSize: 18.0, fontFamily: 'Family Name'), //For Selected tab
              unselectedLabelStyle: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Family Name'), //For Un-selected Tabs
              tabs: [
                Tab(
                  text: 'Pending ',
                ),
                Tab(text: 'Accepted'),
                Tab(
                  text: 'Decliend',
                ),
              ],
            ),
          ),
          body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            PsentJoinRequestListViewPage(),
            AsentJoinRequestListViewPage(),
            DsentJoinRequestListViewPage()
          ]),
          bottomNavigationBar: CustomNavigationBar(
            currentHomeScreen: 0,
            updatePage: () {},
          ),
        ));
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

showDialogFunc(context) {
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
  //                                     builder: (context) => Tabs()));
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
