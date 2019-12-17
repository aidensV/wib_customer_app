import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/pages/checkout/checkout.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_image/network.dart';

GlobalKey<ScaffoldState> _scaffoldKeyCart;
List<ListKeranjang> listNota = [];
String tokenType, accessToken, totalhargaX;
bool isLoading;
bool isLogout;
bool isError;
bool loadingtocheckout;
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
  TextEditingController qtyinput = new TextEditingController();
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
    _scaffoldKeyCart.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<void> totalhargaget() async {
    try {
      final nota = await http.get(
        url('api/listKeranjangAndroid'),
        headers: requestHeaders,
      );

      if (nota.statusCode == 200) {
        // return nota;
        var notaJson = json.decode(nota.body);
        var totalharga = notaJson['totalharga'];
        setState(() {
          totalhargaX = totalharga;
        });
        print('listnota $listNota');
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
        var totalharga = notaJson['totalharga'];
        print('totalharga $totalharga');
        print('notaJson $notaJson');

        listNota = [];
        for (var i in notas) {
          ListKeranjang notax = ListKeranjang(
            id: '${i['cart_id']}',
            item: i['i_name'],
            harga: i['ipr_sunitprice'],
            codeproduk: i['cart_ciproduct'].toString(),
            type: i['ity_name'],
            image: i['ip_path'],
            jumlah: i['cart_qty'].toString(),
            satuan: i['iu_name'],
            total: i['hasil'].toString(),
            hargadiskon: i['gpp_sellprice'],
            qtyinput: TextEditingController(text: i['cart_qty'].toString()),
          );
          listNota.add(notax);
        }
        setState(() {
          isLoading = false;
          isLogout = false;
          isError = false;
          totalhargaX = totalharga;
        });
        return listNota;
      }else if(nota.statusCode == 401){
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
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
          isLoading = false;
          isLogout = false;
          isError = true;
        });
      showInSnackBar('Timed out, Try again');
    } catch (e) {
      setState(() {
          isLoading = false;
          isLogout = false;
          isError = true;
        });
      debugPrint('$e');
    }
    return null;
  }

  @override
  void initState() {
    _scaffoldKeyCart = new GlobalKey<ScaffoldState>();
    getHeaderHTTP();
    totalhargaX = null;
    isLoading = true;
    isLogout = false;
    loadingtocheckout = false;
    isError = false;
    print(requestHeaders);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyCart,
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
                                qtyinput.text = listNota[index].jumlah;
                                double hargaperitem =
                                    double.parse(listNota[index].harga);
                                NumberFormat _numberFormat =
                                    new NumberFormat.simpleCurrency(
                                        decimalDigits: 2, name: 'Rp. ');
                                String finalhargaperitem =
                                    _numberFormat.format(hargaperitem);
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
                                                listNota[index].hargadiskon ==
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: Text(
                                                            listNota[index]
                                                                        .harga ==
                                                                    null
                                                                ? 'Rp. 0.00'
                                                                : _numberFormat.format(double.parse(listNota[
                                                                            index]
                                                                        .harga
                                                                        .toString()) *
                                                                    int.parse(listNota[
                                                                            index]
                                                                        .jumlah
                                                                        .toString())),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                            )),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: Text(
                                                            listNota[index]
                                                                        .hargadiskon ==
                                                                    null
                                                                ? 'Rp. 0.00'
                                                                : _numberFormat.format(double.parse(listNota[
                                                                            index]
                                                                        .hargadiskon
                                                                        .toString()) *
                                                                    int.parse(listNota[
                                                                            index]
                                                                        .jumlah
                                                                        .toString())),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 5,
                                              child: new FadeInImage.assetNetwork(
                                              placeholder: 'images/noimage.jpg',
                                              image:
                                                  listNota[index].image != null
                                                      ? urladmin(
                                                          'storage/image/master/produkthumbnailthumbnail/${listNota[index].image}',
                                                        )
                                                      : url(
                                                          'assets/img/noimage.jpg',
                                                        ),
                                              width: 100.0,
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
                                                              top: 10.0,
                                                              bottom: 10.0),
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
                                                  listNota[index].hargadiskon ==
                                                          null
                                                      ? Container(
                                                          height: 30.0,
                                                        )
                                                      : Container(
                                                          height: 30.0,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  listNota[index]
                                                                              .harga ==
                                                                          null
                                                                      ? 'Rp. 0.00'
                                                                      : finalhargaperitem,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough)),
                                                            ],
                                                          ),
                                                        ),
                                                  listNota[index].hargadiskon ==
                                                          null
                                                      ? Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  listNota[index]
                                                                              .harga ==
                                                                          null
                                                                      ? 'Rp. 0.00'
                                                                      : finalhargaperitem,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            0.0),
                                                                child: Text(
                                                                    " / " +
                                                                        listNota[index]
                                                                            .satuan,
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
                                                            children: <Widget>[
                                                              Text(
                                                                  listNota[index]
                                                                              .hargadiskon ==
                                                                          null
                                                                      ? 'Rp. 0.00'
                                                                      : _numberFormat.format(double.parse(listNota[
                                                                              index]
                                                                          .hargadiskon
                                                                          .toString())),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            0.0),
                                                                child: Text(
                                                                    " / " +
                                                                        listNota[index]
                                                                            .satuan,
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 2,
                                                          child: ButtonTheme(
                                                              minWidth: 0,
                                                              buttonColor: Color(
                                                                  0xff388bf2),
                                                              child: FlatButton(
                                                                child: Icon(
                                                                    Icons
                                                                        .remove_circle,
                                                                    color: Colors
                                                                        .green),
                                                                color: Colors
                                                                    .white,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                  0.0,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  var idX =
                                                                      listNota[
                                                                              index]
                                                                          .id;
                                                                  try {
                                                                    final kurangqty = await http.post(
                                                                        url('api/reduceQtyKeranjangAndroid'),
                                                                        headers: requestHeaders,
                                                                        body: {
                                                                          'id_keranjang':
                                                                              idX,
                                                                          'code_produk' : listNota[index].codeproduk,
                                                                        });

                                                                    if (kurangqty
                                                                            .statusCode ==
                                                                        200) {
                                                                      var kurangqtyJson =
                                                                          json.decode(
                                                                              kurangqty.body);
                                                                      if (kurangqtyJson[
                                                                              'status'] ==
                                                                          'success') {
                                                                          
                                                                          setState(
                                                                              () {
                                                                            listNota[index].jumlah = "${kurangqtyJson['qtysuccess']}";
                                                                            listNota[index].qtyinput.text ="${kurangqtyJson['qtysuccess']}";
                                                                          });

                                                                          totalhargaget();
                                                                        
                                                                      }else if(kurangqtyJson['status'] == 'stockkurangminbeli'){
                                                                        showInSnackBar('${kurangqtyJson['message']}');
                                                                        setState(
                                                                              () {
                                                                            listNota[index].jumlah = "${kurangqtyJson['stockkrgminbeliqty']}";
                                                                            listNota[index].qtyinput.text ="${kurangqtyJson['stockkrgminbeliqty']}";
                                                                          });

                                                                          totalhargaget();

                                                                      }else if(kurangqtyJson['status'] == 'minbeli'){
                                                                        showInSnackBar('${kurangqtyJson['messageminbeli']}');
                                                                        setState(
                                                                              () {
                                                                            listNota[index].jumlah = "${kurangqtyJson['minbeliqty']}";
                                                                            listNota[index].qtyinput.text ="${kurangqtyJson['minbeliqty']}";
                                                                          });
                                                                          totalhargaget();
                                                                      }else if(kurangqtyJson['status'] == 'maxstock'){
                                                                        showInSnackBar('${kurangqtyJson['messagestock']}');
                                                                        setState(
                                                                              () {
                                                                            listNota[index].jumlah = "${kurangqtyJson['stockqty']}";
                                                                            listNota[index].qtyinput.text ="${kurangqtyJson['stockqty']}";
                                                                          });
                                                                          totalhargaget();

                                                                      } else if (kurangqtyJson[
                                                                              'status'] ==
                                                                          'Error') {
                                                                        showInSnackBar(
                                                                            'Gagal! Hubungi pengembang software!');
                                                                      }
                                                                    } else {
                                                                      showInSnackBar(
                                                                          'Request failed with status: ${kurangqty.statusCode}');
                                                                        print('${kurangqty.body}');
                                                                    }
                                                                  } on TimeoutException catch (_) {
                                                                    showInSnackBar(
                                                                        'Timed out, Try again');
                                                                  } catch (e) {
                                                                    print(e);
                                                                  }
                                                                },
                                                              )),
                                                        ),
                                                        Expanded(
                                                          flex: 6,
                                                          child: TextField(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  listNota[
                                                                          index]
                                                                      .qtyinput,
                                                              decoration:
                                                                  InputDecoration(),
                                                              onChanged:
                                                                  (text) async {
                                                                var idX =
                                                                    listNota[
                                                                            index]
                                                                        .id;
                                                                var jumlah = text
                                                                            .length ==
                                                                        0
                                                                    ? '1'
                                                                    : int.parse(text) <=
                                                                            1
                                                                        ? '1'
                                                                        : text;
                                                                try {
                                                                  final tambahqty =
                                                                      await http.post(
                                                                          url('api/updateQtyKeranjangAndroid'),
                                                                          headers: requestHeaders,
                                                                          body: {
                                                                        'produk':
                                                                            idX,
                                                                        'qtyupdate':
                                                                            jumlah,
                                                                          'code_produk' : listNota[index].codeproduk,
                                                                      });
                                                                  if (tambahqty
                                                                          .statusCode ==
                                                                      200) {
                                                                    var tambahqtyJson =
                                                                        json.decode(
                                                                            tambahqty.body);
                                                                    if (tambahqtyJson[
                                                                            'status'] ==
                                                                        'success') {
                                                                      totalhargaget();
                                                                      setState(
                                                                          () {
                                                                        listNota[index].jumlah =
                                                                            jumlah;
                                                                        
                                                                      });
                                                                      
                                                                    } else if (tambahqtyJson[
                                                                            'status'] ==
                                                                        'stockkurangminbeli') {
                                                                      totalhargaget();
                                                                      showInSnackBar(
                                                                          '${tambahqtyJson['message']}');
                                                                      setState(
                                                                          () {
                                                                        listNota[index]
                                                                            .qtyinput
                                                                            .text = "${tambahqtyJson['stockkrgminbeliqty']}";
                                                                        listNota[index].jumlah =
                                                                            '${tambahqtyJson['stockkrgminbeliqty']}';
                                                                      });
                                                                    } else if (tambahqtyJson[
                                                                            'status'] ==
                                                                        'minbeli') {
                                                                      totalhargaget();
                                                                      showInSnackBar(
                                                                          '${tambahqtyJson['minbeliqty']}');
                                                                          setState(
                                                                          () {
                                                                        listNota[index]
                                                                            .qtyinput
                                                                            .text = "${tambahqtyJson['qty']}";
                                                                        listNota[index].jumlah =
                                                                            '${tambahqtyJson['qty']}';
                                                                      });
                                                                    }else if(tambahqtyJson['status'] == 'maximalstock'){
                                                                      totalhargaget();
                                                                      showInSnackBar(
                                                                          '${tambahqtyJson['messagestock']}');
                                                                          setState(
                                                                          () {
                                                                        listNota[index]
                                                                            .qtyinput
                                                                            .text = "${tambahqtyJson['qtymaxstock']}";
                                                                        listNota[index].jumlah =
                                                                            '${tambahqtyJson['qtymaxstock']}';
                                                                      });
                                                                    }
                                                                  } else {
                                                                    showInSnackBar(
                                                                        'Request failed with status: ${tambahqty.statusCode}');
                                                                    print(tambahqty
                                                                        .body);
                                                                  }
                                                                } on TimeoutException catch (_) {
                                                                  showInSnackBar(
                                                                      'Timed out, Try again');
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              }),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: ButtonTheme(
                                                            minWidth: 0,
                                                            buttonColor: Color(
                                                                0xff388bf2),
                                                            child: FlatButton(
                                                              child: Icon(
                                                                  Icons
                                                                      .add_circle,
                                                                  color: Colors
                                                                      .green),
                                                              color:
                                                                  Colors.white,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                0.0,
                                                              ),
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
                                                                              idX,
                                                                          'code_produk' : listNota[index].codeproduk,
                                                                      });

                                                                  if (tambahqty
                                                                          .statusCode ==
                                                                      200) {
                                                                    var tambahqtyJson =
                                                                        json.decode(
                                                                            tambahqty.body);
                                                                    if (tambahqtyJson[
                                                                              'status'] ==
                                                                          'success') {
                                                                          
                                                                          setState(
                                                                              () {
                                                                            listNota[index].jumlah = "${tambahqtyJson['qtysuccess']}";
                                                                            listNota[index].qtyinput.text ="${tambahqtyJson['qtysuccess']}";
                                                                          });

                                                                          totalhargaget();
                                                                        
                                                                      }else if(tambahqtyJson['status'] == 'stockkurangminbeli'){
                                                                        showInSnackBar('${tambahqtyJson['message']}');
                                                                        setState(
                                                                              () {
                                                                            listNota[index].jumlah = "${tambahqtyJson['stockkrgminbeliqty']}";
                                                                            listNota[index].qtyinput.text ="${tambahqtyJson['stockkrgminbeliqty']}";
                                                                          });

                                                                          totalhargaget();

                                                                      }else if(tambahqtyJson['status'] == 'minbeli'){
                                                                        showInSnackBar('${tambahqtyJson['messageminbeli']}');
                                                                        setState(
                                                                              () {
                                                                            listNota[index].jumlah = "${tambahqtyJson['minbeliqty']}";
                                                                            listNota[index].qtyinput.text ="${tambahqtyJson['minbeliqty']}";
                                                                          });
                                                                          totalhargaget();
                                                                      }else if(tambahqtyJson['status'] == 'maxstock'){
                                                                        showInSnackBar('${tambahqtyJson['messagestock']}');
                                                                        setState(
                                                                              () {
                                                                            listNota[index].jumlah = "${tambahqtyJson['stockqty']}";
                                                                            listNota[index].qtyinput.text ="${tambahqtyJson['stockqty']}";
                                                                          });
                                                                          totalhargaget();

                                                                      } else if (tambahqtyJson[
                                                                              'status'] ==
                                                                          'Error') {
                                                                        showInSnackBar(
                                                                            'Gagal! Hubungi pengembang software!');
                                                                      }
                                                                  } else {
                                                                    showInSnackBar(
                                                                        'Request failed with status: ${tambahqty.statusCode}');
                                                                    print(tambahqty
                                                                        .body);
                                                                  }
                                                                } on TimeoutException catch (_) {
                                                                  showInSnackBar(
                                                                      'Timed out, Try again');
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
            listNota.length == 0
                ? Container()
                : Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 20.0),
                            child: Text('Total Harga'),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, top: 10.0, bottom: 20.0),
                            child: Text(
                              totalhargaX == null
                                  ? 'Rp. 0.00'
                                  : 'Rp. ' + totalhargaX,
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  listNota.length == 0 ?
                  Container():
                  SizedBox(
                     width: double.infinity,
                    child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.green[400],
                  disabledTextColor: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  splashColor: Colors.blueAccent,
                  onPressed: loadingtocheckout == true ? null : () async {
                    setState(() {
                      loadingtocheckout = true;
                    });
                    try {
                      final tambahqty = await http.post(
                        url('api/gocheckkeranjangAndroid'),
                        headers: requestHeaders,
                      );

                      if (tambahqty.statusCode == 200) {
                        var tambahqtyJson = json.decode(tambahqty.body);
                        if (tambahqtyJson['status'] == 'Success') {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Checkout()));

                        } else if (tambahqtyJson['status'] == 'failed') {

                          for (int i = 0; i < tambahqtyJson['namaproduk'].length; i++) {
                            showInSnackBar('${tambahqtyJson['namaproduk'][i]} Jumlahnya 0');  
                          }
                          setState(() {
                            loadingtocheckout = false;
                          });
                          
                        }
                      } else {
                        showInSnackBar(
                            'Request failed with status: ${tambahqty.statusCode}');
                        setState(() {
                            loadingtocheckout = false;
                          });
                        print('${tambahqty.body}');
                      }
                    } on TimeoutException catch (_) {
                      showInSnackBar('Timed out, Try again');
                      setState(() {
                            loadingtocheckout = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(loadingtocheckout == true ? "Tunggu sebentar" : "Bayar Semua Barang",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                  ),
                  
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: new Row(
      //     mainAxisSize: MainAxisSize.max,
      //     children: <Widget>[
      //       SizedBox(
      //           width: MediaQuery.of(context).size.width, // specific value
      //           child: )
      //     ],
      //   ),
      // ),
    );
  }
}

class ListKeranjang {
  final String id;
  final String item;
  final String harga;
  final String type;
  final String codeproduk;
  final String image;
  String jumlah;
  final String satuan;
  String total;
  final String hargadiskon;
  TextEditingController qtyinput;
  ListKeranjang(
      {this.id,
      this.item,
      this.harga,
      this.type,
      this.image,
      this.jumlah,
      this.satuan,
      this.codeproduk,
      this.total,
      this.qtyinput,
      this.hargadiskon});
}
