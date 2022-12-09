import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wefaq/AdminEventList.dart';
import 'package:wefaq/AdminHomePage.dart';
import 'package:wefaq/AdminTabScreen.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/ReportedAcc.dart';
import 'package:wefaq/ReportedEvents.dart';
import 'package:wefaq/eventsTabs.dart';
import 'package:wefaq/report.dart';
import 'package:wefaq/reportedeventsScreeen.dart';

import 'ProjectsTapScreen.dart';
import 'adminAccountTap.dart';
import 'chats.dart';

class AdminCustomNavigationBar extends StatefulWidget {
  const AdminCustomNavigationBar(
      {Key? key, required this.updatePage, required this.currentHomeScreen})
      : super(key: key);

  final Function updatePage;
  final int currentHomeScreen;

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<AdminCustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.only(bottom: 24, top: 6),
            color: Color.fromARGB(255, 255, 255, 255),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomBarButton(widget.currentHomeScreen, 0, Icons.home_filled,
                    widget.updatePage),
                BottomBarButton(widget.currentHomeScreen, 1, Icons.event_busy,
                    widget.updatePage),
                BottomBarButton(widget.currentHomeScreen, 2,
                    CupertinoIcons.group_solid, widget.updatePage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  const BottomBarButton(
      this.currentPage, this.index, this.icon, this.updatePage,
      {Key? key})
      : super(key: key);
  final IconData icon;
  final int currentPage;
  final int index;
  final Function updatePage;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 40,
      child: MaterialButton(
          splashColor: Color.fromARGB(0, 207, 6, 6),
          highlightColor: Color.fromARGB(0, 201, 25, 25),
          padding: const EdgeInsets.all(0),
          onPressed: () => {
                if (index == 0)
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => adminHomeScreen()))
                  }
                else if (index == 1)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminTabs()))
                  }
                else if (index == 2)
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminAccountTabs()))
                  }
              },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Icon(
              icon,
              color: index == currentPage
                  ? Theme.of(context).colorScheme.onSurface
                  : Color.fromARGB(255, 135, 106, 152),
            ),
          )),
    );
  }
}
