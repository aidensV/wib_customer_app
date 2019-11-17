import 'package:flutter/material.dart';
import 'package:wib_customer_app/pages/tracking_list/listTileTransaksi.dart';
import 'detail.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

GlobalKey<ScaffoldState> _scaffoldKeyX;
List<ListNota> listNota;
FocusNode datepickerFocus;
String tokenType, accessToken;
var _urutkanvalue, _tanggalawal, _tanggalakhir;
Map<String, String> requestHeaders = Map();

void showInSnackBar(String value) {
  _scaffoldKeyX.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

Future<List<ListNota>> listNotaAndroid() async {
  DataStore storage = new DataStore();

  String tokenTypeStorage = await storage.getDataString('token_type');
  String accessTokenStorage = await storage.getDataString('access_token');

  tokenType = tokenTypeStorage;
  accessToken = accessTokenStorage;
  requestHeaders['Accept'] = 'application/json';
  requestHeaders['Authorization'] = '$tokenType $accessToken';
  // print(requestHeaders);

  try {
    final nota = await http.post(
      url('api/SemuaTransaksiAndroid'),
      headers: requestHeaders,body: {'urutkan': _urutkanvalue, 'tanggal_awal' : _tanggalawal, 'tanggal_akhir' : _tanggalakhir}
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
          total: i['s_total'],
          customer: i['cm_name'],
          tanggalTransaksi: i['s_date'],
        );
        listNota.add(notax);
      }

      print('listnota $listNota');
      print('listnota length ${listNota.length}');
      return listNota;
    } else if (nota.statusCode == 500) {
      showInSnackBar('Request failed with status: ${nota.statusCode}');
      print(nota.body);
      return null;
    }
  } on TimeoutException catch (_) {
    showInSnackBar('Timed out, Try again');
  } catch (e) {
    debugPrint('$e');
  }
  return null;
}

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

class AllNota extends StatefulWidget {
  AllNota({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _AllNotaState();
  }
}

class _AllNotaState extends State<AllNota> {
  
  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    _scaffoldKeyX = new GlobalKey<ScaffoldState>();
    _urutkanvalue = 'kosong';
    _tanggalawal = 'kosong';
    datepickerFocus = FocusNode();
    _tanggalakhir = 'kosong';
    print(requestHeaders);
    super.initState();
  }

  @override
  void setState(fn) {
    // Cek if widget is mounted in tree widget
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyX,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    DropdownButton<String>(
                       isExpanded: true,
                      items: [
                        DropdownMenuItem<String>(
                          child: Text('Transaksi Terbaru'),
                          value: 'one',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('Total Belanja'),
                          value: 'two',
                        ),
                      ],
                      onChanged: (String value) {
                        setState(() {
                          _urutkanvalue = value;
                        });
                      },
                      hint: Text('Urutkan transaksi berdasarkan'),
                      
                      value: _urutkanvalue == 'kosong' ? null : _urutkanvalue,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: DateTimePickerFormField(
                              initialDate: DateTime.now(),
                              dateOnly: true,
                              focusNode: datepickerFocus,
                              inputType: InputType.date,
                              editable: false,
                              format: DateFormat('dd-MM-y'),
                              decoration: InputDecoration(
                                //  border: InputBorder.none,
                                hintText: 'Tanggal Awal',
                                hintStyle: TextStyle(fontSize: 13,color: Colors.black),
                              ),
                              // resetIcon: FontAwesomeIcons.times,
                              onChanged: (ini) {
                                setState(() {
                                  _tanggalawal = ini == null ? 'kosong' : ini.toString();
                                });
                              },
                              autofocus: false,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: DateTimePickerFormField(
                              initialDate: DateTime.now(),
                              inputType: InputType.date,
                              focusNode: datepickerFocus,
                              editable: false,
                              format: DateFormat('dd-MM-y'),
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                hintText: 'Tanggal Akhir',
                                hintStyle: TextStyle(fontSize: 13,color: Colors.black),
                              ),
                              // resetIcon: FontAwesomeIcons.times,
                              onChanged: (ini) {
                                setState(() {
                                  _tanggalakhir = ini == null ? 'kosong' : ini.toString();
                                });
                              },
                              autofocus: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
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
                          } else if (snapshot.data != null ||
                              snapshot.data != 0) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                double totalpembelian =
                                    double.parse(snapshot.data[index].total);
                                NumberFormat _numberFormat =
                                    new NumberFormat.simpleCurrency(
                                        decimalDigits: 2, name: 'Rp. ');
                                String hargaTotal =
                                    _numberFormat.format(totalpembelian);

                                DateTime dateTime = DateTime.parse(
                                    snapshot.data[index].tanggalTransaksi);
                                String dateTimeParse =
                                    DateFormat('d MMM y').format(dateTime);

                                return ListTileTransaksi(
                                  hargaTotal: hargaTotal,
                                  nota: snapshot.data[index].nota,
                                  tanggalTransaksi: dateTimeParse,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Detail(
                                            id: snapshot.data[index].id,
                                            nota: snapshot.data[index].nota,
                                            customer:
                                                snapshot.data[index].customer,
                                            total: snapshot.data[index].total,
                                            status:
                                                snapshot.data[index].status),
                                      ),
                                    );
                                  },
                                  status: statusNota(
                                    snapshot.data[index].statusDeliver,
                                    snapshot.data[index].statusPacking,
                                    snapshot.data[index].statusPembayaran,
                                    snapshot.data[index].statusMetodePembayaran,
                                    snapshot.data[index].statusSetuju,
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
          ],
        ),
      ),
    );
  }
}

class ListNota {
  String id;
  String tanggalTransaksi;
  String nota;
  String customer;
  String total;
  String status;
  String statusDeliver;
  String statusPacking;
  String statusPembayaran;
  String statusMetodePembayaran;
  String statusSetuju;

  ListNota({
    this.id,
    this.nota,
    this.status,
    this.customer,
    this.total,
    this.statusDeliver,
    this.statusPacking,
    this.statusPembayaran,
    this.statusMetodePembayaran,
    this.statusSetuju,
    this.tanggalTransaksi,
  });
}
