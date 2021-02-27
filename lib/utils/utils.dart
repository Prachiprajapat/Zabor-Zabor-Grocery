import 'package:flutter/material.dart';

double baseHeight = 640.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message,
    SnackBarAction action) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    action: action,
    content: Text(message),
  ));
}
