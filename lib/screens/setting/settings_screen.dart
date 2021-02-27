import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zabor/app_localizations/app_language_provider.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/screens/basket_screen_module/basket_screen.dart';
import 'package:zabor/screens/change_password/change_password_screen.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/my_reservation_module/my_reservation_screen.dart';
import 'package:zabor/screens/order_history_screen_module/order_history_screen.dart';
import 'package:zabor/screens/profile/profile_screen.dart';
import 'package:zabor/screens/requests_screen/requests_screen.dart';
import 'package:zabor/screens/search_user_list_screen/search_user_list_screen.dart';
import 'package:zabor/screens/setting/widgets/settings_nav_row.dart';
import 'package:zabor/screens/setting/widgets/settings_toggle_row.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';
import 'package:zabor/screens/static_pages/static_page_screen.dart';

import '../../constants/constants.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isUserLogged = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    _isUserLogged = await AppUtils.isUserLoggedIn() == null
        ? false
        : await AppUtils.isUserLoggedIn();
    print(_isUserLogged);
    setState(() {});
  }

  void logout(BuildContext context) async {
    ConfirmAction confirmAction = await showAlertWithTwoButton(
        context, 'Do you want to logout?', 'No', 'Yes');

    if (confirmAction == ConfirmAction.ACCEPT) {
      AppUtils.logout();
      setState(() {
        _isUserLogged = false;
      });
    }
  }

  void _myProfilePressed(BuildContext context) async {
    bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
        ? false
        : await AppUtils.isUserLoggedIn();
    if (!_isUserLoggedIn) {
      ConfirmAction confirmAction = await showAlertWithTwoButton(context,
          'You are not logged in.\nDo you want to login?', 'No', 'Yes');

      if (confirmAction == ConfirmAction.ACCEPT) {
        _navigateToLogin(context);
      }
      return;
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  void _changepasswordPressed(BuildContext context) async {
    bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
        ? false
        : await AppUtils.isUserLoggedIn();
    if (!_isUserLoggedIn) {
      ConfirmAction confirmAction = await showAlertWithTwoButton(context,
          'You are not logged in.\nDo you want to login?', 'No', 'Yes');

      if (confirmAction == ConfirmAction.ACCEPT) {
        _navigateToLogin(context);
      }
      return;
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(AppLocalizations.of(context).translate('MORE'),
                style: AppFontStyle().kHeadingTextStyle),
            SizedBox(
              height: 8,
            ),
            // Text(AppLocalizations.of(context).translate('You can manage following settings below'),
            //     style: AppFontStyle().kTextBlack11Style, textAlign: TextAlign.center,),
            SizedBox(
              height: 20,
            ),
            // new SettingsNavRow(
            //   title: AppLocalizations.of(context).translate('My Profile'),
            //   tapAction: () {
            //     _myProfilePressed(context);
            //   },
            // ),
            new SettingsNavRow(
              title: AppLocalizations.of(context).translate('Change password'),
              tapAction: () {
                _changepasswordPressed(context);
              },
            ),
            new SettingsToggleRow(
              title: AppLocalizations.of(context).translate('Change Language'),
              tapAction: (action) {
                print('Change Language $action');
                if (action) {
                  appLanguage.changeLanguage(Locale("es"));
                  return;
                }
                print('Change Language $action');
                appLanguage.changeLanguage(Locale("en"));
              },
            ),
            // new SettingsNavRow(
            //   title: AppLocalizations.of(context).translate('User List'),
            //   tapAction: () async {
            //     print('User List');
            //     bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
            //         ? false
            //         : await AppUtils.isUserLoggedIn();
            //     if (!_isUserLoggedIn) {
            //       ConfirmAction confirmAction = await showAlertWithTwoButton(
            //           context,
            //           'You are not logged in.\nDo you want to login?',
            //           'No',
            //           'Yes');

            //       if (confirmAction == ConfirmAction.ACCEPT) {
            //         _navigateToLogin(context);
            //       }
            //       return;
            //     }

            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => SearchUserListScreen()));
            //   },
            // ),
            // new SettingsNavRow(
            //   title: AppLocalizations.of(context).translate('Requests'),
            //   tapAction: () async {
            //     print('Requests');
            //     bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
            //         ? false
            //         : await AppUtils.isUserLoggedIn();
            //     if (!_isUserLoggedIn) {
            //       ConfirmAction confirmAction = await showAlertWithTwoButton(
            //           context,
            //           'You are not logged in.\nDo you want to login?',
            //           'No',
            //           'Yes');

            //       if (confirmAction == ConfirmAction.ACCEPT) {
            //         _navigateToLogin(context);
            //       }
            //       return;
            //     }

            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => RequestsScreen()));
            //   },
            // ),
            new SettingsNavRow(
              title: AppLocalizations.of(context).translate('My Basket'),
              tapAction: () async {
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
                        builder: (context) => BasketScreen(
                              isFromSettings: true,
                            )));
              },
            ),
            // new SettingsNavRow(
            //   title: AppLocalizations.of(context).translate('My Reservations'),
            //   tapAction: () async {
            //     bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
            //         ? false
            //         : await AppUtils.isUserLoggedIn();
            //     if (!_isUserLoggedIn) {
            //       ConfirmAction confirmAction = await showAlertWithTwoButton(
            //           context,
            //           'You are not logged in.\nDo you want to login?',
            //           'No',
            //           'Yes');

            //       if (confirmAction == ConfirmAction.ACCEPT) {
            //         _navigateToLogin(context);
            //       }
            //       return;
            //     }

            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => MyReservationScreen()));
            //   },
            // ),
            new SettingsNavRow(
              title: AppLocalizations.of(context).translate('Order History'),
              tapAction: () async {
                bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
                    ? false
                    : await AppUtils.isUserLoggedIn();
                // if (!_isUserLoggedIn) {
                //   ConfirmAction confirmAction = await showAlertWithTwoButton(
                //       context,
                //       'You are not logged in.\nDo you want to login?',
                //       'No',
                //       'Yes');

                //   if (confirmAction == ConfirmAction.ACCEPT) {
                //     _navigateToLogin(context);
                //   }
                //   return;
                // }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderHistoryScreen()));
              },
            ),
            new SettingsNavRow(
              title: AppLocalizations.of(context).translate('Share feedback'),
              tapAction: () async {
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
                        builder: (context) => ShareFeedbackScreen()));
              },
            ),
            new SettingsNavRow(
              title: AppLocalizations.of(context)
                  .translate('Terms and Conditions'),
              tapAction: () {
                print('Terms and Conditions');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaticPageScreen(
                              description:
                                  'Read terms and conditions carefully.',
                              title: 'Terms and Conditions',
                              id: 1,
                            )));
              },
            ),
            // new SettingsNavRow(
            //   title: AppLocalizations.of(context).translate('Rate App'),
            //   tapAction: () {
            //     print('Rate App');
            //   },
            // ),
            new SettingsNavRow(
              title: AppLocalizations.of(context).translate('About Us'),
              tapAction: () {
                print('About Us');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaticPageScreen(
                              description: 'Get to know more about us',
                              title: 'ABOUT US',
                              id: 3,
                            )));
              },
            ),
            new SettingsNavRow(
              title: AppLocalizations.of(context).translate('Privacy Policy'),
              tapAction: () {
                print('Privacy Policy');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaticPageScreen(
                              description: 'Read our privacy policy carefully.',
                              title: 'PRIVACY POLICY',
                              id: 2,
                            )));
              },
            ),
            // new SettingsToggleRow(
            //   title: 'Notification toggle',
            //   tapAction: (action) {
            //     print('Notification toggle');
            //   },
            // ),
            FlatButton(
              onPressed: () {
                if (_isUserLogged) {
                  logout(context);
                } else {
                  _navigateToLogin(context);
                }
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            _isUserLogged
                                ? AppLocalizations.of(context)
                                    .translate('Logout')
                                : AppLocalizations.of(context)
                                    .translate('Login'),
                            style: AppFontStyle().kHeadingTextStyle),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            AppLocalizations.of(context).translate('Follow Us'),
                            style: AppFontStyle().kHeadingTextStyle),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                  icon: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    color: AppColors().kPrimaryColor,
                                  ),
                                  onPressed: () async {
                                    const url =
                                        'https://www.facebook.com/zaboreats/';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }),
                              IconButton(
                                  // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                  icon: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    color: AppColors().kPrimaryColor,
                                  ),
                                  onPressed: () async {
                                    const url =
                                        'https://www.instagram.com/zaboreats/';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }),
                              IconButton(
                                  // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                  icon: FaIcon(
                                    FontAwesomeIcons.twitter,
                                    color: AppColors().kPrimaryColor,
                                  ),
                                  onPressed: () async {
                                    const url = 'https://twitter.com/ZaborEats';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }),
                            ]),
                      ],
                    ),
                  )
                ],
              ),
            )
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
