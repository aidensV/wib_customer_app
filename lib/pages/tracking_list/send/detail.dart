import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/storage/storage.dart';
import 'tracking.dart';

var idX, notaX, customerX, statusX;
GlobalKey<ScaffoldState> _scaffolddetaildelivered;
String accessToken,
    tokenType,
    stockiesX,
    ongkirX,
    totalhargasemuabarangX,
    totalpembelianX,
    provinsiX,
    kabupatenX,
    kecamatanX,
    kodeposX,
    alamatX,
    expedisiX,
    resiX,
    deliveredX;
Map<String, dynamic> formSerialize;
Map<String, String> requestHeaders = Map();
List<ListItem> listItem = [];
bool isLoading;
bool isError;

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

  void showInSnackBar(String value) {
    _scaffolddetaildelivered.currentState
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
        var totalhargasemuabarang = itemJson['totalhargabarang'];
        var totalpembelian = itemJson['totalpembelian'];
        var provinsi = itemJson['provinsi'];
        var kabupaten = itemJson['kabupaten'];
        var kecamatan = itemJson['kecamatan'];
        var kodepos = itemJson['kodepos'];
        var alamat = itemJson['alamat'];
        String expedisi = itemJson['expedisi'];
        String resi = itemJson['resi'];
        String delivered = itemJson['delivered'];
        print('biaya $ongkir');
        print('item ini $itemproduct');
        print(itemJson);
        listItem = [];
        for (var i in itemJson['item']) {
          ListItem notax = ListItem(
              nama: i['i_name'],
              satuan: i['iu_name'],
              qty: '${i['sd_qty'].toString()}',
              hargasales: i['sd_price'],
              totalharga: i['sd_total'],
              jenis: i['ity_name'],
              price: i['ipr_sunitprice'],
              image: i['ip_path'],
              code: i['i_code'],
              berat: i['itp_weight'].toString(),
              hargadiskon: i['sd_discvalue']);
          listItem.add(notax);
        }

        print('listItem $listItem');
        print('length listItem ${listItem.length}');
        setState(() {
          stockiesX = stockies;
          ongkirX = ongkir;
          provinsiX = provinsi;
          kabupatenX = kabupaten;
          kecamatanX = kecamatan;
          kodeposX = kodepos;
          alamatX = alamat;
          expedisiX = expedisi;
          deliveredX = delivered;
          resiX = resi;
          totalpembelianX = totalpembelian;
          totalhargasemuabarangX = totalhargasemuabarang;
          isLoading = false;
          isError = false;
        });
        return listItem;
      } else if (item.statusCode == 500) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
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
    isLoading = true;
    isError = false;
    idX = id;
    notaX = nota;
    customerX = customer;
    statusX = status;
    ongkirX = null;
    _scaffolddetaildelivered = new GlobalKey<ScaffoldState>();
    stockiesX = null;
    provinsiX = null;
    kabupatenX = null;
    kecamatanX = null;
    kodeposX = null;
    alamatX = null;
    expedisiX = null;
    deliveredX = null;
    resiX = null;
    totalhargasemuabarangX = null;
    totalpembelianX = null;
    listItemNotaAndroid();
    getHeaderHTTP();
    super.initState();
  }

  Widget statusNota(deliveredX) {
    if (deliveredX == 'A') {
      return Text(
        "Ambil sendiri",
        style: TextStyle(color: Colors.orange),
      );
    } else if (deliveredX == 'Y') {
      return Text(
        "Barang sudah diterima",
        style: TextStyle(color: Colors.red),
      );
    } else if (deliveredX == 'T') {
      return Text(
        "Pengiriman terlambat",
        style: TextStyle(color: Colors.green),
      );
    } else if (deliveredX == 'P') {
      return Text(
        "Sedang dikirim",
        style: TextStyle(color: Colors.orange),
      );
    } else if (deliveredX == 'P') {
      return Text("Sedang Dikirim", style: TextStyle(color: Colors.green));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat _numberFormat =
        new NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
    return Scaffold(
      key: _scaffolddetaildelivered,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Detail Nota"),
        backgroundColor: Color(0xff31B057),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
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
                  padding: EdgeInsets.all(5.0),
                  child: ListView(
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.local_mall, color: Colors.green),
                          title: Text(
                              notaX == null ? 'Nota : -' : 'Nota : $notaX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.person, color: Colors.green),
                          title: Text(customerX == null
                              ? 'Customer : -'
                              : 'Customer : $customerX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading:
                              Icon(Icons.local_shipping, color: Colors.green),
                          title: Text(expedisiX == null
                              ? 'Jasa Pengiriman : -'
                              : 'Jasa Pengiriman : $expedisiX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading:
                              Icon(Icons.call_to_action, color: Colors.green),
                          title: Text(resiX == null
                              ? 'Nomor Resi : -'
                              : 'Nomor Resi : $resiX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.shop, color: Colors.green),
                          title: Text(totalhargasemuabarangX == null ||
                                  totalhargasemuabarangX == '0'
                              ? 'Total Harga Barang : Rp. 0.00'
                              : 'Total Harga Barang : Rp. $totalhargasemuabarangX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.local_atm, color: Colors.green),
                          title: Text(ongkirX == null || ongkirX == '0'
                              ? 'Biaya Ongkir : Rp. 0.00'
                              : 'Biaya Ongkir : ' +
                                  _numberFormat.format(
                                      double.parse(ongkirX.toString()))),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading:
                              Icon(Icons.shopping_basket, color: Colors.green),
                          title: Text(
                              totalpembelianX == null || totalpembelianX == '0'
                                  ? 'Total Pembelian : Rp. 0.00'
                                  : 'Total Pembelian : Rp. $totalpembelianX'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 5.0),
                        child: new Text(
                          deliveredX == null
                              ? 'Alamat Pengiriman'
                              : deliveredX == 'A'
                                  ? 'Alamat Pengiriman'
                                  : 'Alamat Pengiriman',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.location_on, color: Colors.green),
                          title: Text(ongkirX == null ||
                                  ongkirX == '0' ||
                                  ongkirX == '0.00'
                              ? 'Provinsi : -'
                              : provinsiX == null || provinsiX == '0'
                                  ? 'Provinsi : -'
                                  : 'Provinsi : $provinsiX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading:
                              Icon(Icons.location_city, color: Colors.green),
                          title: Text(ongkirX == null ||
                                  ongkirX == '0' ||
                                  ongkirX == '0.00'
                              ? 'Kab/Kota : -'
                              : kabupatenX == null || kabupatenX == '0'
                                  ? 'Kabupaten : -'
                                  : 'Kab/Kota : $kabupatenX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.location_on, color: Colors.green),
                          title: Text(ongkirX == null ||
                                  ongkirX == '0' ||
                                  ongkirX == '0.00'
                              ? 'Kecamatan : -'
                              : kecamatanX == null || kecamatanX == '0'
                                  ? 'Kecamatan : -'
                                  : 'Kecamatan : $kecamatanX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.local_post_office,
                              color: Colors.green),
                          title: Text(ongkirX == null ||
                                  ongkirX == '0' ||
                                  ongkirX == '0.00'
                              ? 'Kodepos : -'
                              : kodeposX == null || kodeposX == '0'
                                  ? 'Kodepos : -'
                                  : 'Kodepos : $kodeposX'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.streetview, color: Colors.green),
                          title: Text(ongkirX == null ||
                                  ongkirX == '0' ||
                                  ongkirX == '0.00'
                              ? '-'
                              : alamatX == null || alamatX == ''
                                  ? ''
                                  : alamatX),
                        ),
                      ),
                      listItem.length == 0
                          ? Card(
                              child: ListTile(
                                title: Text(
                                  'Tidak ada data',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, left: 15.0),
                              child: new Text('Daftar Barang'),
                            ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 1,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio:
                              MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? 2.2
                                  : 4.2,
                          children: listItem.map(
                            (item) {
                              var children2 = <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 0.0,
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
                                                      left: 0.0,
                                                      top: 0.0,
                                                    ),
                                                    child: Text(
                                                        item.totalharga ==
                                                                    null ||
                                                                item.totalharga
                                                                        .toString() ==
                                                                    '0.00'
                                                            ? "Total : Rp. 0.00"
                                                            : "Total : " +
                                                                _numberFormat.format(
                                                                    double.parse(item
                                                                        .totalharga
                                                                        .toString())),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: Text(
                                                        ' | ${item.qty} Qty',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
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
                                                        var location =
                                                            stockiesX;
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
                                                                  'code':
                                                                      item.code,
                                                                  'cart_qty':
                                                                      item.qty,
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
                                                                    '${item.nama} berhasil dimasukkan ke keranjang');
                                                              } else if (addcartJson[
                                                                      'status'] ==
                                                                  'minbeli') {
                                                                showInSnackBar(
                                                                    '${addcartJson['minbuy']}');
                                                              } else if (addcartJson[
                                                                      'status'] ==
                                                                  'stockkurangminbeli') {
                                                                showInSnackBar(
                                                                    '${addcartJson['message']}');
                                                              } else if (addcartJson[
                                                                      'status'] ==
                                                                  'maxstock') {
                                                                showInSnackBar(
                                                                    '${addcartJson['messagestock']}');
                                                              } else if (addcartJson[
                                                                      'error'] ==
                                                                  'error') {
                                                                showInSnackBar(
                                                                    '${item.nama} sudah ada dikeranjang');
                                                              } else if (addcartJson[
                                                                      'error'] ==
                                                                  'Berat Barang Belum Di Set') {
                                                                showInSnackBar(
                                                                    'Mohon Maaf, berat barang belum disetting');
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
                                                            color:
                                                                Colors.white),
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
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 5,
                                              child: Image.network(
                                                item.image != null
                                                    ? urladmin(
                                                        'storage/image/master/produk/${item.image}',
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
                                                        item.nama,
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
                                                    height: 30.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0.0),
                                                          child: Text(
                                                              item.jenis ==
                                                                          null ||
                                                                      item.jenis ==
                                                                          ''
                                                                  ? 'Jenis Barang'
                                                                  : item.jenis,
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                ),
                                // padding: const EdgeInsets.all(10.0),
                                // margin: EdgeInsets.all(5.0),
                                child: Card(
                                  elevation: 0.0,
                                  child: Column(
                                    children: children2,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: InkWell(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tracking(
                nota: notaX,
                customer: customerX,
              ),
            ),
          );
        },
        child: Container(
          width: 120.0,
          height: 40.0,
          decoration: new BoxDecoration(
            color: Color(0xff31B057),
            border: new Border.all(color: Colors.transparent, width: 2.0),
            borderRadius: new BorderRadius.circular(23.0),
          ),
          child: Center(
            child: Text(
              'Lacak Pengiriman',
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
}

class ListItem {
  final String nama;
  final String satuan;
  final String qty;
  final String code;
  final String image;
  final String price;
  final String berat;
  final String jenis;
  final String hargasales;
  final String totalharga;
  final String hargadiskon;

  ListItem({
    this.nama,
    this.satuan,
    this.qty,
    this.code,
    this.jenis,
    this.image,
    this.price,
    this.berat,
    this.totalharga,
    this.hargasales,
    this.hargadiskon,
  });
}
