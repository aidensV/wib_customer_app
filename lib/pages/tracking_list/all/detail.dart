import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import '../../../utils/Navigator.dart';
import 'dart:convert';
import 'package:wib_customer_app/storage/storage.dart';

var idX, notaX, customerX, statusX;
String accessToken, tokenType, stockiesX;
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
          );
          listItem.add(notax);
        }

        print('listItem $listItem');
        print('length listItem ${listItem.length}');
        setState(() {
          stockiesX = stockies;
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
    stockiesX = null;
    listItemNotaAndroid();
    getHeaderHTTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  // leading:
                                  //  Image.network(
                                  //   urladmin(
                                  //     'storage/image/master/produk/${snapshot.data[index].image}',
                                  //   ),
                                  // ),
                                  leading: Image.network(
                                    listItem[index].image != null
                                        ? url(
                                            'assets/img/noimage.jpg',
                                          )
                                        : url(
                                            'assets/img/noimage.jpg',
                                          ),
                                    width: 70.0,
                                    height: 100.0,
                                  ),

                                  // leading: FlutterLogo(size: 72.0),
                                  title: Text(listItem[index].nama == null ? 'Unknown Item' : listItem[index].nama),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, top: 10.0),
                                              child: Text("Jumlah :  ${listItem[index].qty}",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, top: 10.0),
                                              child: Text(listItem[index].hargasales == null ? 'Rp. 0 ': 'Rp. '+listItem[index].hargasales + '/ Pcs',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, top: 10.0),
                                              child: Text(listItem[index].totalharga == null ? 'Rp. 0': 'Rp. ' + listItem[index].totalharga,
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  // trailing: Icon(Icons.favorite, color: Colors.pink),
                                  trailing: new FlatButton(
                                    child: new Text(
                                      'Beli Lagi',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.green,
                                    onPressed: () async {
                                      var location = stockiesX;
                                      if (location == null) {
                                        _showAlamatNull();
                                      } else {
                                        try {
                                          final adcart = await http.post(
                                              url('api/addCartAndroid'),
                                              headers: requestHeaders,
                                              body: {
                                                'code': listItem[index].code,
                                                'cart_qty': listItem[index].qty,
                                                'cart_location': stockiesX,
                                              });

                                          if (adcart.statusCode == 200) {
                                            var addcartJson =
                                                json.decode(adcart.body);
                                            if (addcartJson['done'] == 'done') {
                                              showInSnackBar(
                                                  '${listItem[index].nama} berhasil dimasukkan ke keranjang');
                                            } else if (addcartJson['error'] ==
                                                'stock') {
                                              showInSnackBar(
                                                  'Stock ${listItem[index].nama} tersisa ${addcartJson['stock']}');
                                            } else if (addcartJson['error'] ==
                                                'error') {
                                              showInSnackBar(
                                                  '${listItem[index].nama} sudah ada dikeranjang');
                                            }
                                          } else {
                                            print('${adcart.body}');
                                          }
                                        } on TimeoutException catch (_) {} catch (e) {
                                          print(e);
                                        }
                                      }
                                    },
                                  ),
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
                  fontSize: 18.0,
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
                      style:
                          TextStyle(fontFamily: 'TitilliumWeb', fontSize: 20.0),
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

                            Map<String, dynamic> requestHeadersX = requestHeaders;

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
                                  MyNavigator.goCheckout(context);
                                }else{
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
  });
}

