import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'utils/Navigator.dart';
import 'storage/storage.dart';
import 'env.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final focusNode = FocusNode();
Map<String, String> requestHeaders = Map();

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  final userFocus = FocusNode();
  final passFocus = FocusNode();
  String msg = '';
  String username = '';
  bool _isLoading;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, {SnackBarAction action}) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      action: action,
    ));
  }

  final _formKey = GlobalKey<FormState>();

  void initState() {
    _isLoading = false;
    super.initState();
  }

  void dispose() {
    userFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }

  _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final getToken = await http.post(url('oauth/token'), body: {
        'grant_type': grantType,
        'client_id': clientId,
        'client_secret': clientSecret,
        "username": user.text,
        "password": pass.text,
      });

      print('getToken ' + getToken.body);

      var getTokenDecode = json.decode(getToken.body);

      if (getToken.statusCode == 200) {
        if (getTokenDecode['error'] == 'invalid_credentials') {
          showInSnackBar(getTokenDecode['message']);
          msg = getTokenDecode['message'];
          setState(() {
            _isLoading = false;
          });
        } else if (getTokenDecode['error'] == 'invalid_request') {
          showInSnackBar(getTokenDecode['hint']);
          msg = getTokenDecode['hint'];
          setState(() {
            _isLoading = false;
          });
        } else if (getTokenDecode['token_type'] == 'Bearer') {
          DataStore()
              .setDataString('access_token', getTokenDecode['access_token']);
          DataStore().setDataString('token_type', getTokenDecode['token_type']);
        }
        dynamic tokenType = getTokenDecode['token_type'];
        dynamic accessToken = getTokenDecode['access_token'];
        requestHeaders['Accept'] = 'application/json';
        requestHeaders['Authorization'] = '$tokenType $accessToken';
        try {
          final getUser = await http.get(url("api/user"), headers: requestHeaders);
          // print('getUser ' + getUser.body);

          if (getUser.statusCode == 200) {
            dynamic datauser = json.decode(getUser.body);

            if (datauser['cm_id'] == null) {
              msg = 'Username atau Password anda salah!';
            } else {
              DataStore store = new DataStore();

              // store.setDataInteger("user_id", int.parse(datajson['user']["u_id"]));
              store.setDataInteger("id", datauser['cm_id']);
              store.setDataString("username", datauser['cm_username']);
              store.setDataString("name", datauser['cm_name']);
              store.setDataString("email", datauser['cm_email']);

              print(datauser);

              Navigator.pushReplacementNamed(context, "/dashboard");
              // print('statement else is true');
              // print(datauser);
              setState(() {
                _isLoading = false;
              });
            }
          } else {
            showInSnackBar('Request failed with status: ${getUser.statusCode}');
          }
        } on SocketException catch (_) {
          showInSnackBar('Connection Timed Out');
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          print(e);
          // showInSnackBar(e);
          setState(() {
            _isLoading = false;
          });
        }
      } else if (getToken.statusCode == 401) {
        showInSnackBar('Username atau Password Salah');
      } else {
        showInSnackBar('Request failed with status: ${getToken.statusCode}');
      }
      // print(datajson.toString());

    } on SocketException catch (_) {
      showInSnackBar('Connection Timed Out');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      // showInSnackBar(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  getGroupAkses({String menu, bool boolean}) async {
    // print('$menu $getGroupJson');
    DataStore store = new DataStore();

    store.setDataBool('$menu (Group)', boolean);
  }

  getAksesMenu({String menu, bool boolean}) async {
    var store = new DataStore();

    store.setDataBool('$menu (Akses)', boolean);
  }
  @override
  Widget build(BuildContext context) {
    //  Widget Input Username Here
    final usernameField = TextFormField(
      autofocus: true,
      obscureText: false,
      controller: user,
      onFieldSubmitted: (thisValue) {
        FocusScope.of(context).requestFocus(passFocus);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Username tidak boleh kosong!';
        }
        return null;
      },
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
    // Widget Password Here
    final passwordField = TextFormField(
      obscureText: true,
      controller: pass,
      focusNode: passFocus,
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (thisValue) {
        FocusScope.of(context).unfocus();
        if (_isLoading) {
          return null;
        } else {
          if (_formKey.currentState.validate()) {
            _login();
          }
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Password tidak boleh kosong!';
        }
        return null;
      },
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
    // Login Button Here
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(3.0),
      color: Color(0xff31B057),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (_isLoading) {
            return null;
          } else {
            if (_formKey.currentState.validate()) {
              _login();
            }
          }
        },
        child: Text(
          _isLoading ? 'Tunggu Sebentar' : 'Masuk',
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
    // Bottom Section Here
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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(27.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //  Brand Login Here
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
                    // Error Message Here
                    Text(
                      msg,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.red),
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
      ),
    );
  }
}