import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import 'checkout.dart';
import 'model.dart';

List<ListProvinsi> listNota = [];
List<ListProvinsi> filteredlistNota = [];
String tokenType, accessToken;
bool isLoading;
Map<String, String> requestHeaders = Map();

class ProvinsiSending extends StatefulWidget {
  final ListProvinsi provinsi;
  ProvinsiSending({Key key, this.provinsi}) : super(key: key);
  // final String title;
  @override
  State<StatefulWidget> createState() {
    return _ProvinsiState();
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

class _ProvinsiState extends State<ProvinsiSending> {
  TextEditingController controllerfile = new TextEditingController();
  Future<List<ListProvinsi>> getHeaderHTTP() async {
    listNotaAndroid();
  }

  GlobalKey<ScaffoldState> _scaffoldKeyZ = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKeyZ.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<List<ListProvinsi>> listNotaAndroid() async {
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
      final nota = await http.get(
        url('api/listprovinceAndroid'),
        headers: requestHeaders,
      );

      if (nota.statusCode == 200) {
        // return nota;
        var notaJson = json.decode(nota.body);
        var notas = notaJson['provinsi'];

        print('notaJson $notaJson');

        listNota = [];
        for (var i in notas) {
          ListProvinsi notax = ListProvinsi(
            id: '${i['p_id']}',
            nama: i['p_nama'],
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
      setState(() {
        isLoading = false;
      });
      showInSnackBar('Timed out, Try again');
    } catch (e) {
      debugPrint('$e');
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
  List<ListProvinsi> listNota = List();
  List<ListProvinsi> filteredlistNota = List();

  @override
  void initState() {
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
      key: _scaffoldKeyZ,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new TextField(
            decoration: InputDecoration(
              labelText: 'Cari Alamat Provinsi',
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
                                    onTap: () {
                                      Navigator.pop(context, ListProvinsi(
                                        id: filteredlistNota[index].id,
                                        nama: filteredlistNota[index].nama,
                                      ));
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

