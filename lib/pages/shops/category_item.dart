import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';


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
        headers: {
          "Authorization": "$tokenTypeStorage $accessTokenStorage"
        },
        body: {
          "kategori" : "$category_id"
        }
    );

    var data = json.decode(responseBody.body);
    var product = data['item'];

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
        iconTheme: IconThemeData(
          color: Color(0xff25282b)
        ),
        title: Text("Menampilkan kategori $category" ,style: TextStyle(color: Color(0xff25282b)),),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child:  PagewiseGridView.count(
                pageSize: PAGE_SIZE,
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 0.7,
                itemBuilder: this._itemBuilder,
                pageFuture: (pageIndex) => getData(pageIndex, PAGE_SIZE),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _itemBuilder(context, ItemKategori entry, _) {
    return SingleChildScrollView(
      child: Card(
        elevation: 0.0,
        child: InkWell(
          child: Container(
//                            color: Colors.red,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
//                                  clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        "images/botol.png",
                        fit: BoxFit.cover,
                        height: 150.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Positioned(
                        top: 5.0,
                        left: 108.0,
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: new IconButton(
                            icon: Icon(Icons.favorite, color: _isPressed),
                            onPressed: () {
                              setState(() {
                                _isPressed = Colors.pink[400];
                              });
                            },
                          ),
                        )
                    ),
                  ],
                ),
                // SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                  child: Container(
                    width:
                    MediaQuery.of(context).size.width - 130,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            entry.item,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            entry.price,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.deepOrange
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, "/details");
          },
        ),
      ),
    );
  }
}

class ItemKategori {
  String item;
  String price;

  ItemKategori.fromJson(obj) {
    this.item = obj['i_name'];
    this.price = obj['ipr_sunitprice'];
  }

  static List<ItemKategori> fromJsonList(jsonList) {
    return jsonList.map<ItemKategori>((obj) => ItemKategori.fromJson(obj)).toList();
  }
}