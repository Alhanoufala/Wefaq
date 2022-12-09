import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/backgroundLogin.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  // late String _email;
  // final auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      CoolAlert.show(
        context: context,
        title: "link sent",
        confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
        onConfirmBtnTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserLogin()));
        },
        type: CoolAlertType.success,
        backgroundColor: Color.fromARGB(221, 212, 189, 227),
        text: "password reset link sent! check your email  ",
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      CoolAlert.show(
        context: context,
        title: "Sorry",
        confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
        //cancelBtnColor: Color.fromARGB(144, 64, 6, 87),
        type: CoolAlertType.error,
        backgroundColor: Color.fromARGB(221, 212, 189, 227),
        text: "There is no user with this email  ",
        confirmBtnText: 'Try again',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 244, 243, 255),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(199, 66, 23, 139),
                size: 30,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
              }),
          // title: Text('',
          //     style: TextStyle(
          //       fontWeight: FontWeight.normal,
          //       color: Colors.white,
          //     )),
        ),
        body: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Enter your email and we will send you a password reset link ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              // textAlign: TextAlign.center,
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _emailController,
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
                ),
              ),
              SizedBox(
                height: 30,
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    passwordReset();
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
                    width: size.width * 0.4,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(colors: [
                          Color.fromARGB(144, 67, 7, 87),
                          Color.fromARGB(221, 137, 171, 187)
                        ])),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Reset Password ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: TextField(
              //         keyboardType: TextInputType.emailAddress,
              //         decoration: InputDecoration(
              //           hintText: 'Email'
              //         ),
              //          onChanged: (value) {
              //           setState(() {
              //             _email = value.trim();
              //           });
              //         },
              //       ),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         ElevatedButton(
              //           child: Text('Send Request'),
              //           onPressed: () {
              //             auth.sendPasswordResetEmail(email: _email);
              //             Navigator.of(context).pop();
              //           },
              //           //color: Theme.of(context).accentColor,
              //         ),

              //       ],
              //     ),
            ],
          ),
        ));
  }
}
