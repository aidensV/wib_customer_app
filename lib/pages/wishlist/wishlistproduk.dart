import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/storage/storage.dart';

var ids, wishlistproduks, wishlistprodukids;
String accessToken, tokenType;
Map<String, String> requestHeaders = Map();
bool isLoading;

class WishlistProduk extends StatefulWidget {
  final String id, wishlistproduk, wishlistproduk_id;
  WishlistProduk({
    Key key,
    @required this.id,
    @required this.wishlistproduk,
    @required this.wishlistproduk_id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WishlistProdukState(
      id: id,
      wishlistproduk: wishlistproduk,
      wishlistproduk_id: wishlistproduk_id,
    );
  }
}

class _WishlistProdukState extends State<WishlistProduk> {
  Color _isPressed = Colors.grey;

  final String id, wishlistproduk, wishlistproduk_id;
  _WishlistProdukState({
    Key key,
    @required this.id,
    @required this.wishlistproduk,
    @required this.wishlistproduk_id,
  });

  List wishlistproduk_item = [];

  Future<String> getWishlistProduk() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    var response = await http.post(url('api/ActionWishlistAndroid'),
        headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"},
        body: {"produk": "BRG0203"});

    this.setState(() {
      var data = json.decode(response.body);
      wishlistproduk_item = data['status'];
    });

    return "Success!";
  }

  @override
  void initState() {
    getWishlistProduk();
    print(wishlistproduk_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff25282b)),
          title: Text(
            "Menampilkan kategori $wishlistproduk",
            style: TextStyle(color: Color(0xff25282b)),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: GridView.count(
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 5.0,
                    childAspectRatio: 0.7,
                    children: List.generate(
                        wishlistproduk_item.length == 0 ? 0 : wishlistproduk_item.length,
                        (index) {
                      return Card(
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                            icon: Icon(Icons.favorite,
                                                color: _isPressed),
                                            onPressed: () {
                                              setState(() {
                                                _isPressed = Colors.pink[400];
                                              });
                                            },
                                          ),
                                        )),
                                  ],
                                ),
                                // SizedBox(width: 15),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 10.0, left: 10.0, top: 10.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 130,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            wishlistproduk_item[index]["i_name"],
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
                                            "Rp. " +
                                                wishlistproduk_item[index]
                                                    ["ipr_bunitprice"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.deepOrange),
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            wishlistproduk_item[index]["i_code"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.grey[400],
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
                            Navigator.pushNamed(context, "/wislishproduk");
                          },
                        ),
                      );
                    })),
              ),
            ],
          ),
        ));
  }
}
