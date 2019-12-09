import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/pages/checkout/model.dart';
import 'package:wib_customer_app/pages/tracking_list/send/detail.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
// import 'checkout.dart';
import 'model.dart';

List<ListKabupaten> listNota = [];
List<ListKabupaten> filteredlistNota = [];
String tokenType, accessToken;
bool isLoading;
bool isError;
bool isLogout;
var _scaffoldKeyKabupaten;
Map<String, String> requestHeaders = Map();
ListProvinsi provinsi;

class KabupatenSending extends StatefulWidget {
  final ListProvinsi provinsi;
  KabupatenSending({
    Key key,
    @required this.provinsi,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _KabupatenState();
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _KabupatenState extends State<KabupatenSending> {
  _KabupatenState({
    Key key,
  });
  TextEditingController controllerfile = new TextEditingController();
  Future<List<ListKabupaten>> getHeaderHTTP() async {
    return listNotaAndroid();
  }

  void showInSnackBar(String value) {
    _scaffoldKeyKabupaten.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<List<ListKabupaten>> listNotaAndroid() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');
    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print(requestHeaders);
    setState(() {
      isLoading = true;
    });
    try {
      final nota = await http.post(url('api/listkabupatenAndroid'),
          headers: requestHeaders, body: {'provinsi': widget.provinsi.id});

      if (nota.statusCode == 200) {
        // return nota;
        var notaJson = json.decode(nota.body);
        var notas = notaJson['kabupaten'];

        listNota = [];
        for (var i in notas) {
          ListKabupaten notax = ListKabupaten(
            id: '${i['c_id']}',
            nama: i['c_nama'],
          );
          listNota.add(notax);
        }

        setState(() {
          isLoading = false;
          isLogout = false;
          isError = false;
        });
        return listNota;
      } else if (nota.statusCode == 401) {
        setState(() {
          isLoading = false;
          isLogout = true;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isLogout = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isLogout = false;
        isError = true;
      });
    } catch (e) {
      debugPrint('$e');
      setState(() {
        isLoading = false;
        isLogout = false;
        isError = true;
      });
    }
    return null;
  }

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  final _debouncer = Debouncer(milliseconds: 500);
  List<ListKabupaten> listNota = List();
  List<ListKabupaten> filteredlistNota = List();

  @override
  void initState() {
    _scaffoldKeyKabupaten = GlobalKey<ScaffoldState>();
    listNotaAndroid().then((usersFromServer) {
      setState(() {
        listNota = usersFromServer;
        filteredlistNota = listNota;
      });
    });
    getHeaderHTTP();
    isLoading = true;
    isError = false;
    isLogout = false;
    print(requestHeaders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyKabupaten,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new TextField(
            decoration: InputDecoration(
              labelText: 'Cari Alamat Kabupaten',
            ),
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  filteredlistNota = listNota
                      .where((u) =>
                          (u.nama.toLowerCase().contains(string.toLowerCase())))
                      .toList();
                });
              });
            },
          ),
          backgroundColor: Colors.white),
      body: Container(
        // padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            isLoading == true
                ? Center(child: CircularProgressIndicator())
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
                        : Expanded(
                            // child: Scrollbar(
                            child: RefreshIndicator(
                              onRefresh: () => listNotaAndroid(),
                              child: filteredlistNota == null
                                  ? Container()
                                  : ListView.builder(
                                      // scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.all(5.0),
                                      itemCount: filteredlistNota.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.person_pin_circle,
                                                color: Colors.green),
                                            title: Text(
                                                filteredlistNota[index].nama),
                                            onTap: () async {
                                              var idX = listNota[index].id;
                                              showInSnackBar(
                                                  'Sedang mencari biaya ongkir, mohon tunggu sebentar');
                                              try {
                                                final tambahqty = await http.post(
                                                    url('api/get_ongkir_android'),
                                                    headers: requestHeaders,
                                                    body: {'kota': idX});

                                                if (tambahqty.statusCode ==
                                                    200) {
                                                  var ongkirJson = json
                                                      .decode(tambahqty.body);
                                                  var ongkir =
                                                      ongkirJson['total']
                                                          .toString();
                                                  var textongkir =
                                                      ongkirJson['textongkir']
                                                          .toString();
                                                  var totalbelanja =
                                                      ongkirJson['totalbelanja']
                                                          .toString();
                                                  Navigator.pop(
                                                      context,
                                                      ListKabupaten(
                                                        id: filteredlistNota[
                                                                index]
                                                            .id,
                                                        nama: filteredlistNota[
                                                                index]
                                                            .nama,
                                                        ongkir: ongkir,
                                                        textongkir: textongkir,
                                                        totalbelanja:
                                                            totalbelanja,
                                                      ));
                                                } else {
                                                  print('${tambahqty.body}');
                                                  showInSnackBar(
                                                      'Request failed with status: ${tambahqty.statusCode}');
                                                }
                                              } on TimeoutException catch (_) {
                                                showInSnackBar(
                                                    'Timed out, Try again');
                                              } catch (e) {
                                                print(e);
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            // ),
                          ),
          ],
        ),
      ),
    );
  }
}
