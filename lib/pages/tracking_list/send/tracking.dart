import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:wib_customer_app/storage/storage.dart';

var notas, customers;
var _scaffoldKeyTrackingDelivery;
String accessToken, tokenType;
Map<String, String> requestHeaders = Map();
List<ListTracking> listTracking;
bool isLoading;
bool isLogout;
bool isError;

class Tracking extends StatefulWidget {
  final String nota, customer;
  Tracking({
    Key key,
    @required this.nota,
    @required this.customer,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TrackingState(
      nota: nota,
      customer: customer,
    );
  }
}

class _TrackingState extends State<Tracking> {
  final String nota, customer;
  _TrackingState({
    Key key,
    @required this.nota,
    @required this.customer,
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

  void showInSnackBar(String value) {
    _scaffoldKeyTrackingDelivery.currentState
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
          isLogout = false;
          isError = false;
        });
        return listTracking;
      } else if (item.statusCode == 401) {
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
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isLogout = false;
        isError = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        isLogout = false;
        isError = true;
      });
    }
    return null;
  }

  @override
  void initState() {
    listTracking = [];
    isLoading = true;
    isLogout = false;
    isError = false;
    _scaffoldKeyTrackingDelivery = new GlobalKey<ScaffoldState>();
    notas = nota;
    customers = customer;
    getHeaderHTTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat _numberFormat =
        new NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
    return Scaffold(
      key: _scaffoldKeyTrackingDelivery,
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Lacak Pengiriman"),
        textTheme: TextTheme(
          title: TextStyle(
            color : Colors.black,
            fontSize: 18,
          ),
        ),
        // backgroundColor: Color(0xff31B057),
      ),
      body: isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          :isLogout == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => getHeaderHTTP(),
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
                    onRefresh: () => getHeaderHTTP(),
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
              : Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        isLoading == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : listTracking.length == 0
                                ? RefreshIndicator(
                                    onRefresh: () => listTrackingNotaAndroid(),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.local_mall,
                                                  color: Colors.green),
                                              title: Text(notas == null
                                                  ? 'Nota : -'
                                                  : 'Nota : $notas'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.person,
                                                  color: Colors.green),
                                              title: Text(customer == null
                                                  ? 'Customer : -'
                                                  : 'Customer : $customer'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(
                                                  Icons.local_shipping,
                                                  color: Colors.green),
                                              title: Text(noresi == null
                                                  ? 'No Resi : -'
                                                  : 'No Resi : $noresi'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.local_atm,
                                                  color: Colors.green),
                                              title: Text(price == null
                                                  ? 'Biaya Ongkir : Rp.  -'
                                                  : 'Biaya Ongkir : ' +
                                                      _numberFormat.format(
                                                          double.parse(price
                                                              .toString()))),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20.0, bottom: 20.0),
                                          child: Text(
                                            'History Pengiriman',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            title: Text(
                                              'Tidak ada data',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => listTrackingNotaAndroid(),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.local_mall,
                                                  color: Colors.green),
                                              title: Text(notas == null
                                                  ? 'Nota : -'
                                                  : 'Nota : $notas'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.person,
                                                  color: Colors.green),
                                              title: Text(customer == null
                                                  ? 'Customer : -'
                                                  : 'Customer : $customer'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(
                                                  Icons.local_shipping,
                                                  color: Colors.green),
                                              title: Text(noresi == null
                                                  ? 'No Resi : -'
                                                  : 'No Resi : $noresi'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.local_atm,
                                                  color: Colors.green),
                                              title: Text(price == null
                                                  ? 'Biaya Ongkir : Rp.  -'
                                                  : 'Biaya Ongkir : ' +
                                                      _numberFormat.format(
                                                          double.parse(price
                                                              .toString()))),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20.0, bottom: 20.0),
                                          child: Text(
                                            'History Pengiriman',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 0.0,
                                            bottom: 5.0,
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: listTracking
                                                .map((ListTracking f) =>
                                                    Container(
                                                      child: Card(
                                                        child: ListTile(
                                                          title: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .access_time,
                                                                color: Colors
                                                                    .green,
                                                                size: 18,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0),
                                                                child: Text(
                                                                    f.tanggal ==
                                                                            null
                                                                        ? '?'
                                                                        : f.tanggal),
                                                              ),
                                                            ],
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 14,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0),
                                                                  child: Text(
                                                                      f.posisi ==
                                                                              null
                                                                          ? '?'
                                                                          : f.posisi),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                      ],
                    ),
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
