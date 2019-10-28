import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/Navigator.dart';
import 'storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'utils/utils.dart';
import 'utils/items.dart';
import 'pages/shops/bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/pages/shops/category_item.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  Color _isPressed = Colors.grey;
  int PAGE_SIZE = 6;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController;

  String _username;

  Future<Null> RemoveSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
    _username = await dataStore.getDataString("username");
    print(_username);
  }

  List category;

  Future<String> getCategory() async {
    var response = await http.get(
        Uri.encodeFull("http://192.168.100.27/warungislamibogor_shop/api/listKategoriAndroid"),
        headers: {
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjY1MTFjYmNlM2I4Nzg1ZGNkNmU3NDY4OTAxYThhYWUwMTNjM2UxZmY0YjhkNDAyMDFkM2JiODZmYWFhMjQ4ZTA5NDdkOWE3YTVmYjZhNmI1In0.eyJhdWQiOiIyIiwianRpIjoiNjUxMWNiY2UzYjg3ODVkY2Q2ZTc0Njg5MDFhOGFhZTAxM2MzZTFmZjRiOGQ0MDIwMWQzYmI4NmZhYWEyNDhlMDk0N2Q5YTdhNWZiNmE2YjUiLCJpYXQiOjE1NzE3OTc2NTksIm5iZiI6MTU3MTc5NzY1OSwiZXhwIjoxNjAzNDIwMDU4LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.TfBOgh4nwlEw3UGADLn02mlB-BmX-k8_s1iGiCR809iD1iMFYOf7RTHQc5SrghM7XCK51tS-6lGZ2IaMQ41RGBvqSpylwibuZTiktcq1yPxT_TieGKRkdnx-CnOpgCFRct7mM3ylcWxzK8jlm1EyAtaay4zYeSolRQlWoS9Vz050114ncAvQWmS0GJ9JF0Zjti6yd3tl9I69bnkB1B7I9YB24CSkJDxOR6C4pjiVW4Ew6RL0JYTMFgEUf0liz_twR2uULUUPPDaMB0uhAtPsG7-cAaeZv8BKmMGjVenyIDJyLVqT1-4lUTxDgJIUXSM_IfzgoMfgILznDhD6dKv1l9gm0kHJkgcdu9sKTEpxoR7lEs7UopeKzKFnHbNDkrECwlBudeyKdkMZ-TCLjDZOK5CfTXNmInPZY_fO9eFKvj52jGd9rH2TSdNLoiiGSPrZL3dCZhePPAyAJPCX2CGO3vY6bRv91O2hDAsmqHakQjS7oRiwd9CE-MpR_K11noP0vqlgq26alKNfOtH74MVayF0Os_2PVtmrfaBcbaKw7bQlBhaT08SWQBS3W5Yxt4lYquc04l9upMjgkZ4cwl-mle86DA-6PZNT7AOnql4sTVSxcd9i-8SfPBbIMS0jS33Gb03Cpb72y90fVMiMAWx2v1lk0f-ndjWogdujw_dGEjs"
        }
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    print(category[1]["ity_code"]);

    return "Success!";
  }

  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/20/20723472/20723472_3d762d15-da3d-41df-a07e-d6c04e29fe74.jpg',
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/20/20723472/20723472_0fe98b01-15fd-4137-8f9b-733fd7c124d5.jpg',
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/20/20723472/20723472_74240718-338b-4684-9a8e-23ccf918d78a.jpg',
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/21/20723472/20723472_cb378008-4d45-4f88-a440-44ac7faf5a2b.jpg',
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int totalRefresh = 0;
  refreshFunction() async {
    setState(() {
      totalRefresh += 1;
    });
  }

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 4);
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ShopBloc>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Profil Drawer Here
              UserAccountsDrawerHeader(
                // Below this my gf name :))))), jk
                accountName: Text('Kim Jisoo'),
                accountEmail: Text('Jisoocu@gmail.com'),
                // This how you set profil image in sidebar
                // Remeber to add image first in pubspec.yaml
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('images/jisoocu.jpg'),
                ),
                // This how you set color in top of sidebar
                decoration: BoxDecoration(
                  color: Color(0xff31B057),
                ),
              ),
              //  Menu Section Here
              ListTile(
                title: Text(
                  'Tracking',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    color: Color(0xff25282b),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/tracking_list");
                },
              ),
              ListTile(
                title: Text(
                  'Repeat Order',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    color: Color(0xff25282b),
                  ),
                ),
                onTap: () {
                  MyNavigator.goToRepeatOrder(context);
                },
              ),
              ListTile(
                title: Text(
                  'Shop',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    color: Color(0xff25282b),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/home");
                },
              ),
              ListTile(
                title: Text(
                  'Test',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    color: Color(0xff25282b),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/test");
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    color: Color(0xff25282b),
                  ),
                ),
                onTap: () {
                  RemoveSharedPrefs();
                  Navigator.pushReplacementNamed(context, "/login");
                },
              ),
            ],
          ),
        ),
        // Body Section Here
        body: RefreshIndicator(
          onRefresh: () => refreshFunction(),
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/background.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        height: 60.0,
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 60.0,
                                width: 220.0,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                    topLeft: Radius.circular(5.0),
                                  ),
                                ),
                                child: TextField(
                                  style: TextStyle(fontFamily: 'Roboto'),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 11.0),
                                    hintText: "Cari Sekarang!",
                                    hintStyle:
                                    TextStyle(fontFamily: 'Roboto'),
                                    prefixIcon: Icon(
                                      CupertinoIcons.search,
                                      color: HexColor('#7f8c8d'),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        MyNavigator.goWishlist(context);
                                      },
                                      icon: Icon(Icons.favorite),
                                      color: Colors.white,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        MyNavigator.goKeranjang(context);
                                      },
                                      icon: Icon(Icons.shopping_cart),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                // IconButton(
                                //   icon: Icon(Icons.print),
                                //   onPressed: () {
                                //     print(
                                //         'width ${MediaQuery.of(context).size.width}');
                                //     print(
                                //         'height ${MediaQuery.of(context).size.height}');
                                //   },
                                // )
                              ],
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: carouselSlider = CarouselSlider(
                        height: 100.0,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        reverse: false,
                        enableInfiniteScroll: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration: Duration(milliseconds: 2000),
                        pauseAutoPlayOnTouch: Duration(seconds: 10),
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index) {
                          setState(() {
                            _current = index;
                          });
                        },
                        items: imgList.map((imgUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[500],
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: new ClipRRect(
                                    borderRadius: new BorderRadius.circular(8.0),
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 38.0, top: 158.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: map<Widget>(imgList, (index, url) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Colors.yellowAccent
                                  : Colors.grey[300],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Rekomendasi Produk", style: TextStyle(fontSize: 21.0, fontFamily: 'Roboto'),),
                      Text("Lihat Semua", style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto', color: Color(0xff31B057)),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 20, bottom: 10.0),
                  height: 175,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            0.1,
                            0.4,
                            0.6,
                            0.9
                          ],
                          colors: [Colors.white, Colors.white, Colors.white, Colors.grey[100]])
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    primary: false,
                    itemCount: items == null ? 0 : items.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map item = items.reversed.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 168.0,
                          child: Card(
                            elevation: 0.0,
                            child: InkWell(
//                      color: Colors.green,
                                child: Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "${item["img"]}",
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${item["name"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${item["desc"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.grey[400],
                                        ),
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "/details");
                                }
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Belanja Sekarang!", style: TextStyle(fontSize: 21.0, fontFamily: 'Roboto'),),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 20, bottom: 10.0),
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          primary: false,
                          itemCount: category == null ? 0 : category.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10 ,bottom: 5.0),
                              child: Container(
                                  height: 50.0,
                                  child: OutlineButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryItem(
                                              id: category[index]["ity_id"].toString(),
                                              category: category[index]["ity_name"],
                                              category_id: category[index]["ity_code"].toString(),
                                        ),
                                        )
                                      );
                                    },
                                    child: Text(category[index]["ity_name"], style: TextStyle(color: Color(0xff31B057)),),
                                    borderSide: BorderSide(
                                      color: Color(0xff31B057),
                                      style: BorderStyle.solid,
                                      width: 0.8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(18.0),
                                    ),
                                  )
                              ),
                            );
                          },
                        ),
                      ),
                      PagewiseGridView.count(
                        pageSize: PAGE_SIZE,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 5.0,
                        childAspectRatio: 0.7,
                        itemBuilder: this._itemBuilder,
                        pageFuture: (pageIndex) =>
                            BackendService.getData(pageIndex, PAGE_SIZE),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
          bottomNavigationBar:BottomNavigationBar(
            type: BottomNavigationBarType.shifting ,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xff31B057),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,),
                  title: new Text('Shop'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.repeat,),
                  title: new Text('Repeat Order')
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map,),
                  title: new Text('Tracking')
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person,),
                  title: new Text('Profile')
              )
            ],
          )
      ),
    );
  }

  Widget _itemBuilder(context, ProductModel entry, _) {
    return Card(
      elevation: 0.0,
      child: InkWell(
        child: Container(
//                            color: Colors.red,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
//                                  clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      "images/botol.png",
                      fit: BoxFit.cover,
                      height: 150.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                      top: 5.0,
                      left: 108.0,
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: new IconButton(
                          icon: Icon(Icons.favorite, color: _isPressed),
                          onPressed: () {
                            setState(() {
                              _isPressed = Colors.pink[400];
                            });
                          },
                        ),
                      )
                  ),
                ],
              ),
              // SizedBox(width: 15),
              Padding(
                padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                child: Container(
                  width:
                  MediaQuery.of(context).size.width - 130,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          entry.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          entry.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.deepOrange
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 3),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          entry.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, "/details");
        },
      ),
    );                                                                                                                    
  }
}

class BackendService {
  static Future<List<ProductModel>> getData(index, limit) async {
    final responseBody = await http.get(
        Uri.encodeFull("http://192.168.100.27/warungislamibogor_shop/api/produk_beranda_android?_limit=$limit"),
        headers: {
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjY1MTFjYmNlM2I4Nzg1ZGNkNmU3NDY4OTAxYThhYWUwMTNjM2UxZmY0YjhkNDAyMDFkM2JiODZmYWFhMjQ4ZTA5NDdkOWE3YTVmYjZhNmI1In0.eyJhdWQiOiIyIiwianRpIjoiNjUxMWNiY2UzYjg3ODVkY2Q2ZTc0Njg5MDFhOGFhZTAxM2MzZTFmZjRiOGQ0MDIwMWQzYmI4NmZhYWEyNDhlMDk0N2Q5YTdhNWZiNmE2YjUiLCJpYXQiOjE1NzE3OTc2NTksIm5iZiI6MTU3MTc5NzY1OSwiZXhwIjoxNjAzNDIwMDU4LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.TfBOgh4nwlEw3UGADLn02mlB-BmX-k8_s1iGiCR809iD1iMFYOf7RTHQc5SrghM7XCK51tS-6lGZ2IaMQ41RGBvqSpylwibuZTiktcq1yPxT_TieGKRkdnx-CnOpgCFRct7mM3ylcWxzK8jlm1EyAtaay4zYeSolRQlWoS9Vz050114ncAvQWmS0GJ9JF0Zjti6yd3tl9I69bnkB1B7I9YB24CSkJDxOR6C4pjiVW4Ew6RL0JYTMFgEUf0liz_twR2uULUUPPDaMB0uhAtPsG7-cAaeZv8BKmMGjVenyIDJyLVqT1-4lUTxDgJIUXSM_IfzgoMfgILznDhD6dKv1l9gm0kHJkgcdu9sKTEpxoR7lEs7UopeKzKFnHbNDkrECwlBudeyKdkMZ-TCLjDZOK5CfTXNmInPZY_fO9eFKvj52jGd9rH2TSdNLoiiGSPrZL3dCZhePPAyAJPCX2CGO3vY6bRv91O2hDAsmqHakQjS7oRiwd9CE-MpR_K11noP0vqlgq26alKNfOtH74MVayF0Os_2PVtmrfaBcbaKw7bQlBhaT08SWQBS3W5Yxt4lYquc04l9upMjgkZ4cwl-mle86DA-6PZNT7AOnql4sTVSxcd9i-8SfPBbIMS0jS33Gb03Cpb72y90fVMiMAWx2v1lk0f-ndjWogdujw_dGEjs"
        }
    );

    var data = json.decode(responseBody.body);
    var product = data['semuaitem'];

    return ProductModel.fromJsonList(product);
  }
}

class ProductModel {
  String title;
  String id;

  ProductModel.fromJson(obj) {
    this.title = obj['i_name'];
    this.id = obj['ipr_sunitprice'];
  }

  static List<ProductModel> fromJsonList(jsonList) {
    return jsonList.map<ProductModel>((obj) => ProductModel.fromJson(obj)).toList();
  }
}

