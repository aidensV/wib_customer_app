import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

var _scaffoldKeyfilterPay;
FocusNode datepickerfirst, datepickerlast;
var _urutkanvalue, _tanggalawal, _tanggalakhir, _tanggalawalvalue, _tanggalakhirvalue;

class FilterTransaksipay extends StatefulWidget {
  FilterTransaksipay({Key key, this.title ,this.tanggalakhirpay,this.tanggalawalpay,this.urutkantransaksipay}) : super(key: key);
  final String title,tanggalawalpay, tanggalakhirpay, urutkantransaksipay;
  @override
  State<StatefulWidget> createState() {
    return _FilterTransaksiPayState();
  }
}

class _FilterTransaksiPayState extends State<FilterTransaksipay> {

  void showInSnackBar(String value) {
    _scaffoldKeyfilterPay.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    _scaffoldKeyfilterPay = GlobalKey<ScaffoldState>();
    super.initState();
    _urutkanvalue = widget.urutkantransaksipay == null ? 'kosong' : widget.urutkantransaksipay;
    _tanggalawal = 'kosong';
    datepickerfirst = FocusNode();
    datepickerlast = FocusNode();
    _tanggalakhirvalue =  widget.tanggalakhirpay == 'kosong' ? '2019-12-30 00:00:00.000' : widget.tanggalakhirpay;
    _tanggalawalvalue = widget.tanggalawalpay == 'kosong' ? '2019-10-30 00:00:00.000' : widget.tanggalawalpay;
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
                      initialValue: widget.tanggalawalpay == 'kosong' ? DateTime.now() : DateTime.parse(_tanggalawalvalue),
                      decoration: InputDecoration(
                        hintText: 'Tanggal Awal',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          firstDate: DateTime(1900),
                          context: context,
                          initialDate: widget.tanggalawalpay == 'kosong' ? DateTime.now() : DateTime.parse(_tanggalawalvalue),
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
                      initialValue: widget.tanggalakhirpay == 'kosong' ? DateTime.now() : DateTime.parse(_tanggalakhirvalue),
                      decoration: InputDecoration(
                        hintText: 'Tanggal Akhir',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          firstDate: DateTime(1900),
                          context: context,
                          initialDate: widget.tanggalakhirpay == 'kosong' ? DateTime.now() : DateTime.parse(_tanggalakhirvalue),
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
                        '_urutkantransaksipay': _urutkanvalue,
                        '_tanggalawalpay':_tanggalawal == 'kosong' ? widget.tanggalawalpay == 'kosong' ? 'kosong' : _tanggalawalvalue : _tanggalawal,
                        '_tanggalakhirpay':_tanggalakhir == 'kosong' ? widget.tanggalakhirpay == 'kosong' ? 'kosong' : _tanggalakhirvalue : _tanggalakhir,
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
                        '_urutkantransaksipay': 'kosong',
                        '_tanggalawalpay': 'kosong',
                        '_tanggalakhirpay': 'kosong',
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
