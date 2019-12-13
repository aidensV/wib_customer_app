import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_image/network.dart';
// import 'package:wib_customer_app/env.dart';
// import 'package:wib_customer_app/pages/account/setting.dart';

// import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/storage/storage.dart';

// import '../../dashboard.dart';
// import '../../saldo.dart';
import '../../env.dart';
import 'edit_profile.dart';
// import 'dart:async';

// GlobalKey<ScaffoldState> _scaffoldKeyprofile = new GlobalKey<ScaffoldState>();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>{

  String id;
  String name;
  String gender;
  String email;
  String address;
  String province;
  String city;
  String district;
  String rekening;
  String bank;
  String phone;
  String image;
  String namaprovinsi;
  String namakota;
  String namadesa;
  bool loading = true;

  Future<Null> getheader() async {
    try {
      var storage = new DataStore();
      name = await storage.getDataString("name");
      email = await storage.getDataString("email");
      gender = await storage.getDataString("gender");
      phone = await storage.getDataString("phone");
      address = await storage.getDataString("alamat");
      province = await storage.getDataString("province");
      city = await storage.getDataString("city");
      district = await storage.getDataString("district");
      bank = await storage.getDataString("bank");
      rekening = await storage.getDataString("nbank");
      image = await storage.getDataString("image");
      namaprovinsi = await storage.getDataString("namaprovinsi") == 'Tidak ditemukan' ? null : await storage.getDataString("namaprovinsi");
      namakota = await storage.getDataString("namakota") == 'Tidak ditemukan' ? null : await storage.getDataString("namakota");
      namadesa = await storage.getDataString("namadesa") == 'Tidak ditemukan' ? null : await storage.getDataString("namadesa");
      // imageprofile = await storage.getDataString('image');

      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';
      setState(() {
          loading = false;
      });
    } on TimeoutException catch (_) {} catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  breakline(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        border: new Border(
          bottom: new BorderSide(width: 1 , color:Colors.black87.withOpacity(0.05) ),
          left: new BorderSide(width: 1 , color:Colors.black87.withOpacity(0.05) ),
          top: new BorderSide(width: 1 , color:Colors.black87.withOpacity(0.05) ),
          right: new BorderSide(width: 1 , color:Colors.black87.withOpacity(0.05) ),
        )
      ),
    );
  }

  @override
  void initState() {
    getheader();
    datepickerfirst = FocusNode();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            child:Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                  ),
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * 0.80,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: new BoxDecoration(
                          color: Colors.green,
                          // image: new DecorationImage(
                          //   fit: BoxFit.cover,
                          //   image: new AssetImage('images/jisoocu.jpg'),
                          // ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 300,
                              child : Image(
                                fit: BoxFit.cover,
                                image: NetworkImageWithRetry(
                                  url('storage/image/member/profile/$image'),
                                ),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              height: 300,
                              decoration: new BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),

                            Positioned(
                              bottom: 100,
                              left: 10,
                              child: Container (
                                padding: const EdgeInsets.all(16.0),
                                width: MediaQuery.of(context).size.width * 0.8,
                                child:Column(
                                  children: <Widget>[
                                    Text(
                                      name != null ? name : '',
                                      style: new TextStyle(
                                        fontSize: 36.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),  
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      // height: MediaQuery.of(context).size.height * 0.34,
                      margin: EdgeInsetsDirectional.only(top: 220, start: MediaQuery.of(context).size.width * 0.05),
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      decoration: new BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius:BorderRadius.circular(20.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                          ),
                        ]
                      ),
                        child : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                              'Data Diri',
                                style: TextStyle(
                                  fontSize: 24.0,color: Colors.black87.withOpacity(0.6), 
                                  fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                              ),
                            ),
                          
                            Container(
                              margin: EdgeInsets.only(top:0),
                              height: 50,
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        Icons.person , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text( name != null ? name :
                                    '',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.venusMars , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text( gender == 'L' ? 'Laki - Laki' : (gender == 'P' ? 'Perempuan'  : ''),
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        Icons.mail , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text( email != null ? email : '',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        Icons.phone_android , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    phone != null ? phone : '',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),

                      
                    ],
                  ),
                ),

                Container(
                  decoration: new BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                  ),
                  margin:EdgeInsets.only(top:50),
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      // height: MediaQuery.of(context).size.height * 0.423,
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      decoration: new BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius:BorderRadius.circular(20.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                          ),
                        ]
                      ),
                        child : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                              'Alamat',
                                style: TextStyle(
                                  fontSize: 24.0,color: Colors.black87.withOpacity(0.6), 
                                  fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                              ),
                            ),
                          
                            Container(
                              margin: EdgeInsets.only(top:0),
                              height: 50,
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.home , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    address != null ? address :  '',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.map , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    namaprovinsi != null ? namaprovinsi : 'Provinsi Belum Di set',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.map , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    namakota != null ? namakota : 'Kabupaten Belum di Set',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.map , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    namadesa != null ? namadesa : 'Kecamatan Belum di Set',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 45),
                      width: MediaQuery.of(context).size.width * 0.90,
                      // height: MediaQuery.of(context).size.height * 0.253,
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      decoration: new BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius:BorderRadius.circular(20.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                          ),
                        ]
                      ),
                        child : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                              'Rekening Bank',
                                style: TextStyle(
                                  fontSize: 24.0,color: Colors.black87.withOpacity(0.6), 
                                  fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                              ),
                            ),
                          
                            Container(
                              margin: EdgeInsets.only(top:0),
                              height: 50,
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.moneyBill , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    rekening != null ? rekening : '',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),

                            breakline(),
                            Container(
                              height: 50,
                              child : Card(
                                
                                elevation: 0.0,
                                color: Colors.white.withOpacity(0),
                                child : ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                                leading: Container(
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  padding : EdgeInsets.only(right:12),
                                      child: Icon(
                                        FontAwesomeIcons.moneyBillAlt , color: Colors.black87.withOpacity(0.6),
                                        size: 20,
                                        ),
                                ),

                                  title: Text(
                                    bank != null ? bank : '',
                                    style: TextStyle(fontSize: 14.0,color: Colors.black87.withOpacity(0.6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                      Padding(
              padding: const EdgeInsets.only(top: 20.0,bottom: 30.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: RaisedButton(
                  color: Colors.white,
                  textColor: Colors.green,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(15.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(),
                              ),
                            );
                  },
                  child: Text(
                    "Ubah Data",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
                    ],
                  ),
                ),

              ],
            ),   
          );
        }
      ),
    );
  }
}
