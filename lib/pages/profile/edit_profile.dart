import 'package:flutter/material.dart';
import '../checkout/listkabupaten.dart';
import '../checkout/listkecamatan.dart';
import '../checkout/listprovinsi.dart';

ListProvinsi selectedProvinsi;
ListKabupaten selectedKabupaten;
ListKecamatan selectedkecamatan;

class EditProfile extends StatefulWidget{
    final id;
    final name;
    final gender;
    final email;
    final address;
    final province;
    final city;
    final district;
    final rekening;
    final bank;
    EditProfile({Key key , this.id , this.name , this.gender , this.email , this.address , this.province , this.city , this.district , this.bank , this.rekening});
    
    @override
    _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile>{
    final id;
    String name;
    String gender;
    String email;
    String address;
    String province;
    String city;
    String district;
    String rekening;
    String bank;

    void _pilihprovinsi(BuildContext context) async {
    final ListProvinsi provinsi = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProvinsiSending(),
        ));
    setState(() {
      selectedProvinsi = provinsi;
      selectedKabupaten = null;
    });
  }
  
    void _pilihkabupaten(BuildContext context) async {
    final ListKabupaten kabupaten = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KabupatenSending(provinsi: selectedProvinsi),
        ));
    setState(() {
      selectedKabupaten = kabupaten;
      selectedkecamatan = null;
    });
  }

  void _pilihkecamatan(BuildContext context) async {
    final ListKecamatan kecamatan = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                KecamatanSending(kabupaten: selectedKabupaten)));
    setState(() {
      selectedkecamatan = kecamatan;
    });
  }

    _EditProfile({Key key , this.id , this.name , this.gender , this.email , this.address , this.province , this.city , this.district , this.bank , this.rekening});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Profile'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(43, 204, 86, 1),
                ),
                child: Column(
                  children: <Widget>[

                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  } 
}
