import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/login_signup/providers/login_sigup_provider.dart';
import 'package:zabor/screens/login_signup/widgets/social_button.dart';
import 'package:zabor/webservices/webservices.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({
    Key key,
  }) : super(key: key);

  @override
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _password;
  String _email;
  String _name;
  String _confirmPassword;
  @override
  Widget build(BuildContext context) {
    final loginSignupTabBar =
        Provider.of<LoginSignupTabBar>(context, listen: false);
    final webservices = Provider.of<Webservices>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: ScreenUtil.instance.setHeight(420),
            ),
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: AppColors().kWhiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors().kBlackColor54,
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ]),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FlatButton(
                              child: Text('LOGIN',
                                  style: AppFontStyle().kHeading16GreyStyle),
                              onPressed: () {
                                loginSignupTabBar
                                    .changeTab(LoginSignupTab.Login);
                              },
                            ),
                            Stack(
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'SIGN UP',
                                    style: AppFontStyle().kHeading16TextStyle,
                                  ),
                                  onPressed: () {},
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  right: 15,
                                  child: Container(
                                    height: 2,
                                    width: 50,
                                    color: AppColors().kPrimaryColor,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        nameTextField(),
                        emailTextField(),
                        passwordTextField(),
                        confirmPasswordTextField(),
                        SizedBox(
                          height: ScreenUtil.instance.setHeight(30),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: ScreenUtil.instance.setHeight(90),
                    width: double.infinity,
                    child: Consumer<Webservices>(
                      builder: (context, webservice, child) => FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            onPressed: webservice.isFetching
                                ? null
                                : () {
                                    _validateInputs(
                                        webservices, loginSignupTabBar);
                                  },
                            color: AppColors().kPrimaryColor,
                            child: webservice.isFetching
                                ? CircularProgressIndicator()
                                : Text(
                                    'SIGN UP',
                                    style: AppFontStyle().kHeading16TextStyle,
                                  ),
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.instance.setHeight(90),
                ),
                Platform.isAndroid ? 
                buildSocialLoginColumn() : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?",
                        style: AppFontStyle().kTextGrey12Style),
                    Text(' '),
                    GestureDetector(
                      onTap: (){
                        loginSignupTabBar
                                    .changeTab(LoginSignupTab.Login);
                      },
                                          child: Text('SIGN IN',
                          style: AppFontStyle().kTextYellowBold12Style),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.instance.setHeight(20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column buildSocialLoginColumn() {
    return Column(children: [
                Text(
                  ('------- SOCIAL LOGIN WITH -------'),
                  style: AppFontStyle().kTextBlack10Style,
                ),
                SizedBox(
                  height: ScreenUtil.instance.setHeight(40),
                ),
                new SocialButtonWidget(),
                SizedBox(

                  height: ScreenUtil.instance.setHeight(40),
                ),
              ]);
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors().kGreyColor100),
          borderRadius: BorderRadius.all(
              new Radius.circular(ScreenUtil.instance.setHeight(90))),
        ),
        child: TextFormField(
            decoration: InputDecoration(
                hintText: 'Email',
                icon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FaIcon(FontAwesomeIcons.envelope, color: AppColors().kPrimaryColor,),
                ),
                enabledBorder: InputBorder.none,
                border: InputBorder.none),
            validator: AppHelpers().validateEmail,
            onSaved: (String val) {
              _email = val;
            }),
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors().kGreyColor100),
          borderRadius: BorderRadius.all(
              new Radius.circular(ScreenUtil.instance.setHeight(90))),
        ),
        child: TextFormField(
                    obscureText: true,
            decoration: InputDecoration(
                hintText: 'Password',
                icon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FaIcon(FontAwesomeIcons.unlock, color: AppColors().kPrimaryColor,),
                ),
                enabledBorder: InputBorder.none,
                border: InputBorder.none),
            validator: AppHelpers().validatePassword,
            onSaved: (String val) {
              _password = val;
            }),
      ),
    );
  }

  Widget confirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors().kGreyColor100),
          borderRadius: BorderRadius.all(
              new Radius.circular(ScreenUtil.instance.setHeight(90))),
        ),
        child: TextFormField(
          obscureText: true,
            decoration: InputDecoration(
                hintText: 'Confirm Password',
                icon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FaIcon(FontAwesomeIcons.unlock, color: AppColors().kPrimaryColor,),
                ),
                enabledBorder: InputBorder.none,
                border: InputBorder.none),
            validator: AppHelpers().validatePassword,
            onSaved: (String val) {
              _confirmPassword = val;
            }),
      ),
    );
  }

  Widget nameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors().kGreyColor100),
          borderRadius: BorderRadius.all(
              new Radius.circular(ScreenUtil.instance.setHeight(90))),
        ),
        child: TextFormField(
            decoration: InputDecoration(
                hintText: 'Name',
                icon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FaIcon(FontAwesomeIcons.user, color: AppColors().kPrimaryColor,),
                ),
                enabledBorder: InputBorder.none,
                border: InputBorder.none),
            validator: AppHelpers().validateName,
            onSaved: (String val) {
              _name = val;
            }),
      ),
    );
  }

  void _validateInputs(webservices, loginSignupTabBar) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_password != _confirmPassword) {
        showSnackBar('Password does not matched');
        return;
      }
      final RegistrationResponseModel model = await webservices
          .callPOSTWebserivce<RegistrationResponseModel>(
              apisToUrls(Apis.registration), {
        'name': _name,
        'email': _email,
        'password': _password,
        'role': 'user'
      });

      showSnackBar(model.msg);
      if (model.status == true) {
        loginSignupTabBar.changeTab(LoginSignupTab.Login);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void showSnackBar(String value){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }
}
