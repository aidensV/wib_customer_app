import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wib_customer_app/pages/profile/profile.dart';
import 'dashboard.dart';
import 'env.dart';
import 'saldo.dart';
import 'utils/Navigator.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
// import 'utils/items.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';


String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
List<ListBanner> listBanner = [];
List<ListHistory> listHistory = [];
  var dashboardViewKey = new GlobalKey<ScaffoldState>();

class ListHistory {
  final String tanggal;
  final String jumlah;
  final String catatan;
  final String total;
  final String nota;

  ListHistory({this.tanggal, this.jumlah, this.catatan, this.total, this.nota});
}

class DashboardView extends StatefulWidget{
  int page;

  DashboardView({Key key,this.page});
  @override
  State<StatefulWidget>createState(){
    return _DashboardView(page:page);
  }
  
}

class _DashboardView extends State<DashboardView>{
  int page;

  _DashboardView({Key key , this.page});
  final List<Widget> _children = [
    DashboardPage(),
    Saldo(),
    ProfilePage(),
  ];

  
  void alert(String value) {
    dashboardViewKey.currentState.showSnackBar(
      SnackBar(
        content: new Text(value),
      ),
    );
  }

  listhistory(BuildContext context) async {
    try {
      var storage = new DataStore();

      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';

      final response = await http.get(
        url('api/listKasir'),
        headers: requestHeaders,
      );
      

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);

        listHistory = List<ListHistory>();

        for (var data in responseJson) {
          listHistory.add(
            ListHistory(
              tanggal: data['s_id'].toString(),
              jumlah: data['s_nota'],
              catatan: data['cm_name'],
              total: data['s_delivered'],
              nota: data['s_delivered'],
            ),
          );
        }
        print(responseJson);
        print(listHistory);
        return listHistory;
      } else if (response.statusCode == 401) {
        alert('Token kedaluwarsa, silahkan logout dan login kembali');
      } else {
        alert('Error Code : ${response.statusCode}');
        print(jsonDecode(response.body));
        // showModalBottomSheet(
        //   context: context,
        //   builder: (BuildContext context) => Scrollbar(
        //     child: SingleChildScrollView(
        //       child: Container(
        //         child: Text(jsonDecode(response.body)),
        //       ),
        //     ),
        //   ),
        // );
      }
    } on SocketException catch (_) {
      alert('Host not found, check your connection');
    } on TimeoutException catch (_) {
      alert('Request Timeout, try again');
    } catch (e, stacktrace) {
      print('Error : $e || Stacktrace : $stacktrace');
      alert('Error : ${e.toString()}');
      // showModalBottomSheet(
      //   context: context,
      //   builder: (BuildContext context) => Scrollbar(
      //     child: SingleChildScrollView(
      //       child: Container(
      //         child: Text(stacktrace.toString()),
      //       ),
      //     ),
      //   ),
      // );
    }
  }
  int _currentIndex = 0;
  void onTabTapped(int index) {
     _currentIndex = index;
   setState(() {
   });
 }

 Future<void> dataProfile() async{
    var storage = new DataStore();

    usernameprofile = await storage.getDataString("username");
    emailprofile = await storage.getDataString('email');
    imageprofile = await storage.getDataString('image');

  }

  PageController pageController;

  String _username;
  String usernameprofile, emailprofile, imageprofile;

  Future<Null> removeSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
    _username = await dataStore.getDataString("username");
    print(_username);
  }

  @override
  void initState() {
    dataProfile();
    print(requestHeaders);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          // key: dashboardViewKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // Profil Drawer Here
                UserAccountsDrawerHeader(
                  // Below this my gf name :))))), jk
                  accountName: Text(usernameprofile == null ? 'Nama Lengkap' : usernameprofile),
                  accountEmail: Text(emailprofile == null ? 'Email Anda' : emailprofile),
                  // This how you set profil image in sidebar
                  // Remeber to add image first in pubspec.yaml
                  currentAccountPicture: CircleAvatar(
                     backgroundImage: imageprofile != null ? AssetImage('images/jisoocu.jpg') : AssetImage('images/jisoocu.jpg'),
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
                    'Repeat Order',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Roboto',
                      color: Color(0xff25282b),
                    ),
                  ),
                  onTap: () {
                    MyNavigator.goToRepeatOrder(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Shop',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Roboto',
                      color: Color(0xff25282b),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/home");
                  },
                ),
                ListTile(
                  title: Text(
                    'Test',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Roboto',
                      color: Color(0xff25282b),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/test");
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
                    removeSharedPrefs();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                ),
              ],
            ),
          ),
          // Body Section Here
           body: _children[_currentIndex],
          bottomNavigationBar: _currentIndex == 0 ?  
          null
          //true
          :
          //false
          BottomNavigationBar(
            onTap: onTabTapped, 
            // type: BottomNavigationBarType.shifting,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xff31B057),
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: new Text('Shop'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.attach_money,
                  ),
                  title: new Text('Saldo')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  title: new Text('Profile'))
            ],
          )
        ),
    );
  }
}