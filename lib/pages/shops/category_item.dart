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
Map<String, String> requestHeaders = Map();
bool isLoading;

class CategoryItem extends StatefulWidget {
  final String id, category, category_id;
  CategoryItem({
    Key key,
    @required this.id,
    @required this.category,
    @required this.category_id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoryItemState(
      id: id,
      category: category,
      category_id: category_id,
    );
  }
}

class _CategoryItemState extends State<CategoryItem> {
  Color _isPressed = Colors.grey;
  int PAGE_SIZE = 6;

  final String id, category, category_id;
  _CategoryItemState({
    Key key,
    @required this.id,
    @required this.category,
    @required this.category_id,
  });

  List category_item = [];

  Future<List<ItemKategori>> getData(index, limit) async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    final responseBody = await http.post(
        url('api/listProdukKategoriAndroid?_limit=$limit'),
        headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"},
        body: {"kategori": "$category_id"});

    var data = json.decode(responseBody.body);
    var product = data['item'];

    print(product);

    return ItemKategori.fromJsonList(product);
  }

  @override
  void initState() {
    print(category_id);
    super.initState();

    categoryids = category_id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff25282b)),
          title: Text(
            "Produk kategori $category",
            style: TextStyle(color: Color(0xff25282b)),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 5.0, right: 5.0),
                child: PagewiseGridView.count(
                  pageSize: PAGE_SIZE,
                  primary: false,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 0.6,
                  itemBuilder: this._itemBuilder,
                  pageFuture: (pageIndex) => getData(pageIndex, PAGE_SIZE),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _itemBuilder(context, ItemKategori entry, _) {
    return Card(
      // child: Card(
        elevation: 0.0,
        child: InkWell(
          child: Container(
            child: Column(
              
              children: <Widget>[
                Stack(
                  
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
//                                  clipBehavior: Clip.antiAlias,
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
                            icon: Icon(Icons.favorite,size: 16, color: entry.wishlist == null?  Colors.grey[400] :Colors.pink),

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
                            },
                            // setState(() {
                            //   _isPressed = Colors.pink[400];
                            // });
                          ),
                        )),
                  ],
                ),
                // SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 130,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            entry.item,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          height: 65,
                        ),
                        entry.diskon == null
                            ? Container(
                                height: 25,
                              )
                            : Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Rp. ' + entry.price,
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                                height: 25,
                              ),
                        entry.diskon == null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Rp. " + entry.price,
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
                                      entry.tipe,
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
                                      "Rp. " + entry.diskon,
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
                                      'Botol',
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
                )
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
