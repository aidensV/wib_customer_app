import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wib_customer_app/pages/account/setting.dart';

import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';

import '../../dashboard.dart';
import '../../saldo.dart';
// import 'dart:async';

// GlobalKey<ScaffoldState> _scaffoldKeyprofile = new GlobalKey<ScaffoldState>();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username;
  String _name;
  String _email;

  int _currentIndex = 2;
  void onTabTapped(int index) {
    _currentIndex = index;
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Saldo(),
        ),
      );
    } else if (index == 2) {}
  }

  void getSharedPrefs() async {
    DataStore dataStore = new DataStore();
    _username = await dataStore.getDataString("username");
    _name = await dataStore.getDataString("name");
    _email = await dataStore.getDataString("email");

    this.setState(() {});
  }

  void initState() {
    getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key:_scaffoldKeyprofile,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Akun Kamu",
            style: TextStyle(color: Color(0xff31B057)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image:
                                        new AssetImage("images/jisoocu.jpg")))),
                        Container(
                          child: Text(
                            "Edit foto",
                            style: TextStyle(
                                color: Color(0xff31B057),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Username",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Container(
                          child: Text(
                            "$_username",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Nama",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Container(
                          child: Text(
                            "$_name",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Email",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Container(
                          child: Text(
                            "$_email",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              color: Colors.green[400],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/settingprofile'),
                    builder: (context) => SettingProfile(),
                  ),
                );
              },
              child: const Text('Setting',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //       onTap: onTabTapped,
      //       // type: BottomNavigationBarType.shifting,
      //       unselectedItemColor: Colors.grey,
      //       selectedItemColor: Color(0xff31B057),
      //       currentIndex: _currentIndex,
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Icon(
      //             Icons.home,
      //           ),
      //           title: new Text('Shop'),
      //         ),
      //         BottomNavigationBarItem(
      //             icon: Icon(
      //               Icons.attach_money,
      //             ),
      //             title: new Text('Saldo')),
      //         BottomNavigationBarItem(
      //             icon: Icon(
      //               Icons.person,
      //             ),
      //             title: new Text('Profile'))
      //       ],
      //     ),
    );
  }
}
