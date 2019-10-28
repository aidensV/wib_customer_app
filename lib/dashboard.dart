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

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController;

  String _username;

  Future<Null> RemoveSharedPrefs() async {
    DataStore dataStore = new DataStore();
    dataStore.clearData();
    _username = await dataStore.getDataString("username");
    print(_username);
  }

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 4);

    super.initState();
  }

  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/17/20723472/20723472_c5be5e07-0069-4871-8ed3-07a76019551c.jpg',
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/17/20723472/20723472_eed9c68f-c758-40eb-966f-3f844a06e1c0.jpg',
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/17/20723472/20723472_cfa2e00c-2dba-4449-8e2e-024c00c5349f.jpg',
    'https://ecs7.tokopedia.net/img/cache/1242/banner/2019/10/17/20723472/20723472_5965b5be-ec2f-4580-b304-2cb972bde3f0.jpg',
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ShopBloc>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    fontFamily: 'TitilliumWeb',
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
                    fontFamily: 'TitilliumWeb',
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
                    fontFamily: 'TitilliumWeb',
                    color: Color(0xff25282b),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/home");
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'TitilliumWeb',
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
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 50.0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 30.0,
                            width: 200.0,
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
                              style: TextStyle(fontFamily: 'TitilliumWeb'),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 3.0),
                                hintText: "Cari Sekarang!",
                                hintStyle:
                                    TextStyle(fontFamily: 'TitilliumWeb'),
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
                        ],
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
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
                  padding: EdgeInsets.only(left: 38.0, top: 150.0),
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
            Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                primary: false,
                itemCount: items == null ? 0 : items.length,
                itemBuilder: (BuildContext context, int index) {
                  Map item = items.reversed.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                        child: Container(
                          height: 250,
                          width: 140,
//                      color: Colors.green,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "${item["img"]}",
                                  height: 178,
                                  width: 140,
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
                                    color: Colors.blueGrey[300],
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          bloc.addToCart(index);
                        }),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: GridView.count(
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.7,
                children: items
                    .map(
                      (item) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        // padding: const EdgeInsets.all(10.0),
                        // margin: EdgeInsets.all(5.0),
                        child: InkWell(
                          child: Container(
                            // color: Colors.red,
                            child: Column(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // clipBehavior: Clip.antiAlias,
                                  child: Image.asset(
                                    "${item["img"]}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // SizedBox(width: 15),
                                Container(
                                  height: 80,
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${item["name"]}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
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
                                            fontSize: 12,
                                            color: Colors.blueGrey[300],
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${item["price"]}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // bloc.detailView(index);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
