import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';

class splash extends StatefulWidget {
  static const String screenRoute = 'home';

  const splash({Key? key}) : super(key: key);

  @override
  _splash createState() => _splash();
}

class _splash extends State<splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const UserLogin()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 227, 218, 233),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 222,
              width: 222,
            ),
            const SizedBox(
              height: 30,
            ),
            const CircularProgressIndicator(
              color: Colors.grey,
            )
          ],
        )));
  }
}
