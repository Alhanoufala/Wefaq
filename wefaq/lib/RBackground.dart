import 'package:flutter/material.dart';

class RBackground extends StatelessWidget {
  final Widget child;

  const RBackground({
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
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/images/ie.png", width: size.width),
          ),
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: Image.asset("assets/images/top2222.png", width: size.width),
          // ),
          // Positioned(
          //   top: 50,
          //   right: 5,
          //   child:
          //       Image.asset("assets/images/logo.png", width: size.width * 0.35),
          // ),
          child
        ],
      ),
    );
  }
}
