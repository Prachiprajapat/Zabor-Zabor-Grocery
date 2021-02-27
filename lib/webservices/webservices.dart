import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';

class Webservices extends ChangeNotifier {
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  Future<T> callPOSTWebserivce<T>(String url, dynamic data) async {
    print('hitting url: ' + url);
    print('with parameter: ' + data.toString());
    _isFetching = true;
    notifyListeners();
    var response = await http.post(url, body: data);
    _isFetching = false;
    notifyListeners();
    if (response.statusCode == 200) {
      print(response.body);
      return fromJson<T>(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      print(response.body);
      final responseModel =
          ErrorResponseModel.fromJson(jsonDecode(response.body));
      return fromJson<T>(jsonDecode(
          '{"status":false,"msg":"${responseModel.errors[0].msg}"}'));
    } else {
      return fromJson<T>(
          jsonDecode('{"status":false,"msg":"Something went wrong"}'));
    }
    return null;
  }

  static T fromJson<T>(dynamic json) {
    if (T == RegistrationResponseModel) {
      return RegistrationResponseModel.fromJson(json) as T;
    } else if (T == LoginResponseModel) {
      return LoginResponseModel.fromJson(json) as T;
    } else if (T == CommonResponseModel) {
      return CommonResponseModel.fromJson(json) as T;
    } else {
      throw Exception("Unknown class");
    }
  }

  static List<K> _fromJsonList<K>(List jsonList) {
    if (jsonList == null) {
      return null;
    }

    List<K> output = List();

    for (Map<String, dynamic> json in jsonList) {
      output.add(fromJson(json));
    }

    return output;
  }
}

class ErrorResponseModel {
  List<Error> errors;

  ErrorResponseModel({
    this.errors,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      ErrorResponseModel(
        errors: json["errors"] == null
            ? null
            : List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errors": errors == null
            ? null
            : List<dynamic>.from(errors.map((x) => x.toJson())),
      };
}

class Error {
  String location;
  String param;
  String value;
  String msg;

  Error({
    this.location,
    this.param,
    this.value,
    this.msg,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        location: json["location"] == null ? null : json["location"],
        param: json["param"] == null ? null : json["param"],
        value: json["value"] == null ? null : json["value"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "location": location == null ? null : location,
        "param": param == null ? null : param,
        "value": value == null ? null : value,
        "msg": msg == null ? null : msg,
      };
}
