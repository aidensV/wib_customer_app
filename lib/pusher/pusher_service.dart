import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:flutter/services.dart';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/notification_service/notification_service.dart';
import 'package:wib_customer_app/storage/storage.dart';

class PusherService {
  Event eventPenjualanDiKonfirm, eventPenjualanDiProses, eventPenjulanDiKirim, eventPenjualanDiTolak;
  String lastConnectionState;

  Channel penjualanChannelOn, penjualanChannelOff, penjualanChannel;
  NotificationService notificationService;

  PusherService({@required this.notificationService});

  StreamController<String> eventDataPenjualanDiKonfirm =
      StreamController<String>();
  StreamController<String> eventDataPenjualanDiProses =
      StreamController<String>();
  StreamController<String> eventDataPenjualanDiKirim =
      StreamController<String>();

        StreamController<String> eventDataPenjualanDiTolak =
      StreamController<String>();

  Sink get _inEventDataDiKonfirm => eventDataPenjualanDiKonfirm.sink;
  Sink get _inEventDataDiProses => eventDataPenjualanDiProses.sink;
  Sink get _inEventDataDiKirim => eventDataPenjualanDiKirim.sink;
  Sink get _inEventDataDiTolak => eventDataPenjualanDiTolak.sink;

  Stream get eventStreamDikonfirm => eventDataPenjualanDiKonfirm.stream;
  Stream get eventStreamDiProses => eventDataPenjualanDiProses.stream;
  Stream get eventStreamDiKirim => eventDataPenjualanDiKirim.stream;
  Stream get eventStreamDiTolak => eventDataPenjualanDiTolak.stream;

  Future<void> initPusher() async {
    try {
      await Pusher.init(key, PusherOptions(cluster: cluster));
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void connectPusher() {
    Pusher.connect(
        onConnectionStateChange: (ConnectionStateChange connectionState) async {
      lastConnectionState = connectionState.currentState;
    }, onError: (ConnectionError e) {
      print("Error: ${e.message}");
    });
  }

  Future<void> subscribePusher() async {
    // penjualanChannelOff = await Pusher.subscribe('penjualan-channel');
    // penjualanChannelOn = await Pusher.subscribe('penjualan-channel');
    DataStore store = DataStore();

    String userId = await store.getDataString('id');

    penjualanChannel =
        await Pusher.subscribe('penjualan-channel-${userId.toString()}');
  }

  void unSubscribePusher(String channelName) {
    Pusher.unsubscribe(channelName);
  }

  bindEvent() {
    penjualanChannel.bind('penjualan-di-konfirm', (last) {
      eventPenjualanDiKonfirm = last;

      eventDataPenjualanDiKonfirm.add(last.data);

      dynamic dataJson = jsonDecode(last.data);
      print(dataJson);

      notificationService.showBigTextNotification(
        // title: 'Segera melakukan proses packing',
        title: 'Transaksi Pembelian',
        description: 'Nota ${dataJson['message']['nota']} telah di Konfirm',
        payload: dataJson['message']['request'],
      );
    });

    penjualanChannel.bind('penjualan-ditolak', (last) {
      eventPenjualanDiTolak = last;

      eventDataPenjualanDiTolak.add(last.data);

      dynamic dataJson = jsonDecode(last.data);
      print(dataJson);

      notificationService.showBigTextNotification(
        // title: 'Segera melakukan proses packing',
        title: 'Transaksi Pembelian',
        description: 'Nota ${dataJson['message']['nota']} telah di Tolak',
        payload: dataJson['message']['request'],
      );
    });

    penjualanChannel.bind('penjualan-proses', (last) {
      eventPenjualanDiProses = last;

      eventDataPenjualanDiProses.add(last.data);

      dynamic dataJson = jsonDecode(last.data);
      print(dataJson);

      notificationService.showBigTextNotification(
        // title: 'Segera melakukan proses packing',
        title: 'Transaksi Pembelian',
        description: 'Nota ${dataJson['message']['nota']} telah di proses',
        payload: dataJson['message']['request'],
      );
    });

    penjualanChannel.bind('penjualan-delivered', (last) {
      eventPenjulanDiKirim = last;

      eventDataPenjualanDiKirim.add(last.data);

      dynamic dataJson = jsonDecode(last.data);
      print(dataJson);

      notificationService.showBigTextNotification(
        // title: 'Segera melakukan proses packing',
        title: 'Transaksi Pembelian',
        description: 'Nota ${dataJson['message']['nota']} telah di kirim dengan no. ekspedisi ${dataJson['message']['expedisi']}',
        payload: dataJson['message']['request'],
      );
    });
  }

  void unbindEvent() {
    penjualanChannel.unbind('penjualan-di-konfirm');
    penjualanChannel.unbind('penjualan-delivered');
    penjualanChannel.unbind('penjualan-proses');
    penjualanChannel.unbind('penjualan-ditolak');
    // penjualanChannelOn.unbind('penjualan-payment-on');
    // penjualanChannelOn.unbind('penjualan-payment-off');
    // _eventData.close();
  }

  Future<void> firePusher() async {
    await initPusher();
    connectPusher();
    await subscribePusher();
    bindEvent();
  }
}
