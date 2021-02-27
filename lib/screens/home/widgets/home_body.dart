import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/filter/filter_screen.dart';
import 'package:zabor/screens/home/models/advert_response_model.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/screens/home/services/services.dart';
import 'package:zabor/screens/home/widgets/restaurant_banner.dart';
import 'package:zabor/screens/home/widgets/searchbar.dart';
import 'package:zabor/screens/notification_screen/notification_screen.dart';
import 'package:zabor/screens/restaurant_detail/restaurant_detail_screen.dart';
import 'package:zabor/screens/restaurant_list/restaurant_list_screen.dart';
import 'package:zabor/screens/restaurant_list/services/restaurant_list_services.dart';
import 'package:zabor/screens/story_view/story_view.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/location_services.dart';

import 'custom_appbar.dart';
import 'home_section.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key key,
  }) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool _isLoading = false;
  Data _homeScreenData;
  int _currentPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  Timer _timer;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    callHomeApi();
    callAdvertApi();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _timer.cancel();
  }

  void pageControllerAutoScroll() {
    if (_homeScreenData.bannerRestaurant.length == 1) {
      return;
    }
    try {
      _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
        if (_currentPage <
            (_homeScreenData.bannerRestaurant.length == null
                ? 0
                : _homeScreenData.bannerRestaurant.length - 1)) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });
    } catch (e) {}
  }

  void callHomeApi() async {
    setState(() {
      _isLoading = true;
    });
    final homeServices = HomeScreenServices();
    final apiResponse = await homeServices.getHomeScreenData(context);
    if (apiResponse.error) {
      showInSnackBar(apiResponse.message);
    } else {
      _homeScreenData = apiResponse.data;
      pageControllerAutoScroll();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new CustomAppBar(
          filterTapped: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FilterScreen()));
          },
          notificationPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationScreen()));
          },
        ),
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                }),
            Expanded(child: SearchBar()),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        _isLoading
            ? CircularProgressIndicator()
            : (_homeScreenData == null ||
                    (_homeScreenData.newestRestaurant.length == 0 &&
                        _homeScreenData.bannerRestaurant.length == 0 &&
                        _homeScreenData.mostpopular.length == 0))
                ? Center(
                    child: Text('No Store Near You'),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: _homeScreenData.bannerRestaurant.length == 0
                                ? 0
                                : 300,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount:
                                  _homeScreenData.bannerRestaurant.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RestaurantDetailScreen( 
                                                restuarantModel: _homeScreenData ==
                                                        null
                                                    ? null
                                                    : RestaurantModel(
                                                        id: _homeScreenData
                                                            .bannerRestaurant[
                                                                index]
                                                            .id,
                                                        name: _homeScreenData
                                                            .bannerRestaurant[
                                                                index]
                                                            .name,
                                                        address: _homeScreenData
                                                            .bannerRestaurant[
                                                                index]
                                                            .address,
                                                        restaurantpic:
                                                            _homeScreenData
                                                                .bannerRestaurant[
                                                                    index]
                                                                .restaurantpic),
                                              )));
                                },
                                child: RestaurantBanner(
                                  restaurantModel: _homeScreenData == null
                                      ? null
                                      : _homeScreenData.bannerRestaurant[index],
                                ),
                              ),
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                          new HomeSections(
                            title: AppLocalizations.of(context)
                                .translate('Most Popular'),
                            arrRestaurants: _homeScreenData == null
                                ? null
                                : _homeScreenData.mostpopular,
                            seeAllPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantListScreen(
                                            restaurantListEntryPoint:
                                                RestaurantListEntryPoint
                                                    .seeAllPopularRestaurants,
                                          )));
                            },
                          ),
                          new HomeSections(
                            title: AppLocalizations.of(context)
                                .translate('New Deals'),
                            arrRestaurants: _homeScreenData == null
                                ? null
                                : _homeScreenData.newestRestaurant,
                            seeAllPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantListScreen(
                                            restaurantListEntryPoint:
                                                RestaurantListEntryPoint
                                                    .seeAllNewRestaurants,
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
      ],
    );
  }

  callAdvertApi() async {
    if (position == null) {
      try {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (error) {
        if (error.code == "PERMISSION_DENIED") {
          return;
        }
      }
    }
    print(position.latitude);
    print(position.longitude);

    ApiResponse<AdvertResponseModel> apiResponse =
        await K3Webservice.postMethod(
            apisToUrls(Apis.getAdverts),
            {
              "latitude": position == null ? "0.0" : "${position.latitude}",
              "longitude": position == null ? "0.0" : "${position.longitude}"
            },
            null);
    // List<Advert> teamp = [
    //   Advert(
    //       id: 41,
    //       restaurantId: 42,
    //       video: null,
    //       pic: 'restaurantpic/restaurantpic-1597031788670.png',
    //       videoThumb: 'restaurantpic/restaurantpic-1597031788670.png',
    //       restaurantpic: 'restaurantpic/restaurantpic-1597031788670.png',
    //       name: 'fas safss fs ',
    //       address: 'gsdgd gdg',
    //       distance: 34.33),
    //   Advert(
    //       id: 41,
    //       restaurantId: 42,
    //       video: null,
    //       pic: 'restaurantpic/restaurantpic-1597031788670.png',
    //       videoThumb: 'restaurantpic/restaurantpic-1597031788670.png',
    //       restaurantpic: 'restaurantpic/restaurantpic-1597031788670.png',
    //       name: 'fas safss fs ',
    //       address: 'gsdgd gdg',
    //       distance: 34.33),
    // ];
    // showVideoAdvertDialog(teamp);
    if (apiResponse.error) return;
    if (apiResponse.data.data == null) return;
    if (apiResponse.data.data.data.length == 0) return;

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => StoryViewScreen(
    //               advertData: apiResponse.data.data,
    //             )));

    if (apiResponse.data.data.type == 1) {
      showVideoAdvertDialog(apiResponse.data.data.data);
    } else {
      showAdvertDialog(apiResponse.data.data.data);
    }
  }

  showAdvertDialog(List<Advert> adverts) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Container(
                height: 300.0,
                width: 300.0,
                child: PageView.builder(
                  itemCount: adverts.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantDetailScreen(
                                    restuarantModel: RestaurantModel(
                                        id: adverts[index].restaurantId,
                                        name: adverts[index].name,
                                        address: adverts[index].address,
                                        restaurantpic:
                                            adverts[index].restaurantpic),
                                  )));
                    },
                    child: Column(
                      children: [
                        Expanded(
                                                  child: RestaurantBanner(
                            restaurantModel: RestaurantModel(
                                id: adverts[index].restaurantId,
                                name: adverts[index].name,
                                address: adverts[index].address,
                                restaurantpic: adverts[index].restaurantpic),
                          ),
                        ),
                        FlatButton(child: Text('Close'),onPressed: (){
                          Navigator.pop(context);
                        },)
                      ],
                    ),
                  ),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ));
  }

  showVideoAdvertDialog(List<Advert> adverts) {
    _controller = VideoPlayerController.network(
      adverts.first.video == null ? 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4' : baseUrl + adverts.first.video,
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    if (!_controller.value.isPlaying) { _controller.play();}
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Container(
                height: 300.0,
                width: 300.0,
                child: PageView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantDetailScreen(
                                    restuarantModel: RestaurantModel(
                                        id: adverts[index].restaurantId,
                                        name: adverts[index].name,
                                        address: adverts[index].address,
                                        restaurantpic:
                                            adverts[index].restaurantpic),
                                  )));
                    },
                    child: Column(
                      children: [
                        Expanded(
                                                  child: FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                // If the VideoPlayerController has finished initialization, use
                                // the data it provides to limit the aspect ratio of the VideoPlayer.
                                return AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  // Use the VideoPlayer widget to display the video.
                                  child: VideoPlayer(_controller),
                                );
                              } else {
                                // If the VideoPlayerController is still initializing, show a
                                // loading spinner.
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                        FlatButton(child: Text('Close'),onPressed: (){
                          Navigator.pop(context);
                          _controller.pause();
                        },)
                      ],
                    ),
                  ),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ));
  }
}
