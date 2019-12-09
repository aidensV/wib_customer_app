import 'package:flutter/material.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'model.dart';
import 'dart:convert';
import 'stockiescabang.dart';

var _scaffoldKeyCabang;
List<ListCabang> listCabang = [];
String tokenType, accessToken;
bool isLoading;
bool isLogout;
bool isError;
Map<String, String> requestHeaders = Map();

void showInSnackBar(String value) {
  _scaffoldKeyCabang.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class Cabang extends StatefulWidget {
  Cabang({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _CabangState();
  }
}

class _CabangState extends State<Cabang> {
  Future<List<ListCabang>> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print(requestHeaders);

    return listNotaAndroid();
  }

  Future<List<ListCabang>> listNotaAndroid() async {
    setState(() {
      isLoading = true;
    });
    try {
      final cabang = await http.get(
        url('api/list_cabang'),
        headers: requestHeaders,
      );

      if (cabang.statusCode == 200) {
        // return nota;
        var cabangJson = json.decode(cabang.body);
        var cabanngs = cabangJson['cabang'];

        print('cabang $cabangJson');

        listCabang = [];
        for (var i in cabanngs) {
          ListCabang cabangx = ListCabang(
            id: '${i['b_id']}',
            nama: i['b_name'],
            telepon: i['b_nphone'].toString(),
            owner: i['ed_nemployee'],
          );
          listCabang.add(cabangx);
        }
        setState(() {
          isLoading = false;
          isError = false;
          isLogout = false;
        });
        print('listnota $listCabang');
        print('listnota length ${listCabang.length}');
        return listCabang;
      } else if (cabang.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = false;
          isLogout = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          isLogout = false;
        });

        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
        isLogout = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        isLogout = false;
      });
      debugPrint('$e');
    }
    return null;
  }

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    _scaffoldKeyCabang = GlobalKey<ScaffoldState>();
    isLoading = true;
    isError = false;
    isLogout = false;
    getHeaderHTTP();
    print(requestHeaders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyCabang,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Daftar Cabang",
            style: TextStyle(
              color: Color(0xff25282b),
            ),
          ),
          backgroundColor: Colors.white),
      body: Container(
        // padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            isLoading == true
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : isLogout == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RefreshIndicator(
                          onRefresh: () => listNotaAndroid(),
                          child: Column(children: <Widget>[
                            new Container(
                              width: 100.0,
                              height: 100.0,
                              child: Image.asset("images/system-eror.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Center(
                                child: Text(
                                  "Token anda sudah expired, silahkan login ulang kembali",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      )
                    : isError == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: RefreshIndicator(
                              onRefresh: () => listNotaAndroid(),
                              child: Column(children: <Widget>[
                                new Container(
                                  width: 100.0,
                                  height: 100.0,
                                  child: Image.asset("images/system-eror.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30.0,
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Gagal memuat halaman, tekan tombol muat ulang halaman untuk refresh halaman",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 15.0, right: 15.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      color: Colors.white,
                                      textColor: Colors.green,
                                      disabledColor: Colors.grey,
                                      disabledTextColor: Colors.black,
                                      padding: EdgeInsets.all(15.0),
                                      splashColor: Colors.blueAccent,
                                      onPressed: () async {
                                        getHeaderHTTP();
                                      },
                                      child: Text(
                                        "Muat Ulang Halaman",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          )
                        : listCabang.length == 0
                            ? Container(
                                child: RefreshIndicator(
                                  onRefresh: () => listNotaAndroid(),
                                  // onRefresh: () => listNotaAndroid(),
                                  child: Column(children: <Widget>[
                                    new Container(
                                      width: 100.0,
                                      height: 100.0,
                                      child: Image.asset(
                                          "images/empty-transaction.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, left: 30.0, right: 30.0),
                                      child: Center(
                                        child: Text(
                                          "Warung Islami Bogor Tidak Memiliki Cabang Sama sekali",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              )
                            : Expanded(
                                child: Scrollbar(
                                  child: RefreshIndicator(
                                    onRefresh: () => listNotaAndroid(),
                                    child: ListView.builder(
                                      // scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.all(5.0),
                                      itemCount: listCabang.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          color: Colors.white,
                                          child: ListTile(
                                            leading: new Container(
                                              child: new Image.asset(
                                                  'images/wib-logo.png',
                                              ),
                                              width: 70.0,
                                              height: 100.0,
                                            ),

                                            // leading: FlutterLogo(size: 72.0),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0.0),
                                              child:
                                                  Text(listCabang[index].nama),
                                            ),
                                            subtitle: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10.0),
                                                        child: Icon(
                                                            Icons.person,
                                                            size: 14,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10.0),
                                                        child: Text(
                                                          listCabang[index]
                                                              .owner,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10.0),
                                                        child: Icon(
                                                            Icons.local_phone,
                                                            size: 14,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10.0),
                                                        child: Text(
                                                          listCabang[index]
                                                              .telepon,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:20.0,bottom: 10.0),
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width, // specific value
                                                    child: FlatButton(
                                                      child: new Text(
                                                          'Lihat Stockies Cabang'),
                                                      color: Colors.green[400],
                                                      textColor: Colors.white,
                                                      disabledColor: Colors.grey,
                                                      onPressed: () async {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProvinsiSending(
                                                              id: listCabang[
                                                                      index]
                                                                  .id,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
          ],
        ),
      ),
    );
  }
}
