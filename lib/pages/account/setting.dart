import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
bool isLoading, isError;
GlobalKey<ScaffoldState> _scaffoldKeySettingProfile;

showInSnackbarSettingProfile(String content) {
  _scaffoldKeySettingProfile.currentState.showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

class SettingProfile extends StatefulWidget {
  @override
  _SettingProfileState createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {

  @override
  void initState() {
    _scaffoldKeySettingProfile = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeySettingProfile,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff25282b),
        ),
        title: Text(
          'Setting Profile',
          style: TextStyle(
            color: Color(0xff31b057),
          ),
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            // margin: EdgeInsets.only(top: 20.0),
            new Container(
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: 20.0,
                  ),
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
                  Card(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Ubah Biodata Diri',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'Nama',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            title: Text(
                              'Alpha Bravo',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text(
                              'Jenis Kelamin',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            title: Text(
                              'Laki-Laki',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.blue[500],
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text(
                              'TTL',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            title: Text(
                              '12 November 2019',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.blue[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Ubah Daftar Kontak',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text(
                              'E-mail',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            title: Text(
                              'ariakbar6944@gmail.com',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.blue[500],
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text(
                              'No. Handphone',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            title: Text(
                              '085331219757',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.blue[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                        child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Ubah Alamat',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'Provinsi',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          title: Text(
                            'Jawa Timur',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'Kabupaten',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          title: Text(
                            'Surabaya',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'Kecamatan',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          title: Text(
                            'Wonokromo',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'Kode Pos',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          title: Text(
                            '60245',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            'Alamat Pengiriman',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          title: Text(
                            'Jl. Ngagel Jaya',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    )),
                  ),
                  Card(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Rekening Bank',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          new RaisedButton(
                            onPressed: () {},
                            color: Colors.green[400],
                            child: const Text(
                              'Tambah Rekening Bank',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
