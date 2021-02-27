import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/state_manager_widgets/tab_bar_manager.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:http/http.dart' as http;

class SocialButtonWidget extends StatefulWidget {
  const SocialButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  _SocialButtonWidgetState createState() => _SocialButtonWidgetState();
}

class _SocialButtonWidgetState extends State<SocialButtonWidget> {
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  bool _isLoading = false;
  final facebookLogin = FacebookLogin();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: ScreenUtil.instance.setHeight(90),
                        width: ScreenUtil.instance.setHeight(90),
                        // decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //         image: AssetImage('assets/images/insta.png'))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _loginWithFacebook();
                      },
                      child: Container(
                        height: ScreenUtil.instance.setHeight(90),
                        width: ScreenUtil.instance.setHeight(90),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/fb.png'))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _login();
                      },
                      child: Container(
                        height: ScreenUtil.instance.setHeight(90),
                        width: ScreenUtil.instance.setHeight(90),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/google.png'))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: ScreenUtil.instance.setHeight(90),
                        width: ScreenUtil.instance.setHeight(90),
                        // decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //         image: AssetImage('assets/images/twitter.png'))),
                      ),
                    ),
                  ],
                ),
                Platform.isIOS
                    ? AppleSignInButton(
                        // style: ButtonStyle.black,
                        type: ButtonType.continueButton,
                        onPressed: appleLogIn,
                      )
                    : Container()
              ],
            ),
    );
  }

  _loginWithFacebook() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await facebookLogin.logIn(['email']);
      final token = result.accessToken.token;
      String deviceToken = await AppUtils.getDeviceToken();
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
      final profile = json.decode(graphResponse.body);
      print(profile);
      setState(() {
        _isLoading = false;
      });
      callLoginWithSocialAccountApi(json.encode({
        "name": profile["name"] ?? "",
        "email": profile["email"] ?? "",
        "fb_token": profile["id"] ?? "",
        "role": "user",
        "device_token": deviceToken
      }));
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _currentUser = await _googleSignIn.signIn();
      String token = await AppUtils.getDeviceToken();
      setState(() {
        _isLoading = false;
        if (_currentUser == null) return;
        print("${_currentUser.email}");
        callLoginWithSocialAccountApi(json.encode({
          "name": _currentUser.displayName ?? "",
          "email": _currentUser.email ?? "",
          "google_token": _currentUser.id ?? "",
          "role": "user",
          "device_token": token
        }));
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _logout() {
    _googleSignIn.signOut();
    setState(() {
      print("logiyte");
    });
  }

  callLoginWithSocialAccountApi(dynamic data) async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse<LoginResponseModel> apiResponse = await K3Webservice.postMethod(
        apisToUrls(Apis.socialLogin),
        data,
        {"Content-Type": "application/json"});

    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      showAlert(context, apiResponse.message ?? "");
      return;
    } else {
      final tabBarManager = Provider.of<TabBarManager>(context);
      AppUtils.saveUser(apiResponse.data.data.user);
      AppUtils.saveToken(apiResponse.data.data.token);
      tabBarManager.activeTab = 0;
      Navigator.pop(context);
    }
  }

  appleLogIn() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.identityToken);
          print(result.credential.email);
          String deviceToken = await AppUtils.getDeviceToken();
          callLoginWithSocialAccountApi(json.encode({
            "name": result.credential.fullName ?? "",
            "email": result.credential.email ?? "",
            "fb_token": result.credential.identityToken ?? "",
            "role": "user",
            "device_token": deviceToken
          }));
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }
}
