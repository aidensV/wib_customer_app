import 'package:flutter/material.dart';
import 'utils/Navigator.dart';
import 'storage/storage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController;

  List<String> images = [
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/11/20723472/20723472_8b4beedc-68ba-454c-a4dd-8ce1011f1694.jpg'
        'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/13/20723472/20723472_98150dcf-3d99-4b36-b359-f75b4349398d.jpg'
        'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/13/20723472/20723472_dd4457b2-4599-4d6c-9400-753fc5357323.jpg'
  ];

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
        appBar: AppBar(
          backgroundColor: Color(0xff31B057),
          title: Text('Beranda'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                MyNavigator.goWishlist(context);
              },
              icon: Icon(Icons.favorite),
            ),
            IconButton(
              onPressed: () {
                MyNavigator.goKeranjang(context);
              },
              icon: Icon(Icons.shopping_cart),
            )
          ],
        ),
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
            ],
          ),
        ),
        // Body Section Here
        body: Stack(
          children: <Widget>[
            Center(
              child: Text("Dashboard"),
            ),
          ],
        ),
      ),
    );
  }
}
