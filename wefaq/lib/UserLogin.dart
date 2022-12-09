import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/AdminHomePage.dart';
import 'package:wefaq/HomePage.dart';

import 'package:wefaq/UserRegisteration.dart';
import 'package:wefaq/backgroundLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:wefaq/resetPassword.dart';

import 'main.dart';

class UserLogin extends StatefulWidget {
  static const String screenRoute = 'UserLogin';

  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  bool showpass = true;
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;
  var names = [];
  var emails = [];

  @override
  void initState() {
    get();
    super.initState();
  }

  Future get() async {
    var fillterd = FirebaseFirestore.instance
        .collection("AllProjects")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var project in snapshot.docs) {
        setState(() {
          names.add(project["name"]);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 243, 255),
      body: Background(
        child: Form(
          key: _FormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.02),
              //     Container(
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.symmetric(horizontal: 25 , vertical: 5),
              //   child: Text(
              //     "Welcome to Wefaq ",
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Color.fromARGB(199, 66, 23, 139),
              //         fontSize: 36),
              //     textAlign: TextAlign.left,
              //   ),
              // ),
              SizedBox(height: size.height * 0.2),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Log in ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(199, 66, 23, 139),
                      fontSize: 34),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "example@email.com",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 202, 198, 198)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(199, 66, 23, 139),
                      )),
                  validator: MultiValidator(
                      [RequiredValidator(errorText: 'required')]),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "required";
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: showpass,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "********",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 202, 198, 198)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontSize: 19,
                      color: Color.fromARGB(199, 66, 23, 139),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showpass = !showpass;
                        });
                      },
                      child: showpass
                          ? const Icon(
                              Icons.visibility_off,
                            )
                          : Icon(
                              Icons.visibility,
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70, vertical: 0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ResetScreen()))
                  },
                  child: Text(
                    "Forget password ?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(199, 66, 23, 139)),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    _FormKey.currentState?.validate();
                    final rec = await FirebaseFirestore.instance
                        .collection('users')
                        .where("Email", isEqualTo: email)
                        .where("status", isEqualTo: "inactive")
                        .get();
                    final del = await FirebaseFirestore.instance
                        .collection('users')
                        .where("Email", isEqualTo: email)
                        .where("status", isEqualTo: "deleted")
                        .get();
                    final deltedByAdmin = await FirebaseFirestore.instance
                        .collection('users')
                        .where("Email", isEqualTo: email)
                        .where("status", isEqualTo: "deletedByAdmin")
                        .get();
                    //if ( rec.docs.isEmpty)

                    if (rec.docs.isNotEmpty) {
                      showDialogFunc();
                    } else if (del.docs.isNotEmpty) {
                      CoolAlert.show(
                        context: context,
                        title: "Sorry",
                        confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                        //cancelBtnColor: Color.fromARGB(144, 64, 6, 87),
                        type: CoolAlertType.error,
                        backgroundColor: Color.fromARGB(221, 212, 189, 227),
                        text: "Incorrect username or password",
                        confirmBtnText: 'Try again',
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else if (deltedByAdmin.docs.isNotEmpty) {
                        CoolAlert.show(
                            context: context,
                            title: "Sorry",
                            confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                            //cancelBtnColor: Color.fromARGB(144, 64, 6, 87),
                            type: CoolAlertType.error,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text: "your account is deleted by the admin due to voialtion been detected on your account",
                            confirmBtnText: 'ok',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                    }

                    //loding indicator
                    /*showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: ((context) =>
                            Center(child: CircularProgressIndicator())));
        */
                    else {
                      if (_FormKey.currentState!.validate()) {
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            if (email.toLowerCase() == 'admin@wefaq.com') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => adminHomeScreen()));
                            } else
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));

                            print("Logged in Succesfully");
                          }
                        } catch (e) {
                          print(e);
                          /*   validator:
                      MultiValidator([
                        RequiredValidator(
                            errorText: 'Incorrect username or password')
                      ]);*/
                          CoolAlert.show(
                            context: context,
                            title: "Sorry",
                            confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                            //cancelBtnColor: Color.fromARGB(144, 64, 6, 87),
                            type: CoolAlertType.error,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text: "Incorrect username or password",
                            confirmBtnText: 'Try again',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      }
                    }
                    // hide the loding indicator
                    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    backgroundColor: Colors.white,
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
                      "LOG IN",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New User? ",
                    style: TextStyle(
                        // decoration: TextDecoration.underline,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(123, 11, 13, 18)),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserRegistratin()))
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(199, 66, 23, 139)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteprofile() async {
    print(FirebaseAuth.instance.currentUser!.email);
    for (var i = 0; i < names.length; i++) {
      FirebaseFirestore.instance
          .collection('AllProjects')
          .doc(names[i].toString() +
              "-" +
              FirebaseAuth.instance.currentUser!.email!)
          .delete();
      FirebaseFirestore.instance
          .collection("AllJoinRequests")
          .doc(names[i].toString() +
              "-" +
              FirebaseAuth.instance.currentUser!.email!)
          .delete();
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .delete();

    await FirebaseAuth.instance.currentUser!.delete();
  }

  showDialogFunc() {
               CoolAlert.show(
                          context: context,
                          title: "",
                          confirmBtnColor: Color.fromARGB(144, 74, 234, 90),
                        //  cancelBtnColor: Colors.black,
                          cancelBtnTextStyle: TextStyle(color: Color.fromARGB(255, 237, 7, 7), fontWeight:FontWeight.w600,fontSize: 18.0),
                          confirmBtnText: 'restore ',
                          cancelBtnText: 'Delete' ,
                             onConfirmBtnTap: () {
                            print("restore");
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .update({'status': 'active'});

                                CoolAlert.show(
                                  context: context,
                                  title: "your account is active now",
                                  confirmBtnColor:
                                      Color.fromARGB(144, 64, 7, 87),
                                  onConfirmBtnTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  },
                                  type: CoolAlertType.success,
                                  backgroundColor:
                                      Color.fromARGB(221, 212, 189, 227),
                                  text: "you will be logged in",
                                );
                          },
                          onCancelBtnTap: (){
           FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .update({'status': 'deleted'});
                                  CoolAlert.show(
                                    context: context,
                                    title: "your account is deleted now",
                                    confirmBtnColor:
                                        Color.fromARGB(144, 64, 7, 87),
                                    onConfirmBtnTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserLogin()));
                                    },
                                    type: CoolAlertType.success,
                                    backgroundColor:
                                        Color.fromARGB(221, 212, 189, 227),
                                    text:
                                        "your account is deleted successfully, you are no longer a user ",
                                  );

                                  deleteprofile();
                          },
                       
                          type: CoolAlertType.confirm,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          text:
                              "your account is inactive, do you want to restore it or delete it immediately?",
                        );
   
  }

  showDialogFunc2() {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    padding: const EdgeInsets.all(15),
                    height: 190,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Code for acceptance role

                        Row(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              child: Text(
                                "your account is deleted by the admin ",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(159, 64, 7, 87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                // go to participant's profile
                              },
                            ),
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                        ]),
                        SizedBox(
                          height: 35,
                        ),
                        //----------------------------------------------------------------------------
                        Row(
                          children: <Widget>[
                            Text(""),
                            Text("        "),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: const EdgeInsets.all(0),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                width: 100,
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    gradient: new LinearGradient(colors: [
                                      Color.fromARGB(144, 176, 175, 175),
                                      Color.fromARGB(144, 176, 175, 175),
                                    ])),
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )));
        });
  }
}
