import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tottracker/NEW_SCREENS/app_drawer.dart';
import 'package:tottracker/NEW_SCREENS/baby_cry_analyzer_screen.dart';
import 'package:tottracker/NEW_SCREENS/features_overview_screen.dart';
import 'package:tottracker/NEW_SCREENS/profile_screen.dart';
import 'package:tottracker/custom_drawer/home_drawer.dart';
import 'package:tottracker/providers/profile_controller.dart';
import '../providers/user.dart' as U;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
// charts_flutter removed; not used in this file

import 'package:flutter/material.dart';

import '../sleep_screen/const.dart';
import '../sleep_screen/custom_clipper.dart';
import '../sleep_screen/detail_screen.dart';

class BoxDash extends StatelessWidget {
  final String Text1;
  final String Text2;
  final String Text3;
  final IconData icon;
  final Color color;

  BoxDash(
      {required this.Text1,
      required this.Text2,
      required this.Text3,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Text1,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  Text2,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  Text3,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: color,
              radius: 35,
              child: Icon(
                icon,
                color: Colors.white,
                size: 35,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RowCard extends StatelessWidget {
  final String Text1;
  final String Text2;
  final IconData icon;
  final Color color;

  RowCard(
      {required this.Text1,
      required this.Text2,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 35,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Text1,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    Text2,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Home"),
    selectedColor: Colors.purple,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("Profile"),
    selectedColor: Colors.teal,
  ),
];

class DashScreen extends StatefulWidget {
  const DashScreen({Key? key}) : super(key: key);

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const DashScreen();
    super.initState();
  }

  var _showOnlyFavorites = false;
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  _DashScreenState() {
    _pages = [
      DashScreen(),
      ProfileScreens(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double _crossAxisSpacing = 16, _mainAxisSpacing = 16, _cellHeight = 150.0;
    int _crossAxisCount = 2;

    double _width = (MediaQuery.of(context).size.width -
            ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    double _aspectRatio =
        _width / (_cellHeight + _mainAxisSpacing + (_crossAxisCount + 1));
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press manually
        if (_selectedIndex == 0) {
          // If we're on the first tab, exit the app
          return true;
        } else {
          // Otherwise, switch to the first tab and consume the back button press
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Constants.lightBlue,
              height: Constants.headerHeight + statusBarHeight,
            ),
          ),
          Positioned(
            left: 30,
            top: 80,
            child: Text(
              "TotTracker",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 50,
            child: Container(
              height: 120,
              width: 120,
              child: Image(
                  image: AssetImage('assets/drawables/tottracker4.png'),
                  height: 200,
                  width: 200,
                  color: Colors.white.withOpacity(1)),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BabyCryAnalyzerScreen(),
                      ),
                    );
                  },
                  child: BoxDash(
                    Text1: "",
                    Text2: "Baby Crying Analyzer",
                    Text3: "",
                    color: Colors.red,
                    icon: Icons.mic,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(),
                      ),
                    );
                  },
                  child: BoxDash(
                    Text1: "Status",
                    Text2: "Sleeping",
                    Text3: "",
                    color: Colors.blueAccent,
                    icon: Icons.offline_pin,
                  ),
                ),
                Row(
                  children: [
                    RowCard(
                      Text1: "Blood Pressure",
                      Text2: "50",
                      color: Colors.orange,
                      icon: Icons.send,
                    ),
                    RowCard(
                      Text1: "Temperature",
                      Text2: "37",
                      color: Colors.grey,
                      icon: Icons.group,
                    ),
                  ],
                ),
                BoxDash(
                  Text1: "Growth monitoring",
                  Text2: "weght:",
                  Text3: "height:",
                  color: Colors.green,
                  icon: Icons.email,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
