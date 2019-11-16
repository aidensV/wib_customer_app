import 'dart:convert';

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wib_customer_app/cari_produk/cari_produk_detail.dart';
import 'package:wib_customer_app/cari_produk/filter_cari_produk.dart';
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
JenisProduk selectedJenisProduk;

String minHarga, maxHarga;

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

    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http.post(
        url('api/daftarProduk'),
        headers: requestHeaders,
        body: {
          'namaProduk': cariController.text,
          'jenisProduk':
              selectedJenisProduk != null ? selectedJenisProduk.idJenis : '',
          'minHarga': minHarga,
          'maxHarga': maxHarga,
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
          isLoading = false;
          isError = false;
        });
      } else if (response.statusCode == 401) {
        showInSnackBarProduk(
            'Token kedaluwarsa, silahkan logout dan login kembali');
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        showInSnackBarProduk('Error Code : ${response.statusCode}');
        print(jsonDecode(response.body));
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      print('Error : $e');
      showInSnackBarProduk('Error : ${e.toString()}');
      setState(() {
        isLoading = false;
        isError = true;
      });
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
    selectedJenisProduk = null;

    minHarga = null;
    maxHarga = null;
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
              textInputAction: TextInputAction.search,
              onSubmitted: (ini) {
                setState(() {
                  cariController.value = TextEditingValue(
                    selection: cariController.selection,
                    text: ini,
                  );
                });
                print('submitted $ini');
                if (ini.isNotEmpty ||
                    selectedJenisProduk != null ||
                    minHarga.isNotEmpty ||
                    maxHarga.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: '/cari_produk_detail'),
                      builder: (BuildContext context) => CariProdukLebihDetail(
                        namaProduk: cariController.text,
                      ),
                    ),
                  );
                } else {
                  showInSnackBarProduk('Input cari tidak boleh kosong');
                }
              },
              onChanged: (ini) {
                setState(() {
                  cariController.value = TextEditingValue(
                    selection: cariController.selection,
                    text: ini,
                  );
                });
                if (ini.length != 0) {
                  setState(() {
                    isCari = true;
                  });
                  Future.delayed(
                    Duration(
                      milliseconds: 50,
                    ),
                    getProduk(),
                  );
                } else {
                  setState(() {
                    isCari = false;
                  });
                }
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
            IconButton(
              onPressed: () {
                if (cariController.text.isNotEmpty ||
                    selectedJenisProduk != null ||
                    minHarga.isNotEmpty ||
                    maxHarga.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: '/cari_produk_detail'),
                      builder: (BuildContext context) => CariProdukLebihDetail(
                        namaProduk: cariController.text,
                      ),
                    ),
                  );
                } else {
                  showInSnackBarProduk('Input cari tidak boleh kosong');
                }
              },
              icon: Icon(
                Icons.search,
                color: Colors.cyan,
              ),
            ),
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
                      child: cariController.text.length != 0 &&
                              listProduk.length == 0
                          ? ListView(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    'Produk tidak ditemukan',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                          : ListView.builder(
                              itemCount: listProduk.length,
                              itemBuilder: (BuildContext context, int i) =>
                                  Card(
                                child: ListTile(
                                  title: Text(listProduk[i].namaProduk),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        settings: RouteSettings(
                                            name: '/cari_produk_detail'),
                                        builder: (BuildContext context) =>
                                            CariProdukLebihDetail(
                                          namaProduk: listProduk[i].namaProduk,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),
                  ),
        floatingActionButton: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          onPressed: () async {
            dynamic filter = await Navigator.push(
              context,
              MaterialPageRoute(
                settings: RouteSettings(name: '/filter_cari_produk'),
                builder: (BuildContext context) => FilterCariProduk(
                  jenisProduk: selectedJenisProduk,
                  minHarga: minHarga,
                  maxHarga: maxHarga,
                ),
              ),
            );

            if (filter != null) {
              selectedJenisProduk = filter['selectedJenisProduk'];
              minHarga = filter['minHarga'];
              maxHarga = filter['maxHarga'];
              getProduk();
            }
          },
          child: Text('Filter'),
          color: Colors.green,
          textColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
