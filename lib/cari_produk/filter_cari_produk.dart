import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/error/error.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'modelCariProduk.dart';
import 'package:http/http.dart' as http;

bool isLoading, isError;
GlobalKey<ScaffoldState> _scaffoldKeyFilterCari;
JenisProduk selectedJenisProduk;

TextEditingController minHargaController, maxHargaController;
String tokenType, accessToken;

Map<String, String> requestHeaders = Map<String, String>();
List<JenisProduk> listJenisProduk;

showInSnackbarFilterCari(String content) {
  _scaffoldKeyFilterCari.currentState.showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

class FilterCariProduk extends StatefulWidget {
  final JenisProduk jenisProduk;
  final String minHarga, maxHarga;

  FilterCariProduk({
    @required this.jenisProduk,
    @required this.maxHarga,
    @required this.minHarga,
  });

  @override
  _FilterCariProdukState createState() => _FilterCariProdukState();
}

class _FilterCariProdukState extends State<FilterCariProduk> {
  void getDataFilter() async {
    DataStore store = DataStore();
    String tokenTypeStorage = await store.getDataString('token_type');
    String accessTokenStorage = await store.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;

    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http.get(
        url('api/filterCariProduk'),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);

        print(responseJson);

        listJenisProduk = List<JenisProduk>();

        for (var data in responseJson) {
          listJenisProduk.add(
            JenisProduk(
              idJenis: data['ity_id'].toString(),
              namaJenis: data['ity_name'],
            ),
          );
        }

        setState(() {
          isLoading = false;
          isError = false;
        });
      } else if (response.statusCode == 401) {
        showInSnackbarFilterCari('Token kedaluwarsa, silahkan login kembali');
        setState(() {
          isLoading = false;
          isError = true;
        });
      } else {
        showInSnackbarFilterCari('Error Code : ${response.statusCode}');
        print('Error : ${jsonDecode(response.body)}');
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      print('Error : $e');
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    _scaffoldKeyFilterCari = GlobalKey<ScaffoldState>();
    isLoading = true;
    isError = false;

    listJenisProduk = List<JenisProduk>();
    selectedJenisProduk = widget.jenisProduk;

    if (widget.minHarga != null) {
      minHargaController = TextEditingController(text: widget.minHarga);
    } else {
      minHargaController = TextEditingController();
    }

    if (widget.maxHarga != null) {
      maxHargaController = TextEditingController(text: widget.maxHarga);
    } else {
      maxHargaController = TextEditingController();
    }

    getDataFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyFilterCari,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
        title: Text('Filter'),
        actions: <Widget>[
          FlatButton(
            child: Text('Bersihkan Filter'),
            textColor: Colors.cyan,
            onPressed: () {
              setState(() {
                selectedJenisProduk = null;
                minHargaController.clear();
                maxHargaController.clear();
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isError
                ? ErrorCobalLagi(
                    onPress: getDataFilter,
                  )
                : SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black54,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 3.0,
                              color:
                                  Colors.grey.withOpacity(0.5).withOpacity(0.5),
                              offset: Offset(5.0, 0.0),
                            ),
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'Filter',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.tag),
                            title: DropdownButton(
                              hint: Text('Jenis Produk'),
                              isExpanded: true,
                              value: selectedJenisProduk,
                              items: listJenisProduk
                                  .map(
                                    (JenisProduk listJenisProduk) =>
                                        DropdownMenuItem(
                                      child: Text(listJenisProduk.namaJenis),
                                      value: listJenisProduk,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (ini) {
                                setState(() {
                                  selectedJenisProduk = ini;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            leading: Text('Min'),
                            title: TextField(
                              controller: minHargaController,
                              decoration:
                                  InputDecoration(hintText: 'Minimal Harga'),
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (ini) {
                                minHargaController.value = TextEditingValue(
                                  selection: minHargaController.selection,
                                  text: ini,
                                );
                              },
                            ),
                          ),
                          ListTile(
                            leading: Text('Max'),
                            title: TextField(
                              controller: maxHargaController,
                              decoration:
                                  InputDecoration(hintText: 'Maksimal Harga'),
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (ini) {
                                maxHargaController.value = TextEditingValue(
                                  selection: maxHargaController.selection,
                                  text: ini,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
      floatingActionButton: RaisedButton(
        onPressed: () {
          Navigator.pop(
            context,
            {
              'selectedJenisProduk': selectedJenisProduk,
              'minHarga': minHargaController.text,
              'maxHarga': maxHargaController.text,
            },
          );
        },
        child: Text('Simpan Perubahan'),
        color: Colors.green,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
