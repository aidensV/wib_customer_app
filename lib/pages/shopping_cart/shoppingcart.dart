import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import '../../utils/Navigator.dart';

GlobalKey<ScaffoldState> _scaffoldKeyX = new GlobalKey<ScaffoldState>();
List<ListKeranjang> listNota = [];
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

void showInSnackBar(String value) {
  _scaffoldKeyX.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

Future<List<ListKeranjang>> listNotaAndroid() async {
  try {
    final nota = await http.get(
      url('api/listKeranjangAndroid'),
      headers: requestHeaders,
    );

    if (nota.statusCode == 200) {
      // return nota;
      var notaJson = json.decode(nota.body);
      var notas = notaJson['item'];

      print('notaJson $notaJson');

      listNota = [];
      for (var i in notas) {
        ListKeranjang notax = ListKeranjang(
          id: '${i['cart_id']}',
          item: i['i_name'],
          harga: i['ipr_sunitprice'],
          type: i['ity_name'],
          image: i['ip_path'],
          jumlah: i['cart_qty'].toString(),
          satuan: i['iu_name'],
          total: i['hasil'].toString(),
        );
        listNota.add(notax);
      }

      print('listnota $listNota');
      print('listnota length ${listNota.length}');
      return listNota;
    } else {
      showInSnackBar('Request failed with status: ${nota.statusCode}');
      return null;
    }
  } on TimeoutException catch (_) {
    showInSnackBar('Timed out, Try again');
  } catch (e) {
    debugPrint('$e');
  }
  return null;
}

class Keranjang extends StatefulWidget {
  Keranjang({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _KeranjangState();
  }
}

class _KeranjangState extends State<Keranjang> {
  TextEditingController controllerfile = new TextEditingController();
  Future<List<ListKeranjang>> getHeaderHTTP() async {
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

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    // getHeaderHTTP();
    print(requestHeaders);
    super.initState();
  }
  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Anda belum memiliki item pada keranjang belanja anda'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                   _dismissDialog();
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
   _dismissDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyX,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Keranjang Belanja",
            style: TextStyle(
              color: Color(0xff25282b),
            ),
          ),
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: RefreshIndicator(
          onRefresh: () => refreshFunction(),
          child: Scrollbar(
            child: FutureBuilder(
              future: getHeaderHTTP(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return ListTile(
                      title: Text('Tekan Tombol Mulai.'),
                    );
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.data == null ||
                        snapshot.data == 0 ||
                        snapshot.data.length == null ||
                        snapshot.data.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListView(
                          children: <Widget>[
                            new Container(
                              width: 100.0,
                              height: 100.0,
                              child: Image.asset("images/empty-cart.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Center(
                                child: Text("Keranjang belanja anda kosong",
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            // ListTile(
                            //   title: Text(
                            //     'Tidak ada data',
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    } else if (snapshot.data != null || snapshot.data != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              Card(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Text("Total Harga : ",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Text(
                                                    "Rp. " +
                                                        snapshot
                                                            .data[index].total,
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              ButtonTheme(
                                                buttonColor: Color(0xff388bf2),
                                                child: FlatButton(
                                                  onPressed: () async {
                                                    var idX =
                                                        snapshot.data[index].id;
                                                    try {
                                                      final removecart =
                                                          await http.post(
                                                              url('api/removelistKeranjangAndroind'),
                                                              headers: requestHeaders,
                                                              body: {
                                                            'id_keranjang': idX
                                                          });

                                                      if (removecart
                                                              .statusCode ==
                                                          200) {
                                                        var removecartJson =
                                                            json.decode(
                                                                removecart
                                                                    .body);
                                                        if (removecartJson[
                                                                'status'] ==
                                                            'Success') {
                                                          setState(() {
                                                            totalRefresh += 1;
                                                          });
                                                        } else if (removecartJson[
                                                                'status'] ==
                                                            'Error') {
                                                          showInSnackBar(
                                                              'Gagal! Hubungi pengembang software!');
                                                        }
                                                      } else {
                                                        showInSnackBar(
                                                            'Request failed with status: ${removecart.statusCode}');
                                                      }
                                                    } on TimeoutException catch (_) {
                                                      showInSnackBar(
                                                          'Timed out, Try again');
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                  child: new Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.pink,
                                                      size: 18.0),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Image.network(
                                            snapshot.data[index].image != null
                                                ? urladmin(
                                                    'storage/image/master/produk/${snapshot.data[index].image}',
                                                  )
                                                : url(
                                                    'assets/img/noimage.jpg',
                                                  ),
                                            width: 80.0,
                                            height: 100.0,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: Text(
                                                    snapshot.data[index].item,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff25282b),
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                        "Rp. " +
                                                            snapshot.data[index]
                                                                .harga,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0.0),
                                                      child: Text(
                                                          " / " +
                                                              snapshot
                                                                  .data[index]
                                                                  .satuan,
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                          )),
                                                    )
                                                  ],
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 0.0, top: 10.0),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    ButtonTheme(
                                                      minWidth: 0,
                                                      height: 20.0,
                                                      buttonColor:
                                                          Color(0xff388bf2),
                                                      child: FlatButton(
                                                        onPressed: () async {
                                                          var idX = snapshot
                                                              .data[index].id;
                                                          try {
                                                            final kurangqty =
                                                                await http.post(
                                                                    url('api/reduceQtyKeranjangAndroid'),
                                                                    headers: requestHeaders,
                                                                    body: {
                                                                  'id_keranjang':
                                                                      idX
                                                                });

                                                            if (kurangqty
                                                                    .statusCode ==
                                                                200) {
                                                              var kurangqtyJson =
                                                                  json.decode(
                                                                      kurangqty
                                                                          .body);
                                                              if (kurangqtyJson[
                                                                      'status'] ==
                                                                  'Success') {
                                                                setState(() {
                                                                  totalRefresh +=
                                                                      1;
                                                                });
                                                              } else if (kurangqtyJson[
                                                                      'status'] ==
                                                                  'Error') {
                                                                showInSnackBar(
                                                                    'Gagal! Hubungi pengembang software!');
                                                              }
                                                            } else {
                                                              showInSnackBar(
                                                                  'Request failed with status: ${kurangqty.statusCode}');
                                                            }
                                                          } on TimeoutException catch (_) {
                                                            showInSnackBar(
                                                                'Timed out, Try again');
                                                          } catch (e) {
                                                            print(e);
                                                          }
                                                        },
                                                        child: new Icon(
                                                            Icons.remove_circle,
                                                            color:
                                                                Colors.green),
                                                        color: Colors.white,
                                                        padding:
                                                            EdgeInsets.only(
                                                          right: 0.0,
                                                        ),
                                                      ),
                                                    ),
                                                    new Text(snapshot
                                                        .data[index].jumlah),
                                                    ButtonTheme(
                                                      minWidth: 0,
                                                      height: 20.0,
                                                      buttonColor:
                                                          Color(0xff388bf2),
                                                      child: FlatButton(
                                                        onPressed: () async {
                                                          var idX = snapshot
                                                              .data[index].id;
                                                          try {
                                                            final tambahqty =
                                                                await http.post(
                                                                    url('api/addQtyKeranjangAndroid'),
                                                                    headers: requestHeaders,
                                                                    body: {
                                                                  'id_keranjang':
                                                                      idX
                                                                });

                                                            if (tambahqty
                                                                    .statusCode ==
                                                                200) {
                                                              var tambahqtyJson =
                                                                  json.decode(
                                                                      tambahqty
                                                                          .body);
                                                              if (tambahqtyJson[
                                                                      'status'] ==
                                                                  'Success') {
                                                                setState(() {
                                                                  totalRefresh +=
                                                                      1;
                                                                });
                                                              } else if (tambahqtyJson[
                                                                      'status'] ==
                                                                  'Error') {
                                                                showInSnackBar(
                                                                    'Gagal! Hubungi pengembang software!');
                                                              }
                                                            } else {
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
                                                        child: new Icon(
                                                            Icons.add_circle,
                                                            color:
                                                                Colors.green),
                                                        color: Colors.white,
                                                        padding:
                                                            EdgeInsets.only(
                                                          right: 0.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 0.0, top: 10.0),
                                              ),
                                              Container(
                                                height: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                }
                return null; // unreachable
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width, // specific value
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(15.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    try {
                      final tambahqty = await http.post(
                          url('api/gocheckkeranjangAndroid'),
                          headers: requestHeaders,);

                      if (tambahqty.statusCode == 200) {
                        var tambahqtyJson = json.decode(tambahqty.body);
                        if (tambahqtyJson['status'] == 'Success') {
                          MyNavigator.goCheckout(context);
                        } else if (tambahqtyJson['status'] == 'Error') {
                          showInSnackBar('Gagal! Hubungi pengembang software!');
                        }else if(tambahqtyJson['status'] == 'Kosong'){
                           _showMaterialDialog();
                        }
                      } else {
                        showInSnackBar(
                            'Request failed with status: ${tambahqty.statusCode}');
                      }
                    } on TimeoutException catch (_) {
                      showInSnackBar('Timed out, Try again');
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    "Bayar Semua Barang",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ListKeranjang {
  final String id;
  final String item;
  final String harga;
  final String type;
  final String image;
  final String jumlah;
  final String satuan;
  final String total;

  ListKeranjang(
      {this.id,
      this.item,
      this.harga,
      this.type,
      this.image,
      this.jumlah,
      this.satuan,
      this.total});
}
