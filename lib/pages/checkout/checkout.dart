import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import '../../utils/Navigator.dart';
import 'listkabupaten.dart';
import 'listkecamatan.dart';
import 'listprovinsi.dart';
import 'model.dart';

List<ListCheckout> listNota = [];
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
bool isLoading;
Map<String, dynamic> formSerialize;
ListProvinsi selectedProvinsi;
ListKabupaten selectedKabupaten;
ListKecamatan selectedkecamatan;


class Checkout extends StatefulWidget {
  final String totalharga;
  Checkout({
    Key key,  this.totalharga,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CheckoutState(
      totalharga : totalharga,
      
    );
  }
}

class _CheckoutState extends State<Checkout> {
  final kodeposController = TextEditingController();
  final alamatController = TextEditingController();
  final String totalharga;
  _CheckoutState({
    Key key,
    @required this.totalharga,
    
  });
  

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  TextEditingController controllerfile = new TextEditingController();
  Future<List<ListCheckout>> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print(requestHeaders);

    listNotaAndroid();
  }

  GlobalKey<ScaffoldState> _scaffoldKeyX = new GlobalKey<ScaffoldState>();

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
        

        print('notaJson $notaJson');
        

        listNota = [];
        for (var i in notas) {
          ListCheckout notax = ListCheckout(
            id: '${i['cart_id']}',
            item: i['i_name'],
            harga: i['ipr_sunitprice'],
            type: i['ity_name'],
            image: i['ip_path'],
            jumlah: i['cart_qty'].toString(),
            satuan: i['iu_name'],
            total: i['hasil'],
            gudang: i['cart_location'],
          );
          listNota.add(notax);
        }

        print('listnota $listNota');
        print('listnota length ${listNota.length}');
        setState(() {
          isLoading = false;
        });
        return listNota;
      } else {
        showInSnackBar('Request failed with status: ${nota.statusCode}');
        setState(() {
          isLoading = false;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      showInSnackBar('Timed out, Try again');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('$e');
      setState(() {
        isLoading = false;
      });
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

  @override
  void initState() {
    getHeaderHTTP();
    isLoading = false;
    selectedProvinsi = null;
    selectedKabupaten = null;
    selectedkecamatan = null;

    print(requestHeaders);
    super.initState();
  }

  void _showMaterialDialogKabupaten() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Silahkan pilih provinsi terlebih dahulu'),
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
  void _showMaterialItemNull() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Anda tidak memiliki barang untuk dicheckout'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    MyNavigator.goToDashboard(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  void _showMaterialDialogKabupatenNull() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Silahkan pilih kabupaten terlebih dahulu'),
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

  void _showMaterialDialogKodeposNull() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Silahkan isi kodepos terlebih dahulu'),
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

  void _showMaterialDialogAlamatNull() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Silahkan isi alamat lengkap terlebih dahulu'),
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

  void _showMaterialDialogKecamatanNull() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Silahkan pilih kecamatan terlebih dahulu'),
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

  void _showMaterialDialogAmbilBarang() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Anda memilih opsi ambil barang ditempat'),
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

  String idprovinsilist = '';
  bool _value1 = false;
  bool _value2 = false;

  //we omitted the brackets '{}' and are using fat arrow '=>' instead, this is dart syntax
  void _value1Changed(bool value) => setState(() => _value1 = value);
  void _value2Changed(bool value) => setState(
        () => _value2 = value,
      );

  void _showMaterialDialogKecamatan() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content:
                Text('Silahkan pilih provinsi dan kabupaten terlebih dahulu'),
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
      body: ListView(
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
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0),
                  child: new Text(
                    'Alamat Pengiriman',
                    textAlign: TextAlign.left,
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.create, color: Colors.green),
                    title: Text(_value2 == true
                        ? "-"
                        : selectedProvinsi == null
                            ? 'Pilih Provinsi'
                            : selectedProvinsi.nama),
                    onTap: () {
                      if (_value2 == true) {
                        _showMaterialDialogAmbilBarang();
                      } else {
                        _pilihprovinsi(context);
                      }
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.create, color: Colors.green),
                    title: Text(_value2 == true
                        ? "-"
                        : selectedKabupaten != null
                            ? selectedKabupaten.nama
                            : 'Pilih Kabupaten'),
                    onTap: () {
                      if (_value2 == true) {
                        _showMaterialDialogAmbilBarang();
                      } else if (selectedProvinsi == null) {
                        _showMaterialDialogKabupaten();
                      } else {
                        _pilihkabupaten(context);
                      }
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.create, color: Colors.green),
                    title: Text(_value2 == true
                        ? "-"
                        : selectedkecamatan != null
                            ? selectedkecamatan.nama
                            : 'Pilih Kecamatan'),
                    onTap: () {
                      if (_value2 == true) {
                        _showMaterialDialogAmbilBarang();
                      } else if (selectedKabupaten == null) {
                        _showMaterialDialogKecamatan();
                      } else {
                        _pilihkecamatan(context);
                      }
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.create, color: Colors.green),
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
                    leading: Icon(Icons.create, color: Colors.green),
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
                  child: Text("Rp." + totalharga,
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
                              ? 'Rp. ' + selectedKabupaten.textongkir
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
                  child: Text(_value2 == true ? 'Rp. ' + totalharga : selectedKabupaten == null ? totalharga : 'Rp. ' + selectedKabupaten.totalbelanja,
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
          new CheckboxListTile(
            value: _value1,
            controlAffinity: ListTileControlAffinity.leading,
            title: new Text('Bayar pakai saldo WIB store'),
            onChanged: _value1Changed,
          ),
          new CheckboxListTile(
            value: _value2,
            controlAffinity: ListTileControlAffinity.leading,
            title: new Text('Ambil barang ditempat'),
            onChanged: _value2Changed,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 15.0),
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
              childAspectRatio: 2,
              children: listNota
                  .map(
                    (item) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                      ),
                      // padding: const EdgeInsets.all(10.0),
                      // margin: EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 0.0,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text("Total Harga :",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text("Rp. " + '${item.total}',
                                            style: TextStyle(
                                              color: Colors.green,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
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
                                                const EdgeInsets.only(top: 0.0),
                                            child: Text(
                                              '${item.item}',
                                              style: TextStyle(
                                                  color: Color(0xff25282b),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text("Rp. " + '${item.harga}',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0.0),
                                                child: Text(
                                                    " / " + '${item.satuan}',
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
                                              Text("Jumlah : ${item.jumlah} ",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 0.0, top: 10.0),
                                        ),
                                        Container(
                                          height: 40.0,
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
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
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
                        _showMaterialDialogKabupaten();
                        return false;
                      } else if (selectedKabupaten == null) {
                        _showMaterialDialogKabupatenNull();
                        return false;
                      } else if (selectedkecamatan == null) {
                        _showMaterialDialogKecamatanNull();
                        return false;
                      } else if (kodeposController.text.length == 0 ||
                          kodeposController.text == null) {
                        _showMaterialDialogKodeposNull();
                        return false;
                      } else if (alamatController.text.length == 0 ||
                          alamatController.text == null) {
                        _showMaterialDialogAlamatNull();
                        return false;
                      }else{
                        _checkoutSekarang();
                      }
                    } else {  
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
    formSerialize['gudang'] = List();
    formSerialize['id'] = List();
    formSerialize['ciproduct'] = List();
    formSerialize['qty'] = List();
    formSerialize['disc'] = List();
    formSerialize['discv'] = List();
    formSerialize['hargabarang'] = List();

    formSerialize['provinsi'] = _value2 == true ? "0" : selectedProvinsi.id;
    formSerialize['kota'] = _value2 == true ? "0" : selectedKabupaten.id;
    formSerialize['kecamatan'] = _value2 == true ? "0" : selectedkecamatan.id;
    formSerialize['tunai'] = _value1 == true ? 'Y' : 'N';
    formSerialize['accongkir'] = _value2 == true ? 'Y' : 'N';
    formSerialize['ongkir'] = _value2 == true ? 0 : selectedKabupaten.ongkir;
    formSerialize['kodepos'] = _value2 == true ? '-' : kodeposController.text;
    formSerialize['alamat'] = _value2 == true ? '-' : alamatController.text;
    for (int i = 0; i < listNota.length; i++) {
      formSerialize['id'].add(listNota[i].id);
      formSerialize['ciproduct'].add(listNota[i].item);
      formSerialize['qty'].add(listNota[i].jumlah);
      formSerialize['disc'].add(0);
      formSerialize['discv'].add(0);
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
          Navigator.pushNamed(context, "/tracking_list");
        } else if (responseJson['status'] == 'saldokurang') {
          showInSnackBar('Saldo anda tidak mencukupi');
        }else if(responseJson['status'] == 'kosong'){
          _showMaterialItemNull();
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
