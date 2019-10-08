import 'package:flutter/material.dart';
import 'utils/Navigator.dart';

import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () => Navigator.pushReplacementNamed(context, "/login"));
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