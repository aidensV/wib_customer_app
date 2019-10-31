import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:wib_customer_app/pages/shops/shop.dart';
import 'package:wib_customer_app/pages/tracking_list/tracking.dart';
import 'package:wib_customer_app/pages/profile/profile.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int _currentIndex = 0;
  final List<Widget> _children = [
    ShopPage(),
    TrackingList(),
    ProfilePage()
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController;

  String _name;
  String _email;

  Future<Null> getSharedPrefs() async {
    DataStore dataStore = new DataStore();
    _name = await dataStore.getDataString("name");
    _email = await dataStore.getDataString("email");

    print(_name);
  }

  Future<Null> RemoveSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
  }


  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);
    getSharedPrefs();
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Profil Drawer Here
              UserAccountsDrawerHeader(
                // Below this my gf name :))))), jk
                accountName: Text('$_name'),
                accountEmail: Text('$_email'),
                // This how you set profil image in sidebar
                // Remeber to add image first in pubspec.yaml
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('images/jisoocu.jpg'),
                ),
                // This how you set color in top of sidebar
                decoration: BoxDecoration(
                  color: Color(0xff31B057),
                ),
              ),
              //  Menu Section Here
              ListTile(
                title: Text(
                  'Tracking',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    color: Color(0xff25282b),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/tracking_list");
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    color: Color(0xff25282b),
                  ),
                ),
                onTap: () {
                  RemoveSharedPrefs();
                  Navigator.pushReplacementNamed(context, "/login");
                },
              ),
            ],
          ),
        ),
        // Body Section Here
        body: RefreshIndicator(
          onRefresh: () => refreshFunction(),
            child: _children[_currentIndex],
        ),
          bottomNavigationBar:BottomNavigationBar(
            type: BottomNavigationBarType.shifting ,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xff31B057),
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,),
                  title: new Text('Shop'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map,),
                  title: new Text('Tracking')
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person,),
                  title: new Text('Profile')
              )
            ],
          )
      ),
    );
  }
}
