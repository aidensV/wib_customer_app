import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wib_customer_app/widget/rating_bar.dart';

class DetailShop extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Item Name",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RatingBar(
                          rating: 4.4,
                        ),
                        Text(
                          4.4.toString(),
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SingleChildScrollView(
                      child: Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: IconButton(
                icon: Icon(
                  LineIcons.long_arrow_left,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: IconButton(
                icon: Icon(
                  LineIcons.shopping_cart,
                  color: Colors.black,
                ),
                onPressed: null,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 11,
            left: MediaQuery.of(context).size.width / 6,
            child: Hero(
              tag: 'images/botol.png',
              child: Image.asset(
                'images/botol.png',
                fit: BoxFit.cover,
                height: 250.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: Text(
                'Rp.10.000',
                style: TextStyle(
                  color: Colors.orange,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 58.0,
              width: 150.0,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: OutlineButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor:Color(0xff31B057),
                    borderSide: BorderSide(color: Color(0xff31B057)),
                    onPressed: () {
                      Navigator.pushNamed(context, "/dashboard");
                    },
                    child: new Text("Beli", style: TextStyle(fontSize: 18.0),),
                  ),
              )
            ),
          )
        ],
      ),
    );
  }
}
