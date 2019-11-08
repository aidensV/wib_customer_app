import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:provider/provider.dart';
import 'package:wib_customer_app/cari_produk/cari_produk.dart';
import 'utils/Navigator.dart';
import 'package:wib_customer_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'utils/utils.dart';
// import 'utils/items.dart';
import 'pages/shops/bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:wib_customer_app/env.dart';
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/pages/shops/category_item.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'pages/shops/product_detail.dart';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();
List<ListBanner> listBanner = [];
bool isLoading;

ScrollController scrollController = ScrollController(initialScrollOffset: 0.0);

bool isScrolled;
int red, green, blue;
double opacity, maxOffsetToColor;

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
  String usernameprofile, emailprofile, imageprofile;

  Future<Null> RemoveSharedPrefs() async {
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
      this.setState(() {
        category = json.decode(response.body);
      });

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
      } else {
        return null;
      }
    } on TimeoutException catch (_) {} catch (e) {
      debugPrint('$e');
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

  Decoration appBarDecoration() {
    if (isScrolled) {
      return BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(70, 70, 70, 0.7),
            offset: Offset(0.0, 3.0),
            blurRadius: 7.0,
          ),
        ],
      );
    }
    return null;
  }

  scrollEvent() {
    // print(scrollController.offset);
    if (scrollController.offset == 0) {
      maxOffsetToColor = 0;
      setState(() {
        red = 255;
        green = 255;
        blue = 255;

        opacity = 0.0;
      });
    } else if (scrollController.offset + 100 > 255) {
      if (maxOffsetToColor == 0 &&
          maxOffsetToColor != scrollController.offset + 100) {
        maxOffsetToColor = scrollController.offset;
        setState(() {
          red = 0;
          green = 0;
          blue = 0;

          opacity = 1.0;
        });
      }
    } else if (scrollController.offset < 255 && scrollController.offset > 0) {
      if (scrollController.offset > 150) {
        setState(() {
          isScrolled = true;
        });
      } else if (scrollController.offset < 150) {
        setState(() {
          isScrolled = false;
        });
      }

      setState(() {
        red = 255 - scrollController.offset.round();
        green = 255 - scrollController.offset.round();
        blue = 255 - scrollController.offset.round();

        opacity = (scrollController.offset.round()) / 255;
      });
    }

    // print('Red $red');
    // print('green $green');
    // print('blue $blue');
    // print('opacity $opacity');
  }

  @override
  void initState() {
    listBannerAndroid();
    scrollController = ScrollController(initialScrollOffset: 0.0);
    isScrolled = false;
    red = 255;
    green = 255;
    blue = 255;
    opacity = 0.0;
    maxOffsetToColor = 0.0;
    scrollController.addListener(scrollEvent);
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
                  accountName: Text(usernameprofile == null
                      ? 'Nama Lengkap'
                      : usernameprofile),
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
                    RemoveSharedPrefs();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                ),
              ],
            ),
          ),
          // Body Section Here
          body: SafeArea(
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
                                    items: <Widget>[
                                      for (var i = 0;
                                          i < listBanner.length;
                                          i++)
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImageWithRetry(urladmin(
                                                  'storage/image/master/banner/${listBanner[i].banner}')),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                    ],
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
                              style: TextStyle(
                                  fontSize: 21.0, fontFamily: 'Roboto'),
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
                        padding:
                            EdgeInsets.only(top: 10, left: 20, bottom: 10.0),
                        height: 200,
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
                                colors: [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.grey[100]
                            ])),
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
                        color: Colors.grey[100],
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
                                itemCount:
                                    category == null ? 0 : category.length,
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
                                                  category_id: category[index]
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
                              pageSize: PAGE_SIZE,
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              // mainAxisSpacing: 10.0,
                              crossAxisSpacing: 5.0,
                              childAspectRatio: 0.6,
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
                Positioned(
                  // top: 10.0,
                  child: Container(
                    decoration: appBarDecoration(),
                    height: 55.0,
                    child: AppBar(
                      backgroundColor: Color.fromRGBO(255, 255, 255, opacity),
                      iconTheme: IconThemeData(
                          color: Color.fromRGBO(red, green, blue, 1)),
                      textTheme: TextTheme(
                          title: TextStyle(
                        color: Colors.white,
                      )),
                      title: Container(
                        height: 40.0,
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
                            hintStyle: TextStyle(fontFamily: 'Roboto'),
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              color: HexColor('#7f8c8d'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => CariProduk(),
                                settings: RouteSettings(name: '/cari_produk'),
                              ),
                            );
                          },
                        ),
                      ),
                      elevation: 0.0,
                      actions: <Widget>[
                        IconButton(
                          onPressed: () {
                            MyNavigator.goWishlist(context);
                          },
                          icon: Icon(Icons.favorite),
                          // color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () {
                            MyNavigator.goKeranjang(context);
                          },
                          icon: Icon(Icons.shopping_cart),
                          // color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xff31B057),
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
              // BottomNavigationBarItem(
              //     icon: Icon(
              //       Icons.map,
              //     ),
              //     title: new Text('Tracking')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  title: new Text('Profile'))
            ],
          )),
    );
  }

  Widget _recItemBuilder(context, RecomendationModel entry, _) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      // elevation: 0.0,
      child: InkWell(
//                      color: Colors.green,
          child: Card(
            child: Column(
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
                      Text(entry.item,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          )),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Text(
                          "Rp." + entry.price,
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
                          entry.tipe,
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
          }),
    );
  }

  Widget _itemBuilder(context, ProductModel entry, _) {
    return Stack(
      children: <Widget>[
        Positioned(
          // child: Container(
          child: Container(
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
                                        } else if (hapuswishlistJson[
                                                'status'] ==
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
                                    setState(() {
                                      _isPressed = Colors.pink[400];
                                    });
                                  },
                                ),
                              )),
                        ],
                      ),
                      // SizedBox(width: 15),
                      Padding(
                        padding:
                            EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 130,
                          child: Column(
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
                              entry.diskon == null
                                  ? Container(
                                      // height: 20,
                                      )
                                  : Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Rp. ' + entry.price,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                      // height: 20,
                                    ),
                              entry.diskon == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            "Rp. " + entry.price,
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
                                            "Rp. " + entry.diskon,
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
                        ),
                      )
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
          ),
        ),
      ],
    );
  }
}

class BackendService {
  static Future<List<ProductModel>> getData(index, limit) async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    final responseBody = await http.get(
        url('api/produk_beranda_android?_limit=$limit'),
        headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"});

    var data = json.decode(responseBody.body);
    var product = data['semuaitem'];

    return ProductModel.fromJsonList(product);
  }

  static Future<List<RecomendationModel>> getDataRecom(index, limit) async {
    var storage = new DataStore();

    var tokenTypeStorage = await storage.getDataString('token_type');
    var accessTokenStorage = await storage.getDataString('access_token');

    final responseBody = await http.get(
        url('api/produk_beranda_android?_limit=0&_recLimit=$limit'),
        headers: {"Authorization": "$tokenTypeStorage $accessTokenStorage"});

    var data = json.decode(responseBody.body);
    var product = data['itemslider'];
    print('bbb');

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
