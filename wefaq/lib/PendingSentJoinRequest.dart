import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:cool_alert/cool_alert.dart';

class PsentJoinRequestListViewPage extends StatefulWidget {
  @override
  _sentRequestListState createState() => _sentRequestListState();
}

class _sentRequestListState extends State<PsentJoinRequestListViewPage> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = [];

  var status = [];
  var emailP = [];

  var Email = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    getRequests();
    super.initState();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //get all projects
  Future getRequests() async {
    var fillterd = _firestore
        .collection('AllJoinRequests')
        .where('participant_email', isEqualTo: Email)
        .where('Status', isEqualTo: 'Pending')
        .snapshots();
    await for (var snapshot in fillterd)
      for (var Request in snapshot.docs) {
        setState(() {
          ProjectTitleList.add(Request['project_title']);
          emailP.add(Request['participant_email']);
          status.add(Request['Status']);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: ProjectTitleList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 80,
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Text(
                          "  " + ProjectTitleList[index] + " project ",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(159, 64, 7, 87),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.0,
                            width: 100,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                              color: Color.fromARGB(159, 215, 14, 14),
                            ),
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              'Delete',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialogFunc(context, emailP[index],
                                ProjectTitleList[index]);
                          },
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

showDialogFunc(context, ParticipantEmail, ProjectTitle) {
  CoolAlert.show(
    context: context,
    title: "",
    confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
    //  cancelBtnColor: Colors.black,
    //  cancelBtnTextStyle: TextStyle(color: Color.fromARGB(255, 237, 7, 7), fontWeight:FontWeight.w600,fontSize: 18.0),
    confirmBtnText: 'Delete',
    //cancelBtnText: 'Delete' ,
    onConfirmBtnTap: () {
      FirebaseFirestore.instance
          .collection('AllJoinRequests')
          .doc(ProjectTitle + '-' + ParticipantEmail)
          .update({
        'Status': 'Request Deleted',
      });
      CoolAlert.show(
        context: context,
        title: "Request for " + ProjectTitle + " has been deleted  ",
        confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
        onConfirmBtnTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Tabs()));
        },
        type: CoolAlertType.success,
        backgroundColor: Color.fromARGB(221, 212, 189, 227),
      );
    },

    type: CoolAlertType.confirm,
    backgroundColor: Color.fromARGB(221, 212, 189, 227),
    text: " Are you sure you want to Delete Request? ",
  );
  // return Center(
  //     child: Material(
  //         type: MaterialType.transparency,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             color: const Color.fromARGB(255, 255, 255, 255),
  //           ),
  //           padding: const EdgeInsets.all(15),
  //           height: 150,
  //           width: MediaQuery.of(context).size.width * 0.9,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               // Code for acceptance role
  //               Row(children: <Widget>[
  //                 Expanded(
  //                   flex: 2,
  //                   child: GestureDetector(
  //                     child: Text(
  //                       " Are you sure you want to Delete Request? ",
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         color: Color.fromARGB(159, 64, 7, 87),
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     onTap: () {
  //                       // go to participant's profile
  //                     },
  //                   ),
  //                 ),
  //                 // const SizedBox(
  //                 //   height: 10,
  //                 // ),
  //               ]),
  //               SizedBox(
  //                 height: 35,
  //               ),
  //               //----------------------------------------------------------------------------
  //               Row(
  //                 children: <Widget>[
  //                   Text("   "),
  //                   Text("     "),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => Tabs()));
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       surfaceTintColor: Colors.white,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(80.0)),
  //                       padding: const EdgeInsets.all(0),
  //                     ),
  //                     child: Container(
  //                       alignment: Alignment.center,
  //                       height: 40.0,
  //                       width: 100,
  //                       decoration: new BoxDecoration(
  //                           borderRadius: BorderRadius.circular(9.0),
  //                           gradient: new LinearGradient(colors: [
  //                             Color.fromARGB(144, 176, 175, 175),
  //                             Color.fromARGB(144, 176, 175, 175),
  //                           ])),
  //                       padding: const EdgeInsets.all(0),
  //                       child: Text(
  //                         "Cancel",
  //                         style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w600,
  //                             color: Color.fromARGB(255, 255, 255, 255)),
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.only(left: 40),
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         FirebaseFirestore.instance
  //                             .collection('AllJoinRequests')
  //                             .doc(ProjectTitle + '-' + ParticipantEmail)
  //                             .update({
  //                           'Status': 'Request Deleted',
  //                         });
  //                         CoolAlert.show(
  //                           context: context,
  //                           title: "Success!",
  //                           confirmBtnColor:
  //                               Color.fromARGB(144, 64, 6, 87),
  //                           type: CoolAlertType.success,
  //                           backgroundColor:
  //                               Color.fromARGB(221, 212, 189, 227),
  //                           text: "Your request for " +
  //                               ProjectTitle +
  //                               " has been Deleted.",
  //                           confirmBtnText: 'Done',
  //                           onConfirmBtnTap: () {
  //                             //send join requist
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => Tabs()));
  //                           },
  //                         );
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         surfaceTintColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(80.0)),
  //                         padding: const EdgeInsets.all(0),
  //                       ),
  //                       child: Container(
  //                         alignment: Alignment.center,
  //                         height: 40.0,
  //                         width: 100,
  //                         decoration: new BoxDecoration(
  //                             borderRadius: BorderRadius.circular(9.0),
  //                             gradient: new LinearGradient(colors: [
  //                               Color.fromARGB(144, 210, 2, 2),
  //                               Color.fromARGB(144, 210, 2, 2)
  //                             ])),
  //                         padding: const EdgeInsets.all(0),
  //                         child: Text(
  //                           "Delete",
  //                           style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w600,
  //                               color:
  //                                   Color.fromARGB(255, 255, 255, 255)),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         )));
}
