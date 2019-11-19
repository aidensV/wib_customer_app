import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

var _scaffoldKeyfilterAll;
var datepickerfirst, datepickerlast;
var _urutkanvalue, _tanggalawal, _tanggalakhir, _tanggalakhirvalue, _tanggalawalvalue;
String tanggalawalallvalue,tanggalakhirvalue;

class FilterTransaksiAll extends StatefulWidget {
  FilterTransaksiAll({Key key, this.title ,this.tanggalakhirall,this.tanggalawalall,this.urutkantransaksiall}) : super(key: key);
  final String title,tanggalawalall, tanggalakhirall, urutkantransaksiall;
  @override
  State<StatefulWidget> createState() {
    return _FilterTransaksiAllState();
  }
}

class _FilterTransaksiAllState extends State<FilterTransaksiAll> {

  void showInSnackBar(String value) {
    _scaffoldKeyfilterAll.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    _scaffoldKeyfilterAll = GlobalKey<ScaffoldState>();
    super.initState();
    _urutkanvalue = widget.urutkantransaksiall == null ? 'kosong' : widget.urutkantransaksiall;
    _tanggalawal = 'kosong';
    datepickerfirst = FocusNode();
    datepickerlast = FocusNode();
    _tanggalakhirvalue =  widget.tanggalakhirall == 'kosong' ? '2019-12-30 00:00:00.000' : widget.tanggalakhirall;
    _tanggalawalvalue = widget.tanggalawalall == 'kosong' ? '2019-10-30 00:00:00.000' : widget.tanggalawalall;
    _tanggalakhir = 'kosong';

  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeyfilterAll,
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
                      initialValue: widget.tanggalawalall == 'kosong' ? null : DateTime.parse(_tanggalawalvalue),
                      editable: false,
                      format: DateFormat('dd-MM-y'),
                      decoration: InputDecoration(
                        hintText:  'Tanggal Awal',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
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
                      inputType: InputType.date,
                      focusNode: datepickerlast,
                      initialValue: widget.tanggalakhirall == 'kosong' ? null : DateTime.parse(_tanggalakhirvalue),
                      // controller: _tanggalakhirController,
                      editable: false,
                      format: DateFormat('dd-MM-yyyy'),
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        hintText: 'Tanggal Akhir',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      // resetIcon: FontAwesomeIcons.times,
                      onChanged: (ini) {
                        setState(() {
                          _tanggalakhir =  ini == null ? 'kosong' : ini.toString();
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
                        '_urutkantransaksiall': _urutkanvalue,
                        '_tanggalawalall': _tanggalawal == 'kosong' ? widget.tanggalawalall == 'kosong' ? 'kosong' : _tanggalawalvalue : _tanggalawal,
                        '_tanggalakhirall': _tanggalakhir == 'kosong' ? widget.tanggalakhirall == 'kosong' ? 'kosong' : _tanggalakhirvalue : _tanggalakhir,
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
                        '_urutkantransaksiall': 'kosong',
                        '_tanggalawalall': 'kosong',
                        '_tanggalakhirall': 'kosong',
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
