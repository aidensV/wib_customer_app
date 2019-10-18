import 'package:flutter/material.dart';
import 'package:wib_customer_app/pages/shops/bloc.dart';
import 'package:provider/provider.dart';
import 'package:wib_customer_app/utils/items.dart';

class DetailShop extends StatefulWidget {
  @override
  _DetailShopState createState() => _DetailShopState();
}

class _DetailShopState extends State<DetailShop> {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ShopBloc>(context);
    var detail = bloc.detail;

    for (int i = 0; i < detail.length; i++) {
      setState(() {
        var itemIndex = detail.keys.toList()[i];
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff25282b),
        ),
        title: Text(
            detail.isEmpty ? "Tidak Item" : "Cart",
            style: TextStyle(
              color: Color(0xff25282b),
            )),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Order Item(s)", style: TextStyle(fontSize: 18.0, color: Color(0xff25282b), fontWeight: FontWeight.bold),),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/pos");
                        },
                        child: Text("+ Tambah", style: TextStyle(fontSize: 15.0, color: Color(0xfffbaf18),),),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    "-----------------------------------------------------------",
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ),
                Container(
                  height: 190,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: detail.length,
                    itemBuilder: (context, index) {
                      int itemIndex = detail.keys.toList()[index];
                      int count = detail[itemIndex];
                      Map item = items[itemIndex];
                      int countPrice = items[itemIndex]["sysprice"] * count;

                      return Padding(
                        padding: const EdgeInsets.only(bottom:15.0),
                        child: Container(
                          height: 60,
//                    color: Colors.red,
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  "images/martabak${itemIndex + 1}.jpg",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              SizedBox(width: 15),

                              Container(
                                height: 80,
                                width: MediaQuery.of(context).size.width-90,
                                child: ListView(
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        Row(
                                          children: <Widget>[
                                            Card(
                                                color: Colors.white,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          bloc.reduceQty(itemIndex);
                                                        },
                                                        child: const Text(
                                                            '-',
                                                            style: TextStyle(fontSize: 15, color: Color(0xfffbaf18))
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 15.0, left: 15.0),
                                                      child: Text(
                                                        "$count",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15,
                                                        ),
                                                        maxLines: 2,
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 10.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          bloc.addToCart(itemIndex);
                                                        },
                                                        child: const Text(
                                                            '+',
                                                            style: TextStyle(fontSize: 20, color: Color(0xfffbaf18))
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}


