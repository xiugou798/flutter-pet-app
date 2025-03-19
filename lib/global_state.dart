import 'package:flutter/material.dart';

class GlobalState extends ChangeNotifier {
  int _counter = 0;
  bool _isLogin = false;
  var _userInfo = null;

  int get counter => _counter;
  bool get isLogin => _isLogin;

  get userInfo => _userInfo;


  void updateUserInfo(userInfo) {
    _userInfo = userInfo;
  }

  void login(){
    _isLogin = true;
  }

  void logout(){
    _isLogin = false;
  }

  // 修改状态的方法
  void increment() {
    _counter++;
    notifyListeners();
  }
}
