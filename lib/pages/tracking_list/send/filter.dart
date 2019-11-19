import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

var _scaffoldKeyfilterDelivered;
FocusNode datepickerfirst, datepickerlast;
var _urutkanvalue, _tanggalawal, _tanggalakhir, _tanggalawalvalue, _tanggalakhirvalue;

class FilterTransaksidelivered extends StatefulWidget {
  FilterTransaksidelivered({Key key, this.title ,this.tanggalakhirdelivered,this.tanggalawaldelivered,this.urutkantransaksidelivered}) : super(key: key);
  final String title,tanggalawaldelivered, tanggalakhirdelivered, urutkantransaksidelivered;
  @override
  State<StatefulWidget> createState() {
    return _FilterTransaksideliveredState();
  }
}

class _FilterTransaksideliveredState extends State<FilterTransaksidelivered> {

  void showInSnackBar(String value) {
    _scaffoldKeyfilterDelivered.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    _scaffoldKeyfilterDelivered = GlobalKey<ScaffoldState>();
    super.initState();
    _urutkanvalue = widget.urutkantransaksidelivered == null ? 'kosong' : widget.urutkantransaksidelivered;
    _tanggalawal = 'kosong';
    datepickerfirst = FocusNode();
    datepickerlast = FocusNode();
    _tanggalakhirvalue =  widget.tanggalakhirdelivered == 'kosong' ? '2019-12-30 00:00:00.000' : widget.tanggalakhirdelivered;
    _tanggalawalvalue = widget.tanggalawaldelivered == 'kosong' ? '2019-10-30 00:00:00.000' : widget.tanggalawaldelivered;
    _tanggalakhir = 'kosong';
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyfilterDelivered,
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
                    child: DateTimePickerFormField(
                      dateOnly: true,
                      focusNode: datepickerfirst,
                      inputType: InputType.date,
                      initialValue: widget.tanggalawaldelivered == 'kosong' ? null : DateTime.parse(_tanggalawalvalue),
                      editable: false,
                      format: DateFormat('dd-MM-y'),
                      decoration: InputDecoration(
                        //  border: InputBorder.none,
                        hintText: 'Tanggal Awal',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      // resetIcon: FontAwesomeIcons.times,
                      onChanged: (ini) {
                        setState(() {
                          _tanggalawal =
                              ini == null ? 'kosong' : ini.toString();
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
                      inputType: InputType.date,
                      focusNode: datepickerlast,
                      initialValue: widget.tanggalakhirdelivered == 'kosong' ? null : DateTime.parse(_tanggalakhirvalue),
                      editable: false,
                      format: DateFormat('dd-MM-y'),
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        hintText: 'Tanggal Akhir',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      // resetIcon: FontAwesomeIcons.times,
                      onChanged: (ini) {
                        setState(() {
                          _tanggalakhir =
                              ini == null ? 'kosong' : ini.toString();
                        });
                      },
                      autofocus: false,
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
                        '_urutkantransaksidelivered': _urutkanvalue,
                        '_tanggalawaldelivered': _tanggalawal == 'kosong' ? widget.tanggalawaldelivered == 'kosong' ? 'kosong' : _tanggalawalvalue : _tanggalawal,
                        '_tanggalakhirdelivered': _tanggalakhir == 'kosong' ? widget.tanggalakhirdelivered == 'kosong' ? 'kosong' : _tanggalakhirvalue : _tanggalakhir,
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
                        '_urutkantransaksidelivered': 'kosong',
                        '_tanggalawaldelivered': 'kosong',
                        '_tanggalakhirdelivered': 'kosong',
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
