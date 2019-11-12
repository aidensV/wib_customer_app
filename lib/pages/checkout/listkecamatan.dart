import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
// import 'checkout.dart';
import 'model.dart';

List<ListKecamatan> listNota = [];
List<ListKecamatan> filteredlistNota = [];
String tokenType, accessToken;
bool isLoading;
Map<String, String> requestHeaders = Map();
ListKabupaten kabupaten;
var _scaffoldKeyU;

class KecamatanSending extends StatefulWidget {
  final ListKabupaten kabupaten;
  KecamatanSending({
    Key key,
    @required this.kabupaten,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _KecamatanState(
    );
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

class _KecamatanState extends State<KecamatanSending> {
  _KecamatanState({
    Key key,
  });
  TextEditingController controllerfile = new TextEditingController();
  Future<List<ListKecamatan>> getHeaderHTTP() async {
    

     return listNotaAndroid();
  }

  void showInSnackBar(String value) {
    _scaffoldKeyU.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<List<ListKecamatan>> listNotaAndroid() async {
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
      final nota = await http.post(url('api/listkecamatanAndroid'),
          headers: requestHeaders, body: {'kabupaten': widget.kabupaten.id});

      if (nota.statusCode == 200) {
        // return nota;
        var notaJson = json.decode(nota.body);
        var notas = notaJson['kecamatan'];

        print('notaJson $notaJson');

        listNota = [];
        for (var i in notas) {
          ListKecamatan notax = ListKecamatan(
            id: '${i['d_id']}',
            nama: i['d_nama'],
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
  List<ListKecamatan> listNota = List();
  List<ListKecamatan> filteredlistNota = List();

  @override
  void initState() {
    _scaffoldKeyU = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKeyU,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new TextField(
            decoration: InputDecoration(
              labelText: 'Cari Alamat Kecamatan',
            ),
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  filteredlistNota = listNota
                      .where((u) => (u.nama
                              .toLowerCase()
                              .contains(string.toLowerCase())))
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
                          child:filteredlistNota == null ? Container() : ListView.builder(
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
                                    Navigator.pop(context, ListKecamatan(
                                            id : filteredlistNota[index].id,
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

