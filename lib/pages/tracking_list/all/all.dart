import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';

GlobalKey<ScaffoldState> _scaffoldKeyX = new GlobalKey<ScaffoldState>();
List<ListNota> listNota = [];
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

void showInSnackBar(String value) {
  _scaffoldKeyX.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

Future<List<ListNota>> listNotaAndroid() async {
  try {
    final nota = await http.get(
      url('api/SemuaTransaksiAndroid'),
      headers: requestHeaders,
    );

    if (nota.statusCode == 200) {
      // return nota;
      var notaJson = json.decode(nota.body);
      var notas = notaJson['nota'];

      print('notaJson $notaJson');

      listNota = [];
      for (var i in notas) {
        ListNota notax = ListNota(
          id: '${i['s_id']}',
          nota: i['s_nota'],
          statusDeliver: i['s_delivered'],
          statusPacking: i['s_packing'],
          statusPembayaran: i['s_paystatus'],
          statusMetodePembayaran: i['s_paymethod'],
          statusSetuju: i['s_isapprove'],
          total : i['s_total'],
          customer: i['cm_name'],
        );
        listNota.add(notax);
      }

      print('listnota $listNota');
      print('listnota length ${listNota.length}');
      return listNota;
    } else {
//      showInSnackBar('Request failed with status: ${nota.statusCode}');
      return null;
    }
  } on TimeoutException catch (_) {
    showInSnackBar('Timed out, Try again');
  } catch (e) {
    debugPrint('$e');
  }
  return null;
}

Widget statusNota(statusDeliver, statusPacking, statusPembayaran, statusMetodePembayaran, statusSetuju) {
  if (statusSetuju == 'C') {
    return Text("Menunggu Konfirmasi", style: TextStyle(color: Colors.orange),);
  }

  if (statusSetuju == 'N') {
    return Text("Denied", style: TextStyle(color: Colors.red),);
  }

  if (statusDeliver == 'Y') {
    return Text("Transaksi Selesai", style: TextStyle(color: Colors.green),);
  }

  if (statusDeliver == 'L') {
    return Text("Pengiriman Terlambat", style: TextStyle(color: Colors.orange),);
  }

  if (statusDeliver == 'P') {
    return Text("Sedang Dikirim", style: TextStyle(color: Colors.green));
  }

  if (statusPacking == 'Y') {
    return Text("Packing Selesai", style: TextStyle(color: Colors.green));
  }

  if (statusSetuju == 'Y') {
    return Text("Proses Packing", style: TextStyle(color: Colors.green));
  }

  if (statusPembayaran == 'Y') {
    return Text("Sudah Dibayar", style: TextStyle(color: Colors.green));
  }

  if (statusPembayaran == 'N') {
    return Text("Pembayaran", style: TextStyle(color: Colors.green));
  }
  return null;
}

class AllNota extends StatefulWidget {
  AllNota({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _AllNotaState();
  }
}

class _AllNotaState extends State<AllNota> {
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
  }

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    getHeaderHTTP();
    print(requestHeaders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyX,
      body: RefreshIndicator(
        onRefresh: () => refreshFunction(),
        child: Scrollbar(
          child: FutureBuilder(
            future: listNotaAndroid(),
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
                    return ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Tidak ada data',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.data != null || snapshot.data != 0) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(snapshot.data[index].nota),
                            subtitle: Text("Rp." + snapshot.data[index].total),
                            trailing: statusNota(
                                snapshot.data[index].statusDeliver,
                                snapshot.data[index].statusPacking,
                                snapshot.data[index].statusPembayaran,
                                snapshot.data[index].statusMetodePembayaran,
                                snapshot.data[index].statusSetuju
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detail(
                                      id: snapshot.data[index].id,
                                      nota: snapshot.data[index].nota,
                                      customer: snapshot.data[index].customer,
                                      total: snapshot.data[index].total,
                                      status: snapshot.data[index].status),
                                ),
                              );
                            },
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
    );
  }
}

class ListNota {
  final String id;
  final String nota;
  final String customer;
  final String total;
  final String status;
  final String statusDeliver;
  final String statusPacking;
  final String statusPembayaran;
  final String statusMetodePembayaran;
  final String statusSetuju;

  ListNota({this.id, this.nota, this.status, this.customer, this.total, this.statusDeliver, this.statusPacking, this.statusPembayaran, this.statusMetodePembayaran, this.statusSetuju});
}
