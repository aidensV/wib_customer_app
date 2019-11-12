import 'package:flutter/material.dart';
import 'package:wib_customer_app/storage/storage.dart';

import '../../utils/Navigator.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController textEditingController;
  String _username;
  String _name;
  String _email;

  Future<Null> getSharedPrefs() async {
    DataStore dataStore = new DataStore();
    _name = await dataStore.getDataString("username");
    _name = await dataStore.getDataString("name");
    _email = await dataStore.getDataString("email");

    print(_username);
    print(_name);
    print(_email);
    setState(() {
      textEditingController = new TextEditingController(text: _username);
      textEditingController = new TextEditingController(text: _name);
      textEditingController = new TextEditingController(text: _email);
    });
  }

  // Future<Null> RemoveSharedPrefs() async {
  //   DataStore dataStore = new DataStore ();
  //   dataStore.clearData();
  //   _level = await dataStore.getDataString("level");
  //   print(_level);
  // }

  void initState() {
    super.initState();
    _username = "";
    _name = "";
    _email = "";
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff25282b),
        ),
        title: Text(
          'Account',
          style: TextStyle(
            color: Color(0xff31b057),
          ),
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // color: Colors.white,
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: new Column(
          children: <Widget>[
            new Container(
              // padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(top: 60.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: new Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage("images/jisoocu.jpg"),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: new Container(
                      child: new Text(
                        "$_username",
                        style: new TextStyle(
                            fontFamily: "Opensans",
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: new Container(
                      child: new Text(
                        "$_name",
                        style: new TextStyle(
                            fontFamily: "Opensans",
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: new Container(
                      margin: EdgeInsets.only(top: 05.0),
                      child: new Text(
                        "$_email",
                        style: new TextStyle(
                            fontFamily: "Opensans",
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  new Container(
                    height: 30.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.monetization_on, color: Colors.green[500]),
                          Text('SALDO:'),
                          Text('Rp. 1000'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.control_point, color: Colors.green[500]),
                          Text('POINT:'),
                          Text('250'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.card_giftcard, color: Colors.green[500]),
                          Text('VOUCHER:'),
                          Text('10'),
                        ],
                      ),
                    ],
                  ),
                  new Container(
                    height: 30.0,
                  ),
                  new Card(
                    child: new ListTile(
                      title: Text('Perumahan Gianyar',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      leading: Icon(
                        Icons.home,
                        color: Colors.green[500],
                      ),
                    ),
                  ),
                  new Card(
                    child: new ListTile(
                      title: Text('(+62) 555-1212',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      leading: Icon(
                        Icons.contact_phone,
                        color: Colors.green[500],
                      ),
                    ),
                  ),
                  new Card(
                    child: new ListTile(
                      title: Text('Setting',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      leading: IconButton(
                        icon: Icon(Icons.settings, color: Colors.green[500],),
                        onPressed: () {
                          MyNavigator.goSetting(context);
                        },
                      ),
                    ),
                  ),
                  new Container(
                    height: 30.0,
                  ),
                  new Center(
                    child: GestureDetector(
                      onTap: () {
                        // RemoveSharedPrefs();
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                      child: new Text(
                        "Logout",
                        style: new TextStyle(
                            fontFamily: "Opensans",
                            color: Colors.red,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // new Container(
            //   height: 15.0,
            //   color: Colors.grey[200],
            // ),
            // new Container(
            //   height: 10.0,
            // ),
          ],
        ),
      ),
    );
  }
}
