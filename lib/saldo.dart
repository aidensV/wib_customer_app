import 'package:flutter/material.dart';


class Saldo extends StatefulWidget{
  final customer;

  Saldo({Key key, this.customer});
  @override
  State<StatefulWidget>createState(){
    return _Saldo(customer : customer);
  }
}

class _Saldo extends State<Saldo>{
  final customer;
  _Saldo({Key key , this.customer});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: <Widget>[
              Container(
              margin: EdgeInsets.only(top: 20, bottom: 15),
              width: 130,
              height: 130,
              child: CircleAvatar(
                backgroundImage: AssetImage('images/jisoocu.jpg'),
              ),
            ),

            Text(
              'Faizal Triswanto',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87),
              textAlign: TextAlign.left,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.attach_money,
                ),

                Text('Rp. 200,000.00')
              ],
            ),

            Scrollbar(
              child:Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration : new BoxDecoration(
                      color: Color.fromRGBO(43, 204, 86, 1)
                      
                    ),
                    child: Text('History Saldo',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                    ),
                    
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child : ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                            leading: Container(
                              height: 70,
                              padding : EdgeInsets.only(right:12),
                              decoration: new BoxDecoration(
                                border: new Border(
                                  right: new BorderSide(width: 1 , color:Colors.black87 ))),
                                  child: Icon(
                                    Icons.attach_money , color: Colors.black87,),
                            ),

                            title: Text(
                              "Rp. 200,000.00",
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                            ),

                            subtitle: Row(
                              children: <Widget>[
                                Text("23 Mei 2019 - Kembalian Ongkir", style: TextStyle(color: Colors.black87))
                              ],
                            ),
                            ),
                          );
                        },
                      ),           
                    ),
                  ),
                ],
              )
            )
          ],
      ),
    );
  }
}

class Saldoo extends StatefulWidget{
  final customer;

  Saldoo({Key key, this.customer});
  @override
  State<StatefulWidget>createState(){
    return _Saldoo(customer : customer);
  }
}

class _Saldoo extends State<Saldoo>{
  final customer;
  _Saldoo({Key key , this.customer});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            child: Text('data'),
          )
        ],
      ),
    );
  }
}