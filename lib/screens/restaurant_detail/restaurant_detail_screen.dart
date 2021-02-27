import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/checkin_screen/checkin_screen.dart';
import 'package:zabor/screens/food_list_module/food_list_screen.dart';
import 'package:zabor/screens/give_rating/give_rating_screen.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/reserve_seat_module/reserve_seat_screen.dart';
import 'package:zabor/screens/restaurant_detail/widgets/restaurant_details_tab_view.dart';
import 'package:zabor/screens/restaurant_detail/widgets/restaurant_review_tab_view.dart';
import 'package:zabor/screens/restaurant_detail/widgets/restuarant_detail_top_widget.dart';
import 'package:zabor/webservices/webservices.dart';

import 'models/restaurant_details_model.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({Key key, this.restuarantModel})
      : super(key: key);

  @override
  _RestaurantDetailScreenState createState() =>
      _RestaurantDetailScreenState(restuarantModel);
  final RestaurantModel restuarantModel;
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final RestaurantModel restuarantModel;
  bool _isUserLoggedIn = false;
  bool _isLoading = false;
  final List<Widget> myTabs = [
    Tab(
      text: "",
    ),
    //Tab(text: "REVIEWS"),
  ];
  TabController _tabController;
  ScrollController _scrollController;
  RestaurantDetailModel _restaurantDetailModel;
  bool fixedScroll;

  _RestaurantDetailScreenState(this.restuarantModel);

  Widget _buildCarousel() {
    return Stack(
      children: <Widget>[
        Placeholder(fallbackHeight: 100),
        Positioned.fill(
            child: Align(alignment: Alignment.center, child: Text('Slider'))),
      ],
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    //_scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

    super.initState();
    callRestaurntDetailApi();
  }

  @override
  void didUpdateWidget(RestaurantDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void getIsUserLoggedIn() async {
    _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
        ? false
        : await AppUtils.isUserLoggedIn();
    setState(() {});
  }

  void callRestaurntDetailApi() async {
    setState(() {
      _isLoading = true;
    });
    var response = await http.post(apisToUrls(Apis.restaurantDetail),
        body: {"res_id": "${restuarantModel.id}"});
    print(response.body);
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      RestuarantDetailsResponseModel restuarantDetailsResponseModel =
          RestuarantDetailsResponseModel.fromJson(jsonDecode(response.body));
      _restaurantDetailModel = restuarantDetailsResponseModel.data;
    } else if (response.statusCode == 422) {
      final responseModel =
          ErrorResponseModel.fromJson(jsonDecode(response.body));
      _showSnackBar(context, responseModel.errors[0].msg);
    } else {
      _showSnackBar(context, 'Something went wrong');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (fixedScroll) {
      _scrollController.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      fixedScroll = _tabController.index == 1;
    });
  }

  _buildTabContext(int lineCount) => Container(
        child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: lineCount,
          itemBuilder: (BuildContext context, int index) {
            return Text('some content');
          },
        ),
      );

  _ratingButtonPressed(BuildContext context) async {
    if (_restaurantDetailModel.restaurantDetail == null) return;

    if (_isUserLoggedIn) {
      if (_restaurantDetailModel == null &&
          _restaurantDetailModel.restaurantDetail[0] == null) {
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GiveRatingScreen(
                    restaurantDetail:
                        _restaurantDetailModel.restaurantDetail[0],
                  )));
    } else {
      ConfirmAction confirmAction = await showAlertWithTwoButton(
          context,
          'To rate the restaurant you need to login.\n\n Do you want to login?',
          'No',
          'Yes');
      if (confirmAction == ConfirmAction.ACCEPT) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
      }
    }
  }

  _checkinButtonPressed(BuildContext context) async {
    if (_restaurantDetailModel.restaurantDetail == null) return;

    if (_isUserLoggedIn) {
      if (_restaurantDetailModel == null &&
          _restaurantDetailModel.restaurantDetail[0] == null) {
        return;
      }
      if (_restaurantDetailModel == null) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CheckinScreen(
                    restaurantDetail:
                        _restaurantDetailModel.restaurantDetail[0],
                  )));
    } else {
      ConfirmAction confirmAction = await showAlertWithTwoButton(
          context,
          'You need to login to checkin.\n\n Do you want to login?',
          'No',
          'Yes');
      if (confirmAction == ConfirmAction.ACCEPT) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getIsUserLoggedIn();
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                  child: RestuarantDetailTopWidget(
                restuarantModel: restuarantModel,
              )),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors().kBlackColor,
                  isScrollable: false,
                  tabs: myTabs,
                  indicatorColor: AppColors().kPrimaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors().kBlackColor),
                ),
              ),
            ];
          },
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _restaurantDetailModel == null
                  ? Center(
                      child: Text('No Detail Found'),
                    )
                  : Container(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          RestaurantDetailsTabView(
                            restaurantDetailModel: _restaurantDetailModel,
                          ),
                          // RestaurantReviewTabView(
                          //   reviews: _restaurantDetailModel.review,
                          // )
                        ],
                      ),
                    ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          children: <Widget>[
            SizedBox(width:10),
            // Expanded(child: FlatButton(child: Text(AppLocalizations.of(context).translate('BOOK')),onPressed: (){
            //   Navigator.push(context, MaterialPageRoute(builder:(context) => ReserveSeatScreen(
            //     resId: restuarantModel == null ? 0 :restuarantModel.id,
            //   )));
            // }, color: AppColors().kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),)),
            // SizedBox(width:15),
            Expanded(child: FlatButton(child: Text(AppLocalizations.of(context).translate('ORDER NOW')),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder : (context) => FoodListScreen(restName: restuarantModel == null ? '' :restuarantModel.name, restId: restuarantModel == null ? 0 :restuarantModel.id,)));
            }, color: AppColors().kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))),
            SizedBox(width:10),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors().kPrimaryColor,
              child: Icon(Icons.star),
              onPressed: () {
                _ratingButtonPressed(context);
              },
            ),
    );
  }
}
