import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/forgot_password/widgets/forgot_password_widget.dart';

class ForgotPassswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: ScreenUtil.instance.setHeight(550),
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/splash.png',
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
          ForgotPasswordWidget(),
          Positioned(
            top: 30,
            child: FlatButton(
              onPressed: () => {Navigator.pop(context)},
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('assets/images/back2.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
