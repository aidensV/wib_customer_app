import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_image/network.dart';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/pages/account/setting.dart';

import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';

import '../../dashboard.dart';
import '../../saldo.dart';
import 'edit_profile.dart';
// import 'dart:async';

// GlobalKey<ScaffoldState> _scaffoldKeyprofile = new GlobalKey<ScaffoldState>();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>{

  String id;
  String name;
  String gender;
  String email;
  String address;
  String province;
  String city;
  String district;
  String rekening;
  String bank;

  breakline(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        border: new Border(
          bottom: new BorderSide(width: 1 , color:Colors.black87.withOpacity(0.05) ),
          left: new BorderSide(width: 1 , color:Colors.black87.withOpacity(0.05) ),
          top: new BorderSide(width: 1 , color:Colors.black87.withOpacity(0.05) ),
          right: new BorderSide(width: 1 , color:Colors.black87.withOpacity(0.05) ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            child:Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.48,
                        decoration: new BoxDecoration(
                          color: Colors.green,
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new AssetImage('images/jisoocu.jpg'),
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.48,
                              decoration: new BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),

                            Positioned(
                              bottom: 45,
                              left: 10,
                              child: Container (
                                padding: const EdgeInsets.all(16.0),
                                width: MediaQuery.of(context).size.width * 0.8,
                                child:Column(
                                  children: <Widget>[
                                    Text('Faizal Triswanto',
                                      style: new TextStyle(
                                        fontSize: 36.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),  
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.height * 0.34,
                      margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.width * 0.62, start: MediaQuery.of(context).size.width * 0.05),
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      decoration: new BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius:BorderRadius.circular(20.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                          ),
                        ]
                      ),
                        child : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                              'Data Diri',
                                style: TextStyle(
                                  fontSize: 24.0,color: Colors.black87.withOpacity(0.6), 
                                  fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                              ),
                            ),
                          
                            Container(
                              margin: EdgeInsets.only(top:0),
                              height: 50,
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        Icons.person , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    'Faizal Triswanto',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.venusMars , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    'Laki - Laki',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        Icons.mail , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    'faizaltriswanto@gmail.com',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),

                      
                    ],
                  ),
                ),

                Container(
                  decoration: new BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.height * 0.423,
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      decoration: new BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius:BorderRadius.circular(20.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                          ),
                        ]
                      ),
                        child : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                              'Alamat',
                                style: TextStyle(
                                  fontSize: 24.0,color: Colors.black87.withOpacity(0.6), 
                                  fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                              ),
                            ),
                          
                            Container(
                              margin: EdgeInsets.only(top:0),
                              height: 50,
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.home , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    'Jalan Raya Gadung Dusun Randu Pukah RT13 RW03',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.map , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    'Jawa Timur',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.map , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    'Kab Bogor',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.map , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    'Cibinong',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 45),
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.height * 0.253,
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      decoration: new BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius:BorderRadius.circular(20.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                          ),
                        ]
                      ),
                        child : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                              'Rekening Bank',
                                style: TextStyle(
                                  fontSize: 24.0,color: Colors.black87.withOpacity(0.6), 
                                  fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                              ),
                            ),
                          
                            Container(
                              margin: EdgeInsets.only(top:0),
                              height: 50,
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.moneyBill , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    '128390182903812',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.moneyBillAlt , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    'BCA',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                      
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: FlatButton(
                          child: Text('Ubah Data'),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(id : id ,name : name , gender : gender , email : email , address : address , province : province , city : city , district : district , rekening : rekening , bank : bank),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),   
          );
        }
      ),
    );
  }
}

/* class _ProfilePageState extends State<ProfilePage> {
  String _username;
  String _name;
  String _email;
class _ProfilePageState extends State<ProfilePage> {
  String _username, _name, _email, imageprofile;

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
    imageprofile = await dataStore.getDataString('image');

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
                        CircleAvatar(
                          child: ClipOval(
                            child: Image(
                              image: NetworkImageWithRetry(
                                url('storage/image/member/profile/$imageprofile'),
                              ),
                            ),
                          ),
                        ),
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
} */
