import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/providers/login_sigup_provider.dart';
import 'package:zabor/screens/login_signup/widgets/login_widget.dart';
import 'package:zabor/screens/login_signup/widgets/singup_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginSignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenUtil = ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
                  Container(
                    height: ScreenUtil.instance.setHeight(550),
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/images/grocery_splash.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
              Expanded(
                child: Container(
                  color: AppColors().kWhiteColor,
                ),
              ),
            ],
          ),
          Consumer<LoginSignupTabBar>(
            builder: (context, loginSignupTabBar, child) =>
                loginSignupTabBar.loginSignupTab == LoginSignupTab.Login
                    ? LoginWidget()
                    : SignupWidget(),
          ),
                            Positioned(
                    right: 10,
                    top: 20,
                    child: IconButton(
                      icon: Image.asset('assets/images/cancel.png'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
        ],
      ),
    );
  }
}
