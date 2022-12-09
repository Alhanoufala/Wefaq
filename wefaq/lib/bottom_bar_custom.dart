import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/eventsTabs.dart';
import 'package:wefaq/postEvent.dart';
import 'package:wefaq/postProject.dart';
import 'ProjectsTapScreen.dart';
import 'chats.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar(
      {Key? key, required this.updatePage, required this.currentHomeScreen})
      : super(key: key);

  final Function updatePage;
  final int currentHomeScreen;

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
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
                BottomBarButton(widget.currentHomeScreen, 1,
                    Icons.list_alt_outlined, widget.updatePage),
                const SizedBox(
                  width: 50,
                ),
                BottomBarButton(widget.currentHomeScreen, 3,
                    CupertinoIcons.collections, widget.updatePage),
                BottomBarButton(widget.currentHomeScreen, 4,
                    CupertinoIcons.chat_bubble, widget.updatePage),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: BottomBarMiddleButton(
                    widget.currentHomeScreen, widget.updatePage)
                .pOnly(bottom: 32),
          ),
        ],
      ),
    );
  }
}

class BottomBarMiddleButton extends StatelessWidget {
  const BottomBarMiddleButton(this.currentHomeScreen, this.updatePage,
      {Key? key})
      : super(key: key);
  final int currentHomeScreen;
  final Function updatePage;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      height: 55,
      child: TextButton(
        onPressed: () => {
          FullScreenMenu.show(
            context,
            items: [
              FSMenuItem(
                  icon: Icon(Icons.lightbulb, color: Colors.white),
                  text: Text(
                    'Post project',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(144, 64, 7, 87),
                        fontWeight: FontWeight.bold),
                  ),
                  gradient: new LinearGradient(colors: [
                    Color.fromARGB(144, 64, 7, 87),
                    Color.fromARGB(221, 137, 171, 187),
                  ]),
                  onTap: () {
                    FullScreenMenu.hide();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostProject()));
                  }),
              FSMenuItem(
                  icon: Icon(Icons.post_add, color: Colors.white),
                  text: Text(
                    'Post event',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(144, 64, 7, 87),
                        fontWeight: FontWeight.bold),
                  ),
                  gradient: new LinearGradient(colors: [
                    Color.fromARGB(144, 64, 7, 87),
                    Color.fromARGB(221, 137, 171, 187),
                  ]),
                  onTap: () {
                    FullScreenMenu.hide();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostEvent()));
                  }),
            ],
          )
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          elevation: MaterialStateProperty.all(8),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(115, 100, 6, 138)),
          shadowColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.onSurface),
        ),
        child: Container(
          width: 55,
          height: 55,
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                Color.fromARGB(255, 73, 7, 134).withOpacity(0.4),
                Color.fromARGB(251, 141, 180, 182)
              ], center: Alignment.topLeft, radius: 1)),
          child: Icon(
            CupertinoIcons.plus,
            color: (currentHomeScreen == 2)
                ? Color.fromARGB(255, 64, 11, 73)
                : Colors.white,
          ).p(8),
        ),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()))
                  }
                else if (index == 4)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => chatScreen()))
                  }
                else if (index == 1)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProjectsTabs()))
                  }
                else if (index == 3)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EventsTabs()))
                  }
              },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Icon(
              icon,
              color: index == currentPage
                  ? Theme.of(context).colorScheme.onSurface
                  : Color.fromARGB(255, 169, 141, 185),
            ),
          )),
    );
  }
}
