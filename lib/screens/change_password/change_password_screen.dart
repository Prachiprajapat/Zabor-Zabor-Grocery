import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/change_password/bloc/bloc.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/utils/bloc_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  String _oldPassword;
  String _newPassword;
  String _confirmPassword;
  double _textFieldBoxHeight = 60;
  ChangePasswordBloc _changePasswordBloc;

  @override
  void initState() {
    super.initState();
    _changePasswordBloc = ChangePasswordBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset('assets/images/back2.png'),
                    onPressed: () => {Navigator.pop(context)},
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('CHANGE PASSWORD'),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      // Text(
                      //   'Change your password from below.',
                      //   style: TextStyle(
                      //       fontSize: 16, color: AppColors().kBlackColor),
                      // ),
                    ],
                  ),
                ],
              ),
              StreamBuilder<BlocState>(
                  stream: _changePasswordBloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data is BlocLoadingState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.data is BlocFailureState) {
                      BlocFailureState state = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 60),
                        child: showMessage(state.message, () {
                          _changePasswordBloc.initState();
                        }, false),
                      );
                    }

                    if (snapshot.data is BlocAuthErrorState) {
                      BlocAuthErrorState state = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 60),
                        child: showMessage(state.message, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginSignupScreen()));
                        }, false),
                      );
                    }

                    if (snapshot.data is BlocSuccessState) {
                      BlocSuccessState state = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 60),
                        child: showMessage(state.message, () {
                          Navigator.pop(context);
                        }, true),
                      );
                    }

                    if (snapshot.data is BlocInitState) {
                      return buildInitBody(context);
                    }

                    return buildInitBody(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildInitBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            textFieldContainer(
                AppLocalizations.of(context).translate('Old Password'),
                'assets/images/3.0x/lock.png',
                _textFieldBoxHeight, (String val) {
              _oldPassword = val;
            }),
            SizedBox(
              height: 20,
            ),
            textFieldContainer(
                AppLocalizations.of(context).translate('New Password'),
                'assets/images/3.0x/lock.png',
                _textFieldBoxHeight, (String val) {
              _newPassword = val;
            }),
            SizedBox(
              height: 20,
            ),
            textFieldContainer(
                AppLocalizations.of(context).translate('Confirm Password'),
                'assets/images/3.0x/lock.png',
                _textFieldBoxHeight, (String val) {
              _confirmPassword = val;
            }),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                onPressed: () {
                  _validateInputs(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15),
                ),
                color: AppColors().kPrimaryColor,
                child: Text(
                  AppLocalizations.of(context).translate('SAVE PASSWORD'),
                  style: TextStyle(
                      color: AppColors().kBlackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Stack textFieldContainer(String hintText, String iconAsset,
      double textFieldBoxHeight, Function onSaved(String value)) {
    return Stack(
      children: <Widget>[
        Container(
          height: textFieldBoxHeight,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, spreadRadius: 0.1, blurRadius: 10)
              ],
              color: AppColors().kWhiteColor,
              borderRadius: BorderRadius.circular(10)),
        ),
        Positioned(
            left: 10,
            right: 10,
            top: 10,
            bottom: 10,
            child: passwordTextField(hintText, iconAsset, onSaved))
      ],
    );
  }

  Widget passwordTextField(
      String hinText, String iconAsset, Function onSaved(String value)) {
    return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
            hintText: hinText,
            icon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Image.asset(iconAsset,
                  height: 20, width: 20, alignment: Alignment.center),
            ),
            enabledBorder: InputBorder.none,
            border: InputBorder.none),
        validator: AppHelpers().validatePassword,
        onSaved: onSaved);
  }

  void _validateInputs(context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _textFieldBoxHeight = 60;
      });
      if (_newPassword != _confirmPassword) {
        showInSnackBar('Password does not matched');
        return;
      }
      _changePasswordBloc.changePassword(_oldPassword, _newPassword);
    } else {
      setState(() {
        _textFieldBoxHeight = 80;
      });
    }
  }

  void showInSnackBar(msg) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: Text(msg),
    ));
  }
}
