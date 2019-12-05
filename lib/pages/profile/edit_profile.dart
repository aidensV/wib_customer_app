import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/env.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';
// import 'package:wib_customer_app/env.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:wib_customer_app/pages/checkout/checkout.dart';
import 'package:wib_customer_app/pages/checkout/model.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'listkabupaten.dart';
import '../checkout/listkecamatan.dart';
import '../checkout/listprovinsi.dart';

var _khususedit_profile;
var datepickerfirst;
ListProvinsi selectedProvinsi;
ListKabupaten selectedKabupaten;
ListKecamatan selectedkecamatan;
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
String imageprofile;
bool loading;

class EditProfile extends StatefulWidget{
    @override
    _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile>{

  void modalkeluar(String value) {
    _khususedit_profile.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  TextEditingController namacontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController addresscontroller = new TextEditingController();
  TextEditingController rekeningcontroller = new TextEditingController();
  TextEditingController bankcontroller = new TextEditingController();
  TextEditingController postalcodecontroller = new TextEditingController();
  TextEditingController phonecontroller = new TextEditingController();
  TextEditingController tempatlahircontroller = new TextEditingController();
    bool back = false;
    var _id;
    var _user;
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

    void _pilihprovinsi(BuildContext context) async {
    final ListProvinsi provinsi = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProvinsiSending(),
        ));
    setState(() {
      selectedProvinsi = provinsi;
      namakota = 'Pilih Kabupaten';
      namadesa = 'Pilih Kecamatan';
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
      namadesa = 'Pilih Kecamatan';
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
      bank = await storage.getDataString("bank") == 'Tidak ditemukan' ? '' : await storage.getDataString("bank");
      rekening = await storage.getDataString("nbank") == 'Tidak ditemukan' ? '' : await storage.getDataString("nbank");
      postal = await storage.getDataString("postalcode") == 'Tidak ditemukan' ? '' : await storage.getDataString("postalcode");
      tempatlahir = await storage.getDataString("tempatlahir") == 'Tidak ditemukan' ? '' : await storage.getDataString("tempatlahir");
      namaprovinsi = await storage.getDataString("namaprovinsi") == 'Tidak ditemukan' ? 'Pilih Provinsi' : await storage.getDataString("namaprovinsi");
      namakota = await storage.getDataString("namakota") == 'Tidak ditemukan' ? 'Pilih Kabupaten' : await storage.getDataString("namakota");
      namadesa = await storage.getDataString("namadesa") == 'Tidak ditemukan' ? 'Pilih Kecamatan' : await storage.getDataString("namadesa");
      lahir = await storage.getDataString("lahir") == 'Tidak ditemukan' ? '0000-00-00 00:00:00.000' : await storage.getDataString("lahir") ;
      _id = await storage.getDataInteger("id");
      _user = await storage.getDataString("username");
      // imageprofile = await storage.getDataString('image');
      
      namacontroller = TextEditingController(text: name);
      emailcontroller = TextEditingController(text: email);
      addresscontroller = TextEditingController(text: address);
      rekeningcontroller = TextEditingController(text: rekening);
      bankcontroller =  TextEditingController(text: bank);
      postalcodecontroller = TextEditingController(text: postal);
      phonecontroller = TextEditingController(text: phone);
      tempatlahircontroller = TextEditingController(text: tempatlahir);
      print(gender);
      print(bank);
      print(lahir);

      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';
      setState(() {
        
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
              await http.get("https://warungislamibogor-store.alamraya.site/api/getDataUser", headers: requestHeaders);
          // print('getUser ' + getUser.body);

          if (getUser.statusCode == 200) {
            dynamic datauser = json.decode(getUser.body);

            DataStore store = new DataStore();

            // store.setDataInteger("user_id", int.parse(datajson['user']["u_id"]));
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

            print(datauser);
            // print('statement else is true');
            // print(datauser);
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

    var request = new http.MultipartRequest("POST", urlpath('api/updateprofileAndroid'));
  // print(imageFile);
  if(imageFile != null){
      var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var kirimfile = new http.MultipartFile("gambar", stream, length,
        filename: basename(imageFile.path));
    request.files.add(kirimfile);
  } 
    request.headers.addAll(headers);
    request.fields['email'] = emailcontroller.text ;
    request.fields['nohp'] = phonecontroller.text ;
    // request.fields['kabupaten'] = selectedKabupaten != null ? selectedKabupaten.id.toString() : ''  ;
    // request.fields['provinsi'] = selectedProvinsi != null ? selectedProvinsi.id.toString() : '' ;
    // request.fields['kecamatan'] = selectedkecamatan != null ? selectedkecamatan.id.toString() : '' ;
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
    if (response.statusCode == 200) {
      if (resp['error'] != null) {
        print((resp['error']).toString());
        setState(() {
          loading = false;
        });
      } else {
        getdata(context);
        print('Berhasil');
        setState(() {
          loading = false;
        });
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
    _image = null;
    gender = '' ;
    getheader();
    _khususedit_profile = GlobalKey<ScaffoldState>();
    datepickerfirst = FocusNode();
    loading  = false;
    super.initState();
    back = false;
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _khususedit_profile,
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
                    _image == null ? Card(
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
                                      child : Image.file(_image),
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
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                getimagecamera();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(45, 204, 91, 1),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                width: MediaQuery.of(context).size.width * 0.40,
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

                            InkWell(
                              onTap: (){
                                getimagegallery();
                              },
                              child : Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(45, 204, 91, 1),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                width: MediaQuery.of(context).size.width * 0.40,
                                padding: EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 20.0),
                                  child:Text(
                                    'Ambil Galery',
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
                        title: TextField(
                          controller: namacontroller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                          ),
                        ),
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

                              gender == 'L' ? print('laki - Laki') : gender == 'P' ? print('Perempuan') : '';
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
                        title: DateTimePickerFormField(
                          dateOnly: true,
                          focusNode: datepickerfirst,
                          inputType: InputType.date,
                          initialValue: lahir == null || lahir == '0000-00-00 00:00:00.000' ? null : DateTime.parse(lahir),
                          editable: false,
                          format: DateFormat('dd-MM-y'),
                          decoration: InputDecoration(
                            hintText:  'Tanggal Awal',
                          ),
                          // resetIcon: FontAwesomeIcons.times,
                          onChanged: (ini) {
                            setState(() {
                              lahir = ini == null ? null : ini.toString();
                            });
                          },
                          autofocus: false,
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
                        title: Text( selectedProvinsi != null ? selectedProvinsi.nama : namaprovinsi),
                        onTap: () { 
                            _pilihprovinsi(context);
                        },
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: Icon(Icons.create, color: Colors.green),
                        title: Text(selectedKabupaten != null ? selectedKabupaten.nama : namakota),
                        onTap: () {
                          _pilihkabupaten(context);
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.create, color: Colors.green),
                        title: Text( selectedkecamatan != null ? selectedkecamatan.nama : namadesa),
                        onTap: () {
                            _pilihkecamatan(context);
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
                          value: bank == null ? '' : bank,
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
                        upload(_image,context);
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
