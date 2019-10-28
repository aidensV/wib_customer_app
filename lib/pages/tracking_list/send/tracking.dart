import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/storage/storage.dart';

var ids, notas, customers, statuss, totals;
String accessToken, tokenType;
Map<String, String> requestHeaders = Map();
List<ListTracking> listTracking;
bool isLoading;

class Tracking extends StatefulWidget {
  final String id, nota, customer, status, total;
  Tracking({
    Key key,
    @required this.id,
    @required this.nota,
    @required this.customer,
    @required this.status,
    @required this.total,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TrackingState(
      id: id,
      nota: nota,
      customer: customer,
      status: status,
      total: total,
    );
  }
}

class _TrackingState extends State<Tracking> {
  final String id, nota, customer, status, total;
  _TrackingState({
    Key key,
    @required this.id,
    @required this.nota,
    @required this.customer,
    @required this.status,
    @required this.total,
  });

  Future<Null> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    setState(() {
      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;

      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';
      print(requestHeaders);
    });
    listTrackingNotaAndroid();
  }


  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String noresi, price;

  Future<List<ListTracking>> listTrackingNotaAndroid() async {
    setState(() {
      isLoading = true;
    });
    try {
      final item = await http.post(url('api/trackingPosisiPengiriman'),
          headers: requestHeaders, body: {'nota': '$notas'});

      if (item.statusCode == 200) {
        // return nota;
        var itemJson = json.decode(item.body);
        print(itemJson);
        listTracking = [];
        for (var i in itemJson['tracking']) {
          ListTracking notax = ListTracking(
            tanggal: i['tanggal'],
            posisi: i['st_position'],
          );
          listTracking.add(notax);
        }

        var trackinNota = itemJson['nota'];
        noresi = trackinNota['s_resi'];
        price = trackinNota['s_payexpedition'];

        print('listTracking $listTracking');
        print('length listTracking ${listTracking.length}');
        setState(() {
          isLoading = false;
        });
        return listTracking;
      } else {
        showInSnackBar('Request failed with status: ${item.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } on TimeoutException catch (_) {
      showInSnackBar('Timed out, Try again');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    return null;
  }

  @override
  void initState() {
    listTracking = [];
    isLoading = false;
    ids = id;
    notas = nota;
    customers = customer;
    statuss = status;
    totals = total;

    getHeaderHTTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Tracking Nota"),
        backgroundColor: Color(0xff31B057),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Nota',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            notas,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Customer',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            customers,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Nomer Resi',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            noresi == null ? "Tunggu Sebentar" : noresi,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Biaya Pengiriman',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            price == null ? "Tunggu Sebentar" : "Rp. $price",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            isLoading == true
                ? Center(
              child: CircularProgressIndicator(),
            )
                : listTracking.length == 0
                ? Card(
              child: ListTile(
                title: Text(
                  'Tidak ada data',
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: listTracking.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(listTracking[index].tanggal),
                        subtitle: Text(listTracking[index].posisi),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListTracking {
  final String tanggal;
  final String posisi;

  ListTracking({
    this.tanggal,
    this.posisi,
  });
}
