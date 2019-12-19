import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

var _scaffoldKeyfilterPay;
FocusNode datepickerfirst, datepickerlast;
var _urutkanvalue, _tanggalawal, _tanggalakhir, _tanggalakhirvalue, _tanggalawalvalue;

class FilterTransaksiprocess extends StatefulWidget {
  FilterTransaksiprocess({Key key, this.title ,this.tanggalakhirprocess,this.tanggalawalprocess,this.urutkantransaksiprocess}) : super(key: key);
  final String title,tanggalawalprocess, tanggalakhirprocess, urutkantransaksiprocess;
  @override
  State<StatefulWidget> createState() {
    return _FilterTransaksiprocessState();
  }
}

class _FilterTransaksiprocessState extends State<FilterTransaksiprocess> {

  void showInSnackBar(String value) {
    _scaffoldKeyfilterPay.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    _scaffoldKeyfilterPay = GlobalKey<ScaffoldState>();
    super.initState();
    _urutkanvalue = widget.urutkantransaksiprocess == null ? 'kosong' : widget.urutkantransaksiprocess;
    _tanggalawal = 'kosong';
    datepickerfirst = FocusNode();
    datepickerlast = FocusNode();
    _tanggalakhirvalue =  widget.tanggalakhirprocess == 'kosong' ? '2019-12-30 00:00:00.000' : widget.tanggalakhirprocess;
    _tanggalawalvalue = widget.tanggalawalprocess == 'kosong' ? '2019-10-30 00:00:00.000' : widget.tanggalawalprocess;
    _tanggalakhir = 'kosong';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyfilterPay,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff25282b),
          ),
          title: new Text(
            "Filter Transaksi",
            style: TextStyle(
              color: Color(0xff25282b),
            ),
          ),
          backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(15.0),
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
                    child: DateTimeField(
                      readOnly: true,
                      format : DateFormat('dd-MM-yyy'),
                      initialValue: widget.tanggalawalprocess == 'kosong' ? null : DateTime.parse(_tanggalawalvalue),
                      decoration: InputDecoration(
                        hintText: 'Tanggal Awal',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          firstDate: DateTime(1900),
                          context: context,
                          initialDate: widget.tanggalawalprocess == 'kosong' ? DateTime.now() : DateTime.parse(_tanggalawalvalue),
                          lastDate: DateTime(2100));
                        },
                        onChanged: (ini) {
                        setState(() {
                          _tanggalawal =  ini == null ? 'kosong' : ini.toString();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: DateTimeField(
                      readOnly: true,
                      format : DateFormat('dd-MM-yyy'),
                      initialValue: widget.tanggalakhirprocess == 'kosong' ? null : DateTime.parse(_tanggalakhirvalue),
                      decoration: InputDecoration(
                        hintText: 'Tanggal Akhir',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          firstDate: DateTime(1900),
                          context: context,
                          initialDate: widget.tanggalakhirprocess == 'kosong' ? DateTime.now() : DateTime.parse(_tanggalakhirvalue),
                          lastDate: DateTime(2100));
                        },
                        onChanged: (ini) {
                        setState(() {
                          _tanggalakhir =  ini == null ? 'kosong' : ini.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(15.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    Navigator.pop(
                      context,
                      {
                        '_urutkantransaksiprocess': _urutkanvalue,
                        '_tanggalawalprocess': _tanggalawal == 'kosong' ? widget.tanggalawalprocess == 'kosong' ? 'kosong' : _tanggalawalvalue : _tanggalawal,
                        '_tanggalakhirprocess': _tanggalakhir == 'kosong' ? widget.tanggalakhirprocess == 'kosong' ? 'kosong' : _tanggalakhirvalue : _tanggalakhir,
                      },
                    );
                  },
                  child: Text(
                    "Cari Sekarang",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.white,
                  textColor: Colors.green,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(15.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    Navigator.pop(
                      context,
                      {
                        '_urutkantransaksiprocess': 'kosong',
                        '_tanggalawalprocess': 'kosong',
                        '_tanggalakhirprocess': 'kosong',
                      },
                    );
                  },
                  child: Text(
                    "Reset Filter",
                    style: TextStyle(fontSize: 14.0),
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
