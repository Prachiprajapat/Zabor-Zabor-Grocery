

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zabor/constants/constants.dart';

class PasswordTextFieldWidget extends StatelessWidget {
  const PasswordTextFieldWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors().kGreyColor100),
          borderRadius: BorderRadius.all(
              new Radius.circular(ScreenUtil.instance.setHeight(90))),
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image.asset('assets/images/3.0x/lock.png',height: 20,width: 20,),
              ),
              enabledBorder: InputBorder.none,
              border: InputBorder.none),
        ),
      ),
    );
  }
}

class EmailTextFieldWidget extends StatelessWidget {
  const EmailTextFieldWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors().kGreyColor100),
          borderRadius: BorderRadius.all(
              new Radius.circular(ScreenUtil.instance.setHeight(90))),
        ),
        child: TextField(
          decoration: InputDecoration(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Image.asset('assets/images/3.0x/email.png',height: 20,width: 20,alignment: Alignment.center),
            ),
              enabledBorder: InputBorder.none,
              border: InputBorder.none),
        ),
      ),
    );
  }
}

//Image.asset('assets/images/3.0x/email.png')
class FullNameTextFieldWidget extends StatelessWidget {
  const FullNameTextFieldWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors().kGreyColor100),
          borderRadius: BorderRadius.all(
              new Radius.circular(ScreenUtil.instance.setHeight(90))),
        ),
        child: TextField(
          decoration: InputDecoration(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset('assets/images/3.0x/full_name.png',height: 20,width: 20,),
              ),
              enabledBorder: InputBorder.none,
              border: InputBorder.none),
        ),
      ),
    );
  }
}
