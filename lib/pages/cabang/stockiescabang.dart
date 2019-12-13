import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
// import 'checkout.dart';
import 'model.dart';

List<ListStockies> listStockies = [];
List<ListStockies> filteredlistStockies = [];
String tokenType, accessToken;
bool isLoading;
var namacabangX;
GlobalKey<ScaffoldState> _scaffoldKeyStockies;
Map<String, String> requestHeaders = Map();

class ProvinsiSending extends StatefulWidget {
  ProvinsiSending({Key key, this.id}) : super(key: key);
  final String id;
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
  Future<List<ListStockies>> getHeaderHTTP() async {
    return listNotaAndroid();
  }

  void showInSnackBar(String value) {
    _scaffoldKeyStockies.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<List<ListStockies>> listNotaAndroid() async {
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
      final stockies = await http.post(url('api/detail_stockies_cabang'),
          headers: requestHeaders, body: {'cabang': widget.id});

      if (stockies.statusCode == 200) {
        // return nota;
        var stockiesJson = json.decode(stockies.body);
        var stockiess = stockiesJson['stockies'];
        var namacabang = stockiesJson['namacabang'];
        listStockies = [];
        for (var i in stockiess) {
          ListStockies stockiesx = ListStockies(
            kabupaten: i['kota'],
            provinsi: i['provinsi'],
          );
          listStockies.add(stockiesx);
        }
        setState(() {
          isLoading = false;
          namacabangX = namacabang;
        });
        return listStockies;
      } else {
        showInSnackBar('Request failed with status: ${stockies.statusCode}');
        print('status ${stockies.body}');
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
  List<ListStockies> listNota = List();
  List<ListStockies> filteredlistNota = List();

  @override
  void initState() {
    _scaffoldKeyStockies = GlobalKey<ScaffoldState>();
    listNotaAndroid().then((usersFromServer) {
      setState(() {
        listStockies = usersFromServer;
        filteredlistStockies = listStockies;
      });
    });
    getHeaderHTTP();
    namacabangX = 'Warung Botol';
    isLoading = false;
    print(requestHeaders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyStockies,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new TextField(
            decoration: InputDecoration(
              hintText: 'Kabupaten Stockies $namacabangX',
            ),
            
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  filteredlistStockies = listStockies
                      .where((u) =>
                          (u.kabupaten.toLowerCase().contains(string.toLowerCase())))
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
                      child: filteredlistStockies == null || filteredlistStockies.length == 0
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
                                          "$namacabangX Tidak Memiliki Stockies Sama sekali",
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
                          : ListView.builder(
                              // scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(5.0),
                              itemCount: filteredlistStockies.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    leading: Icon(Icons.person_pin_circle,
                                        color: Colors.green),
                                    title: Text(filteredlistStockies[index].kabupaten +  '- ' + filteredlistStockies[index].provinsi),
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

