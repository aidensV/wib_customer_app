import 'dart:convert';

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/cari_produk/modelCariProduk.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/error/error.dart';
import 'package:wib_customer_app/storage/storage.dart';

Produk produkState;
List<Produk> listProduk, listProdukX;
List<String> listProdukAutoComplete;
bool isCari, isLoading, isError;

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
GlobalKey<ScaffoldState> _scaffoldKeyProduk;

FocusNode cariFocus;
TextEditingController cariController;
// AutoCompleteTextField autoCompleteProdukField;

// GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey;
FocusNode _autoCompleteProdukFokus;

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
      final response = await http.get(
        url('api/daftarProduk'),
        headers: requestHeaders,
      );

      listProdukAutoComplete = List<String>();

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        print(responseJson);

        for (var data in responseJson) {
          listProdukAutoComplete.add(data['i_name']);
        }
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

  cariProduk() async {
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
        url('api/cariBarang'),
        headers: requestHeaders,
        body: {
          'namaProduk': cariController.text,
        },
      );

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        print(responseJson);

        listProduk = List<Produk>();

        for (var i in responseJson) {
          listProduk.add(
            Produk(
              idProduk: i['i_id'].toString(),
              namaProduk: i['i_name'],
              hargaDiskon: i['gpp_sellprice'],
              hargaProduk: i['ipr_sunitprice'],
              idTipe: i['ity_id'].toString(),
              namaTipe: i['ity_name'],
              kodeProduk: i['i_code'],
              linkProduk: i['i_link'],
            ),
          );
        }

        listProdukX = listProduk;

        setState(() {
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
        showInSnackBarProduk('Error Code = ${response.statusCode}');
        print(jsonDecode(response.body));
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e, stacktrace) {
      print('Error = $e || Stacktrace = $stacktrace');
      showInSnackBarProduk('Error = ${e.toString()}');
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

    listProdukAutoComplete = List<String>();

    getProduk();
    produkState = widget.produk == null
        ? Produk(idProduk: '', namaProduk: '')
        : widget.produk;

    cariFocus = FocusNode();
    cariController = TextEditingController();
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
          // title: autoCompleteProdukField = AutoCompleteTextField<String>(
          //   focusNode: _autoCompleteProdukFokus,
          //   suggestions: listProdukAutoComplete,
          //   key: autoCompleteKey,
          //   submitOnSuggestionTap: true,
          //   clearOnSubmit: false,
          //   itemBuilder: (context, suggestion) => Container(
          //       padding: EdgeInsets.all(7.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           Text(
          //             suggestion,
          //             style: TextStyle(
          //               fontSize: 18.0,
          //             ),
          //           ),
          //         ],
          //       )),
          //   itemFilter: (suggestion, input) =>
          //       suggestion.toLowerCase().startsWith(input.toLowerCase()),
          //   itemSorter: (a, b) {
          //     return a.compareTo(b);
          //   },
          //   itemSubmitted: (iniVal) {},
          //   decoration: InputDecoration(
          //     hintText: 'Pilih Produk',
          //   ),
          // ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                cariController.text = '';
                setState(() {
                  isCari = false;
                  listProduk = listProdukX;
                });
              },
              icon: Icon(Icons.close),
            )
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isError
                ? ErrorCobalLagi(
                    onPress: () {
                      cariProduk();
                      getProduk();
                    },
                  )
                : Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: () => cariProduk(),
                      child: ListView.builder(
                        itemCount: listProduk.length,
                        itemBuilder: (BuildContext context, int i) => Card(
                          child: ListTile(
                            leading: Icon(FontAwesomeIcons.globe),
                            title: Text(listProduk[i].namaProduk),
                            onTap: () {
                              setState(() {
                                produkState = Produk(
                                  idProduk: listProduk[i].idProduk,
                                  namaProduk: listProduk[i].namaProduk,
                                );
                                isCari = false;
                                listProduk = listProdukX;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
