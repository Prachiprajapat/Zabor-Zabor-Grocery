import 'package:flutter/foundation.dart';

class FilterOptionSelection extends ChangeNotifier{
  int option = 0;

  void select(int option){
    this.option = option;
    notifyListeners();
  }
}