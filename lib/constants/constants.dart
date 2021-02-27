import 'package:flutter/material.dart';

String appName = "Mi Gente";
String sessionExpiredText = "Your session is expired. Please login again";
//String kSTRIPE_PK_KEY = "pk_test_lRz8873Lk5axb5QUnywYIfY900dpsCQsO2";
// String kSTRIPE_PK_KEY = "pk_live_R7bScpn0VGJrRJY6i3PGgPwh00qlrncFv3";
String kSTRIPE_PK_KEY = "51H4WVeBZjZ6JXTd8P57n2CqdZIzGDa4UTMe3uYUUk5cpK3xxQ69xGs368y2mM97JzfwfFn2OG6Pht0W3wgkzhstM00ngNkjcK8";
String kGoogleApiKey = "AIzaSyAfxEnHzdr3k9Cglf3WpNgzP1XGqLNX4nI";

String subAdminstrativeArea = '';
class AppFontStyle {
  final TextStyle kHeadingTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: 'Roboto',
  );
  final TextStyle kHeading16TextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: 'Roboto',
  );
  final TextStyle kHeading16GreyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    fontFamily: 'Roboto',
  );
  final TextStyle kHeadingTextButtonStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Roboto');
  final TextStyle kTextGrey11Style =
      TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Roboto');
  final TextStyle kTextBlack11Style =
      TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Roboto');
  final TextStyle kTextBlack10Style =
      TextStyle(fontSize: 10, color: Colors.black, fontFamily: 'Roboto');
  final TextStyle kTextGrey12Style =
      TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Roboto');
  final TextStyle kTextYellowBold12Style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: AppColors().kPrimaryColor,
      fontFamily: 'Roboto');
}

class AppColors {
  final Color kPrimaryColor = Color(0xFFf46a39);
  final Color kYellowColor = Colors.amber[100];
  final Color kGreyColor100 = Colors.grey[100];
  final Color kGreyColor200 = Colors.grey[400];
  final Color kBlackColor = Colors.black;
  final Color kBlackColor54 = Colors.black45;
  final Color kBlackColor38 = Colors.black38;
  final Color kWhiteColor = Colors.white;
  final Color kGreenColor = Colors.green;
  final Color kGrey = Colors.grey;
  final Color redkGrey = Colors.red;
}

class AppHelpers {
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return 'Please Enter Password';
    } else {
      return null;
    }
  }

  String validateName(String value) {
    if (value.length == 0) {
      return 'Please Enter Name';
    } else {
      return null;
    }
  }
}

Future<void> showAlert(BuildContext context, String msg) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(appName),
        content: Text('$msg'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> showAlertWithTwoButton(BuildContext context,
    String description, String cancelText, String accpetText) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(appName),
        content: Text(description),
        actions: <Widget>[
          FlatButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: Text(accpetText),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

class CommonResponseModel {
  bool status;
  String msg;

  CommonResponseModel({
    this.status,
    this.msg,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
      };
}

class ApiResponse<T> {
  T data;
  String message;
  bool error;
  ApiResponse({this.data, this.error = false, this.message});
}

class SharedPrefKeys {
  static String userLoggedIn = "userLoggedIn";
  static String userAccessToken = "userAccessToken";
  static String userModel = "userModel";
  static String deviceToken = "deviceToken";
  static String lastOrderId = "lastOrderId";
}

GestureDetector showMessage(String message, Function onTap, bool isSuccess) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              child: isSuccess
                  ? Icon(
                      Icons.check,
                      size: 140,
                      color: AppColors().kPrimaryColor,
                    )
                  : Icon(
                      Icons.error,
                      size: 140,
                      color: AppColors().kPrimaryColor,
                    ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors().kPrimaryColor)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
}
