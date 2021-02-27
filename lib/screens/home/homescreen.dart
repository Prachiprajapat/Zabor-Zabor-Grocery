import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/screens/drawer/drawer_screen.dart';
import 'package:zabor/screens/feed/feed_screen.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/more/more_screen.dart';
import 'package:zabor/screens/profile/profile_screen.dart';
import 'package:zabor/screens/setting/settings_screen.dart';
import 'package:zabor/state_manager_widgets/is_user_logged_in.dart';
import 'package:zabor/state_manager_widgets/tab_bar_manager.dart';
import 'package:zabor/utils/location_services.dart';
import '../home/../../constants/constants.dart';
import 'widgets/home_body.dart';

//final kTabWidget = [HomeBody(), FeedsScreen(), SettingScreen(), MoreScreen()];
final kTabWidget = [
  HomeBody(),
  //FeedsScreen(),
  ProfileScreen(),
  SettingScreen()
];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        if (Platform.isIOS) {
          showAlert(context, message['aps']['alert']['body']);
        } else {
          showAlert(context, message['notification']['body']);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print(token);
      AppUtils.saveFirebaseDeviceToken(token);
    });
    //getCurrentLocation();
  }

  getCurrentLocation() async {
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);
    } catch (error) {
      print(error);
    }
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabBarManager = Provider.of<TabBarManager>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<TabBarManager>(
        builder: (context, tabBarManager, child) => SafeArea(
          child: kTabWidget[tabBarManager.activeTab],
        ),
      ),
      bottomNavigationBar: Consumer<TabBarManager>(
        builder: (context, tabManager, child) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabManager.activeTab,
          showUnselectedLabels: true,
          selectedItemColor: AppColors().kPrimaryColor,
          unselectedItemColor: AppColors().kBlackColor,
          onTap: (int index) => {tabBarManager.makeActive(index)},
          items: [
            BottomNavigationBarItem(
                icon: tabManager.activeTab == 0
                    ? FaIcon(FontAwesomeIcons.home, color: AppColors().kPrimaryColor,)
                    : FaIcon(FontAwesomeIcons.home),
                title: Text('Home')),
            // BottomNavigationBarItem(
            //     icon: tabManager.activeTab == 1
            //         ? Image.asset("assets/images/feeds_unselected.png")
            //         : Image.asset("assets/images/feeds_selected.png"),
            //     title: Text('Feeds')),
            BottomNavigationBarItem(
                icon: tabManager.activeTab == 1
                    ? Icon(Icons.account_box, color: AppColors().kPrimaryColor)
                    : Icon(Icons.account_box),
                title: Text('Profile')),
            BottomNavigationBarItem(
                icon: tabManager.activeTab == 2
                    ? FaIcon(FontAwesomeIcons.ellipsisV, color: AppColors().kPrimaryColor,)
                    : FaIcon(FontAwesomeIcons.ellipsisV),
                title: Text('More')),
          ],
        ),
      ),
      drawer: DrawerScreen(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool _isUserLogged = true;
  @override
  void initState() {
    super.initState();
    //getUser();
  }

  getUser() async {
    _isUserLogged = await AppUtils.isUserLoggedIn() == null
        ? false
        : await AppUtils.isUserLoggedIn();
    print(_isUserLogged);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final userLoggedInManager = Provider.of<UserLoggedInManager>(context);
    return Consumer<UserLoggedInManager>(
        builder: (context, userLoggedInManager, child) =>
            userLoggedInManager.isLoggedin
                ? ProfileScreen()
                : promptUserLoingWidget());
    //return _isUserLogged ? ProfileScreen() : promptUserLoingWidget();
  }

  Container promptUserLoingWidget() {
    return Container(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 50,
                color: AppColors().kPrimaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'You are not logged in\n',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(text: 'Please'),
                      TextSpan(
                          text: ' login ',
                          style: TextStyle(
                              color: AppColors().kPrimaryColor,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginSignupScreen()));
                            }),
                      TextSpan(text: 'to see the feeds')
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
