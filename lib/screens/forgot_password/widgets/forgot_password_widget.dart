import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/webservices/webservices.dart';

class ForgotPasswordWidget extends StatefulWidget {
  @override
  _ForgotPasswordWidgetState createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  String _email;

  @override
  Widget build(BuildContext context) {
        final webservices = Provider.of<Webservices>(context,listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
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
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'FORGOT PASSWORD',
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
                        Text("Enter your email address below and we'll send you instructions on how to change your password",
                        textAlign: TextAlign.center
                        ,style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(25),
                        ),),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(20),
                        ),
                        emailTextField(),
                         SizedBox(
                          height: ScreenUtil.getInstance().setHeight(30),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: ScreenUtil.instance.setHeight(90),
                      width: double.infinity,
                      child: Consumer<Webservices>(
                      builder: (context,webservice,child) => FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        onPressed: webservice.isFetching ? null : () {
                          _validateInputs(context,webservices);
                        },
                        color: AppColors().kPrimaryColor,
                        child: webservice.isFetching ? CircularProgressIndicator() : Text(
                          'UPDATE',
                          style: AppFontStyle().kHeading16TextStyle,
                        ),
                      ),
                    ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.instance.setHeight(90),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                  child: Image.asset('assets/images/3.0x/email.png',
                      height: 20, width: 20, alignment: Alignment.center),
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

    void _validateInputs(context,webservices) async{
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final CommonResponseModel model = await webservices.callPOSTWebserivce<CommonResponseModel>(apisToUrls(Apis.forgotPassword),
        {'email': _email,
      });
      await showAlert(context, model.msg);
      if (model.status == true){
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}