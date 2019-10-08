import 'package:flutter/material.dart';
import 'utils/Navigator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      autofocus: true,
      obscureText: false,
      style: TextStyle(
          fontFamily: 'TitilliumWeb',
          fontSize: 16.0,
          color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nama Pengguna",
          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[500]),
          border:
          OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3.0),
              topRight: Radius.circular(3.0),
              bottomRight: Radius.circular(3.0),
              bottomLeft: Radius.circular(3.0),
            ),
          )
      ),
    );
    final passwordField = TextField(
      obscureText: true,
      style: TextStyle(
        fontFamily: 'TitilliumWeb',
        fontSize: 16.0,
        color: Color(0xff25282b),
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Kata Sandi",
          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[500]),
          border:
          OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.0),
                topRight: Radius.circular(3.0),
                bottomRight: Radius.circular(3.0),
                bottomLeft: Radius.circular(3.0),
            ),
          )
      ),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(3.0),
      color: Color(0xff31B057),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/dashboard");
        },
        child: Text("Masuk",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'TitilliumWeb',
              fontSize: 16.0,
          ),
        ),
      ),
    );
    final adsSection = Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Text(
            "Belum Menggunakan Alamraya Software+ ?",
            style: TextStyle(
              color: Colors.grey[500],
              fontFamily: 'Roboto',
              fontSize: 13.0,
            ),
          ),
          OutlineButton(
            padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
            onPressed: () {
              MyNavigator.goToDashboard(context);
            },
            child: Text("Hubungi Kami Segera",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'TitilliumWeb',
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
    final footer = Text(
      "Powered by Alamraya Software v.1.0 © 2019",
      style: TextStyle(
        color: Colors.grey,
        fontFamily: 'Roboto',
        fontSize: 12.0
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(27.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 160.0,
                    child: Center(
                      child: Text("Warung Islami Bogor",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TitilliumWeb',
                          fontSize: 30.0,
                          color: Color(0xff31B057),
                        ),
                      )
                    ),
                  ),
                  SizedBox(height: 5.0),
                  usernameField,
                  SizedBox(height: 15.0),
                  passwordField,
                  SizedBox(
                    height: 20.0,
                  ),
                  loginButton,
                  SizedBox(
                    height: 8.0,
                  ),
                adsSection,
                SizedBox(
                  height: 10.0,
                ),
                footer,
                SizedBox(
                  height: 1.0,
                )
                ],
              ),

            ),
          ),
        ),
      ),
    );
  }
}