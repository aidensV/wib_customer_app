import 'package:flutter/material.dart';

class ShopBloc with ChangeNotifier {
  Map<int, int> _cart = {};

  Map<int, int> _detail = {};

  Map<int, int> get cart => _cart;
  Map<int, int> get detail => _detail;

  void addToCart(index) {
    if (_cart.containsKey(index)) {
      _cart[index] += 1;
    } else {
      _cart[index] = 1;
    }
    notifyListeners();
  }

  void detailView(index) {
    if (_detail.containsKey(index)) {
      _detail[index] += 1;
    } else {
      _detail[index] = 1;
    }
    notifyListeners();
  }

  void reduceQty(index) {
    if (_cart[index] == 1) {
      _cart.remove(index);
      notifyListeners();
    } else {
      if (_cart.containsKey(index)) {
        _cart[index] -= 1;
      } else {
        _cart[index] = 1;
      }
      notifyListeners();
    }
  }

  void clear(index) {
    if (_cart.containsKey(index)) {
      _cart.remove(index);
      notifyListeners();
    }
  }
}
