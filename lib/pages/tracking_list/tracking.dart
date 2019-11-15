import 'package:flutter/material.dart';

import 'all/all.dart' as tab1;
import 'pay/pay.dart' as tab2;
import 'process/process.dart' as tab3;
import 'send/send.dart' as tab4;

var _scaffoldBM;
TabController _tabController;

class TrackingList extends StatefulWidget {

  final int index;

  TrackingList({this.index});
  
  @override
  _TrackingListState createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    if(widget.index != null){
      _tabController.animateTo(widget.index);
    }
    _scaffoldBM = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldBM,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color(0xff31B057),
        title: Text('Tracking Nota'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: 'Semua',
            ),
            Tab(
              text: 'Pembayaran',
            ),
            Tab(
              text: 'Proses',
            ),
            Tab(
              text: 'Pengiriman',
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          new tab1.AllNota(),
          new tab2.PayNota(),
          new tab3.ProcessNota(),
          new tab4.SendNota(),
        ],
      ),
    );
  }
}
