import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
// import 'dart:async';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String _username;
  String _name;
  String _email;

  void getSharedPrefs() async {
    DataStore dataStore = new DataStore();
    _username = await dataStore.getDataString("username");
    _name = await dataStore.getDataString("name");
    _email = await dataStore.getDataString("email");

    print(_username);
    print(_name);
    print(_email);
  }

  void initState() {
    
    super.initState();
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text("Akun Kamu", style: TextStyle(color: Color(0xff31B057)),),),
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
                                      image: new AssetImage(
                                          "images/jisoocu.jpg")
                                  )
                              )
                          ),
                          Container(
                            child: Text("Edit foto", style: TextStyle(color: Color(0xff31B057), fontSize: 20.0, fontWeight: FontWeight.bold),),
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
                            child: Text("Username", style: TextStyle(fontSize: 20.0),),
                          ),
                          Container(
                            child: Text("$_username", style: TextStyle(fontSize: 20.0),),
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
                            child: Text("Nama", style: TextStyle(fontSize: 20.0),),
                          ),
                          Container(
                            child: Text("$_name", style: TextStyle(fontSize: 20.0),),
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
                            child: Text("Email", style: TextStyle(fontSize: 20.0),),
                          ),
                          Container(
                            child: Text("$_email", style: TextStyle(fontSize: 20.0),),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
      ),
      bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xff31B057),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: new Text('Shop'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.repeat,
                  ),
                  title: new Text('Repeat Order'),),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.map,
                  ),
                  title: new Text('Tracking')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  title: new Text('Profile'))
            ],
          ),
    );
  }
}
