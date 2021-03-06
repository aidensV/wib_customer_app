import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:wib_customer_app/cari_produk/modelCariProduk.dart';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/error/error.dart';
import 'package:wib_customer_app/pages/shops/product_detail.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:wib_customer_app/utils/utils.dart';
import 'package:http/http.dart' as http;

GlobalKey<ScaffoldState> _scaffoldKeyCariProdukDetail;
bool isLoading, isError;
List<Produk> listProduk;
int pageSize;
NumberFormat numberFormat;
bool isLogin;

Map<String, String> requestHeaders = Map<String, String>();
String tokenType, accessToken;
PagewiseLoadController pagewiseCariProdukController;

showInSnackbarCariProdukDetail(String content) {
  _scaffoldKeyCariProdukDetail.currentState.showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

class CariProdukLebihDetail extends StatefulWidget {
  final String namaProduk,  minHarga, maxHarga;
  final JenisProduk jenisProduk;
  CariProdukLebihDetail({
    this.namaProduk,
    this.jenisProduk,
    this.maxHarga,
    this.minHarga,
  });

  @override
  _CariProdukLebihDetailState createState() => _CariProdukLebihDetailState();
}

class _CariProdukLebihDetailState extends State<CariProdukLebihDetail> {
  navbarActionRight() async {
    DataStore dataStore = new DataStore();
    String _username = await dataStore.getDataString("username");

    if (_username == 'Tidak ditemukan') {
      setState(() {
        isLogin = false;
      });
    } else {
      setState(() {
        isLogin = true;
      });
    }
  }

  Future<List<Produk>> cariProduk({
    @required String namaProduk,
    @required int index,
  }) async {
    DataStore dataStore = DataStore();

    var tokenTypeStorage = await dataStore.getDataString('token_type');
    var accessTokenStorage = await dataStore.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    Map requestBody = Map();
    requestBody['size'] = pageSize.toString();
    requestBody['lengthX'] = index.toString();
    requestBody['namaProduk'] = widget.namaProduk;
    if (widget.jenisProduk != null) {
      requestBody['jenisProduk'] = widget.jenisProduk.idJenis;
    }
    if(widget.minHarga != null){
      requestBody['minHarga'] = widget.minHarga;
    }
    if(widget.maxHarga != null){
      requestBody['maxHarga'] = widget.maxHarga;
    }
    try {
      DataStore dataStore = new DataStore();
      String _username = await dataStore.getDataString("username");
      String produk;
      if (_username == 'Tidak ditemukan') {
        produk = 'api/cariBarang_belumlogin'; 
      } else {
        produk = 'api/cariBarang';
      }
      final response = await http.post(
        url(produk),
        headers: requestHeaders,
        body: requestBody,
      );
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);

        print(responseJson);
        listProduk = List<Produk>();
        for (var data in responseJson) {
          listProduk.add(
            Produk(
              deskripsiProduk: data['itp_description'],
              gambar: data['ip_path'],
              hargaProduk: data['ipr_sunitprice'],
              hargaDiskon: data['gpp_sellprice'],
              kodeProduk: data['i_code'],
              namaProduk: data['i_name'],
              namaTipe: data['ity_name'],
              wishlist: data['wl_ciproduct'],
            ),
          );
        }
        return listProduk;
      } else if (response.statusCode == 401) {
        showInSnackbarCariProdukDetail(
            'Token kedaluwarsa, silahkan login kembali');
        return null;
      } else {
        showInSnackbarCariProdukDetail('Error Code : ${response.statusCode}');
        print(jsonDecode(response.body));
        return null;
      }
    } on TimeoutException catch (_) {
      showInSnackbarCariProdukDetail('Request timeout, try again');
      return null;
    } catch (e) {
      showInSnackbarCariProdukDetail('Error : ${e.toString()}');
      print('Error : $e');
      return null;
    }
    // return null;
  }

  Widget produkCard(Produk produk) {
    return Container(
      child: new Card(
        elevation: 1.5,
        child: InkWell(
          //   height: 250.0,
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'images/noimage.jpg',
                        image: produk.gambar != null
                            ? urladmin(
                                'storage/image/master/produkthumbnail/${produk.gambar}',
                              )
                            : url(
                                'assets/img/noimage.jpg',
                              ),
                        fit: BoxFit.cover,
                        height: 130.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Positioned(
                        top: 5.0,
                        right: 5.0,
                        child: Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: new BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: new IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: 16,
                              color: produk.wishlist == null
                                  ? Colors.grey[400]
                                  : Colors.pink,
                            ),
                            onPressed: () async {
                              var idX = produk.kodeProduk;
                              // var color = produk.color;
                              if (isLogin) {
                                try {
                                  final hapuswishlist = await http.post(
                                      url('api/ActionWishlistAndroid'),
                                      headers: requestHeaders,
                                      body: {'produk': idX});

                                  if (hapuswishlist.statusCode == 200) {
                                    var hapuswishlistJson =
                                        json.decode(hapuswishlist.body);
                                    if (hapuswishlistJson['status'] ==
                                        'tambahwishlist') {
                                      setState(() {
                                        produk.wishlist = produk.kodeProduk;
                                      });
                                    } else if (hapuswishlistJson['status'] ==
                                        'hapuswishlist') {
                                      setState(() {
                                        produk.wishlist = null;
                                      });
                                    }
                                  } else {
                                    print(
                                        'Error Code : ${hapuswishlist.statusCode}');
                                    print(jsonDecode(hapuswishlist.body));
                                  }
                                } on TimeoutException catch (_) {
                                  showInSnackbarCariProdukDetail(
                                      'Request timeout, try again');
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                showInSnackbarCariProdukDetail(
                                    'Silahkan login terlebih dahulu');
                              }
                            },
                          ),
                        )),
                  ],
                ),
                // SizedBox(width: 15),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            produk.namaProduk,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          // height: 60,
                          height: 60.0,
                        ),
                        Positioned(
                          right: 0.0,
                          left: 0.0,
                          bottom: 0.0,
                          child: Column(
                            children: <Widget>[
                              produk.hargaDiskon == null
                                  ? Container(
                                      height: 20,
                                    )
                                  : Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        produk.hargaProduk == null
                                            ? 'Rp. 0.00'
                                            : numberFormat.format(
                                                double.parse(
                                                    produk.hargaProduk),
                                              ),
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                      height: 20,
                                    ),
                              produk.hargaDiskon == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            produk.hargaProduk == null
                                                ? 'Rp. 0.00'
                                                : numberFormat.format(
                                                    double.parse(
                                                        produk.hargaProduk),
                                                  ),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.deepOrange),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            produk.namaTipe,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.green),
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            produk.hargaDiskon == null
                                                ? 'Rp. 0.00'
                                                : numberFormat.format(
                                                    double.parse(
                                                        produk.hargaDiskon)),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.deepOrange),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            produk.namaTipe,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.green),
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(
                  item: produk.namaProduk,
                  price: produk.hargaProduk,
                  code: produk.kodeProduk,
                  diskon: produk.hargaDiskon,
                  desc: produk.deskripsiProduk,
                  tipe: produk.namaTipe,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void refreshPagewise() {
    pagewiseCariProdukController.reset();
  }

  @override
  void initState() {
    _scaffoldKeyCariProdukDetail = GlobalKey<ScaffoldState>();
    listProduk = List<Produk>();
    isLogin = false;
    // isLoading = true;

    // isError = false;
    pageSize = 12;
    numberFormat = NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
    pagewiseCariProdukController = PagewiseLoadController(
      pageSize: pageSize,
      pageFuture: (int i) {
        return cariProduk(
          index: i,
          namaProduk: widget.namaProduk,
        );
      },
    );
    // cariProduk(
    //   namaProduk: widget.namaProduk,
    //   index: 0,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyCariProdukDetail,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40.0,
            width: 220.0,
            decoration: BoxDecoration(
              color: Colors.grey[100].withOpacity(0.9),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
                topLeft: Radius.circular(5.0),
              ),
            ),
            // alignment: Alignment.center,
            child: Container(
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(
                      CupertinoIcons.search,
                      color: HexColor('#7f8c8d'),
                    ),
                  ),
                  Container(
                    child: Text(
                      widget.namaProduk,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: RefreshIndicator(
            onRefresh: () async {
              refreshPagewise();
              await Future.value({});
            },
            child: PagewiseGridView.count(
              pageLoadController: pagewiseCariProdukController,
              primary: false,
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 3
                      : 2,
              // mainAxisSpacing: 10.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 0.6,
              itemBuilder: (BuildContext context, dynamic produk, int i) {
                return produkCard(produk);
              },
              loadingBuilder: (BuildContext context) => Center(
                child: CircularProgressIndicator(),
              ),
              retryBuilder: (BuildContext context, Function onPress) {
                return ErrorCobalLagi(
                  onPress: onPress(),
                );
              },
              noItemsFoundBuilder: (BuildContext context) {
                return ListView(
                  children: [
                    ListTile(
                      title: Text(
                        'Produk tidak ditemukan',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
