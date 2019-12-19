import 'package:flutter/material.dart';
import 'package:wib_customer_app/pages/wishlist/wishlistTile.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../shops/product_detail.dart';
import 'package:flutter_image/network.dart';

var _scaffoldKeyWishlist;
List<ListWishlist> listNota = [];
String tokenType, accessToken;
bool isLoading;
bool isError;
bool isLogout;
Map<String, String> requestHeaders = Map();

void showInSnackBar(String value) {
  _scaffoldKeyWishlist.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class Wishlist extends StatefulWidget {
  Wishlist({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _WishlistState();
  }
}

class _WishlistState extends State<Wishlist> {
  Future<List<ListWishlist>> getHeaderHTTP() async {
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

  Future<List<ListWishlist>> listNotaAndroid() async {
    setState(() {
      isLoading = true;
    });
    try {
      final nota = await http.get(
        url('api/listWishlistAndroid'),
        headers: requestHeaders,
      );

      if (nota.statusCode == 200) {
        // return nota;
        var notaJson = json.decode(nota.body);
        var notas = notaJson['item'];

        print('notaJson $notaJson');

        listNota = [];
        for (var i in notas) {
          ListWishlist notax = ListWishlist(
            id: '${i['wl_id']}',
            item: i['i_name'],
            harga: i['ipr_sunitprice'],
            type: i['ity_name'],
            code: i['i_code'],
            image: i['ip_path'],
            hargadiskon: i['gpp_sellprice'],
            desc: i['itp_tagdesc'],
          );
          listNota.add(notax);
        }
        setState(() {
          isLoading = false;
          isLogout = false;
          isError = false;
        });
        return listNota;
      } else if (nota.statusCode == 401) {
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

  void modalKonfirmasi(idX) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Peringatan!'),
        content: Text('Ingin menghapus produk dari daftar wishlist?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Tidak'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            textColor: Colors.green,
            child: Text('Ya'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final hapuswishlist = await http.post(
                    url('api/removeWishlistAndrouid'),
                    headers: requestHeaders,
                    body: {'id_wishlist': idX});

                if (hapuswishlist.statusCode == 200) {
                  var hapuswishlistJson = json.decode(hapuswishlist.body);
                  if (hapuswishlistJson['status'] == 'success') {
                    setState(() {
                      getHeaderHTTP();
                    });
                  } else if (hapuswishlistJson['status'] == 'Error') {
                    showInSnackBar('Gagal! Hubungi pengembang software!');
                  }
                } else {
                  showInSnackBar(
                      'Request failed with status: ${hapuswishlist.statusCode}');
                }
              } on TimeoutException catch (_) {
                showInSnackBar('Timed out, Try again');
              } catch (e) {
                print(e);
              }
            },
          )
        ],
      ),
    );
  }

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    _scaffoldKeyWishlist = new GlobalKey<ScaffoldState>();
    isLoading = true;
    isError = false;
    isLogout = false;
    getHeaderHTTP();
    print(requestHeaders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyWishlist,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Barang Favorit",
            style: TextStyle(
              color: Color(0xff25282b),
            ),
          ),
          backgroundColor: Colors.white),
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
                : isLogout == true
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
                                    child: Image.asset("images/wishlist.png"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Center(
                                      child: Text("Barang favorit anda kosong",
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                ]),
                              )
                            : Expanded(
                                child: Scrollbar(
                                  child: RefreshIndicator(
                                    onRefresh: () => listNotaAndroid(),
                                    child: ListView.builder(
                                      // scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.all(5.0),
                                      itemCount: listNota.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        double hargaperitem =
                                            double.parse(listNota[index].harga);
                                        NumberFormat _numberFormat =
                                            new NumberFormat.simpleCurrency(
                                                decimalDigits: 2, name: 'Rp. ');
                                        String finalhargaperitem =
                                            _numberFormat.format(hargaperitem);
                                        return WishlistTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
                                                  item: listNota[index].item,
                                                  price: listNota[index].harga,
                                                  code: listNota[index].code,
                                                  diskon: listNota[index]
                                                      .hargadiskon,
                                                  desc: listNota[index].desc,
                                                  tipe: listNota[index].type,
                                                ),
                                              ),
                                            );
                                          },
                                          leading: new FadeInImage.assetNetwork(
                                            placeholder: 'images/noimage.jpg',
                                            image: listNota[index].image != null
                                                ? urladmin(
                                                    'storage/image/master/produkthumbnail/${listNota[index].image}',
                                                  )
                                                : url(
                                                    'assets/img/noimage.jpg',
                                                  ),
                                            width: 70.0,
                                            height: 100.0,
                                          ),

                                          title: Container(
                                            margin:
                                                EdgeInsets.only(right: 50.0),
                                            child: Text(
                                              listNota[index].item,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          subtitle: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              listNota[index].hargadiskon ==
                                                      null
                                                  ? Container(
                                                      height: 23.0,
                                                    )
                                                  : Container(
                                                      height: 23.0,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            listNota[index]
                                                                        .harga ==
                                                                    null
                                                                ? 'Rp. 0.00'
                                                                : finalhargaperitem,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              listNota[index].hargadiskon ==
                                                      null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              bottom: 10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            listNota[index]
                                                                        .harga ==
                                                                    null
                                                                ? 'Rp. 0.00'
                                                                : finalhargaperitem,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .deepOrange,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 0.0,
                                                            ),
                                                            child: Text(
                                                              listNota[index]
                                                                  .type,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              bottom: 10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            listNota[index]
                                                                        .hargadiskon ==
                                                                    null
                                                                ? 'Rp. 0.00'
                                                                : _numberFormat.format(double
                                                                    .parse(listNota[
                                                                            index]
                                                                        .hargadiskon)),
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .deepOrange,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0.0),
                                                            child: Text(
                                                              listNota[index]
                                                                  .type,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          // trailing: Icon(Icons.favorite, color: Colors.pink),
                                          trailing: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: FlatButton(
                                                padding: EdgeInsets.all(5.0),
                                                child: new Icon(
                                                  Icons.favorite,
                                                  color: Colors.pink,
                                                ),
                                                color: Colors.white,
                                                onPressed: () async {
                                                  var idX = listNota[index].id;
                                                  modalKonfirmasi(idX);
                                                },
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
          ],
        ),
      ),
    );
  }
}

class ListWishlist {
  final String id;
  final String item;
  final String code;
  final String harga;
  final String type;
  final String image;
  final String hargadiskon;
  String desc;

  ListWishlist(
      {this.id,
      this.item,
      this.harga,
      this.type,
      this.image,
      this.hargadiskon,
      this.code,
      this.desc});
}
