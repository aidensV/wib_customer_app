import 'package:flutter/material.dart';

class CheckPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    height: 30.0,
                    width: 30.0,
                    child: Icon(
                        Icons.shopping_cart,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff31B057),
                        shape: BoxShape.circle
                    ),
                  ),
                  Container(
                    height: 100.0,
                    width: 2.0,
                    color: Color(0xff31B057),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    height: 30.0,
                    width: 30.0,
                    child: Icon(
                      Icons.map,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff31B057),
                        shape: BoxShape.circle
                    ),
                  ),
                  Container(
                    height: 100.0,
                    width: 2.0,
                    color: Color(0xff31B057),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    height: 30.0,
                    width: 30.0,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff31B057),
                        shape: BoxShape.circle
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 250.0,
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Order Received",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xff25282b)
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.timelapse,
                                    size: 20.0,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "09:15, 9 May 2019",
                                    style: TextStyle(color: Colors.grey[500]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Container(
                    width: 250.0,
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "On The Way",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xff25282b)
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.timelapse,
                                    size: 20.0,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "09:20, 9 May 2019",
                                    style: TextStyle(color: Colors.grey[500]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Container(
                    width: 250.0,
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Delivered",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xff25282b)
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.timelapse,
                                    size: 20.0,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "Finish",
                                    style: TextStyle(color: Colors.grey[500]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
