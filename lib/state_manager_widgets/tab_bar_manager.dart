
import 'package:flutter/material.dart';

class TabBarManager extends ChangeNotifier {
  int activeTab = 0;
  void makeActive(int tab) {
    this.activeTab = tab;
    notifyListeners();
  }
}