import 'package:flutter/material.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';

GlobalKey<ScaffoldState> _scaffoldKeyX = new GlobalKey<ScaffoldState>();
List<ListWishlist> listNota = [];
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

void showInSnackBar(String value) {
  _scaffoldKeyX.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

Future<List<ListWishlist>> listNotaAndroid() async {
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
          image: i['ip_path'],
        );
        listNota.add(notax);
      }

      print('listnota $listNota');
      print('listnota length ${listNota.length}');
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
  return null;
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

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    // getHeaderHTTP();
    print(requestHeaders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyX,
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: RefreshIndicator(
          onRefresh: () => refreshFunction(),
          child: Scrollbar(
            child: FutureBuilder(
              future: getHeaderHTTP(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return ListTile(
                      title: Text('Tekan Tombol Mulai.'),
                    );
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.data == null ||
                        snapshot.data == 0 ||
                        snapshot.data.length == null ||
                        snapshot.data.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListView(
                          children: <Widget>[
                            new Container(
                              width: 100.0,
                              height: 100.0,
                              child: Image.asset("images/wishlist.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Center(
                                child: Text("Barang Favorit Anda Kosong",
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            // ListTile(
                            //   title: Text(
                            //     'Tidak ada data',
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    } else if (snapshot.data != null || snapshot.data != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.white,
                            child: ListTile(
                              // leading:
                              //  Image.network(
                              //   urladmin(
                              //     'storage/image/master/produk/${snapshot.data[index].image}',
                              //   ),
                              // ),
                              leading: Image.network(
                                snapshot.data[index].image != null
                                    ? urladmin(
                                        'storage/image/master/produk/${snapshot.data[index].image}',
                                      )
                                    : url(
                                        'assets/img/noimage.jpg',
                                      ),
                                width: 70.0,
                                height: 100.0,
                              ),

                              // leading: FlutterLogo(size: 72.0),
                              title: Text(snapshot.data[index].item),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                    top: 40.0, bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Rp. " + snapshot.data[index].harga,
                                        style: TextStyle(color: Colors.black)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Text(snapshot.data[index].type,
                                          style: TextStyle(
                                            color: Colors.green,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              // trailing: Icon(Icons.favorite, color: Colors.pink),
                              trailing: new FlatButton(
                                child: new Icon(Icons.favorite,
                                    color: Colors.pink),
                                color: Colors.white,
                                onPressed: () async {
                                  var idX = snapshot.data[index].id;
                                  try {
                                    final hapuswishlist = await http.post(
                                        url('api/removeWishlistAndrouid'),
                                        headers: requestHeaders,
                                        body: {'id_wishlist': idX});

                                    if (hapuswishlist.statusCode == 200) {
                                      var hapuswishlistJson =
                                          json.decode(hapuswishlist.body);
                                      if (hapuswishlistJson['status'] ==
                                          'success') {
                                        setState(() {
                                          totalRefresh += 1;
                                        });
                                      } else if (hapuswishlistJson['status'] ==
                                          'Error') {
                                        showInSnackBar(
                                            'Gagal! Hubungi pengembang software!');
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
                              ),
                            ),
                          );
                        },
                      );
                    }
                }
                return null; // unreachable
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ListWishlist {
  final String id;
  final String item;
  final String harga;
  final String type;
  final String image;

  ListWishlist({this.id, this.item, this.harga, this.type, this.image});
}
