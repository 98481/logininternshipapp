import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internshipapp/LoginForm.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.username}) : super(key: key);
  final String username;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final auth = FirebaseAuth.instance;
  User user;

  var tabs;
  int _count = 0;
  @override
  void initState() {
    tabs = [
      Container(

        child: Text("DashboardDetails\n"),
      ),
      Container(
        child: Text("noti"),
      ),
      Container(
        child: Text("home"),
      ),
      Container(
        child: Text("profile"),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text(
            '   DashBoard',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
            actions: [
              IconButton(
                icon: Icon(Icons.logout,),
                disabledColor: Colors.white,
                onPressed: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs?.clear();
                  auth.signOut();

                  //Navigator.pop(context,true);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
        ),
        body: tabs[_count],
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            boxShadow: [
              BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: BottomNavigationBar(
              currentIndex: _count,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey.shade600,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 10,
              ),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                  activeIcon: Icon(Icons.home),
                  title: Text('Dashboard'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.whistleOutline),
                  activeIcon: Icon(MdiIcons.whistle),
                  title: Text('Coaching\n   Staff'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined),
                  activeIcon: Icon(Icons.notifications),
                  title: Text("Notifications"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  activeIcon: Icon(Icons.account_circle),
                  title: Text("Profile"),
                ),
              ],
              onTap: (index) {
                setState(() {
                  _count = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

