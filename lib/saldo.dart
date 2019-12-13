import 'dart:convert';
import 'package:flutter_image/network.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/storage/storage.dart';
// import 'package:shimmer/shimmer.dart';
// import 'dashboard.dart';
import 'storage/storage.dart';

GlobalKey<ScaffoldState> _scaffoldKeySaldo;
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
String imageprofile;
List<History> history = [];
// GlobalKey<ScaffoldState> _scaffoldKeysaldo = new GlobalKey<ScaffoldState>() ;

class History {
  final nota;
  final saldo;
  final note;
  final type;
  final tanggal;
  final total;

  History(
      {Key key,
      this.nota,
      this.saldo,
      this.note,
      this.type,
      this.tanggal,
      this.total});
}

class Saldo extends StatefulWidget {
  final customer;

  Saldo({Key key, this.customer});
  @override
  State<StatefulWidget> createState() {
    return _Saldo(customer: customer);
  }
}

class _Saldo extends State<Saldo> {
  var rupiah = new NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
  var _id;
  var _user;
  final customer;
  var total;
  bool loading = true;
  _Saldo({Key key, this.customer});

  Future<Null> getsaldo() async {
    try {
      var storage = new DataStore();
      _id = await storage.getDataInteger("id");
      _user = await storage.getDataString("username");
      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';

      final getHistory = await http.post(
        url('api/detail_saldo_android'),
        body: {'member': _id.toString()},
        headers: requestHeaders,
      );

      if (getHistory.statusCode == 200) {
        // return nota;
        var getHistoryJson = json.decode(getHistory.body);
        // var getHistorys = getHistoryJson['getHistory'];
        double saldototal = double.parse(getHistoryJson[0]['hsm_total']);
        var parserupiah = rupiah.format(saldototal);
        this.setState(() {
          total = parserupiah;
        });

        this.setState(() {
          loading = false;
        });
      } else {}
    } on TimeoutException catch (_) {} catch (e) {
      debugPrint('$e');
    }
  }

  Future<List<History>> historyAndroid() async {
    try {
      var storage = new DataStore();
      _id = await storage.getDataInteger("id");
      _user = await storage.getDataString("username");
      imageprofile = await storage.getDataString('image');

      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';

      final getHistory = await http.post(
        url('api/detail_saldo_android'),
        body: {'member': _id.toString()},
        headers: requestHeaders,
      );

      if (getHistory.statusCode == 200) {
        // return nota;
        var getHistoryJson = json.decode(getHistory.body);
        // var getHistorys = getHistoryJson['getHistory'];
        history = [];
        for (var i in getHistoryJson) {
          History getHistoryx = History(
            nota: i['hsm_nota'],
            saldo: rupiah.format(double.parse(i['hsm_changesaldo'])).toString(),
            note: i['hsm_note'],
            type: i['hsm_type'],
            tanggal: i['hsm_date'],
            total: i['hsm_total'],
          );
          history.add(getHistoryx);
        }
        return history;
      } else {
        return null;
      }
    } on TimeoutException catch (_) {} catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  @override
  void initState() {
    _scaffoldKeySaldo = GlobalKey<ScaffoldState>();
    imageprofile = null;
    getsaldo();
    historyAndroid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeySaldo,
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 15),
                      width: MediaQuery.of(context).size.height * 0.15,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImageWithRetry(
                            url('storage/image/member/profile/$imageprofile'),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _user != null ? _user.toString() : '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.attach_money,
                        ),
                        Text(total != null ? total.toString() : '')
                      ],
                    ),
                    Center(
                        child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                              color: Color.fromRGBO(43, 204, 86, 1)),
                          child: Text(
                            'History Saldo',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: history.length < 1 ? 
                            ListView(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    'Tidak Ada Data',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                            : 
                            Column(
                              children: history.map((History f)  => Card(
                                child: ListTile(
                                  contentPadding:EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                                  leading: Container(
                                    height:MediaQuery.of(context).size.height *0.06,
                                    padding: EdgeInsets.only(right: 12),
                                    decoration: new BoxDecoration(
                                      border: new Border(
                                        right: new BorderSide(width: 1,color: Colors.black87))),
                                    child: Icon(
                                      Icons.attach_money,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  title: Text(
                                    f.type =='K'? ' - ' +f.saldo: ' + ' +f.saldo,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black87,
                                      fontWeight:FontWeight.bold
                                    ),
                                  ),
                                  subtitle: Container(
                                    width:MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height * 0.06,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          f.tanggal != '' ? f.tanggal: '',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.black87
                                            ),
                                          textAlign:TextAlign.left,
                                        ),
                                        Text(
                                          f.note !='' ? f.note: '',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.black87),
                                          textAlign:TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
      // bottomNavigationBar: BottomNavigationBar(
      //       onTap: onTabTapped,
      //       // type: BottomNavigationBarType.shifting,
      //       unselectedItemColor: Colors.grey,
      //       selectedItemColor: Color(0xff31B057),
      //       currentIndex: _currentIndex,
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Icon(
      //             Icons.home,
      //           ),
      //           title: new Text('Shop'),
      //         ),
      //         BottomNavigationBarItem(
      //             icon: Icon(
      //               Icons.attach_money,
      //             ),
      //             title: new Text('Saldo')),
      //         BottomNavigationBarItem(
      //             icon: Icon(
      //               Icons.person,
      //             ),
      //             title: new Text('Profile'))
      //       ],
      //     ),
    );
  }
}

class Saldoo extends StatefulWidget {
  final customer;

  Saldoo({Key key, this.customer});
  @override
  State<StatefulWidget> createState() {
    return _Saldoo(customer: customer);
  }
}

class _Saldoo extends State<Saldoo> {
  final customer;
  _Saldoo({Key key, this.customer});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            child: Text('data'),
          )
        ],
      ),
    );
  }
}
