import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import '../shops/product_detail.dart';

var ids, categorys, categoryids;
String accessToken, tokenType;
int kategoriX;
Map<String, String> requestHeaders = Map();

class CategoryItem extends StatefulWidget {
  final String id, category, categoryId;
  CategoryItem({
    Key key,
    @required this.id,
    @required this.category,
    @required this.categoryId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoryItemState(
      id: id,
      category: category,
      categoryId: categoryId,
    );
  }
}

class _CategoryItemState extends State<CategoryItem> {
  // Color _isPressed = Colors.grey;
  int pageSize = 6;

  final String id, category, categoryId;
  _CategoryItemState({
    Key key,
    @required this.id,
    @required this.category,
    @required this.categoryId,
  });

  List categoryItem = [];

  Future<List<ItemKategori>> getData(index, limit) async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');
    try {
      final responseBody = await http.post(
          url('api/listProdukKategoriAndroid?_limit=$limit&count=$index'),
          headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"},
          body: {"kategori": "$categoryId"});

      var data = json.decode(responseBody.body);
      var product = data['item'];
      setState(() {
        kategoriX = product.length;
      });
      return ItemKategori.fromJsonList(product);
    } catch (e) {
      print('Error : $e');
    }
  }

  @override
  void initState() {
    print(categoryId);
    super.initState();
    kategoriX = 1;
    categoryids = categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff25282b)),
          title: Text(
            "Produk kategori $category",
            style: TextStyle(color: Color(0xff25282b)),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              kategoriX == 0
                  ? Container(
                      child: Column(children: <Widget>[
                        new Container(
                          alignment: Alignment.center,
                          width: 120.0,
                          height: 120.0,
                          child: Image.asset("images/empty-transaction.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 15.0, right: 15.0),
                          child: Center(
                            child: Text(
                              "Produk pada kategori $category kosong",
                              style: TextStyle(
                                  fontSize: 18,
                                  height: 1.2,
                                  color: Colors.grey[500]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.only(top: 30.0, left: 5.0, right: 5.0),
                      child: PagewiseGridView.count(
                        pageSize: pageSize,
                        primary: false,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 5.0,
                        childAspectRatio: 0.6,
                        itemBuilder: this._itemBuilder,
                        pageFuture: (pageIndex) => getData(pageIndex, pageSize),
                      ),
                    ),
            ],
          ),
        ));
  }

  Widget _itemBuilder(context, ItemKategori entry, _) {
    return Card(
      // child: Card(
      elevation: 1.5,
      child: InkWell(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      entry.gambar != null
                          ? urladmin(
                              'storage/image/master/produk/${entry.gambar}',
                            )
                          : url(
                              'assets/img/noimage.jpg',
                            ),
                      fit: BoxFit.cover,
                      height: 150.0,
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
                            icon: Icon(Icons.favorite,
                                size: 16,
                                color: entry.wishlist == null
                                    ? Colors.grey[400]
                                    : Colors.pink),
                            onPressed: () async {
                              var storage = new DataStore();

                              var tokenTypeStorage =
                                  await storage.getDataString('token_type');
                              var accessTokenStorage =
                                  await storage.getDataString('access_token');

                              tokenType = tokenTypeStorage;
                              accessToken = accessTokenStorage;
                              requestHeaders['Accept'] = 'application/json';
                              requestHeaders['Authorization'] =
                                  '$tokenType $accessToken';

                              var idx = entry.code;
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
                                      entry.wishlist = entry.code;
                                    });
                                  } else if (aksiwishlistJson['status'] ==
                                      'hapuswishlist') {
                                    setState(() {
                                      entry.wishlist = null;
                                    });
                                  } else if (aksiwishlistJson['status'] ==
                                      'Error') {}
                                } else {
                                  print('${aksiwishlist.body}');
                                }
                              } on TimeoutException catch (_) {} catch (e) {
                                print(e);
                              }
                            }),
                      )),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width - 130,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          entry.item == null || entry.item == ''
                              ? 'Nama item'
                              : entry.item,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        height: 65,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Column(
                          children: <Widget>[
                            entry.diskon == null || entry.diskon == ''
                                ? Container(
                                    height: 25,
                                  )
                                : Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      entry.price == null || entry.price == ''
                                          ? 'Rp. 0.00'
                                          : 'Rp. ' + entry.price,
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    height: 25,
                                  ),
                            entry.diskon == null || entry.diskon == ''
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          entry.price == null ||
                                                  entry.price == ''
                                              ? 'Rp. 0.00'
                                              : "Rp. " + entry.price,
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
                                          entry.tipe == null || entry.tipe == ''
                                              ? 'Jenis'
                                              : entry.tipe,
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
                                          entry.diskon == null ||
                                                  entry.diskon == ''
                                              ? 'Rp. 0.00'
                                              : "Rp. " + entry.diskon,
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
                                          entry.tipe == null || entry.tipe == ''
                                              ? 'Jenis'
                                              : entry.tipe,
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
                item: entry.item,
                price: entry.price,
                code: entry.code,
                diskon: entry.diskon,
                desc: entry.desc,
                tipe: entry.tipe,
              ),
            ),
          );
        },
      ),
      // ),
    );
  }
}

class ItemKategori {
  String item;
  String price;
  String gambar;
  String diskon;
  String code;
  String wishlist;
  String desc;
  String tipe;

  ItemKategori.fromJson(obj) {
    this.item = obj['i_name'];
    this.price = obj['ipr_sunitprice'];
    this.gambar = obj['ip_path'];
    this.diskon = obj['gpp_sellprice'];
    this.code = obj['i_code'];
    this.wishlist = obj['wl_ciproduct'];
    this.tipe = obj['ity_name'];
    this.desc = obj['itp_tagdesc'];
  }

  static List<ItemKategori> fromJsonList(jsonList) {
    return jsonList
        .map<ItemKategori>((obj) => ItemKategori.fromJson(obj))
        .toList();
  }
}
