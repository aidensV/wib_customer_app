import 'dart:ui';

import 'package:flutter/material.dart';
import 'utils/Navigator.dart';
import 'storage/storage.dart';
import 'package:carousel_pro/carousel_pro.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String _username;

  Future<Null> RemoveSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
    _username = await dataStore.getDataString("username");
    print(_username);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // Profil Drawer Here
                UserAccountsDrawerHeader(
                  // Below this my gf name :))))), jk
                  accountName: Text('Kim Jisoo'),
                  accountEmail: Text('Jisoocu@gmail.com'),
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
                      fontFamily: 'TitilliumWeb',
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
                      fontFamily: 'TitilliumWeb',
                      color: Color(0xff25282b),
                    ),
                  ),
                  onTap: () {
                    MyNavigator.goToRepeatOrder(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'TitilliumWeb',
                      color: Color(0xff25282b),
                    ),
                  ),
                  onTap: () {
                    RemoveSharedPrefs();
                    Navigator.pushReplacementNamed(context, "/login");
                  },

                ),
                ListTile(
                  title: Text(
                    'Barang Favorit',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'TitilliumWeb',
                      color: Color(0xff25282b),
                    ),
                  ),
                  onTap: () {
                    MyNavigator.goWishlist(context);
                  },

                ),
              ],
            ),
          ),
          // Body Section Here
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: 500.0,
                height: 150.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/11/20723472/20723472_8b4beedc-68ba-454c-a4dd-8ce1011f1694.jpg')
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100.0),
                        bottomRight: Radius.circular(100.0)
                    )
                ),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: new Container(
                    decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: SizedBox(
                    height: 130.0,
                    width: 350.0,
                    child: Carousel(
                      images: [
                        Padding(padding: EdgeInsets.all(5.0), child: ClipRRect(borderRadius:BorderRadius.circular(8.0), child:Image.network('https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/11/20723472/20723472_8b4beedc-68ba-454c-a4dd-8ce1011f1694.jpg', fit:BoxFit.fill, ),)),
                        Padding(padding: EdgeInsets.all(5.0), child: ClipRRect(borderRadius:BorderRadius.circular(8.0), child:Image.network('https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/13/20723472/20723472_98150dcf-3d99-4b36-b359-f75b4349398d.jpg', fit:BoxFit.fill, ),)),
                        Padding(padding: EdgeInsets.all(5.0), child: ClipRRect(borderRadius:BorderRadius.circular(8.0), child:Image.network('https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/13/20723472/20723472_dd4457b2-4599-4d6c-9400-753fc5357323.jpg', fit:BoxFit.fill, ),)),
                      ],
                      showIndicator: false,
                      borderRadius: true,
                      moveIndicatorFromBottom: 180.0,
                      noRadiusForIndicator: true,
                      overlayShadow: false,
                    )
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
