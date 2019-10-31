import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/pages/checkout/checkout.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import '../../utils/Navigator.dart';

GlobalKey<ScaffoldState> _scaffoldKeyX = new GlobalKey<ScaffoldState>();
List<ListKeranjang> listNota = [];
String tokenType, accessToken;
bool isLoading;
Map<String, String> requestHeaders = Map();

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

  void showInSnackBar(String value) {
    _scaffoldKeyX.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<List<ListKeranjang>> listNotaAndroid() async {
    setState(() {
      isLoading = true;
    });
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
        setState(() {
          isLoading = false;
        });
        print('listnota $listNota');
        print('listnota length ${listNota.length}');
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
    return null;
  }

  @override
  void initState() {
    getHeaderHTTP();
    isLoading = false;
    print(requestHeaders);
    super.initState();
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content:
                Text('Anda belum memiliki item pada keranjang belanja anda'),
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

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyX,
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
      ),
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
                : listNota.length == 0
                    ? RefreshIndicator(
                        onRefresh: () => listNotaAndroid(),
                        child: Column(children: <Widget>[
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
                        ]

                            // child: ListTile(
                            //   title: Text(
                            //     'Tidak ada data',
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                            ),
                      )
                    : Expanded(
                        child: Scrollbar(
                          child: RefreshIndicator(
                            onRefresh: () => listNotaAndroid(),
                            child: ListView.builder(
                              // scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(5.0),
                              itemCount: listNota.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 8,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Text("Total Harga : ",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: Text(
                                                      "Rp. " +
                                                          listNota[index].total,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                ButtonTheme(
                                                  buttonColor:
                                                      Color(0xff388bf2),
                                                  child: FlatButton(
                                                    onPressed: () async {
                                                      var idX =
                                                          listNota[index].id;
                                                      try {
                                                        final removecart =
                                                            await http.post(
                                                                url('api/removelistKeranjangAndroind'),
                                                                headers: requestHeaders,
                                                                body: {
                                                              'id_keranjang':
                                                                  idX
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
                                                              getHeaderHTTP();
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
                                      //  FlatButton(
                                      //   onPressed: () {
                                      //     /*...*/
                                      //   },
                                      //   child: Text(
                                      //     "Flat Button",
                                      //   ),
                                      // ),
                                      //  TextField(
                                      //   keyboardType: TextInputType.number,
                                      //   onChanged: (text) async {
                                      //     print("First text field: $text");
                                      //     var idX = listNota[index].id;
                                      //     var qtyX = text;
                                      //     try {
                                      //       final tambahqty = await http.post(
                                      //           url('api/updateQtyKeranjangAndroid'),
                                      //           headers: requestHeaders,
                                      //           body: {
                                      //             'id_keranjang': idX,
                                      //             'qty': qtyX
                                      //           });

                                      //       if (tambahqty.statusCode == 200) {
                                      //         var tambahqtyJson =
                                      //             json.decode(tambahqty.body);
                                      //         if (tambahqtyJson['status'] ==
                                      //             'Success') {
                                      //           setState(() {
                                      //             totalRefresh += 1;
                                      //           });
                                      //         } else if (tambahqtyJson[
                                      //                 'status'] ==
                                      //             'Error') {
                                      //           showInSnackBar(
                                      //               'Gagal! Hubungi pengembang software!');
                                      //         }
                                      //       } else {
                                      //         showInSnackBar(
                                      //             'Request failed with status: ${tambahqty.statusCode}');
                                      //       }
                                      //     } on TimeoutException catch (_) {
                                      //       showInSnackBar(
                                      //           'Timed out, Try again');
                                      //     } catch (e) {
                                      //       print(e);
                                      //     }
                                      //   },
                                      // ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 5,
                                              child: Image.network(
                                                listNota[index].image != null
                                                    ? urladmin(
                                                        'storage/image/master/produk/${listNota[index].image}',
                                                      )
                                                    : url(
                                                        'assets/img/noimage.jpg',
                                                      ),
                                                width: 80.0,
                                                height: 80.0,
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
                                                              top: 10.0),
                                                      child: Text(
                                                        listNota[index].item,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff25282b),
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                            "Rp. " +
                                                                listNota[index]
                                                                    .harga,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0.0),
                                                          child: Text(
                                                              " / " +
                                                                  listNota[
                                                                          index]
                                                                      .satuan,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
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
                                                            onPressed:
                                                                () async {
                                                              var idX =
                                                                  listNota[
                                                                          index]
                                                                      .id;
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
                                                                    setState(
                                                                        () {
                                                                      getHeaderHTTP();
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
                                                                Icons
                                                                    .remove_circle,
                                                                color: Colors
                                                                    .green),
                                                            color: Colors.white,
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 0.0,
                                                            ),
                                                          ),
                                                        ),
                                                        new Text(listNota[index]
                                                            .jumlah),
                                                        ButtonTheme(
                                                          minWidth: 0,
                                                          height: 20.0,
                                                          buttonColor:
                                                              Color(0xff388bf2),
                                                          child: FlatButton(
                                                            onPressed:
                                                                () async {
                                                              var idX =
                                                                  listNota[
                                                                          index]
                                                                      .id;
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
                                                                    setState(
                                                                        () {
                                                                      getHeaderHTTP();
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
                                                                Icons
                                                                    .add_circle,
                                                                color: Colors
                                                                    .green),
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
                                      ),
                                    ],
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
                        headers: requestHeaders,
                      );

                      if (tambahqty.statusCode == 200) {
                        var tambahqtyJson = json.decode(tambahqty.body);
                        if (tambahqtyJson['status'] == 'Success') {
                          final tambahqty = await http.post(
                            url('api/get_totalharga'),
                            headers: requestHeaders,
                          );
                          var ongkirJson = json.decode(tambahqty.body);
                          var totalharga = ongkirJson['totalharga'].toString();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Checkout(
                                  totalharga: totalharga,
                            ),
                          )
                          );
                        } else if (tambahqtyJson['status'] == 'Error') {
                          showInSnackBar('Gagal! Hubungi pengembang software!');
                        } else if (tambahqtyJson['status'] == 'Kosong') {
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
