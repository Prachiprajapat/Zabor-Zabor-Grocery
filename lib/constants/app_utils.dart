import 'package:shared_preferences/shared_preferences.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'dart:convert';

import 'constants.dart';

class AppUtils {

  static void saveFirebaseDeviceToken(String token) async{
    final pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefKeys.deviceToken, token);
  }

  static Future<String> getDeviceToken() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString(SharedPrefKeys.deviceToken) == null ? '' : pref.getString(SharedPrefKeys.deviceToken);
  }

  static void saveUser(User userModel) async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> json = userModel.toJson();
    pref.setString(SharedPrefKeys.userModel, jsonEncode(json));
    pref.setBool(SharedPrefKeys.userLoggedIn, true);
  }

  static void saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefKeys.userAccessToken, token);
  }

  static Future<dynamic> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.get(SharedPrefKeys.userAccessToken) == null ? null : pref.get(SharedPrefKeys.userAccessToken);
  }

  static void saveLastOrderId(int value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefKeys.lastOrderId, '$value');
  }


  static Future<dynamic> getLastOrderId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(SharedPrefKeys.lastOrderId) == null ? null : pref.getString(SharedPrefKeys.lastOrderId);
  }


  static void logout() async{
        final pref = await SharedPreferences.getInstance();
        pref.remove(SharedPrefKeys.userLoggedIn);
        pref.remove(SharedPrefKeys.userModel);
        pref.remove(SharedPrefKeys.userAccessToken);
  }

  static Future<bool> isUserLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(SharedPrefKeys.userLoggedIn) == null ? false : pref.getBool(SharedPrefKeys.userLoggedIn);
  }

  static Future<User> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString(SharedPrefKeys.userModel);
    if (jsonString == null) {
      pref.setBool(SharedPrefKeys.userLoggedIn, false);
      return null;
    }
    final json = jsonDecode(jsonString);
    final user = User.fromJson(json);
    return user;
  }
}
