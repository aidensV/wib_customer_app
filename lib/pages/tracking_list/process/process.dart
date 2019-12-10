import 'package:flutter/material.dart';
import 'package:wib_customer_app/pages/tracking_list/listTileTransaksi.dart';
import 'detail.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'filter.dart';

List<ListNota> listNota;
var _tanggalawalprocess, _tanggalakhirprocess, _urutkantransaksiprocess;
GlobalKey<ScaffoldState> _scaffoldKeyprocess;
FocusNode datepickerFocus;
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();




Widget statusNota(statusDeliver, statusPacking, statusPembayaran,
    statusMetodePembayaran, statusSetuju) {
  if (statusSetuju == 'C') {
    return Text(
      "Menunggu Konfirmasi",
      style: TextStyle(color: Colors.orange),
    );
  }

  if (statusSetuju == 'N') {
    return Text(
      "Denied",
      style: TextStyle(color: Colors.red),
    );
  }

  if (statusDeliver == 'Y') {
    return Text(
      "Transaksi Selesai",
      style: TextStyle(color: Colors.green),
    );
  }

  if (statusDeliver == 'L') {
    return Text(
      "Pengiriman Terlambat",
      style: TextStyle(color: Colors.orange),
    );
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
  if (statusDeliver == 'A') {
    return Text("Ambil Sendiri", style: TextStyle(color: Colors.green));
  }
  return null;
}

class ProcessNota extends StatefulWidget {
  ProcessNota({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ProcessNotaState();
  }
}

class _ProcessNotaState extends State<ProcessNota> {  
  bool isLoading;
  Future<List<ListNota>> listNotaAndroid() async {
  DataStore storage = new DataStore();

  String tokenTypeStorage = await storage.getDataString('token_type');
  String accessTokenStorage = await storage.getDataString('access_token');

  tokenType = tokenTypeStorage;
  accessToken = accessTokenStorage;
  requestHeaders['Accept'] = 'application/json';
  requestHeaders['Authorization'] = '$tokenType $accessToken';
  try {
    setState(() {
    isLoading = true; 
    });
    final nota = await http.post(url('api/TransaksiProsesAndroid'),
        headers: requestHeaders,
        body: {
          'urutkan': _urutkantransaksiprocess,
          'tanggal_awal': _tanggalawalprocess.toString(),
          'tanggal_akhir': _tanggalakhirprocess.toString(),
        });

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
          total: i['s_total'],
          customer: i['cm_name'],
          tanggalTransaksi: i['s_date'],
        );
        listNota.add(notax);
      }

      print('listnota $listNota');
      print('listnota length ${listNota.length}');
      setState(() {
        isLoading = false; 
      });
      return listNota;
    } else {
//      showInSnackBar('Request failed with status: ${nota.statusCode}');
      return null;
    }
  } on TimeoutException catch (_) {
    setState(() {
        isLoading = false; 
      });
    showInSnackBar('Timed out, Try again');
  } catch (e) {
    setState(() {
        isLoading = false; 
      });
    debugPrint('$e');
  }
  return null;
}

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    print(requestHeaders);
    listNotaAndroid();
    _scaffoldKeyprocess =  new GlobalKey<ScaffoldState>();
    isLoading = true;
    _urutkantransaksiprocess = 'kosong';
    _tanggalawalprocess = 'kosong';
    datepickerFocus = FocusNode();
    _tanggalakhirprocess = 'kosong';
    super.initState();
  }
  void showInSnackBar(String value) {
  _scaffoldKeyprocess.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyprocess,
      body: Container(
        child: Column(
          children: <Widget>[
            isLoading == true
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : listNota.length == 0
                    ? RefreshIndicator(
                        onRefresh: () => listNotaAndroid(),
                        child: Column(children: <Widget>[
                          new Container(
                            alignment: Alignment.center,
                          width: 120.0,
                          height: 120.0,
                          child: Image.asset("images/empty-transaction.png"),
                        ),
                        Padding(
                          
                          padding: const EdgeInsets.only(top: 10.0, left:15.0,right:15.0),
                          child: Center(
                            child: Text("Anda tidak memiliki transaksi sedang diproses",
                                style: TextStyle(fontSize: 18,height:1.2,color: Colors.grey[500]),
                                textAlign: TextAlign.center,),
                          ),
                        ),
                        ]),
                      )
                    : Expanded(
                        child: Scrollbar(
                          child: RefreshIndicator(
                            onRefresh: () => listNotaAndroid(),
                            child: ListView.builder(
                              // scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(5.0),
                              itemCount: listNota.length,
                              itemBuilder: (BuildContext context, int index) {
                                double totalpembelian =
                                    double.parse(listNota[index].total);
                                NumberFormat _numberFormat =
                                    new NumberFormat.simpleCurrency(
                                        decimalDigits: 2, name: 'Rp. ');
                                String hargaTotal =
                                    _numberFormat.format(totalpembelian);

                                DateTime dateTime = DateTime.parse(
                                    listNota[index].tanggalTransaksi);
                                String dateTimeParse =
                                    DateFormat('d MMM y').format(dateTime);

                                return ListTileTransaksi(
                                  hargaTotal: hargaTotal,
                                  nota: listNota[index].nota,
                                  tanggalTransaksi: dateTimeParse,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Detail(
                                          id: listNota[index].id,
                                          nota: listNota[index].nota,
                                          customer: listNota[index].customer,
                                          total: listNota[index].total,
                                          status: listNota[index].status,
                                        ),
                                      ),
                                    );
                                  },
                                  status: statusNota(
                                    listNota[index].statusDeliver,
                                    listNota[index].statusPacking,
                                    listNota[index].statusPembayaran,
                                    listNota[index].statusMetodePembayaran,
                                    listNota[index].statusSetuju,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          dynamic filter = await Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(name: '/filter_transaksi_pay'),
              builder: (BuildContext context) => FilterTransaksiprocess(
                urutkantransaksiprocess: _urutkantransaksiprocess,
                tanggalawalprocess: _tanggalawalprocess,
                tanggalakhirprocess: _tanggalakhirprocess,
              ),
            ),
          );
          if (filter != null) {
            _urutkantransaksiprocess = filter['_urutkantransaksiprocess'];
            _tanggalawalprocess = filter['_tanggalawalprocess'];
            _tanggalakhirprocess = filter['_tanggalakhirprocess'];
            setState(() {
              _urutkantransaksiprocess = filter['_urutkantransaksiprocess'];
              _tanggalawalprocess = filter['_tanggalawalprocess'];
              _tanggalakhirprocess = filter['_tanggalakhirprocess'];
            });

            listNotaAndroid();
          }
        },
        child: Container(
          width: 120.0,
          height: 40.0,
          decoration: new BoxDecoration(
            color: Color(0xff31B057),
            border: new Border.all(color: Colors.transparent, width: 2.0),
            borderRadius: new BorderRadius.circular(23.0),
          ),
          child: Center(
            child: Text(
              'Filter Transaksi',
              style: new TextStyle(
                  fontFamily: 'TitilliumWeb',
                  fontSize: 14.0,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class ListNota {
  String id;
  String nota;
  String customer;
  String total;
  String status;
  String statusDeliver;
  String statusPacking;
  String statusPembayaran;
  String statusMetodePembayaran;
  String statusSetuju;
  String tanggalTransaksi;

  ListNota(
      {this.id,
      this.nota,
      this.status,
      this.tanggalTransaksi,
      this.customer,
      this.total,
      this.statusDeliver,
      this.statusPacking,
      this.statusPembayaran,
      this.statusMetodePembayaran,
      this.statusSetuju});
}
