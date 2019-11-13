import 'package:flutter/material.dart';
// import 'utils/Navigator.dart';
import 'dashboard_view.dart';
import 'storage/storage.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String _username;

  Future<Null> getSharedPrefs() async {
    DataStore dataStore = new DataStore();
    _username = await dataStore.getDataString("username");

    if (_username == 'Tidak ditemukan') {
      Timer(Duration(seconds: 2),
              () => Navigator.pushReplacementNamed(context, "/login"));
    } else {
      Timer(Duration(seconds: 2),
              // () => Navigator.pushReplacementNamed(context, "/dashboard"));
              () => Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                            builder: (context) => DashboardView(),
                                          ),));
    }
  }

  @override
  void initState() {
    
    getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Center(
                    child: Text(
                      "Warung Islami Bogor",
                      style: TextStyle(
                        color: Color(0xff31B057),
                        fontFamily: 'TitilliumWeb',
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}