import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:flutter_image/network.dart';
// import 'package:provider/provider.dart';

import 'package:wib_customer_app/cari_produk/cari_produk.dart';
import 'package:wib_customer_app/notification_service/notification_service.dart';
import 'package:wib_customer_app/pages/profile/profile.dart';
import 'package:wib_customer_app/pusher/pusher_service.dart';
import 'package:wib_customer_app/saldo.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'utils/Navigator.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
// import 'package:wib_customer_app/utils/Navigator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/pages/shops/category_item.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'pages/shops/product_detail.dart';
import 'pages/wishlist/wishlist.dart';
import 'pages/shopping_cart/shoppingcart.dart';

bool bottom;
String tokenType, accessToken, rekomX;
Map<String, String> requestHeaders = Map();
List<ListBanner> listBannerSlider, listBannerBasic;
List<RecomendationModel> listrecomeitem;
bool isLoading;
int pageSize = 6;

ScrollController scrollController = ScrollController(initialScrollOffset: 0.0);

bool isScrolled;
int red, green, blue;
double opacity, maxOffsetToColor;

GlobalKey<ScaffoldState> _scaffoldKeyDashboard;
NotificationService notificationService;
PagewiseLoadController pagewiseLoadControllerVertical,
    pageWiseLoadControllerHorizontal;

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

  // String _username;
  String usernameprofile, emailprofile, imageprofile, namaCustomer;

  final List<Widget> _children = [
    null,
    Saldo(),
    ProfilePage(),
  ];

  int _currentIndex = 0;
  void onTabTapped(int index) {
    _currentIndex = index;
    setState(() {});
  }

  Future<Null> removeSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
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
    // print(requestHeaders);
    try {
      final response = await http.get(
        url('api/listKategoriAndroid'),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        this.setState(() {
          category = json.decode(response.body);
        });
      } else if (response.statusCode == 401) {
        showInSnackBarDashboard('Token Kedaluwarsa, silahkan login kembali');
      } else {
        showInSnackBarDashboard('Error Code : ${response.statusCode}');
        Map responseJson = jsonDecode(response.body);
        print('Error Code : ${response.statusCode}');
        if (responseJson.containsKey('message')) {
          showInSnackBarDashboard('Message ${responseJson['message']}');
        }
      }

      // print(category[1]["ity_code"]);

      return "Success!";
    } catch (e) {
      print('Error : $e');
    }
  }

  Future<void> getrekom() async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    tokenType = tokenTypeStorage;
    accessToken = accessTokenStorage;
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = '$tokenType $accessToken';

    try {
      final response = await http.get(
        url('api/cek_rekomendasiproduk'),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        var rekomJson = json.decode(response.body);
        String rekomvalue = rekomJson['cekrekom'].toString();
        setState(() {
          rekomX = rekomvalue;
          isLoading = false;
        });
      } else {
        print('testign ${response.body}');
        showInSnackBarProduk('Error Code : ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error : $e');
    }
  }

  Future<void> dataProfile() async {
    DataStore storage = new DataStore();

    usernameprofile = await storage.getDataString("username");
    namaCustomer = await storage.getDataString("name");
    emailprofile = await storage.getDataString('email');
    imageprofile = await storage.getDataString('image');
  }

  Future<void> listBannerAndroid() async {
    try {
      DataStore storage = new DataStore();

      String tokenTypeStorage = await storage.getDataString('token_type');
      String accessTokenStorage = await storage.getDataString('access_token');

      tokenType = tokenTypeStorage;
      accessToken = accessTokenStorage;
      requestHeaders['Accept'] = 'application/json';
      requestHeaders['Authorization'] = '$tokenType $accessToken';
      setState(() {
        isLoading = true;
      });
      final banner = await http.get(
        url('api/banner'),
        headers: requestHeaders,
      );

      // print(banner.statusCode);
      if (banner.statusCode == 200) {
        // return nota;
        dynamic bannerJson = json.decode(banner.body);

        // print('Banner $banners');

        listBannerSlider = List();
        for (var i in bannerJson['banner_slide']) {
          ListBanner bannerx = ListBanner(
            idbanner: i['b_id'].toString(),
            banner: i['b_image'],
          );
          listBannerSlider.add(bannerx);
        }

        listBannerBasic = List();
        for (var i in bannerJson['banner_basic']) {
          ListBanner bannerY = ListBanner(
            idbanner: i['b_id'].toString(),
            banner: i['b_image'],
          );
          listBannerBasic.add(bannerY);
        }

        setState(() {
          isLoading = false;
          listBannerSlider = listBannerSlider;
          listBannerBasic = listBannerBasic;
        });
      } else if (banner.statusCode == 401) {
        showInSnackBarProduk('Token kedaluwarsa, silahkan login kembali');
        setState(() {
          isLoading = false;
        });
      } else {
        showInSnackBarProduk('Error Code : ${banner.statusCode}');
        print('Error Code : ${banner.statusCode}');
        Map responseJson = jsonDecode(banner.body);
        if (responseJson.containsKey('message')) {
          showInSnackBarDashboard('Message ${responseJson['message']}');
        }
        setState(() {
          isLoading = false;
        });
      }
    } on TimeoutException catch (_) {
      showInSnackBarProduk('Request Timeout, try again');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error : $e');
    }
    // return null;
  }

  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [];

  List<T> map<T>(List listBannerSlider, Function handler) {
    List<T> result = [];
    for (var i = 0; i < listBannerSlider.length; i++) {
      result.add(handler(i, listBannerSlider[i]));
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
    listBannerSlider = List();
    listBannerBasic = List();
    listBannerAndroid();
    pageWiseLoadControllerHorizontal = PagewiseLoadController(
      pageSize: pageSize,
      pageFuture: (pageIndex) => BackendService.getData(pageIndex, pageSize),
    );
    pagewiseLoadControllerVertical = PagewiseLoadController(
      pageSize: pageSize,
      pageFuture: (pageIndex) =>
          BackendService.listrecomendationitem(pageIndex, pageSize),
    );

    scrollController = ScrollController(initialScrollOffset: 0.0);
    isScrolled = false;
    red = 255;
    green = 255;
    blue = 255;
    opacity = 0.0;
    maxOffsetToColor = 0.0;
    tabController = TabController(vsync: this, length: 4);
    getCategory();
    getrekom();
    isLoading = true;
    dataProfile();
    rekomX = '1';
    // print(requestHeaders);

    notificationService = new NotificationService(context: context);

    notificationService.initStateNotificationCustomerSudahBayarService();
    PusherService pusherService =
        PusherService(notificationService: notificationService);

    pusherService = PusherService(notificationService: notificationService);
    pusherService.firePusher();

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
          child: Column(
            children: <Widget>[
              // Profil Drawer Here
              UserAccountsDrawerHeader(
                // Below this my gf name :))))), jk
                accountName:
                    Text(namaCustomer == null ? 'Nama Lengkap' : namaCustomer),
                accountEmail:
                    Text(emailprofile == null ? 'Email Anda' : emailprofile),
                // This how you set profil image in sidebar
                // Remeber to add image first in pubspec.yaml
                currentAccountPicture: Container(
                  width: 30,
                  height: 30,
                  child: imageprofile != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              // width: MediaQuery.of(context).size.width,

                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            imageUrl: url(
                                'storage/image/member/profile/$imageprofile'),
                          ),
                        )
                      : Image.asset('images/jisoocu.jpg'),
                ),
                // This how you set color in top of sidebar
                decoration: BoxDecoration(
                  color: Color(0xff31B057),
                ),
              ),
              //  Menu Section Here
              Expanded(
                child: Container(
                  // color: Colors.red,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Daftar Transaksi',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Color(0xff25282b),
                          ),
                        ),
                        leading: Icon(Icons.list),
                        onTap: () {
                          Navigator.pushNamed(context, "/tracking_list");
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Cabang Warung Botol',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Color(0xff25282b),
                          ),
                        ),
                        leading: Icon(Icons.list),
                        onTap: () {
                          Navigator.pushNamed(context, "/list_cabang");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Colors.black54,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Roboto',
                      color: Color(0xff25282b),
                    ),
                  ),
                  trailing: Icon(Icons.exit_to_app),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Peringatan!'),
                        content: Text('Apa anda yakin ingin logout?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Tidak',
                              style: TextStyle(color: Colors.black54),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Ya',
                              style: TextStyle(color: Colors.cyan),
                            ),
                            onPressed: () {
                              removeSharedPrefs();
                              Navigator.pushReplacementNamed(context, "/login");
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Body Section Here
        body: _currentIndex == 0
            ? SafeArea(
                child: Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      onRefresh: () async {
                        getrekom();
                        listBannerAndroid();
                        pagewiseLoadControllerVertical.reset();
                        pageWiseLoadControllerHorizontal.reset();
                        await Future.value({});
                      },
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
                                        padding:
                                            const EdgeInsets.only(top: 100.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : listBannerSlider.length == 0
                                      ? Container()
                                      : Padding(
                                          padding: EdgeInsets.only(top: 70.0),
                                          child: carouselSlider =
                                              CarouselSlider(
                                            height: 100.0,
                                            initialPage: 0,
                                            enlargeCenterPage: true,
                                            autoPlay: true,
                                            reverse: false,
                                            enableInfiniteScroll: true,
                                            autoPlayInterval:
                                                Duration(seconds: 5),
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 2000),
                                            pauseAutoPlayOnTouch:
                                                Duration(seconds: 10),
                                            scrollDirection: Axis.horizontal,
                                            onPageChanged: (index) {
                                              setState(() {
                                                _current = index;
                                              });
                                            },
                                            items: listBannerSlider
                                                .map(
                                                  (ListBanner
                                                          listBannerSlider) =>
                                                      Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0),
                                                    child: CachedNetworkImage(
                                                      placeholder:
                                                          (context, url) =>Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                      height: 130.0,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      imageUrl:
                                                          urladmin('storage/image/master/banner/${listBannerSlider.banner}'),
                                                    ),

                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 38.0, top: 158.0),
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
                          rekomX == '0'
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Rekomendasi Produk",
                                        style: TextStyle(
                                            fontSize: 21.0,
                                            fontFamily: 'Roboto'),
                                      ),
                                    ],
                                  ),
                                ),
                          rekomX == '0'
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 20, bottom: 10.0),
                                  height: 225,
                                  width: MediaQuery.of(context).size.width,
                                  child: PagewiseListView(
                                    pageLoadController:
                                        pagewiseLoadControllerVertical,
                                    padding: EdgeInsets.all(2.0),
                                    scrollDirection: Axis.horizontal,
                                    primary: false,
                                    itemBuilder:
                                        (BuildContext context, data, int i) {
                                      return _recItemBuilder(context, data, i);
                                    },
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Belanja Sekarang!",
                                        style: TextStyle(
                                            fontSize: 21.0,
                                            fontFamily: 'Roboto'),
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
                                    itemCount:
                                        category == null ? 0 : category.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                                      id: category[index]
                                                              ["ity_id"]
                                                          .toString(),
                                                      category: category[index]
                                                          ["ity_name"],
                                                      categoryId:
                                                          category[index]
                                                                  ["ity_code"]
                                                              .toString(),
                                                    ),
                                                  ));
                                            },
                                            child: Text(
                                              category[index]["ity_name"],
                                              style: TextStyle(
                                                  color: Color(0xff31B057)),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        18.0),
                                                side: BorderSide(
                                                    color: Color(0xff31B057))),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                PagewiseGridView.count(
                                  pageLoadController:
                                      pageWiseLoadControllerHorizontal,
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
                                  itemBuilder: (BuildContext context,
                                      dynamic data, int i) {
                                    return _itemBuilder(context, data, i);
                                  },
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
                          } else if (scrollController.offset > 255) {
                            if (maxOffsetToColor == 0 &&
                                maxOffsetToColor != scrollController.offset) {
                              maxOffsetToColor = scrollController.offset;

                              if (scrollController.offset > 250) {
                                if (isScrolled == false) {
                                  isScrolled = true;
                                }
                              } else if (scrollController.offset < 250) {
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

                            opacity = scrollController.offset.round() / 255;
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
                              backgroundColor:
                                  Color.fromRGBO(255, 255, 255, opacity),
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
                                      builder: (BuildContext context) =>
                                          CariProduk(),
                                      settings:
                                          RouteSettings(name: '/cari_produk'),
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
                                        MaterialPageRoute(
                                          settings:
                                              RouteSettings(name: '/wishlist'),
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
                                        MaterialPageRoute(
                                          settings: RouteSettings(
                                              name: '/keranjangbelanja'),
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
              )
            : _children[_currentIndex],
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

  Widget _recItemBuilder(
      BuildContext context, RecomendationModel entry, int i) {
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

              // child: Image(
              //   image: NetworkImageWithRetry(
              //     entry.gambar != null
              //         ? urladmin(
              //             'storage/image/master/produk/${entry.gambar}',
              //           )
              //         : url(
              //             'assets/img/noimage.jpg',
              //           ),
              //   ),
              //   fit: BoxFit.cover,
              //   height: 130.0,
              //   width: MediaQuery.of(context).size.width,
              // ),
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  height: 130.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset("images/loadingitem.gif"),
                ),
                errorWidget: (context, url, error) => Container(
                          height: 130.0,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset("images/noimage.jpg"),
                        ),
                fit: BoxFit.cover,
                height: 130.0,
                width: MediaQuery.of(context).size.width,
                imageUrl: entry.gambar != null
                    ? urladmin(
                        'storage/image/master/produk/${entry.gambar}',
                      )
                    : url(
                        'assets/img/noimage.jpg',
                      ),
              ),
            ),
            // SizedBox(height: 7),
            Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    entry.item == null ? 'Nama Item' : entry.item,
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
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                child: Row(
                  children: <Widget>[
                    entry.diskon == null || entry.diskon == ''
                        ? Expanded(
                            flex: 5,
                            child: Text(
                              entry.price == null || entry.price == ''
                                  ? 'Rp. 0.00'
                                  : _numberFormat
                                      .format(double.parse(entry.price)),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.deepOrange),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                            ),
                          )
                        : Expanded(
                            flex: 5,
                            child: Text(
                              entry.diskon == null || entry.diskon == ''
                                  ? 'Rp. 0.00'
                                  : _numberFormat
                                      .format(double.parse(entry.diskon)),
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
                      child: Text(
                        entry.tipe == null || entry.tipe == ''
                            ? 'Jenis'
                            : entry.tipe,
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

  Widget _itemBuilder(context, ProductModel entry, int i) {
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
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          height: 150.0,

                          child: Image.asset("images/loadingitem.gif"),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 150.0,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset("images/noimage.jpg"),
                        ),
                        fit: BoxFit.cover,
                        height: 150.0,
                        width: MediaQuery.of(context).size.width,
                        imageUrl: entry.gambar != null
                            ? urladmin(
                                'storage/image/master/produk/${entry.gambar}',
                              )
                            : url(
                                'assets/img/noimage.jpg',
                              ),
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
                                  print(hapuswishlist.statusCode);
                                  Map responseJson =
                                      jsonDecode(hapuswishlist.body);
                                  print(
                                      'Error Code : ${hapuswishlist.statusCode}');
                                  if (responseJson.containsKey('message')) {
                                    showInSnackBarDashboard(
                                        'Message ${responseJson['message']}');
                                  }
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
                            entry.item == null || entry.item == ''
                                ? 'Nama Item'
                                : entry.item,
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
                                        entry.price == null || entry.price == ''
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
                                            entry.price == null ||
                                                    entry.price == ''
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
                                            entry.tipe == null ||
                                                    entry.tipe == ''
                                                ? 'Jenis'
                                                : entry.tipe,
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
                                            entry.tipe == null ||
                                                    entry.tipe == ''
                                                ? 'Jenis'
                                                : entry.tipe,
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
    // print(hitung);
    // print(limit);
    try {
      final responseBody = await http.get(
          url('api/produk_beranda_android?_limit=$limit&count=$hitung'),
          headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"});

      if (responseBody.statusCode == 200) {
        var data = json.decode(responseBody.body);
        var product = data['semuaitem'];

        return ProductModel.fromJsonList(product);
      } else if (responseBody.statusCode == 401) {
        showInSnackBarDashboard('Token kedaluwarsa, silahkan login kembali');
        return null;
      } else {
        showInSnackBarDashboard('Error Code : ${responseBody.statusCode}');
        Map responseJson = jsonDecode(responseBody.body);
        print('Error Code : ${responseBody.statusCode}');
        if (responseJson.containsKey('message')) {
          showInSnackBarDashboard('Message ${responseJson['message']}');
        }
        return null;
      }
    } on TimeoutException catch (_) {
      showInSnackBarDashboard('Request timeout, try again');
      return null;
    } catch (e) {
      print('Error : $e');
      showInSnackBarDashboard('Error : ${e.toString()}');
      return null;
    }
  }

  static Future<List<RecomendationModel>> listrecomendationitem(
      index, limit) async {
    var storage = new DataStore();

    // print('index $index');

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    try {
      final responseBody = await http.get(
          url('api/produk_beranda_android?_limit=0&_recLimit=$limit'),
          headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"});

      if (responseBody.statusCode == 200) {
        var data = json.decode(responseBody.body);
        var product = data['itemslider'];

        if (product != null) {
          return RecomendationModel.fromJsonList(product);
        }
      } else if (responseBody.statusCode == 401) {
        showInSnackBarDashboard('Token kedaluwarsa, silahkan login kembali');
        return null;
      } else {
        showInSnackBarDashboard('Error code : ${responseBody.statusCode}');
        Map responseJson = jsonDecode(responseBody.body);

        print('Error Code : ${responseBody.statusCode}');
        if (responseJson.containsKey('message')) {
          showInSnackBarDashboard('Message ${responseJson['message']}');
        }
        print('Error Code : ${responseBody.statusCode}');
        print(jsonDecode(responseBody.body));
        return null;
      }
    } on TimeoutException catch (_) {
      showInSnackBarDashboard('Request timeout, try again');
      return null;
    } catch (e) {
      print('Error : $e');
      showInSnackBarDashboard('Error : ${e.toString()}');
      return null;
    }
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
