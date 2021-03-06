import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/storage/storage.dart';

var idX, notaX, customerX, statusX;
GlobalKey<ScaffoldState> _scaffolddetailprocess;
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
bool loadingaddcart;

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
    _scaffolddetailprocess.currentState
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
        listItem = [];
        for (var i in itemJson['item']) {
          ListItem notax = ListItem(
              nama: i['i_name'],
              satuan: i['iu_name'],
              qty: '${i['sd_qty'].toString()}',
              hargasales: i['sd_price'],
              jenis: i['ity_name'],
              totalharga: i['sd_total'],
              price: i['ipr_sunitprice'],
              image: i['ip_path'],
              code: i['i_code'],
              berat: i['itp_weight'].toString(),
              hargadiskonpercent: i['sd_discpercent'].toString(),
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
        print(item.body);
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

  @override
  void initState() {
    listItem = [];
    isLoading = true;
    isError = false;
    loadingaddcart = false;
    idX = id;
    notaX = nota;
    customerX = customer;
    statusX = status;
    _scaffolddetailprocess = new GlobalKey<ScaffoldState>();
    ongkirX = null;
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
      key: _scaffolddetailprocess,
      backgroundColor: Colors.white,
      appBar: AppBar(
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Detail Transaksi'),
        backgroundColor: Color(0xff31B057),
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
                              : 'Total Harga Barang : Rp. $totalhargasemuabarangX '),
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
                      Container(
                        margin: EdgeInsets.only(
                          top: 0.0,
                          bottom: 30.0,
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: listItem
                              .map((ListItem item) => Container(
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
                                                              color: Colors
                                                                  .black)),
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
                                                          setState(() {
                                                            loadingaddcart =
                                                                true;
                                                          });
                                                          if (stockiesX ==
                                                                  null ||
                                                              stockiesX ==
                                                                  'null' ||
                                                              stockiesX == '') {
                                                            showInSnackBar(
                                                                'Silahkan setting alamat dulu pada pengaturan akun');
                                                            setState(() {
                                                              loadingaddcart =
                                                                  false;
                                                            });
                                                          } else if (stockiesX ==
                                                              'Tidak Ada Cabang Terdekat') {
                                                            showInSnackBar(
                                                                'Silahkan ubah alamat anda sesuai stockies yang ada pada cabang warung botol');
                                                            setState(() {
                                                              loadingaddcart =
                                                                  false;
                                                            });
                                                          } else {
                                                            try {
                                                              final adcart =
                                                                  await http.post(
                                                                      url(
                                                                          'api/addCartAndroid'),
                                                                      headers:
                                                                          requestHeaders,
                                                                      body: {
                                                                    'code': item
                                                                        .code,
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
                                                                  setState(() {
                                                                    loadingaddcart =
                                                                        false;
                                                                  });
                                                                } else if (addcartJson[
                                                                        'status'] ==
                                                                    'minbeli') {
                                                                  showInSnackBar(
                                                                      '${addcartJson['minbuy']}');
                                                                  setState(() {
                                                                    loadingaddcart =
                                                                        false;
                                                                  });
                                                                } else if (addcartJson[
                                                                        'status'] ==
                                                                    'stockkurangminbeli') {
                                                                  showInSnackBar(
                                                                      '${addcartJson['message']}');
                                                                  setState(() {
                                                                    loadingaddcart =
                                                                        false;
                                                                  });
                                                                } else if (addcartJson[
                                                                        'status'] ==
                                                                    'maxstock') {
                                                                  showInSnackBar(
                                                                      '${addcartJson['messagestock']}');
                                                                  setState(() {
                                                                    loadingaddcart =
                                                                        false;
                                                                  });
                                                                } else if (addcartJson[
                                                                        'error'] ==
                                                                    'error') {
                                                                  showInSnackBar(
                                                                      '${item.nama} sudah ada dikeranjang');
                                                                  setState(() {
                                                                    loadingaddcart =
                                                                        false;
                                                                  });
                                                                } else if (addcartJson[
                                                                        'error'] ==
                                                                    'Berat Barang Belum Di Set') {
                                                                  showInSnackBar(
                                                                      'Mohon Maaf, berat barang belum disetting');
                                                                  setState(() {
                                                                    loadingaddcart =
                                                                        false;
                                                                  });
                                                                }
                                                              } else {
                                                                print(
                                                                    '${adcart.body}');
                                                                setState(() {
                                                                  loadingaddcart =
                                                                      false;
                                                                });
                                                              }
                                                            } on TimeoutException catch (_) {} catch (e) {
                                                              print(e);
                                                              setState(() {
                                                                loadingaddcart =
                                                                    false;
                                                              });
                                                            }
                                                          }
                                                        },
                                                        child: new Text(
                                                          loadingaddcart == true
                                                              ? 'Loading...'
                                                              : 'Beli Lagi',
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
                                        Container(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 4,
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'images/noimage.jpg',
                                                  image: item.image != null
                                                      ? urladmin(
                                                          'storage/image/master/produkthumbnail/${item.image}',
                                                        )
                                                      : url(
                                                          'assets/img/noimage.jpg',
                                                        ),
                                                  width: 80.0,
                                                  height: 80.0,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
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
                                                      child: Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                'Harga : ',
                                                                style:
                                                                    TextStyle()),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                item.hargasales == null ||
                                                                        item.hargasales ==
                                                                            'null' ||
                                                                        item.hargasales ==
                                                                            '0' ||
                                                                        item.hargasales ==
                                                                            '0.00' ||
                                                                        item.hargasales ==
                                                                            ''
                                                                    ? '0.00'
                                                                    : _numberFormat.format(double.parse(item
                                                                        .hargasales
                                                                        .toString())),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .deepOrange,
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                item.satuan ==
                                                                            null ||
                                                                        item.satuan ==
                                                                            ''
                                                                    ? ' / Satuan'
                                                                    : ' / ' +
                                                                        item
                                                                            .satuan,
                                                                style:
                                                                    TextStyle(
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                'Jumlah : ',
                                                                style:
                                                                    TextStyle()),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                                item.qty == null ||
                                                                        item.qty ==
                                                                            'null' ||
                                                                        item.qty ==
                                                                            '0' ||
                                                                        item.qty ==
                                                                            '0.00' ||
                                                                        item.qty ==
                                                                            ''
                                                                    ? '0.00'
                                                                    : item.qty,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .deepOrange,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 0.0, top: 10.0),
                                                    ),
                                                    item.hargadiskon == null ||
                                                            item.hargadiskon ==
                                                                'null' ||
                                                            item.hargadiskon ==
                                                                '' ||
                                                            item.hargadiskon ==
                                                                '0.00' ||
                                                            item.hargadiskon ==
                                                                '0'
                                                        ? item.hargadiskonpercent ==
                                                                    null ||
                                                                item.hargadiskonpercent ==
                                                                    'null' ||
                                                                item.hargadiskonpercent ==
                                                                    '' ||
                                                                item.hargadiskonpercent ==
                                                                    '0.00' ||
                                                                item.hargadiskonpercent ==
                                                                    '0'
                                                            ? Container(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              0.0),
                                                                      child: Text(
                                                                          'Diskon : ',
                                                                          style:
                                                                              TextStyle()),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              0.0),
                                                                      child: Text(
                                                                          'Rp. 0.00',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.deepOrange,
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            0.0,
                                                                        top:
                                                                            10.0),
                                                              )
                                                            : Container(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              0.0),
                                                                      child: Text(
                                                                          'Diskon : ',
                                                                          style:
                                                                              TextStyle()),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              0.0),
                                                                      child: Text(
                                                                          _numberFormat.format((double.parse(item.hargasales.toString()) *
                                                                              int.parse(item.qty.toString()) *
                                                                              int.parse(item.hargadiskonpercent) /
                                                                              100)),
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.deepOrange,
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            0.0,
                                                                        top:
                                                                            10.0),
                                                              )
                                                        : Container(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          0.0),
                                                                  child: Text(
                                                                      'Diskon : ',
                                                                      style:
                                                                          TextStyle()),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          0.0),
                                                                  child: Text(
                                                                      _numberFormat.format(double.parse(item
                                                                          .hargadiskon
                                                                          .toString())),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.deepOrange)),
                                                                )
                                                              ],
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0.0,
                                                                    top: 10.0),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 30.0,
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
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
  final String jenis;
  final String berat;
  final String hargasales;
  final String totalharga;
  final String hargadiskon;
  String hargadiskonpercent;

  ListItem({
    this.nama,
    this.satuan,
    this.qty,
    this.code,
    this.image,
    this.price,
    this.berat,
    this.jenis,
    this.totalharga,
    this.hargasales,
    this.hargadiskonpercent,
    this.hargadiskon,
  });
}
