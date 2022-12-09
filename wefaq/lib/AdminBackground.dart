import 'package:flutter/material.dart';

class adminBackgroundHome extends StatelessWidget {
  final Widget child;

  const adminBackgroundHome({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            child: Image.asset(
              "assets/images/backgoundAdmin.png.png",
            ),
          ),
          child
        ],
      ),
    );
  }
}
