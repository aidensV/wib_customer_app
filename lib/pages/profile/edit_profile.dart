import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/env.dart' as env;
import 'package:http/http.dart' as http;

// import 'package:wib_customer_app/env.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:wib_customer_app/pages/checkout/model.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'listkabupaten.dart';
import '../checkout/listkecamatan.dart';
import '../checkout/listprovinsi.dart';
import 'imagecropper.dart';

GlobalKey<ScaffoldState> khususeditprofile;
var datepickerfirst;
ListProvinsi selectedProvinsi;
ListKabupaten selectedKabupaten;
ListKecamatan selectedkecamatan;
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
String imageprofile;
bool loading;
String nameX;
var lahirX;
File image;

class EditProfile extends StatefulWidget{
    @override
    _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile>{

  void modalkeluar(String value) {
    khususeditprofile.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController addresscontroller = new TextEditingController();
  TextEditingController rekeningcontroller = new TextEditingController();
  TextEditingController bankcontroller = new TextEditingController();
  TextEditingController postalcodecontroller = new TextEditingController();
  TextEditingController phonecontroller = new TextEditingController();
  TextEditingController tempatlahircontroller = new TextEditingController();
    bool back = false;
    String name;
    String gender;
    String phone;
    String email;
    String address;
    String province;
    String city;
    String district;
    String rekening;
    String bank;
    String postal;
    String lahir;
    String tempatlahir;
    String namaprovinsi;
    String namakota;
    String namadesa;
    String idprovinsi;
    String idkota;
    String idkecamatan;

    void _pilihprovinsi(BuildContext context) async {
    final ListProvinsi provinsi = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProvinsiSending(),
        ));
    setState(() {
      selectedProvinsi = provinsi;
      selectedKabupaten = null;
      selectedkecamatan = null;
    });
  }
  void showInSnackBar(String value) {
    khususeditprofile.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
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

  File _image;

  Future getimagegallery() async {
    _image = null;
    var imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = imagefile;
    if(_image != null){
      modalkeluar('Gambar Telah Dipilih');
    }
    setState(() {
      
    });
  }

  Future getimagecamera() async {
    _image = null;
    var imagefile = await ImagePicker.pickImage(source: ImageSource.camera);

    _image = imagefile;
    if(_image != null){
      modalkeluar('Gambar Telah Dipilih');
    }
    setState(() {
      
    });
  }

  Future<Null> getheader() async {
    try {
      var storage = new DataStore();
      name = await storage.getDataString("name") == 'Tidak ditemukan' ? '' : await storage.getDataString("name");
      email = await storage.getDataString("email") == 'Tidak ditemukan' ? '' : await storage.getDataString("email");
      gender = await storage.getDataString("gender") == 'Tidak ditemukan' ? '' : await storage.getDataString("gender");
      phone = await storage.getDataString("phone") == 'Tidak ditemukan' ? '' : await storage.getDataString("phone");
      address = await storage.getDataString("alamat") == 'Tidak ditemukan' ? '' : await storage.getDataString("alamat");
      province = await storage.getDataString("province") == 'Tidak ditemukan' ? '' : await storage.getDataString("province");
      city = await storage.getDataString("city") == 'Tidak ditemukan' ? '' : await storage.getDataString("city");
      district = await storage.getDataString("district") == 'Tidak ditemukan' ? '' : await storage.getDataString("district");
      bank = await storage.getDataString("bank") == 'Tidak ditemukan' ? null : await storage.getDataString("bank");
      rekening = await storage.getDataString("nbank") == 'Tidak ditemukan' ? '' : await storage.getDataString("nbank");
      postal = await storage.getDataString("postalcode") == 'Tidak ditemukan' ? '' : await storage.getDataString("postalcode");
      tempatlahir = await storage.getDataString("tempatlahir") == 'Tidak ditemukan' ? '' : await storage.getDataString("tempatlahir");
      namaprovinsi = await storage.getDataString("namaprovinsi") == 'Tidak ditemukan' ? 'Pilih Provinsi' : await storage.getDataString("namaprovinsi");
      namakota = await storage.getDataString("namakota") == 'Tidak ditemukan' ? 'Pilih Kabupaten' : await storage.getDataString("namakota");
      namadesa = await storage.getDataString("namadesa") == 'Tidak ditemukan' ? 'Pilih Kecamatan' : await storage.getDataString("namadesa");
      idprovinsi = await storage.getDataString("idprovinsi") == 'Tidak ditemukan' ? null : await storage.getDataString("idprovinsi");
      idkota = await storage.getDataString("idkota") == 'Tidak ditemukan' ? null : await storage.getDataString("idkota");
      idkecamatan = await storage.getDataString("idkecamatan") == 'Tidak ditemukan' ? null : await storage.getDataString("idkecamatan");
      lahir = await storage.getDataString("lahir") == 'Tidak ditemukan' ? null : await storage.getDataString("lahir") ;
      // imageprofile = await storage.getDataString('image');
      emailcontroller = TextEditingController(text: email);
      addresscontroller = TextEditingController(text: address);
      rekeningcontroller = TextEditingController(text: rekening);
      bankcontroller =  TextEditingController(text: bank);
      postalcodecontroller = TextEditingController(text: postal);
      phonecontroller = TextEditingController(text: phone);
      tempatlahircontroller = TextEditingController(text: tempatlahir);

      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';
      print(lahir);
      setState(() {
        nameX = name;
        lahirX = lahir;
        selectedProvinsi = ListProvinsi(
            id: idprovinsi,
            nama: namaprovinsi,
        );
        selectedKabupaten = ListKabupaten(
            id: idkota,
            nama: namakota,
          );
          selectedkecamatan =
              ListKecamatan(id: idkecamatan, nama: namadesa);
      });
    } on TimeoutException catch (_) {} catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  void getdata(BuildContext context) async {
      var storage = new DataStore();
      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';
      
        try {
          final getUser =
              await http.get(env.url("api/getDataUser"), headers: requestHeaders);

          if (getUser.statusCode == 200) {
            dynamic datauser = json.decode(getUser.body);

            DataStore store = new DataStore();
            store.setDataInteger("id", datauser['cm_id']);
            store.setDataString("username", datauser['cm_username']);
            store.setDataString("name", datauser['cm_name']);
            store.setDataString("email", datauser['cm_email']);
            store.setDataString("image", datauser['cm_path']);
            store.setDataString("gender", datauser['cm_gender']);
            store.setDataString("phone", datauser['cm_nphone']);
            store.setDataString("alamat", datauser['cm_address']);
            store.setDataString("province", datauser['cm_province']);
            store.setDataString("city", datauser['cm_city']);
            store.setDataString("district", datauser['cm_district']);
            store.setDataString("nbank", datauser['cm_nbank']);
            store.setDataString("bank", datauser['cm_bank']);
            store.setDataString("postalcode", datauser['cm_postalcode']);
            store.setDataString("tempatlahir", datauser['cm_cityborn']);
            store.setDataString("lahir", datauser['cm_born']);
            store.setDataString("namaprovinsi", datauser['p_nama']);
            store.setDataString("namakota", datauser['c_nama']);
            store.setDataString("namadesa", datauser['d_nama']);
            store.setDataString("idprovinsi", datauser['cm_province']);
            store.setDataString("idkota", datauser['cm_city']);
            store.setDataString("idkecamatan", datauser['cm_district']);

            print(datauser);
            setState(() {
              back = true;            
            });
          } else {
            modalkeluar('Request failed with status: ${getUser.statusCode}');
          }
        } on SocketException catch (_) {
          modalkeluar('Connection Timed Out');
        } catch (e) {
          print(e);
          // modalkeluar(e);
        }
      }

  Future upload(File imageFile, BuildContext context) async {
    setState(() {
    loading = true;      
    });
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');
    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    Map<String, String> headers = requestHeaders;

    var request = new http.MultipartRequest("POST", env.urlpath('api/updateprofileAndroid'));
  // print(imageFile);
    request.headers.addAll(headers);
  if(imageFile != null){
    request.fields['gambar'] = base64Encode(imageFile.readAsBytesSync());
  } 
    request.fields['email'] = emailcontroller.text ;
    request.fields['nohp'] = phonecontroller.text ;
    request.fields['kabupaten'] = selectedKabupaten != null ? selectedKabupaten.id : null  ;
    request.fields['provinsi'] = selectedProvinsi != null ? selectedProvinsi.id : null ;
    request.fields['kecamatan'] = selectedkecamatan != null ? selectedkecamatan.id : null ;
    request.fields['address'] = addresscontroller.text ;
    request.fields['gender'] = gender.toString() ;
    request.fields['kodepos'] = postalcodecontroller.text ;
    request.fields['bank'] = bank.toString() ;
    request.fields['nbank'] = rekeningcontroller.text ;
    request.fields['tampat_lahir'] = tempatlahircontroller.text ;
    request.fields['tanggal_lahir'] = lahir;
    var response = await request.send();
    print(response.statusCode);
    final respStr = await response.stream.bytesToString();
    var resp = json.decode(respStr);
    // modalkeluar('$respStr');
    if (response.statusCode == 200) {
      if (resp['error'] != null) {
        print((resp['error']).toString());
        setState(() {
          loading = false;
        });
        modalkeluar(resp['error'].toString());
      } else {
        getdata(context);
        print('Berhasil');
        setState(() {
          loading = false;
        });
        modalkeluar('Berhasil Pengubah Profile');
      }
      setState(() {
        loading = false;      
      });
    } else {
      setState(() {
        loading = false;      
      });
      var i = response.statusCode;
      print(resp);
      print('gambar gagal di upload code $i');
    }
  }

  @override
  void initState() {
    image = null;
    gender = '' ;
    getheader();
    nameX = 'Nama';
    lahirX = null;
    selectedProvinsi = null;
    selectedKabupaten = null;
    selectedkecamatan = null;
    khususeditprofile = GlobalKey<ScaffoldState>();
    datepickerfirst = FocusNode();
    loading  = false;
    super.initState();
    back = false;
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: khususeditprofile,
      appBar: loading ? null : AppBar(
        title: Text('Ubah Profile'),
        backgroundColor: Color.fromRGBO(43, 204, 86, 1),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            child: SafeArea(
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.80,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    image == null ? Card(
                      elevation: 0.0,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                             Center(child: Text('Tidak Ada gambar'),) 
                          ],
                        ),
                      ),
                    ) : Container(
                          decoration: new BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                          ),
                          width: double.infinity,
                          // height: MediaQuery.of(context).size.height * 0.80,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 300,
                                decoration: new BoxDecoration(
                                  color: Colors.green,
                                  // image: new DecorationImage(
                                  //   fit: BoxFit.cover,
                                  //   image: new AssetImage('images/jisoocu.jpg'),
                                  // ),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      height: 300,
                                      child : Image.file(image),
                                    ),

                                    Container(
                                      width: double.infinity,
                                      height: 300,
                                      decoration: new BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                    Card(
                      elevation: 0.0,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                // getimagecamera();
                                File imageX = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        settings: RouteSettings(
                                            name: '/ambil_gambar'),
                                        builder: (BuildContext context) =>
                                            AmbilGambar(
                                          title: 'Ambil Gambar',
                                        ),
                                      ),
                                    );

                                    if (imageX != null) {
                                      setState(() {
                                        image = imageX;
                                      });
                                    }
                              },
                              child: Container(
                                // margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(45, 204, 91, 1),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 20.0),
                                  child:Text(
                                    'Ambil Gambar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.green),
                        title: Text(nameX),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(Icons.mail, color: Colors.green),
                        title: TextField(
                          controller: emailcontroller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(Icons.phone_android, color: Colors.green),
                        title: TextField(
                          controller: phonecontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nomor Telepon',
                          ),
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.venusMars, color: Colors.green),
                        title: DropdownButton<String>(
                          value: gender == 'L' ? 'Laki - Laki' : (gender == 'P' ? 'Perempuan' : ''),
                          hint: Text('Pilih Jenis kelamin'),
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (String newValue) {
                            setState(() {
                              print(newValue);
                              if(newValue == 'Laki - Laki'){
                                gender = 'L';
                              }else if(newValue == 'Perempuan'){
                                gender = 'P';
                              }

                              gender == 'L' ? print('laki - Laki') : gender == 'P' ? print('Perempuan') : print('');
                            });
                          },
                          items: <String>['','Laki - Laki', 'Perempuan']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.green),
                        title: DateTimeField(
                                readOnly: true,
                                format: DateFormat('dd-MM-yyy'),
                                  initialValue:lahirX == null ? DateTime.now() :  DateTime.parse(lahirX),
                                  decoration: InputDecoration(
                                    hintText: 'Tanggal Lahir',
                                    hintStyle: TextStyle(fontSize: 13, color: Colors.black),
                                  ),
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      firstDate: DateTime(1900),
                                      context: context,
                                      initialDate: lahirX == null ? DateTime.now() :  DateTime.parse(lahirX),
                                      lastDate: DateTime(2100));
                                },
                                onChanged: (ini) {
                                  setState(() {
                                          lahir = ini == null ? null : ini.toString();
                                  });
                                },
                              ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.baby, color: Colors.green),
                        title: TextField(
                          controller: tempatlahircontroller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Tempat Lahir',
                          ),
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(Icons.home, color: Colors.green),
                        title: TextField(
                          controller: addresscontroller,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Alamat',
                          ),
                        ),
                      ),
                    ),
                    
                    
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.create, color: Colors.green),
                        title: Text(selectedProvinsi == null ? 'Pilih Provinsi' : selectedProvinsi.nama),
                        onTap: () { 
                            _pilihprovinsi(context);
                        },
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(Icons.create, color: Colors.green),
                        title: Text(selectedKabupaten == null ? 'Pilih Kabupaten' : selectedKabupaten.nama),
                        onTap: () {
                          if(selectedProvinsi == null){
                            showInSnackBar('Silahkan pilih provinsi terlebih dahulu');
                          }else{
                            _pilihkabupaten(context);
                          }
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.create, color: Colors.green),
                        title: Text( selectedkecamatan == null ? 'Pilih Kecamatan' : selectedkecamatan.nama),
                        onTap: () {
                          if(selectedKabupaten == null){
                            showInSnackBar('Silahkan pilih kabupaten terlebih dahulu');
                          }else{
                            _pilihkecamatan(context);
                          }
                        },
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.mapMarked, color: Colors.green),
                        title: TextField(
                          controller: postalcodecontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Kode Pos',
                          ),
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.moneyBillAlt, color: Colors.green),
                        title: DropdownButton<String>(
                          value: bank,
                          hint: Text('Pilih Bank'),
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (String newValue) {
                            setState(() {
                              bank = newValue;
                            });
                          },
                          items: <String>['BCA', 'BNI','BTN','BRI']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    

                    Card(
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.moneyBill, color: Colors.green),
                        title: TextField(
                          controller: rekeningcontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nomor Rekening',
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        upload(image,context);
                        if(back == true){
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child :Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(45, 204, 91, 1),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            width: MediaQuery.of(context).size.width * 0.50,
                            padding: EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 20.0),
                            child:Text(
                              'Ubah Data',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                        ) ,
                      ),
                    ),
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
