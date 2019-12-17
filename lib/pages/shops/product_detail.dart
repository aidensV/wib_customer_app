import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'package:flutter_image/network.dart';
import 'dart:async';
import 'dart:convert';

var itemX, priceX, codeX, descX, diskonX, tipeX;
String tokenType, accessToken;
bool isLoading;
bool isError;
bool loadingaddcart;
GlobalKey<ScaffoldState> _scaffoldKeyDetail;
List<ListKeranjang> listNota = [];
String stockiesX, wishlistX, stockX;
Map<String, String> requestHeaders = Map();

class ProductDetail extends StatefulWidget {
  ProductDetail(
      {Key key,
      this.title,
      this.price,
      this.code,
      this.diskon,
      this.item,
      this.tipe,
      this.desc})
      : super(key: key);
  final String title, item, price, code, desc, diskon, tipe;
  @override
  State<StatefulWidget> createState() {
    return ProductDetailState();
  }
}

class ProductDetailState extends State<ProductDetail> {
  final kodeposController = TextEditingController(text: '1');
  ProductDetailState({
    Key key,
  });
  int _current = 0;

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

  Future<List<ListKeranjang>> listNotaAndroid() async {
    setState(() {
      isLoading = true;
    });
    try {
      final nota = await http.post(url('api/productdetail'),
          headers: requestHeaders, body: {'produk': widget.code});

      if (nota.statusCode == 200) {
        // return nota;
        var notaJson = json.decode(nota.body);
        var notas = notaJson['gambar'];
        String stockies = notaJson['stockies'];
        String wishlist = notaJson['wishlist'].toString();
        listNota = [];
        for (var i in notas) {
          ListKeranjang notax = ListKeranjang(
            id: '${i['ip_id']}',
            item: i['ip_path'].toString(),
          );
          listNota.add(notax);
        }
        setState(() {
          wishlistX = wishlist;
          stockiesX = stockies;
        });
        getstock();
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('$e');
    }
    return null;
  }

  Future<void> getstock() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    try {
      final response = await http.post(url('api/stock_check'),
          headers: requestHeaders,
          body: {'produk': widget.code, 'cabang': stockiesX});

      if (response.statusCode == 200) {
        setState(() {
          var stockJson = json.decode(response.body);
          String stockvalue = stockJson['stock'].toString();
          stockX = stockvalue;
          isLoading = false;
          isError = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
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

  CarouselSlider carouselSlider;
  List imgList = [];

  List<T> map<T>(List listNota, Function handler) {
    List<T> result = [];
    for (var i = 0; i < listNota.length; i++) {
      result.add(handler(i, listNota[i]));
    }
    return result;
  }

  void showInSnackBar(String value) {
    _scaffoldKeyDetail.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  bool isWishlist = false;

  @override
  void initState() {
    isLoading = true;
    isError = false;
    wishlistX = null;
    isWishlist = false;
    loadingaddcart = false;
    getHeaderHTTP();
    stockiesX = null;
    stockX = null;
    itemX = widget.item;
    priceX = widget.price;
    codeX = widget.code;
    descX = widget.desc;
    tipeX = widget.tipe;
    diskonX = widget.diskon;
    _scaffoldKeyDetail = new GlobalKey<ScaffoldState>();
    kodeposController.text = '1';
    print(requestHeaders);
    super.initState();
  }

  Widget build(BuildContext context) {
    double hargaperitem = double.parse(priceX);
    NumberFormat _numberFormat =
        new NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
    String finalharganormalitem = _numberFormat.format(hargaperitem);
    return Scaffold(
      key: _scaffoldKeyDetail,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff25282b),
        ),
        title: new Text(
          "Detail Product",
          style: TextStyle(
            color: Color(0xff25282b),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : isError == true
              ? SingleChildScrollView(
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
                            top: 20.0, left: 15.0, right: 15.0, bottom: 40.0),
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
                    // child: ListView(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          listNota.length == 0
                              ? new Container(
                                  child: Image.network(
                                    url(
                                      'assets/img/noimage.jpg',
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: 30.0,
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      carouselSlider = CarouselSlider(
                                        height: 220,
                                        initialPage: 0,
                                        enlargeCenterPage: true,
                                        autoPlay: true,
                                        reverse: false,
                                        enableInfiniteScroll: true,
                                        autoPlayInterval: Duration(seconds: 5),
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 2000),
                                        pauseAutoPlayOnTouch:
                                            Duration(seconds: 10),
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        items: <Widget>[
                                          for (var i = 0;
                                              i < listNota.length;
                                              i++)
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'images/noimage.jpg',
                                                image: urladmin(
                                                    'storage/image/master/produkthumbnail/${listNota[i].item}'),
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Positioned(
                                          bottom: -5.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: map<Widget>(listNota,
                                                (index, url) {
                                              return Container(
                                                width: 8.0,
                                                height: 8.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _current == index
                                                        ? Color.fromRGBO(
                                                            0, 0, 0, 0.9)
                                                        : Color.fromRGBO(
                                                            0, 0, 0, 0.4)),
                                              );
                                            }),
                                          ))
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Container(
                          child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  tipeX == null ? 'Jenis Item' : tipeX,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 4.0, left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  itemX == null ? 'Nama Item' : itemX,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.announcement,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    stockiesX == 'Tidak Ada Cabang Terdekat'
                                        ? 'Tidak ada Cabang Terdekat'
                                        : stockX == '0' || stockX == null
                                            ? 'Stock tersisa : 0'
                                            : 'Stock tersisa : $stockX',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.archive,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Warung Botol',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    '12 Agustus 2012',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                left: 10.0,
                                right: 10.0,
                                bottom: 20.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Kab. Bogor',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Card(
                        child: ListTile(
                          leading: new ButtonTheme(
                              minWidth: 0,
                              buttonColor: Color(0xff388bf2),
                              child: FlatButton(
                                  child: Icon(Icons.remove_circle,
                                      color: Colors.green),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(
                                    0.0,
                                  ),
                                  onPressed: () {
                                    int currentValue = int.parse(
                                        kodeposController.text == null
                                            ? '0'
                                            : kodeposController.text);
                                    setState(() {
                                      currentValue--;
                                      if (currentValue <= 1) {
                                        kodeposController.text = '1';
                                      } else {
                                        kodeposController.text = (currentValue)
                                            .toString(); // incrementing value
                                      }
                                    });
                                  })),
                          title: TextField(
                            controller: kodeposController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(),
                          ),
                          trailing: new ButtonTheme(
                              minWidth: 0,
                              buttonColor: Color(0xff388bf2),
                              child: FlatButton(
                                  child: Icon(Icons.add_circle,
                                      color: Colors.green),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(
                                    0.0,
                                  ),
                                  onPressed: () {
                                    int currentValue = int.parse(
                                        kodeposController.text.length == 0
                                            ? '0'
                                            : kodeposController.text);
                                    setState(() {
                                      currentValue++;
                                      kodeposController.text =
                                          (currentValue).toString();
                                    });
                                  })),
                        ),
                      ),
                      Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, left: 10.0, right: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Description',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0,
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: 20.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    descX == null || descX == ''
                                        ? 'Tidak ada deskripsi untuk barang ini'
                                        : 'Tidak ada deskripsi untuk barang ini',
                                  )
                                ],
                              ),
                            ),
                          ],
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: <Widget>[
                            Text(
                              diskonX == null || diskonX.toString() == '0.00'
                                  ? priceX == null ||
                                          priceX.toString() == '0.00'
                                      ? 'Rp. 0.00'
                                      : finalharganormalitem
                                  : _numberFormat
                                      .format(double.parse(diskonX.toString())),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ButtonTheme(
                                  minWidth: 0,
                                  height: 20.0,
                                  buttonColor: Color(0xff388bf2),
                                  child: FlatButton(
                                    onPressed: () async {
                                      if (isLoading == true) {
                                        showInSnackBar(
                                            'Sedang memuat halaman mohon tunggu sebentar');
                                      } else if (isError == true) {
                                        showInSnackBar(
                                            'Gagal memuat halaman, mohon muat ulang');
                                      } else {
                                        var idx = codeX;
                                        try {
                                          final aksiwishlist = await http.post(
                                              url('api/ActionWishlistAndroid'),
                                              headers: requestHeaders,
                                              body: {'produk': idx});

                                          if (aksiwishlist.statusCode == 200) {
                                            var aksiwishlistJson =
                                                json.decode(aksiwishlist.body);
                                            if (aksiwishlistJson['status'] ==
                                                'tambahwishlist') {
                                              setState(() {
                                                isWishlist = true;
                                                wishlistX = codeX;
                                              });
                                              showInSnackBar(
                                                  '$itemX Berhasil ditambahkan ke barang favorit');
                                            } else if (aksiwishlistJson[
                                                    'status'] ==
                                                'hapuswishlist') {
                                              showInSnackBar(
                                                  '$itemX Berhasil dihapus dari barang favorit');
                                              setState(() {
                                                isWishlist = false;
                                                wishlistX = null;
                                              });
                                            } else if (aksiwishlistJson[
                                                    'status'] ==
                                                'Error') {}
                                          } else {
                                            print('${aksiwishlist.body}');
                                          }
                                        } on TimeoutException catch (_) {} catch (e) {
                                          print(e);
                                        }
                                      }
                                    },
                                    child: Icon(Icons.favorite,
                                        color: wishlistX == codeX
                                            ? Colors.pink
                                            : Colors.grey[400]),
                                    color: Colors.white,
                                    padding: EdgeInsets.all(
                                      0.0,
                                    ),
                                  )),
                              ButtonTheme(
                                  minWidth: 0,
                                  height: 20.0,
                                  buttonColor: Color(0xff388bf2),
                                  child: FlatButton(
                                    onPressed: loadingaddcart == true
                                        ? null
                                        : () async {
                                            setState(() {
                                              loadingaddcart = true;
                                            });
                                            var location = stockiesX;
                                            if (isLoading == true) {
                                              showInSnackBar(
                                                  'Sedang memuat halaman, mohon tunggu sebentar');
                                              setState(() {
                                                loadingaddcart = false;
                                              });
                                            } else if (isError == true) {
                                              showInSnackBar(
                                                  'Gagal memuat halaman, mohon muat ulang halaman kembali');
                                              setState(() {
                                                loadingaddcart = false;
                                              });
                                            } else if (location == null) {
                                              showInSnackBar(
                                                  'Silahkan setting alamat terlebih dahulu pada pengaturan akun');
                                              setState(() {
                                                loadingaddcart = false;
                                              });
                                            } else if (location ==
                                                'Tidak Ada Cabang Terdekat') {
                                              showInSnackBar(
                                                  'Silahkan ubah alamat anda sesuai stockies yang ada pada cabang warung botol');
                                              setState(() {
                                                loadingaddcart = false;
                                              });
                                            } else {
                                              var idx = codeX;
                                              try {
                                                final adcart = await http.post(
                                                    url('api/addCartAndroid'),
                                                    headers: requestHeaders,
                                                    body: {
                                                      'code': idx,
                                                      'cart_qty':
                                                          kodeposController
                                                              .text,
                                                      'cart_location': location,
                                                    });

                                                if (adcart.statusCode == 200) {
                                                  var addcartJson =
                                                      json.decode(adcart.body);
                                                  if (addcartJson['done'] ==
                                                      'done') {
                                                    showInSnackBar(
                                                        '$itemX berhasil dimasukkan ke keranjang');
                                                    setState(() {
                                                      loadingaddcart = false;
                                                    });
                                                  } else if (addcartJson[
                                                          'status'] ==
                                                      'minbeli') {
                                                    showInSnackBar(
                                                        '${addcartJson['minbuy']}');
                                                    setState(() {
                                                      loadingaddcart = false;
                                                    });
                                                  } else if (addcartJson[
                                                          'status'] ==
                                                      'stockkurangminbeli') {
                                                    showInSnackBar(
                                                        '${addcartJson['message']}');
                                                    setState(() {
                                                      loadingaddcart = false;
                                                    });
                                                  } else if (addcartJson[
                                                          'status'] ==
                                                      'maxstock') {
                                                    showInSnackBar(
                                                        '${addcartJson['messagestock']}');
                                                    setState(() {
                                                      loadingaddcart = false;
                                                    });
                                                  } else if (addcartJson[
                                                          'error'] ==
                                                      'error') {
                                                    showInSnackBar(
                                                        '$itemX sudah ada dikeranjang');
                                                    setState(() {
                                                      loadingaddcart = false;
                                                    });
                                                  } else if (addcartJson[
                                                          'error'] ==
                                                      'Berat Barang Belum Di Set') {
                                                    showInSnackBar(
                                                        'Mohon Maaf, berat barang belum disetting');
                                                    setState(() {
                                                      loadingaddcart = false;
                                                    });
                                                  }
                                                } else {
                                                  print('${adcart.body}');
                                                  setState(() {
                                                    loadingaddcart = false;
                                                  });
                                                }
                                              } on TimeoutException catch (_) {} catch (e) {
                                                print(e);
                                              }
                                            }
                                          },
                                    child: Text(
                                      loadingaddcart == true
                                          ? 'Tunggu sebentar '
                                          : 'Add to Cart',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    color: Colors.white,
                                    padding: EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 5.0,
                                      bottom: 5.0,
                                    ),
                                  )),
                            ],
                          )),
                    ],
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

  ListKeranjang({
    this.id,
    this.item,
  });
}
