import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zabor/screens/filter/providers/filter_option_provider.dart';
import 'package:zabor/screens/food_list_module/food_list_provider.dart';
import 'package:zabor/screens/give_rating/give_rating_provider/give_rating_provider.dart';
import 'package:zabor/screens/home/homescreen.dart';
import 'package:zabor/screens/login_signup/providers/login_sigup_provider.dart';
import 'package:zabor/screens/timeline_screen/timeline_screen.dart';
import 'package:zabor/state_manager_widgets/is_user_logged_in.dart';
import 'package:zabor/state_manager_widgets/tab_bar_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zabor/webservices/webservices.dart';
import 'app_localizations/app_language_provider.dart';
import 'app_localizations/app_localizations.dart';

//void main() => runApp(ZaborApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(ZaborApp(
    appLanguage: appLanguage,
  ));
}

class ZaborApp extends StatelessWidget {
  final AppLanguage appLanguage;

  ZaborApp({this.appLanguage});
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLanguage>(builder: (context) => appLanguage,),
        ChangeNotifierProvider<LoginSignupTabBar>(builder: (context) => LoginSignupTabBar(),),
        ChangeNotifierProvider<TabBarManager>(builder: (context) => TabBarManager(),),
        ChangeNotifierProvider<FilterOptionSelection>(builder: (context) => FilterOptionSelection(),),
        ChangeNotifierProvider<Webservices>(builder: (context) => Webservices(),),
        ChangeNotifierProvider<GiveRatingProvider>(builder: (context) => GiveRatingProvider(),),
        ChangeNotifierProvider<UserLoggedInManager>(builder: (context) => UserLoggedInManager(),),
        ChangeNotifierProvider<FoodListProvider>(builder: (context) => FoodListProvider(),),
      ],
        child: Consumer<AppLanguage>(
          builder: (context,model,child) => MaterialApp(
            locale: model.appLocal,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('es', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
            home: HomeScreen(),
            debugShowCheckedModeBanner: false,
          ),
        ),
    );
  }
}
