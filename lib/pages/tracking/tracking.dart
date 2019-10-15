import 'package:flutter/material.dart';
import 'package:wib_customer_app/widget/checkpoint.dart';

class Tracking extends StatefulWidget {
  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Tracking",
          style: TextStyle(
              color: Color(0xff25282b)
          ),
        ),
        iconTheme: IconThemeData(
            color: Color(0xff25282b)
        ),
        elevation: 0.0,
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Order Status",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff25282b),
                        ),
                      ),
                      Text(
                        "INVOICE : 12A34B",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey
                        ),
                      ),
                      Container(
                        width: 200.0,
                        height: 200.0,
                        child: Image.asset("images/truck.gif"),
                        // Gif jangan dipakai setelah aplikasi release, karna mengandung unsur copyright
                        // Jika tetap dipakai maka tanggung jawab sendiri atau programmer setelah david
                      ),
                    ],
                  ),
                ),
                Container(
                  child: CheckPoint(),
                  // Check file in widget/checkpoint if you wanna know
                ),
                SizedBox(
                  height: 80.0,
                )
              ],
            ),
          ),
        ),
      ),
      // Whit this syntax you can create sticky button on bottom of the screen
      floatingActionButton: InkWell(
        onTap: () => print('Confirm Brayy'),
        child: Container(
          width: 200.0,
          height: 50.0,
          decoration: new BoxDecoration(
            color: Color(0xff31B057),
            border: new Border.all(color: Colors.transparent, width: 2.0),
            borderRadius: new BorderRadius.circular(23.0),
          ),
          child: Center(child: Text('Confirm Delivery', style: new TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          ),
        ),
      ),
    );
  }
}
