import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/pages/checkout/model.dart';
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
var _scaffoldKeyY;
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
    _scaffoldKeyY.currentState
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

        print('notaJson $notaJson');

        listNota = [];
        for (var i in notas) {
          ListKabupaten notax = ListKabupaten(
            id: '${i['c_id']}',
            nama: i['c_nama'],
          );
          listNota.add(notax);
        }

        print('listnota $listNota');
        print('listnota length ${listNota.length}');
        setState(() {
          isLoading = false;
        });
        return listNota;
      } else {
        showInSnackBar('Request failed with status: ${nota.statusCode}');
        setState(() {
          isLoading = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      showInSnackBar('Timed out, Try again');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('$e');
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
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
    _scaffoldKeyY = GlobalKey<ScaffoldState>();
    listNotaAndroid().then((usersFromServer) {
      setState(() {
        listNota = usersFromServer;
        filteredlistNota = listNota;
      });
    });
    getHeaderHTTP();
    isLoading = false;
    print(requestHeaders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyY,
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
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
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
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    leading: Icon(Icons.person_pin_circle,
                                        color: Colors.green),
                                    title: Text(filteredlistNota[index].nama),
                                    onTap: () async {
                                      var idX = listNota[index].id;
                                      try {
                                        final tambahqty = await http.post(
                                            url('api/get_ongkir_android'),
                                            headers: requestHeaders,
                                            body: {'kota': idX});

                                        if (tambahqty.statusCode == 200) {

                                          var ongkirJson =
                                              json.decode(tambahqty.body);
                                          var ongkir =
                                              ongkirJson['total'].toString();
                                              var textongkir = ongkirJson['textongkir'].toString();
                                              var totalbelanja = ongkirJson['totalbelanja'].toString();
                                          Navigator.pop(
                                              context,
                                              ListKabupaten(
                                                id: filteredlistNota[index].id,
                                                nama: filteredlistNota[index]
                                                    .nama,
                                                ongkir: ongkir,
                                                textongkir: textongkir,
                                                totalbelanja: totalbelanja,
                                              ));
                                        } else {
                                          print('${tambahqty.body}');
                                          showInSnackBar(
                                              'Request failed with status: ${tambahqty.statusCode}');
                                        }
                                      } on TimeoutException catch (_) {
                                        showInSnackBar('Timed out, Try again');
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
