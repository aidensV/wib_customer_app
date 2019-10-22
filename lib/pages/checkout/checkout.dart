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

class Checkout extends StatefulWidget {
  Checkout({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _WishlistState();
  }
}

class _WishlistState extends State<Checkout> {
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
            "Checkout",
            style: TextStyle(
              color: Color(0xff25282b),
            ),
          ),
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
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
