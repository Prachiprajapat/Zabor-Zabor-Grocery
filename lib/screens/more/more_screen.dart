import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/more/widgets/more_option_widget.dart';
import 'package:zabor/screens/requests_screen/requests_screen.dart';
import 'package:zabor/screens/search_user_list_screen/search_user_list_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(AppLocalizations.of(context).translate('MORE'), style: AppFontStyle().kHeadingTextStyle),
            SizedBox(
              height: 8,
            ),
            new MoreOptionWidget(
              title: AppLocalizations.of(context).translate('User List'),
              onPressed: () async {
                print('User List');
                bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
                    ? false
                    : await AppUtils.isUserLoggedIn();
                if (!_isUserLoggedIn) {
                  ConfirmAction confirmAction = await showAlertWithTwoButton(
                      context,
                      'You are not logged in.\nDo you want to login?',
                      'No',
                      'Yes');

                  if (confirmAction == ConfirmAction.ACCEPT) {
                    _navigateToLogin(context);
                  }
                  return;
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchUserListScreen()));
              },
            ),
            new MoreOptionWidget(
              title: AppLocalizations.of(context).translate('Requests'),
              onPressed: () async {
                print('Requests');
                bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
                    ? false
                    : await AppUtils.isUserLoggedIn();
                if (!_isUserLoggedIn) {
                  ConfirmAction confirmAction = await showAlertWithTwoButton(
                      context,
                      'You are not logged in.\nDo you want to login?',
                      'No',
                      'Yes');

                  if (confirmAction == ConfirmAction.ACCEPT) {
                    _navigateToLogin(context);
                  }
                  return;
                }

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RequestsScreen()));
              },
            ),
            // new MoreOptionWidget(
            //   title: 'Explore',
            //   onPressed: () {
            //     print('Explore');
            //   },
            // )
          ],
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginSignupScreen()));
  }
}
