import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/storage/storage.dart';

var idX, notaX, customerX, statusX;
String accessToken, tokenType;
Map<String, String> requestHeaders = Map();
List<ListItem> listItem;
bool isLoading;

class Detail extends StatefulWidget {
  final String id, nota, customer, status, total;
  Detail({
    Key key,
    @required this.id,
    @required this.nota,
    @required this.customer,
    @required this.status,
    @required this.total,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailState(
      id: id,
      nota: nota,
      customer: customer,
      status: status,
      total: total,
    );
  }
}

class _DetailState extends State<Detail> {
  final String id, nota, customer, status, total;
  _DetailState({
    Key key,
    @required this.id,
    @required this.nota,
    @required this.customer,
    @required this.status,
    @required this.total,
  });

  Future<Null> getHeaderHTTP() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    setState(() {
      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;

      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';
      print(requestHeaders);
    });
    listItemNotaAndroid();
  }


  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }


  Future<List<ListItem>> listItemNotaAndroid() async {
    setState(() {
      isLoading = true;
    });
    try {
      final item = await http.post(url('api/detailTransaksiAndroid'),
          headers: requestHeaders, body: {'nota': '$notaX'});

      if (item.statusCode == 200) {
        // return nota;
        var itemJson = json.decode(item.body);
        print(itemJson);
        listItem = [];
        for (var i in itemJson['item']) {
          ListItem notax = ListItem(
            nama: i['i_name'],
            satuan: i['iu_name'],
            qty: '${i['sd_qty']}',
            price: i['ipr_sunitprice'],
          );
          listItem.add(notax);
        }

        print('listItem $listItem');
        print('length listItem ${listItem.length}');
        setState(() {
          isLoading = false;
        });
        return listItem;
      } else {
        showInSnackBar('Request failed with status: ${item.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } on TimeoutException catch (_) {
      showInSnackBar('Timed out, Try again');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    return null;
  }

  @override
  void initState() {
    listItem = [];
    isLoading = false;
    idX = id;
    notaX = nota;
    customerX = customer;
    statusX = status;
    getHeaderHTTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Detail Nota"),
        backgroundColor: Color(0xff31B057),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Nota',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            notaX,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Customer',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            customerX,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            isLoading == true
                ? Center(
              child: CircularProgressIndicator(),
            )
                : listItem.length == 0
                ? Card(
              child: ListTile(
                title: Text(
                  'Tidak ada data',
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: listItem.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(listItem[index].nama),
                        subtitle: Text("Rp. " + listItem[index].price),
                        trailing: Text(
                            '${listItem[index].qty} ${listItem[index].satuan}'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          _confirmationModalBottomSheet(context);
        },
        child: Container(
          width: 200.0,
          height: 50.0,
          decoration: new BoxDecoration(
            color: Color(0xff31B057),
            border: new Border.all(color: Colors.transparent, width: 2.0),
            borderRadius: new BorderRadius.circular(23.0),
          ),
          child: Center(child: Text('Salin Ke Nota Baru', style: new TextStyle(fontFamily: 'TitilliumWeb',fontSize: 18.0, color: Colors.white),
          ),
          ),
        ),
      ),

    );
  }
}

class ListItem {
  final String nama;
  final String satuan;
  final String qty;
  final String price;

  ListItem({
    this.nama,
    this.satuan,
    this.qty,
    this.price,
  });
}

void _confirmationModalBottomSheet(context){
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
      ),
      context: context,
      builder: (BuildContext bc){
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            height: 130.0,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Apa anda yakin?", style: TextStyle(fontFamily: 'TitilliumWeb', fontSize: 20.0),),
                  ),
                ),
                SizedBox(height: 3.0,),
                Container(
                  child: Text("Item pada transaksi ini akan langsung diarahkan ke checkout !", style: TextStyle(fontFamily: 'TitilliumWeb', fontSize: 16.0, color: Colors.grey[400]),),
                ),
                SizedBox(height: 5.0,),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 80.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            print('Salin nota');
                          },
                          color: Color(0xff31B057),
                          child: Text("Ya", style: TextStyle(fontFamily: 'TitilliumWeb', fontSize: 16.0, color: Colors.white)),),
                      ),
                      SizedBox(width: 10.0,),
                      Container(
                        height: 40.0,
                        width: 80.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.transparent,
                          elevation: 0.0,
                          child: Text("Tidak!", style: TextStyle(fontFamily: 'TitilliumWeb', fontSize: 16.0, color: Color(0xff31B057))),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(2.0),
                              side: BorderSide(color: Color(0xff31B057))
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
  );
}
