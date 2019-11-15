import 'package:flutter/material.dart';

class ListTileTransaksi extends StatelessWidget {
  final Widget status;
  final Function onTap;
  final String nota, tanggalTransaksi, hargaTotal;

  ListTileTransaksi({
    @required this.status,
    @required this.nota,
    @required this.onTap,
    @required this.tanggalTransaksi,
    @required this.hargaTotal,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 3.0,
                offset: Offset(0.0, 3.0),
              ),
            ]),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300],
                    width: 1.0,
                  ),
                ),
              ),
              child: status,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tanggalTransaksi,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    nota,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    hargaTotal,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
