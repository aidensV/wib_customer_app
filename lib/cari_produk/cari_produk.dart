import 'dart:convert';

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/cari_produk/modelCariProduk.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/error/error.dart';
import 'package:wib_customer_app/storage/storage.dart';
// import 'package:wib_customer_app/utils/utils.dart';

Produk produkState;
List<Produk> listProduk, listProdukX;
List<String> listProdukAutoComplete;
bool isCari, isLoading, isError;

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
GlobalKey<ScaffoldState> _scaffoldKeyProduk;

FocusNode cariFocus;
TextEditingController cariController;

showInSnackBarProduk(String content) {
  _scaffoldKeyProduk.currentState.showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

class CariProduk extends StatefulWidget {
  final Produk produk;

  CariProduk({this.produk});

  @override
  _CariProdukState createState() => _CariProdukState();
}

class _CariProdukState extends State<CariProduk> {
  getProduk() async {
    DataStore dataStore = DataStore();

    var tokenTypeStorage = await dataStore.getDataString('token_type');
    var accessTokenStorage = await dataStore.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    try {
      final response = await http.post(
        url('api/daftarProduk'),
        headers: requestHeaders,
        body: {
          'nama_barang': cariController.text,
        },
      );

      listProduk = List<Produk>();

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        // print(responseJson);

        for (var data in responseJson) {
          listProduk.add(
            Produk(
              namaProduk: data['i_name'],
            ),
          );
        }

        setState(() {
          listProduk = listProduk;
        });
      } else if (response.statusCode == 401) {
        showInSnackBarProduk(
            'Token kedaluwarsa, silahkan logout dan login kembali');
      } else {
        showInSnackBarProduk('Error Code : ${response.statusCode}');
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error : $e');
      showInSnackBarProduk('Error : ${e.toString()}');
    }
  }

  @override
  void initState() {
    _scaffoldKeyProduk = GlobalKey<ScaffoldState>();
    isCari = false;
    isLoading = false;
    isError = false;

    listProduk = List();
    listProdukX = List();

    // listProdukAutoComplete = List<String>();

    cariFocus = FocusNode();
    cariController = TextEditingController();
    // _autoCompleteProdukFokus = FocusNode();

    // FocusScope.of(context).requestFocus(_autoCompleteProdukFokus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKeyProduk,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Container(
            margin: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: Colors.grey[100].withOpacity(0.7),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(7.0),
                bottomLeft: Radius.circular(7.0),
                topRight: Radius.circular(7.0),
                topLeft: Radius.circular(7.0),
              ),
            ),
            child: TextField(
              controller: cariController,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                // contentPadding: EdgeInsets.only(top: 11.0),
                hintText: "Cari Sekarang!",
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.black,
                ),
              ),
              onChanged: (ini) {
                if (ini.length != 0) {
                  setState(() {
                    isCari = true;
                  });
                  getProduk();
                } else {
                  setState(() {
                    isCari = false;
                  });
                }
                cariController.value = TextEditingValue(
                  selection: cariController.selection,
                  text: ini,
                );
              },
            ),
          ),
          actions: <Widget>[
            isCari
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isCari = false;
                        cariController.clear();
                      });
                    },
                    icon: Icon(Icons.close),
                  )
                : Container(),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isError
                ? ErrorCobalLagi(
                    onPress: () {
                      getProduk();
                    },
                  )
                : Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: () => getProduk(),
                      child: ListView.builder(
                        itemCount: listProduk.length,
                        itemBuilder: (BuildContext context, int i) => Card(
                          child: ListTile(
                            title: Text(listProduk[i].namaProduk),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
