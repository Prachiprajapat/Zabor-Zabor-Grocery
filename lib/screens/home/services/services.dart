import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/utils/location_services.dart';
import 'package:zabor/webservices/webservices.dart';

class HomeScreenServices {
  Future<ApiResponse<Data>> getHomeScreenData(BuildContext context) async {
    if (position == null) {
      try {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (error) {
        if (error.code == "PERMISSION_DENIED") {
          return ApiResponse(
              error: true, message: "Please give access to location.");
        }
      }
    }
    print(position.latitude);
    print(position.longitude);
    // List<Placemark> placemark = await Geolocator()
    //     .placemarkFromCoordinates(position.latitude, position.longitude);
    // if (placemark.isNotEmpty) {
    //   subAdminstrativeArea = placemark.first.subAdministrativeArea ?? '';
    // }
    final response = await http.post(apisToUrls(Apis.home), body: {
      "latitude": position == null ? "0.0" : "${position.latitude}",
      "longitude": position == null ? "0.0" : "${position.longitude}"
    });
    print(response.body);
    Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude)
        .then((value) => () {
              if (value.isNotEmpty) {
                subAdminstrativeArea = value.first.subAdministrativeArea ?? '';
              }
            });
    if (response.statusCode == 200) {
      HomeScreenResponseModel homeScreenResponseModel =
          HomeScreenResponseModel.fromJson(jsonDecode(response.body));
          checkForUpdate(homeScreenResponseModel, context);
      return ApiResponse(data: homeScreenResponseModel.data);
    } else if (response.statusCode == 422) {
      final responseModel =
          ErrorResponseModel.fromJson(jsonDecode(response.body));
      return ApiResponse(error: true, message: responseModel.errors[0].msg);
    } else {
      return ApiResponse(error: true, message: 'Something went wrong');
    }
  }

  checkForUpdate(
      HomeScreenResponseModel homeScreenResponseModel, BuildContext context) {
    if (Platform.isIOS) {
      if (homeScreenResponseModel.iOSVersion == null ||
          homeScreenResponseModel.iOSVersion == "") return;
      dynamic version = homeScreenResponseModel.iOSVersion;
      if (double.parse(version.toString().replaceAll('.', '').toString()) >
          double.parse(
              AppVersion.iOS.toString().replaceAll('.', '').toString())) {
        showUpdatePopup(null, null, context);
      }
    }

    if (Platform.isAndroid) {
      if (homeScreenResponseModel.androidVersion == null ||
          homeScreenResponseModel.androidVersion == "") return;
      dynamic version = homeScreenResponseModel.androidVersion;
      if (double.parse(version.toString().replaceAll('.', '').toString()) >
          double.parse(
              AppVersion.android.toString().replaceAll('.', '').toString())) {
        showUpdatePopup(null, null, context);
      }
    }
  }

  showUpdatePopup(dynamic title, dynamic description, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                title == null ? 'New Update Available!' : title.toString()),
            content: Text(description == null
                ? 'Please update the application to the latest version.'
                : description.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid) {
                    String url =
                        "https://play.google.com/store/apps/details?id=com.migente.storer";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }

                  if (Platform.isIOS) {
                    String url =
                        "https://apps.apple.com/app/mi-gente/id1515453228";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                },
              ),
            ],
          );
        });
  }
}
