

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zabor/constants/app_utils.dart';

class UserLoggedInManager extends ChangeNotifier {
  bool isLoggedin = false;

  UserLoggedInManager(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      getUser();
    });
  }

  getUser() async {
    isLoggedin = await AppUtils.isUserLoggedIn() == null
        ? false
        : await AppUtils.isUserLoggedIn();
    //print(isLoggedin);
    notifyListeners();
  }
 
}