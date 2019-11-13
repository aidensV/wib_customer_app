import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
// import 'package:provider/provider.dart';
import 'package:wib_customer_app/cari_produk/cari_produk.dart';
import 'package:wib_customer_app/pages/profile/profile.dart';
import 'package:wib_customer_app/saldo.dart';
import 'utils/Navigator.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/pages/shops/category_item.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'pages/shops/product_detail.dart';
import 'pages/wishlist/wishlist.dart';
import 'pages/shopping_cart/shoppingcart.dart';

bool bottom;
String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
List<ListBanner> listBanner = [];
bool isLoading;
int pageSize = 6;


ScrollController scrollController = ScrollController(initialScrollOffset: 0.0);

bool isScrolled;
int red, green, blue;
double opacity, maxOffsetToColor;

GlobalKey<ScaffoldState> _scaffoldKeyDashboard;

showInSnackBarDashboard(String content) {
  _scaffoldKeyDashboard.currentState.showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  TabController tabController;

  PageController pageController;

  String _username;
  String usernameprofile, emailprofile, imageprofile;

  final List<Widget> _children = [
    null,
    Saldo(),
    ProfilePage(),
  ];

  int _currentIndex = 0;
  void onTabTapped(int index) {
     _currentIndex = index;
   setState(() {
   });
 }

  Future<Null> removeSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
    _username = await dataStore.getDataString("username");
    print(_username);
  }

  List category;

  Future<void> getCategory() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';
    print(requestHeaders);
    try {
      final response = await http.get(
        url('api/listKategoriAndroid'),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        this.setState(() {
          category = json.decode(response.body);
        });
      } else if (response.statusCode == 401) {}

      print(category[1]["ity_code"]);

      return "Success!";
    } catch (e) {
      print('Error : $e');
    }
  }

  Future<void> dataProfile() async {
    var storage = new DataStore();

    usernameprofile = await storage.getDataString("username");
    emailprofile = await storage.getDataString('email');
    imageprofile = await storage.getDataString('image');
  }

  Future<List<ListBanner>> listBannerAndroid() async {
    try {
      var storage = new DataStore();

      var tokenTypeStorage = await storage.getDataString('token_type');
      var accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';
      setState(() {
        isLoading = true;
      });
      final banner = await http.get(
        url('api/produk_beranda_android'),
        headers: requestHeaders,
      );

      if (banner.statusCode == 200) {
        // return nota;
        var bannerJson = json.decode(banner.body);
        var banners = bannerJson['banner'];

        print('Banner $banners');

        listBanner = [];
        for (var i in banners) {
          ListBanner bannerx = ListBanner(
            idbanner: '${i['b_id']}',
            banner: i['b_image'],
          );
          listBanner.add(bannerx);
        }
        setState(() {
          isLoading = false;
        });
        return listBanner;
      } else if (banner.statusCode == 401) {
        showInSnackBarProduk('Token kedaluwarsa, silahkan login kembali');
      } else {
        showInSnackBarProduk('Error Code : ${banner.statusCode}');
      }
    } on TimeoutException catch (_) {
      showInSnackBarProduk('Request Timeout, try again');
    } catch (e) {
      print('Error : $e');
    }
    return null;
  }

  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [];

  List<T> map<T>(List listBanner, Function handler) {
    List<T> result = [];
    for (var i = 0; i < listBanner.length; i++) {
      result.add(handler(i, listBanner[i]));
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
    _scaffoldKeyDashboard = GlobalKey<ScaffoldState>();
    listBannerAndroid();
    scrollController = ScrollController(initialScrollOffset: 0.0);
    isScrolled = false;
    red = 255;
    green = 255;
    blue = 255;
    opacity = 0.0;
    maxOffsetToColor = 0.0;
    tabController = TabController(vsync: this, length: 4);
    getCategory();
    isLoading = false;
    dataProfile();
    print(requestHeaders);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKeyDashboard,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Profil Drawer Here
              UserAccountsDrawerHeader(
                // Below this my gf name :))))), jk
                accountName: Text(
                    usernameprofile == null ? 'Nama Lengkap' : usernameprofile),
                accountEmail:
                    Text(emailprofile == null ? 'Email Anda' : emailprofile),
                // This how you set profil image in sidebar
                // Remeber to add image first in pubspec.yaml
                currentAccountPicture: CircleAvatar(
                  backgroundImage: imageprofile != null
                      ? AssetImage('images/jisoocu.jpg')
                      : AssetImage('images/jisoocu.jpg'),
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
                  removeSharedPrefs();
                  Navigator.pushReplacementNamed(context, "/login");
                },
              ),
            ],
          ),
        ),
        // Body Section Here
        body: _currentIndex == 0 ? SafeArea(
          child: Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () => refreshFunction(),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 150.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/background.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        isLoading == true
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 100.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 70.0),
                                child: carouselSlider = CarouselSlider(
                                  height: 100.0,
                                  initialPage: 0,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  reverse: false,
                                  enableInfiniteScroll: true,
                                  autoPlayInterval: Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 2000),
                                  pauseAutoPlayOnTouch: Duration(seconds: 10),
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  items: listBanner
                                      .map(
                                        (ListBanner listBanner) => Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImageWithRetry(urladmin(
                                                  'storage/image/master/banner/${listBanner.banner}')),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
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
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Rekomendasi Produk",
                            style:
                                TextStyle(fontSize: 21.0, fontFamily: 'Roboto'),
                          ),
                          Text(
                            "Lihat Semua",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                color: Color(0xff31B057)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 20, bottom: 10.0),
                      height: 225,
                      // decoration: BoxDecoration(
                      //   gradient: LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     stops: [0.1, 0.4, 0.6, 0.9],
                      //     colors: [
                      //       Colors.white,
                      //       Colors.white,
                      //       Colors.white,
                      //       Colors.grey[100]
                      //     ],
                      //   ),
                      // ),
                      width: MediaQuery.of(context).size.width,
                      child: PagewiseListView(
                        pageSize: 4,
                        padding: EdgeInsets.all(2.0),
                        scrollDirection: Axis.horizontal,
                        primary: false,
                        itemBuilder: this._recItemBuilder,
                        pageFuture: (pageIndex) =>
                            BackendService.getDataRecom(pageIndex, 4),
                      ),
                    ),
                    Container(
                      // color: Colors.grey[100],
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Belanja Sekarang!",
                                  style: TextStyle(
                                      fontSize: 21.0, fontFamily: 'Roboto'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 10, left: 20, bottom: 10.0),
                            height: 50.0,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              primary: false,
                              itemCount: category == null ? 0 : category.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, bottom: 5.0),
                                  child: Container(
                                    height: 50.0,
                                    child: RaisedButton(
                                      color: Colors.transparent,
                                      elevation: 0.0,
                                      highlightColor: Colors.transparent,
                                      highlightElevation: 0.0,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryItem(
                                                id: category[index]["ity_id"]
                                                    .toString(),
                                                category: category[index]
                                                    ["ity_name"],
                                                categoryId: category[index]
                                                        ["ity_code"]
                                                    .toString(),
                                              ),
                                            ));
                                      },
                                      child: Text(
                                        category[index]["ity_name"],
                                        style:
                                            TextStyle(color: Color(0xff31B057)),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Color(0xff31B057))),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          PagewiseGridView.count(
                            pageSize: pageSize,
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 3
                                    : 2,
                            // mainAxisSpacing: 10.0,
                            crossAxisSpacing: 5.0,
                            childAspectRatio: 0.6,
                            itemBuilder: this._itemBuilder,
                            pageFuture: (pageIndex) =>
                                BackendService.getData(pageIndex, pageSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                // top: 10.0,
                child: AnimatedBuilder(
                  animation: scrollController,
                  builder: (BuildContext context, Widget child) {
                    if (scrollController.offset < 1) {
                      maxOffsetToColor = 0;

                      red = 255;
                      green = 255;
                      blue = 255;

                      opacity = 0.0;
                      isScrolled = false;
                    } else if (scrollController.offset + 100 > 255) {
                      if (maxOffsetToColor == 0 &&
                          maxOffsetToColor != scrollController.offset) {
                        maxOffsetToColor = scrollController.offset;

                        if (scrollController.offset + 100 > 250) {
                          if (isScrolled == false) {
                            isScrolled = true;
                          }
                        } else if (scrollController.offset + 100 < 250) {
                          if (isScrolled == true) {
                            isScrolled = false;
                          }
                        }

                        red = 0;
                        green = 0;
                        blue = 0;

                        opacity = 1.0;
                      }
                    } else {
                      if (scrollController.offset > 250) {
                        if (isScrolled == false) {
                          isScrolled = true;
                        }
                      } else if (scrollController.offset < 250) {
                        if (isScrolled == true) {
                          isScrolled = false;
                        }
                      }

                      red = 255 - scrollController.offset.round();
                      green = 255 - scrollController.offset.round();
                      blue = 255 - scrollController.offset.round();

                      opacity = (scrollController.offset.round()) / 255;
                    }

                    return Container(
                      decoration: isScrolled
                          ? BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(70, 70, 70, 0.7),
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            )
                          : null,
                      height: 55.0,
                      child: AppBar(
                        backgroundColor: Color.fromRGBO(255, 255, 255, opacity),
                        iconTheme: IconThemeData(
                            color: Color.fromRGBO(red, green, blue, 1)),
                        textTheme: TextTheme(
                          title: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        title: InkWell(
                          onTap: () {
                            bottom = false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => CariProduk(),
                                settings: RouteSettings(name: '/cari_produk'),
                              ),
                            );
                          },
                          child: Container(
                            height: 40.0,
                            width: 220.0,
                            decoration: BoxDecoration(
                              color: isScrolled
                                  ? Colors.grey[100].withOpacity(0.7)
                                  : Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                                topLeft: Radius.circular(5.0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Center(
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: Icon(
                                      CupertinoIcons.search,
                                      color: HexColor('#7f8c8d'),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Cari Sekarang!",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: isScrolled
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        elevation: 0.0,
                        actions: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(settings: RouteSettings(name: '/wishlist'),
                                builder: (context) => Wishlist(),
                              ));
                            },
                            icon: Icon(Icons.favorite),
                            // color: Colors.white,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(settings: RouteSettings(name: '/keranjangbelanja'),
                                builder: (context) => Keranjang(),
                              ));
                            },
                            icon: Icon(Icons.shopping_cart),
                            // color: Colors.white,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ) : _children[_currentIndex] , 
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped, 
            // type: BottomNavigationBarType.shifting,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xff31B057),
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: new Text('Shop'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.attach_money,
                  ),
                  title: new Text('Saldo')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  title: new Text('Profile'))
            ],
          ),
      ),
    );
  }

  Widget _recItemBuilder(context, RecomendationModel entry, _) {
    NumberFormat _numberFormat =
        new NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
    return InkWell(
      child: Container(
        height: 200,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width / 3,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.0,
            color: Colors.grey[300],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 4.0,
              color: Colors.grey[300],
              offset: Offset(0.0, 0.3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                entry.gambar != null
                    ? urladmin(
                        'storage/image/master/produk/${entry.gambar}',
                      )
                    : url(
                        'assets/img/noimage.jpg',
                      ),
                fit: BoxFit.cover,
                height: 130.0,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            // SizedBox(height: 7),
            Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              child: Row(
                children: <Widget>[
                  Text(entry.item == null ? 'Unknown Item' : entry.item,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Text(
                        entry.price == null
                            ? 'Rp. 0.00'
                            : _numberFormat.format(double.parse(entry.price)),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.deepOrange),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(entry.tipe == null ? 'Unknown Tipe' : entry.tipe,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.green),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              item: entry.item,
              price: entry.price,
              code: entry.code,
              diskon: entry.diskon,
              desc: entry.desc,
              tipe: entry.tipe,
            ),
          ),
        );
      },
    );
  }

  Widget _itemBuilder(context, ProductModel entry, _) {
    NumberFormat _numberFormat =
        new NumberFormat.simpleCurrency(decimalDigits: 2, name: 'Rp. ');
    return Container(
      child: new Card(
        elevation: 1.5,
        child: InkWell(
          //   height: 250.0,
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.network(
                        entry.gambar != null
                            ? urladmin(
                                'storage/image/master/produk/${entry.gambar}',
                              )
                            : url(
                                'assets/img/noimage.jpg',
                              ),
                        fit: BoxFit.cover,
                        height: 150.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Positioned(
                        top: 5.0,
                        right: 5.0,
                        child: Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: new BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: new IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: 16,
                              color: entry.wishlist == null
                                  ? Colors.grey[400]
                                  : Colors.pink,
                            ),
                            onPressed: () async {
                              var idX = entry.code;
                              // var color = entry.color;
                              try {
                                final hapuswishlist = await http.post(
                                    url('api/ActionWishlistAndroid'),
                                    headers: requestHeaders,
                                    body: {'produk': idX});

                                if (hapuswishlist.statusCode == 200) {
                                  var hapuswishlistJson =
                                      json.decode(hapuswishlist.body);
                                  if (hapuswishlistJson['status'] ==
                                      'tambahwishlist') {
                                    setState(() {
                                      entry.wishlist = entry.code;
                                    });
                                  } else if (hapuswishlistJson['status'] ==
                                      'hapuswishlist') {
                                    setState(() {
                                      entry.wishlist = null;
                                    });
                                  }
                                } else {
                                  print('${hapuswishlist.body}');
                                }
                              } on TimeoutException catch (_) {} catch (e) {
                                print(e);
                              }
                            },
                          ),
                        )),
                  ],
                ),
                // SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width - 130,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            entry.item,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          // height: 60,
                          height: 60.0,
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          left: 0.0,
                          child: Column(
                            children: <Widget>[
                              entry.diskon == null
                                  ? Container(
                                      height: 20,
                                    )
                                  : Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        entry.price == null
                                            ? 'Rp. 0.00'
                                            : _numberFormat.format(
                                                double.parse(entry.price)),
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                      height: 20,
                                    ),
                              entry.diskon == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            entry.price == null
                                                ? 'Rp. 0.00'
                                                : _numberFormat.format(
                                                    double.parse(entry.price)),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.deepOrange),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            entry.tipe,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.green),
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            entry.diskon == null
                                                ? 'Rp. 0.00'
                                                : _numberFormat.format(
                                                    double.parse(entry.diskon)),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.deepOrange),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            entry.tipe,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.green),
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ],
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(
                  item: entry.item,
                  price: entry.price,
                  code: entry.code,
                  diskon: entry.diskon,
                  desc: entry.desc,
                  tipe: entry.tipe,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BackendService {
  static Future<List<ProductModel>> getData(index, limit) async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');
    var hitung = index;
    print(hitung);
    print(limit);
    final responseBody = await http.get(
        url('api/produk_beranda_android?_limit=$limit&count=$hitung'),
        headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"});

    var data = json.decode(responseBody.body);
    var product = data['semuaitem'];

    return ProductModel.fromJsonList(product);
  }

  static Future<List<RecomendationModel>> getDataRecom(index, limit) async {
    var storage = new DataStore();

    print('index $index');

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    final responseBody = await http.get(
        url('api/produk_beranda_android?_limit=0&_recLimit=$limit'),
        headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"});

    var data = json.decode(responseBody.body);
    var product = data['itemslider'];

    return RecomendationModel.fromJsonList(product);
  }
}

class RecomendationModel {
  String item;
  String price;
  String gambar;
  String code;
  String wishlist;
  String desc;
  String tipe;
  String diskon;

  RecomendationModel.fromJson(obj) {
    this.item = obj['i_name'];
    this.price = obj['ipr_sunitprice'];
    this.gambar = obj['ip_path'];
    this.code = obj['i_code'];
    this.wishlist = obj['wl_ciproduct'];
    this.desc = obj['itp_tagdesc'];
    this.tipe = obj['ity_name'];
    this.diskon = obj['gpp_sellprice'];
  }

  static List<RecomendationModel> fromJsonList(jsonList) {
    return jsonList
        .map<RecomendationModel>((obj) => RecomendationModel.fromJson(obj))
        .toList();
  }
}

class ProductModel {
  String item;
  String price;
  String gambar;
  String code;
  String wishlist;
  String desc;
  String tipe;
  String diskon;

  ProductModel.fromJson(obj) {
    this.item = obj['i_name'];
    this.price = obj['ipr_sunitprice'];
    this.gambar = obj['ip_path'];
    this.code = obj['i_code'];
    this.wishlist = obj['wl_ciproduct'];
    this.desc = obj['itp_tagdesc'];
    this.tipe = obj['ity_name'];
    this.diskon = obj['gpp_sellprice'];
  }

  static List<ProductModel> fromJsonList(jsonList) {
    return jsonList
        .map<ProductModel>((obj) => ProductModel.fromJson(obj))
        .toList();
  }
}

class ListBanner {
  final String idbanner;
  final String banner;

  ListBanner({this.idbanner, this.banner});
}
