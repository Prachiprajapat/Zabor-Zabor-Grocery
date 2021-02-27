import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/filter/providers/filter_option_provider.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/screens/home/widgets/restaurant_carview.dart';
import 'package:zabor/screens/restaurant_detail/restaurant_detail_screen.dart';
import 'package:zabor/screens/restaurant_list/services/restaurant_list_services.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen(
      {Key key,
      this.subCatId,
      @required this.restaurantListEntryPoint,
      this.query})
      : super(key: key);
  final int subCatId;
  final RestaurantListEntryPoint restaurantListEntryPoint;
  final String query;

  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<RestaurantModel> arrRestaurants = [];
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool _isCall = true;

  _RestaurantListScreenState();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    callRestaurantList();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page = _page + 1;
        print(_page);
        if (_isCall) {
          callLoadMoreRestaurantList();
        }
      }
    });
  }

  void callRestaurantList() async {
    setState(() {
      _isLoading = true;
    });

    final RestaurantListServices restaurantListServices =
        RestaurantListServices();
    ApiResponse apiResponse;
    if (widget.restaurantListEntryPoint ==
        RestaurantListEntryPoint.subCategoryScreen) {
      apiResponse = await restaurantListServices.getRestaurantCatWise(
        "${widget.subCatId}",
        "$_page",
      );
    } else if (widget.restaurantListEntryPoint ==
        RestaurantListEntryPoint.filter) {
      final filterOptionSelection =
          Provider.of<FilterOptionSelection>(context, listen: false);
      int option = filterOptionSelection.option + 1;
      apiResponse =
          await restaurantListServices.getRestaurantFiltered(option, "$_page");
    } else if (widget.restaurantListEntryPoint ==
            RestaurantListEntryPoint.seeAllNewRestaurants ||
        widget.restaurantListEntryPoint ==
            RestaurantListEntryPoint.seeAllPopularRestaurants) {
      apiResponse = await restaurantListServices.getSeeAllRestaurant(
          widget.restaurantListEntryPoint, "$_page");
    } else if (widget.restaurantListEntryPoint ==
        RestaurantListEntryPoint.resSearch) {
      apiResponse = await restaurantListServices.getRestaurantSearchWise(
          widget.query, "$_page");
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    if (apiResponse.error) {
      _showSnackBar(context, apiResponse.message);
    } else {
      List<RestaurantModel> temp = apiResponse.data;
      if (temp.length < 10) {
        _isCall = false;
      }
      arrRestaurants.addAll(temp);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void callLoadMoreRestaurantList() async {
    final RestaurantListServices restaurantListServices =
        RestaurantListServices();
    ApiResponse apiResponse;
    if (widget.restaurantListEntryPoint ==
        RestaurantListEntryPoint.subCategoryScreen) {
      apiResponse = await restaurantListServices.getRestaurantCatWise(
        "${widget.subCatId}",
        "$_page",
      );
    } else if (widget.restaurantListEntryPoint ==
        RestaurantListEntryPoint.filter) {
      final filterOptionSelection =
          Provider.of<FilterOptionSelection>(context, listen: false);
      int option = filterOptionSelection.option + 1;
      apiResponse =
          await restaurantListServices.getRestaurantFiltered(option, "$_page");
    } else if (widget.restaurantListEntryPoint ==
            RestaurantListEntryPoint.seeAllNewRestaurants ||
        widget.restaurantListEntryPoint ==
            RestaurantListEntryPoint.seeAllPopularRestaurants) {
      apiResponse = await restaurantListServices.getSeeAllRestaurant(
          widget.restaurantListEntryPoint, "$_page");
    } else {}

    if (apiResponse.error) {
      setState(() {
        _isCall = false;
      });
      _showSnackBar(context, apiResponse.message);
    } else {
      List<RestaurantModel> temp = apiResponse.data;
      if (temp.length < 10) {
        _isCall = false;
      }
      setState(() {
        arrRestaurants.addAll(temp);
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Image.asset('assets/images/back2.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Stores',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
              ],
            ),
            _isLoading
                ? Center(
                    child: CircularBarIndicatorContainer(
                      height: 100,
                      width: 100,
                    ),
                  )
                : Expanded(
                    child: arrRestaurants == null
                        ? Center(
                            child: Text('No Store Found'),
                          )
                        : GridView.count(
                            controller: _scrollController,
                            crossAxisCount: 2,
                            children: List.generate(arrRestaurants.length + 1,
                                (index) {
                              return index == arrRestaurants.length
                                  ? Center(
                                      child: _isCall
                                          ? CircularProgressIndicator()
                                          : Container())
                                  : Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RestaurantDetailScreen(
                                                        restuarantModel:
                                                            arrRestaurants[
                                                                index],
                                                      )));
                                        },
                                        child: ResturantCardView(
                                          restuarantModel:
                                              arrRestaurants[index],
                                        ),
                                      ),
                                    );
                            }),
                          ),
                  )
          ],
        ),
      ),
    );
  }
}
