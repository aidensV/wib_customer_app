import 'package:flutter/material.dart';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/storage/storage.dart';

// String _username;
String usernameprofile, emailprofile, imageprofile, namaCustomer;

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Future<void> dataProfile() async {
    DataStore storage = new DataStore();

    usernameprofile = await storage.getDataString("username");
    namaCustomer = await storage.getDataString("name");
    emailprofile = await storage.getDataString('email');
    imageprofile = await storage.getDataString('image');
  }

  Future<Null> removeSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          // Profil Drawer Here
          UserAccountsDrawerHeader(
            // Below this my gf name :))))), jk
            accountName:
                Text(namaCustomer == null ? 'Nama Lengkap' : namaCustomer),
            accountEmail:
                Text(emailprofile == null ? 'Email Anda' : emailprofile),
            // This how you set profil image in sidebar
            // Remeber to add image first in pubspec.yaml
            currentAccountPicture: Container(
              width: 30,
              height: 30,
              child: imageprofile != null
                  ? ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'images/noimage.jpg',
                        image:
                            url('storage/image/member/profile/$imageprofile'),
                      ),
                    )
                  : Image.asset('images/noimage.jpg'),
            ),
            // This how you set color in top of sidebar
            decoration: BoxDecoration(
              color: Color(0xff31B057),
            ),
          ),
          //  Menu Section Here
          Expanded(
            child: Container(
              // color: Colors.red,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Daftar Transaksi',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        color: Color(0xff25282b),
                      ),
                    ),
                    leading: Icon(Icons.list),
                    onTap: () {
                      Navigator.pushNamed(context, "/tracking_list");
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Cabang Warung Botol',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        color: Color(0xff25282b),
                      ),
                    ),
                    leading: Icon(Icons.list),
                    onTap: () {
                      Navigator.pushNamed(context, "/list_cabang");
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: Colors.black54,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Roboto',
                  color: Color(0xff25282b),
                ),
              ),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Peringatan!'),
                    content: Text('Apa anda yakin ingin logout?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'Tidak',
                          style: TextStyle(color: Colors.black54),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Ya',
                          style: TextStyle(color: Colors.cyan),
                        ),
                        onPressed: () {
                          removeSharedPrefs();
                          Navigator.pushReplacementNamed(context, "/login");
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
