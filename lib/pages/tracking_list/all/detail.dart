import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../utils/Navigator.dart';
import 'dart:convert';
import 'package:wib_customer_app/pages/checkout/checkout.dart';
import 'package:wib_customer_app/storage/storage.dart';

var idX, notaX, customerX, statusX;
String accessToken, tokenType, stockiesX, ongkirX;
Map<String, dynamic> formSerialize;
Map<String, String> requestHeaders = Map();
List<ListItem> listItem;
bool isLoading;

class Detail extends StatefulWidget {
  final String id, nota, customer, status, total;
  Detail({
    Key key,
    @required this.id,
    @required this.nota,
    @required this.customer,
    @required this.status,
    @required this.total,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailState(
      id: id,
      nota: nota,
      customer: customer,
      status: status,
      total: total,
    );
  }
}

class _DetailState extends State<Detail> {
  final String id, nota, customer, status, total;
  _DetailState({
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
    listItemNotaAndroid();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<List<ListItem>> listItemNotaAndroid() async {
    setState(() {
      isLoading = true;
    });
    try {
      final item = await http.post(url('api/detailTransaksiAndroid'),
          headers: requestHeaders, body: {'nota': '$notaX'});

      if (item.statusCode == 200) {
        // return nota;
        var itemJson = json.decode(item.body);
        String stockies = itemJson['stockies'].toString();
        var itemproduct = itemJson['item'];
        var ongkir = itemJson['ongkir'];
        print('biaya ${ongkir}');
        print(itemproduct);
        print(itemJson);
        listItem = [];
        for (var i in itemJson['item']) {
          ListItem notax = ListItem(
            nama: i['i_name'],
            satuan: i['iu_name'],
            qty: '${i['sd_qty'].toString()}',
            hargasales: i['sd_price'].toString(),
            totalharga: i['sd_total'].toString(),
            price: i['ipr_sunitprice'].toString(),
            image: i['ip_path'],
            code: i['i_code'],
            berat: i['itp_weight'].toString(),
            hargadiskon : i['sd_discvalue'].toString(),
          );
          listItem.add(notax);
        }

        print('listItem $listItem');
        print('length listItem ${listItem.length}');
        setState(() {
          stockiesX = stockies;
          ongkirX = ongkir;
          isLoading = false;
        });
        return listItem;
      } else if(item.statusCode == 500){
        showInSnackBar('Request failed with status: ${item.statusCode}');
        print(item.body);
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

  void _showAlamatNull() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Silahkan Setting alamat dulu pada profile'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/profile");
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  @override
  void initState() {
    listItem = [];
    isLoading = false;
    idX = id;
    notaX = nota;
    customerX = customer;
    statusX = status;
    ongkirX = null;
    stockiesX = null;
    listItemNotaAndroid();
    getHeaderHTTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat _numberFormat = new NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Detail Nota"),
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
                            notaX,
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
                            customerX,
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
                            'Biaya Ongkir',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(ongkirX == null ? 'Rp. 0.00' : _numberFormat.format(double.parse(ongkirX.toString())),
                            style: TextStyle(color: Colors.black54),
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
                : listItem.length == 0
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
                            itemCount: listItem.length,
                            itemBuilder: (BuildContext context, int index) {
                              double totalperitem =
                                  double.parse(listItem[index].totalharga);
                              double hargaperitem =
                                  double.parse(listItem[index].hargasales);
                              NumberFormat _numberFormat =
                                  new NumberFormat.simpleCurrency(
                                      decimalDigits: 2, name: 'Rp. ');
                              String finaltotalitem =
                                  _numberFormat.format(totalperitem);
                              String finalhargaperitem =
                                  _numberFormat.format(hargaperitem);
                              return Card(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 7,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: Text(
                                                      listItem[index]
                                                                  .totalharga ==
                                                              null
                                                          ? "Total : Rp. 0.00"
                                                          : "Total : " +
                                                              finaltotalitem,
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                ButtonTheme(
                                                  minWidth: 0,
                                                  height: 20.0,
                                                  buttonColor:
                                                      Color(0xff388bf2),
                                                  child: FlatButton(
                                                    onPressed: () async {
                                                      var location = stockiesX;
                                                      if (location == null) {
                                                        _showAlamatNull();
                                                      } else {
                                                        try {
                                                          final adcart =
                                                              await http.post(
                                                                  url(
                                                                      'api/addCartAndroid'),
                                                                  headers:
                                                                      requestHeaders,
                                                                  body: {
                                                                'code': listItem[
                                                                        index]
                                                                    .code,
                                                                'cart_qty':
                                                                    listItem[
                                                                            index]
                                                                        .qty,
                                                                'cart_location':
                                                                    stockiesX,
                                                              });

                                                          if (adcart
                                                                  .statusCode ==
                                                              200) {
                                                            var addcartJson =
                                                                json.decode(
                                                                    adcart
                                                                        .body);
                                                            if (addcartJson[
                                                                    'done'] ==
                                                                'done') {
                                                              showInSnackBar(
                                                                  '${listItem[index].nama} berhasil dimasukkan ke keranjang');
                                                            } else if (addcartJson[
                                                                    'error'] ==
                                                                'stock') {
                                                              showInSnackBar(
                                                                  'Stock ${listItem[index].nama} tersisa ${addcartJson['stock']}');
                                                            } else if (addcartJson[
                                                                    'error'] ==
                                                                'error') {
                                                              showInSnackBar(
                                                                  '${listItem[index].nama} sudah ada dikeranjang');
                                                            }
                                                          } else {
                                                            print(
                                                                '${adcart.body}');
                                                          }
                                                        } on TimeoutException catch (_) {} catch (e) {
                                                          print(e);
                                                        }
                                                      }
                                                    },
                                                    child: new Text(
                                                      'Beli Lagi',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 5,
                                            child: Image.network(
                                              listItem[index].image != null
                                                  ? urladmin(
                                                      'storage/image/master/produk/${listItem[index].image}',
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
                                                      listItem[index].nama,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff25282b),
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                listItem[index].hargadiskon.toString() == '0' ?
                                                Container(
                                                  height: 30.0,
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, top: 10.0),
                                                ):
                                                Container(
                                                  height: 30.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          listItem[index]
                                                                      .hargasales ==
                                                                  null
                                                              ? 'Rp. 0.00'
                                                              : _numberFormat.format(double.parse(listItem[index].hargasales.toString())),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                                  decoration: TextDecoration.lineThrough)),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, top: 10.0),
                                                ),
                                                listItem[index].hargadiskon.toString() == '0' ?
                                                Container(
                                                  height: 30.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          listItem[index]
                                                                      .hargadiskon ==
                                                                  null
                                                              ? 'Rp. 0.00'
                                                              : _numberFormat.format(double.parse(listItem[index].hargasales.toString())),
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
                                                                listItem[index]
                                                                    .satuan,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, top: 10.0),
                                                ):
                                                Container(
                                                  height: 30.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          listItem[index]
                                                                      .hargadiskon ==
                                                                  null
                                                              ? 'Rp. 0.00'
                                                              : _numberFormat.format(double.parse(listItem[index].hargasales.toString()) - (double.parse(listItem[index].hargadiskon.toString()) / int.parse(listItem[index].qty)) ),
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
                                                                listItem[index]
                                                                    .satuan,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
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
                                                      Text(
                                                          "Jumlah : ${listItem[index].qty}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, top: 10.0),
                                                ),
                                                Container(
                                                  height: 30.0,
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
          ],
        ),
      ),
      
      floatingActionButton: InkWell(
        onTap: () {
          _confirmationModalBottomSheet(context);
        },
        child: Container(
          width: 200.0,
          height: 50.0,
          decoration: new BoxDecoration(
            color: Color(0xff31B057),
            border: new Border.all(color: Colors.transparent, width: 2.0),
            borderRadius: new BorderRadius.circular(23.0),
          ),
          child: Center(
            child: Text(
              'Salin Ke Nota Baru',
              style: new TextStyle(
                  fontFamily: 'TitilliumWeb',
                  fontSize: 14.0,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmationModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              height: 130.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Apa anda yakin?",
                        style: TextStyle(
                            fontFamily: 'TitilliumWeb', fontSize: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Container(
                    child: Text(
                      "Item pada transaksi ini akan langsung diarahkan ke checkout !",
                      style: TextStyle(
                          fontFamily: 'TitilliumWeb',
                          fontSize: 16.0,
                          color: Colors.grey[400]),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 40.0,
                          width: 80.0,
                          child: RaisedButton(
                            onPressed: () async {
                              formSerialize = Map<String, dynamic>();
                              formSerialize['cabang'] = null;
                              formSerialize['item'] = List();
                              formSerialize['qty'] = List();
                              formSerialize['berat'] = List();

                              formSerialize['cabang'] = stockiesX;
                              for (int i = 0; i < listItem.length; i++) {
                                formSerialize['item'].add(listItem[i].code);
                                formSerialize['qty'].add(listItem[i].qty);
                                formSerialize['berat'].add(listItem[i].berat);
                              }

                              print(formSerialize);

                              Map<String, dynamic> requestHeadersX =
                                  requestHeaders;

                              requestHeadersX['Content-Type'] =
                                  "application/x-www-form-urlencoded";
                              try {
                                final response = await http.post(
                                  url('api/checkout_repeat_order_android'),
                                  headers: requestHeadersX,
                                  body: {
                                    'type_platform': 'android',
                                    'data': jsonEncode(formSerialize),
                                  },
                                  encoding: Encoding.getByName("utf-8"),
                                );

                                if (response.statusCode == 200) {
                                  dynamic responseJson =
                                      jsonDecode(response.body);
                                  if (responseJson['status'] == 'success') {
                                    Navigator.pop(context);
                                    Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkout(),
                              ));
                                  } else {
                                    showInSnackBar(
                                        'Hubungi Pengembang Software');
                                    print('${response.body}');
                                  }
                                  print('response decoded $responseJson');
                                } else {
                                  print('${response.body}');
                                  showInSnackBar(
                                      'Request failed with status: ${response.statusCode}');
                                  Navigator.pop(context);
                                }
                              } on TimeoutException catch (_) {
                                Navigator.pop(context);
                                showInSnackBar('Timed out, Try again');
                              } catch (e) {
                                print(e);
                              }
                            },
                            color: Color(0xff31B057),
                            child: Text("Ya",
                                style: TextStyle(
                                    fontFamily: 'TitilliumWeb',
                                    fontSize: 16.0,
                                    color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          height: 40.0,
                          width: 80.0,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.transparent,
                            elevation: 0.0,
                            child: Text("Tidak!",
                                style: TextStyle(
                                    fontFamily: 'TitilliumWeb',
                                    fontSize: 16.0,
                                    color: Color(0xff31B057))),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(2.0),
                                side: BorderSide(color: Color(0xff31B057))),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ListItem {
  final String nama;
  final String satuan;
  final String qty;
  final String code;
  final String image;
  final String price;
  final String berat;
  final String hargasales;
  final String totalharga;
  final String hargadiskon;

  ListItem({
    this.nama,
    this.satuan,
    this.qty,
    this.code,
    this.image,
    this.price,
    this.berat,
    this.totalharga,
    this.hargasales,
    this.hargadiskon,
  });
}
