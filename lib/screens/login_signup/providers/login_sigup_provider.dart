

import 'package:flutter/material.dart';

class LoginSignupTabBar extends ChangeNotifier{
  LoginSignupTab loginSignupTab = LoginSignupTab.Login;

  void changeTab(LoginSignupTab loginSignupTab){
    this.loginSignupTab = loginSignupTab;
    notifyListeners();
  }

}

enum LoginSignupTab{
  Login,Signup
}