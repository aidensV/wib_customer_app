import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import 'listkabupaten.dart';
import 'listkecamatan.dart';
import 'listprovinsi.dart';
import '../tracking_list/tracking.dart';
import 'model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_image/network.dart';
import '../../dashboard.dart';

List<ListCheckout> listNota = [];
String tokenType,
    accessToken,
    checkboxnoongkir,
    checkboxongkirsaldo,
    checkboxbayartempo,
    checkboxtotalsaldo;
var _scaffoldKeyX;
Map<String, String> requestHeaders = Map();
bool isLoading;
bool isError;
bool isLogout;
Map<String, dynamic> formSerialize;
ListProvinsi selectedProvinsi;
ListKabupaten selectedKabupaten;
ListKecamatan selectedkecamatan;
String hargatotalX, idkabupatenX, namakabupatenX;

class Checkout extends StatefulWidget {
  Checkout({
    Key key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CheckoutState();
  }
}

class _CheckoutState extends State<Checkout> {
  final kodeposController = TextEditingController();
  final alamatController = TextEditingController();

  _CheckoutState({
    Key key,
  });

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  TextEditingController controllerfile = new TextEditingController();
  Future<void> getHeaderHTTP() async {
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

  void showInSnackBar(String value) {
    _scaffoldKeyX.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<List<ListCheckout>> listNotaAndroid() async {
    setState(() {
      isLoading = true;
    });
    try {
      final nota = await http.get(
        url('api/listCheckoutAndroid'),
        headers: requestHeaders,
      );

      if (nota.statusCode == 200) {
        // return nota;
        var notaJson = json.decode(nota.body);
        var notas = notaJson['item'];
        var totalharga = notaJson['totalharga'];
        var idprovinsi = notaJson['idprovinsi'].toString();
        var namaprovinsi = notaJson['namaprovinsi'];
        var idkabupaten = notaJson['idkabupaten'].toString();
        var namakabupaten = notaJson['namakabupaten'];
        var idkecamatan = notaJson['idkecamatan'].toString();
        var namakecamatan = notaJson['namakecamatan'];
        var kodeposcustomer = notaJson['kodepos'].toString();
        var alamatcustomer = notaJson['alamat'].toString();
        print('alamat $alamatcustomer');
        listNota = [];
        for (var i in notas) {
          ListCheckout notax = ListCheckout(
            id: '${i['cart_id']}',
            item: i['i_name'],
            code: i['i_code'],
            harga: i['ipr_sunitprice'],
            type: i['ity_name'],
            image: i['ip_path'],
            jumlah: i['cart_qty'].toString(),
            satuan: i['iu_name'],
            total: i['hasil'],
            gudang: i['cart_location'],
            diskon: i['gpp_sellprice'],
          );
          listNota.add(notax);
        }
        setState(() {
          idkabupatenX = idkabupaten;
          namakabupatenX = namakabupaten;
          hargatotalX = totalharga;
          kodeposController.text =
              kodeposcustomer == 'null' || kodeposcustomer == null
                  ? ''
                  : kodeposcustomer;
          alamatController.text =
              alamatcustomer == 'null' || kodeposcustomer == null
                  ? ''
                  : alamatcustomer;
          selectedProvinsi = ListProvinsi(
            id: idprovinsi,
            nama: namaprovinsi,
          );
          selectedKabupaten = ListKabupaten(
            id: idkabupaten,
            nama: namakabupaten,
          );
          selectedkecamatan =
              ListKecamatan(id: idkecamatan, nama: namakecamatan);
        });
        getOngkir();
        return listNota;
      } else if (nota.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = false;
          isLogout = true;
        });
      } else {
        showInSnackBar('Request failed with status: ${nota.statusCode}');
        print('${nota.body}');
        setState(() {
          isLoading = false;
          isError = true;
          isLogout = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      showInSnackBar('Timed out, Try again');
      setState(() {
        isLoading = false;
        isError = true;
        isLogout = false;
      });
    } catch (e) {
      debugPrint('$e');
      setState(() {
        isLoading = false;
        isError = true;
        isLogout = false;
      });
    }
    setState(() {
      isLoading = false;
      isError = true;
      isLogout = false;
    });
    return null;
  }

  Future<void> getOngkir() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    try {
      final response = await http.post(url('api/get_ongkir_android'),
          headers: requestHeaders, body: {'kota': idkabupatenX});

      if (response.statusCode == 200) {
        var ongkirJson = json.decode(response.body);
        String textongkir = ongkirJson['textongkir'].toString();
        String ongkirvalue = ongkirJson['total'].toString();
        String totalbelanjacustomer = ongkirJson['totalbelanja'].toString();
        print('stock $ongkirvalue');
        setState(() {
          isLoading = false;
          selectedKabupaten = ListKabupaten(
            id: idkabupatenX,
            nama: namakabupatenX,
            ongkir: ongkirvalue,
            textongkir: textongkir,
            totalbelanja: totalbelanjacustomer,
          );
        });
      } else if (response.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = false;
          isLogout = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          isLogout = false;
        });
        showInSnackBar('Request failed with status: ${response.body}');
        return null;
      }
      return "Success!";
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        isLogout = false;
      });
      print('Error : $e');
    }
  }

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    getHeaderHTTP();
    _scaffoldKeyX = new GlobalKey<ScaffoldState>();
    isLoading = true;
    isError = false;
    isLogout = false;
    checkboxnoongkir = 'aktif';
    checkboxongkirsaldo = 'aktif';
    checkboxtotalsaldo = 'aktif';
    checkboxbayartempo = 'aktif';
    idkabupatenX = null;
    namakabupatenX = null;
    selectedProvinsi = null;
    selectedKabupaten = null;
    selectedkecamatan = null;
    hargatotalX = '0';
    // hargabarang();
    print(requestHeaders);
    super.initState();
  }

  String idprovinsilist = '';
  bool _value1 = false;
  bool _bayartempo = false;
  bool _value2 = false;
  bool _bayarongkirsaldo = false;

  //we omitted the brackets '{}' and are using fat arrow '=>' instead, this is dart syntax

  @override
  Widget build(BuildContext context) {
    NumberFormat _numberFormat =
        new NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
    return Scaffold(
      key: _scaffoldKeyX,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff25282b),
        ),
        title: new Text(
          "Checkout",
          style: TextStyle(
            color: Color(0xff25282b),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : isLogout == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => listNotaAndroid(),
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
                        onRefresh: () => listNotaAndroid(),
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
                  : RefreshIndicator(
                      onRefresh: () => listNotaAndroid(),
                      child: ListView(
                        // padding: EdgeInsets.all(5.0),
                        // child: new Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0, left: 5.0),
                                  child: new Text(
                                    'Alamat Pengiriman',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.create, color: Colors.green),
                                    title: Text(_value2 == true
                                        ? "-"
                                        : selectedProvinsi == null
                                            ? 'Pilih Provinsi'
                                            : selectedProvinsi.nama),
                                    onTap: () {
                                      if (_value2 == true) {
                                        showInSnackBar(
                                            'Anda memilih opsi ambil barang ditempat');
                                      } else {
                                        _pilihprovinsi(context);
                                      }
                                    },
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.create, color: Colors.green),
                                    title: Text(_value2 == true
                                        ? "-"
                                        : selectedKabupaten != null
                                            ? selectedKabupaten.nama
                                            : 'Pilih Kabupaten'),
                                    onTap: () {
                                      if (_value2 == true) {
                                        showInSnackBar(
                                            'Anda memilih opsi ambil barang ditempat');
                                      } else if (selectedProvinsi == null) {
                                        showInSnackBar(
                                            'Silahkan pilih provinsi terlebih dahulu');
                                      } else {
                                        _pilihkabupaten(context);
                                      }
                                    },
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.create, color: Colors.green),
                                    title: Text(_value2 == true
                                        ? "-"
                                        : selectedkecamatan != null
                                            ? selectedkecamatan.nama
                                            : 'Pilih Kecamatan'),
                                    onTap: () {
                                      if (_value2 == true) {
                                        showInSnackBar(
                                            'Anda memilih opsi ambil barang ditempat');
                                      } else if (selectedKabupaten == null) {
                                        showInSnackBar(
                                            'Silahkan pilih kabupaten terlebih dahulu');
                                      } else {
                                        _pilihkecamatan(context);
                                      }
                                    },
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.create, color: Colors.green),
                                    title: TextField(
                                      controller: kodeposController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Nomor kode pos',
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.create, color: Colors.green),
                                    title: TextField(
                                      maxLines: 1,
                                      controller: alamatController,
                                      decoration: InputDecoration(
                                        labelText: 'Alamat lengkap pengiriman',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Text('Total Harga Semua Barang'),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                      hargatotalX == null
                                          ? 'Rp. 0'
                                          : 'Rp. ' + hargatotalX,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.green)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Text('Biaya Ongkir'),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                      _value2
                                          ? "Rp. 0.00"
                                          : selectedKabupaten != null
                                              ? selectedKabupaten
                                                              .textongkir ==
                                                          null ||
                                                      selectedKabupaten
                                                              .textongkir ==
                                                          '0' ||
                                                      selectedKabupaten
                                                              .textongkir ==
                                                          '0.00'
                                                  ? 'Rp. 0.00'
                                                  : 'Rp. ' +
                                                      selectedKabupaten
                                                          .textongkir
                                              : 'Rp. 0.00',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.green)),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Text('Total Belanja'),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                      _value2 == true
                                          ? 'Rp. ' + hargatotalX
                                          : selectedKabupaten == null
                                              ? 'Rp. ' + hargatotalX
                                              : selectedKabupaten
                                                              .totalbelanja ==
                                                          null ||
                                                      selectedKabupaten
                                                              .totalbelanja ==
                                                          '0.00' ||
                                                      selectedKabupaten
                                                              .totalbelanja ==
                                                          '0'
                                                  ? 'Rp. 0.00'
                                                  : 'Rp. ' +
                                                      selectedKabupaten
                                                          .totalbelanja,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.green)),
                                ),
                              ],
                            ),
                          ),
                          new CheckboxListTile(
                            value: _bayartempo,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: new Text('Pembayaran Tempo'),
                            onChanged: checkboxbayartempo == 'pasif'
                                ? null
                                : (value) {
                                    setState(() {
                                      _bayartempo = value;
                                      _value1 = value == true ? false : false;
                                      checkboxtotalsaldo =
                                          value == true ? 'pasif' : 'aktif';
                                    });
                                  },
                          ),
                          new CheckboxListTile(
                            value: _value1,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: new Text(
                                'Bayar total belanja pakai saldo WIB store'),
                            onChanged: checkboxtotalsaldo == 'pasif'
                                ? null
                                : (value) {
                                    setState(() {
                                      _value1 = value;
                                      _bayartempo =
                                          value == true ? false : false;
                                      _bayarongkirsaldo =
                                          value == true ? false : false;
                                      checkboxongkirsaldo =
                                          value == true ? 'pasif' : 'aktif';
                                      checkboxbayartempo =
                                          value == true ? 'pasif' : 'aktif';
                                    });
                                  },
                          ),
                          new CheckboxListTile(
                            value: _bayarongkirsaldo,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: new Text(
                                'Bayar ongkir menggunakan saldo WIB Store'),
                            onChanged: checkboxongkirsaldo == 'pasif'
                                ? null
                                : (value) {
                                    setState(() {
                                      _bayarongkirsaldo = value;
                                      _value2 = value == true ? false : false;
                                      _value1 = value == true ? false : false;
                                      checkboxnoongkir =
                                          value == true ? 'pasif' : 'aktif';
                                      checkboxtotalsaldo =
                                          value == true ? 'pasif' : 'aktif';
                                    });
                                  },
                          ),
                          new CheckboxListTile(
                            value: _value2,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: new Text('Ambil barang ditempat'),
                            onChanged: checkboxnoongkir == 'pasif'
                                ? null
                                : (value) {
                                    setState(() {
                                      _value2 = value;
                                      checkboxongkirsaldo =
                                          value == true ? 'pasif' : 'aktif';
                                      _bayarongkirsaldo =
                                          value == true ? false : false;
                                    });
                                  },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, left: 15.0),
                            child: new Text('Daftar barang checkout'),
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
                                      ? 2
                                      : 4.2,
                              children: listNota.map(
                                (item) {
                                  var children2 = <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 10,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Text("Total Harga :",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Text(
                                                    item.diskon == null
                                                        ? _numberFormat.format(
                                                            double.parse(item.harga.toString()) *
                                                                int.parse(item
                                                                    .jumlah
                                                                    .toString()))
                                                        : _numberFormat.format(
                                                            double.parse(item
                                                                    .diskon
                                                                    .toString()) *
                                                                int.parse(
                                                                    item.jumlah.toString())),
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                    )),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                        " | ${item.jumlah} Pcs ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 0.0, top: 0.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 20.0,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 5,
                                                child: new Image(
                                                  image:
                                                      new NetworkImageWithRetry(
                                                          item.image != null
                                                              ? urladmin(
                                                                  'storage/image/master/produk/${item.image}',
                                                                )
                                                              : url(
                                                                  'assets/img/noimage.jpg',
                                                                )),
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
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: Text(
                                                          '${item.item}',
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
                                                    item.diskon == null
                                                        ? Container(
                                                            height: 30.0,
                                                          )
                                                        : Container(
                                                            height: 30.0,
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    item.harga ==
                                                                            null
                                                                        ? 'Rp. 0.00'
                                                                        : _numberFormat.format(double.parse(item
                                                                            .harga)),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        decoration:
                                                                            TextDecoration.lineThrough)),
                                                              ],
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0.0,
                                                                    top: 10.0),
                                                          ),
                                                    item.diskon == null
                                                        ? Container(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    item.harga ==
                                                                            null
                                                                        ? 'Rp. 0.00'
                                                                        : _numberFormat.format(double.parse(item
                                                                            .harga)),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    )),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          0.0),
                                                                  child: Text(
                                                                      " / " +
                                                                          '${item.satuan}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0.0,
                                                                    top: 10.0),
                                                          )
                                                        : Container(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    item.diskon ==
                                                                            null
                                                                        ? 'Rp. 0.00'
                                                                        : _numberFormat.format(double.parse(item
                                                                            .diskon)),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black)),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          0.0),
                                                                  child: Text(
                                                                      " / " +
                                                                          '${item.satuan}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0.0,
                                                                    top: 10.0),
                                                          ),
                                                    Container(
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
                                    Divider(),
                                  ];
                                  return Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.transparent),
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
                      // ),
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
                    if (_value2 == false) {
                      if (selectedProvinsi == null) {
                        showInSnackBar(
                            'Silahkan pilih provinsi terlebih dahulu');
                      } else if (selectedKabupaten == null) {
                        showInSnackBar(
                            'Silahkan pilih kabupaten/kota terlebih dahulu');
                      } else if (selectedkecamatan == null) {
                        showInSnackBar(
                            'Silahkan pilih kecamatan terlebih dahulu');
                      } else if (kodeposController.text.length == 0 ||
                          kodeposController.text == null) {
                        showInSnackBar(
                            'Silahkan masukkan kodepos terlebih dahulu');
                      } else if (alamatController.text.length == 0 ||
                          alamatController.text == null) {
                        showInSnackBar(
                            'Silahkan masukkan alamat lengkap terlebih dahulu');
                      } else {
                        showInSnackBar(
                            'Sedang memproses permintaan anda, mohon tunggu sebentar');
                        _checkoutSekarang();
                      }
                    } else {
                      showInSnackBar(
                          'Sedang memproses permintaan anda, mohon tunggu sebentar');
                      _checkoutSekarang();
                    }
                  },
                  child: Text(
                    "Checkout Sekarang",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void _pilihprovinsi(BuildContext context) async {
    final ListProvinsi provinsi = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProvinsiSending(),
        ));
    setState(() {
      selectedProvinsi = provinsi;
      selectedKabupaten = null;
    });
  }

  void _checkoutSekarang() async {
    formSerialize = Map<String, dynamic>();
    formSerialize['provinsi'] = null;
    formSerialize['kota'] = null;
    formSerialize['kecamatan'] = null;
    formSerialize['tunai'] = null;
    formSerialize['accongkir'] = null;
    formSerialize['ongkir'] = null;
    formSerialize['kodepos'] = null;
    formSerialize['alamat'] = null;
    formSerialize['paydeliver'] = null;
    formSerialize['tempo'] = null;
    formSerialize['gudang'] = List();
    formSerialize['id'] = List();
    formSerialize['namabarang'] = List();
    formSerialize['ciproduct'] = List();
    formSerialize['qty'] = List();
    formSerialize['disc'] = List();
    formSerialize['discv'] = List();
    formSerialize['hargabarang'] = List();

    formSerialize['provinsi'] = _value2 == true ? "0" : selectedProvinsi.id;
    formSerialize['kota'] = _value2 == true ? "0" : selectedKabupaten.id;
    formSerialize['kecamatan'] = _value2 == true ? "0" : selectedkecamatan.id;
    formSerialize['tunai'] = _value1 == true ? 'Y' : 'N';
    formSerialize['paydeliver'] = _bayarongkirsaldo == true ? 'Y' : 'N';
    formSerialize['accongkir'] = _value2 == true ? 'Y' : 'N';
    formSerialize['ongkir'] = _value2 == true ? 0 : selectedKabupaten.ongkir;
    formSerialize['kodepos'] = _value2 == true ? '-' : kodeposController.text;
    formSerialize['alamat'] = _value2 == true ? '-' : alamatController.text;
    formSerialize['tempo'] = _bayartempo == true ? 'Y' : 'N';
    for (int i = 0; i < listNota.length; i++) {
      formSerialize['id'].add(listNota[i].id);
      formSerialize['namabarang'].add(listNota[i].item);
      formSerialize['ciproduct'].add(listNota[i].code);
      formSerialize['qty'].add(listNota[i].jumlah);
      formSerialize['disc'].add(0);
      formSerialize['discv'].add(listNota[i].diskon == null
          ? 0
          : (double.parse(listNota[i].harga) -
                  double.parse(listNota[i].diskon)) *
              int.parse(listNota[i].jumlah));
      formSerialize['hargabarang'].add(listNota[i].harga);
      formSerialize['gudang'].add(listNota[i].gudang);
    }

    print(formSerialize);

    Map<String, dynamic> requestHeadersX = requestHeaders;

    requestHeadersX['Content-Type'] = "application/x-www-form-urlencoded";
    try {
      final response = await http.post(
        url('api/checkout_android'),
        headers: requestHeadersX,
        body: {
          'type_platform': 'android',
          'data': jsonEncode(formSerialize),
        },
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        if (responseJson['status'] == 'success') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => TrackingList()));
        } else if (responseJson['status'] == 'erorstock') {
          showInSnackBar('Eror Stock, ${responseJson['error']}');
        } else if (responseJson['status'] == 'saldokurang') {
          showInSnackBar('Saldo anda tidak mencukupi');
        } else if (responseJson['error'] == 'Saldo Anda Tidak Cukup') {
          showInSnackBar('Saldo anda tidak mencukupi');
        } else if (responseJson['status'] == 'kosong') {
          showInSnackBar('Anda tidak memiliki item untuk checkout');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardPage()));
        }
        print('response decoded $responseJson');
      } else {
        print('${response.body}');
        showInSnackBar('Request failed with status: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      showInSnackBar('Timed out, Try again');
    } catch (e) {
      print(e);
    }
  }

  void _pilihkabupaten(BuildContext context) async {
    final ListKabupaten kabupaten = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KabupatenSending(provinsi: selectedProvinsi),
        ));
    setState(() {
      selectedKabupaten = kabupaten;
      selectedkecamatan = null;
    });
  }

  void _pilihkecamatan(BuildContext context) async {
    final ListKecamatan kecamatan = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                KecamatanSending(kabupaten: selectedKabupaten)));
    setState(() {
      selectedkecamatan = kecamatan;
    });
  }
}
