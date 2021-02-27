import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/offers_screen/offers_response_model.dart';
import 'package:zabor/screens/restaurant_detail/restaurant_detail_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/location_services.dart';
import 'package:zabor/utils/utils.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool _isLoading = false;
  bool _isAuthError = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Offer> _arrOffers = [];

  @override
  void initState() {
    super.initState();
    callOffersApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors().kWhiteColor,
        iconTheme: IconThemeData(color: AppColors().kBlackColor),
        title: Text('Offers',
            style: TextStyle(
                color: AppColors().kBlackColor,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _arrOffers.length ==  0 ? Center(child: Text('NO OFFERS',style: TextStyle(
                color: AppColors().kBlackColor,
                fontSize: 18,
                fontWeight: FontWeight.w600)),):ListView.builder(
              itemCount: _arrOffers.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantDetailScreen(
                                  restuarantModel: RestaurantModel(
                                      id: _arrOffers[index].resId,
                                      name: _arrOffers[index].name ?? "",
                                      address: "",
                                      restaurantpic: _arrOffers[index].restaurantpic ?? ""),
                                )));
                    },
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl:
                                  baseUrl + _arrOffers[index].restaurantpic,
                              placeholder: (context, url) =>
                                  Icon(Icons.broken_image),
                              errorWidget: (context, url, error) => Container(
                                child: Icon(Icons.broken_image),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    color: AppColors().kPrimaryColor,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                  color: AppColors().kPrimaryColor,
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      colors: [
                                        Colors.black45,
                                        Colors.transparent
                                      ])),
                            ),
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Text(
                                _arrOffers[index].name == null
                                    ? ''
                                    : _arrOffers[index].name,
                                maxLines: 1,
                                style: TextStyle(
                                    color: AppColors().kWhiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        buildOfferDetailRow(index),
                        Divider(),
                        SizedBox(height: 10),
                      ],
                    ),
                  )),
    );
  }

  Row buildOfferDetailRow(int index) {
    return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FaIcon(
                              FontAwesomeIcons.tags,
                              size: 40,
                              color: AppColors().kPrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${_arrOffers[index].userType == "all_users" ? 'All User Offer: ' : 'First User Offer: '} Get flat ${_arrOffers[index].percentage ?? 0}% OFF on Order of \$${_arrOffers[index].moa ?? 0} and Above (Max Discount: \$${_arrOffers[index].mpd ?? 0})',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      );
  }

  callOffersApi() async {
    setState(() {
      _isLoading = true;
    });
    dynamic token = await AppUtils.getToken();
  
    if (position == null) {
      try {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (error) {
        if (error.code == "PERMISSION_DENIED") {
          showSnackBar(_scaffoldKey, "Please give access to location.", null);
          return;
        }
      }
    }
    print(position.latitude);

    ApiResponse<OffersResponseModel> apiResponse =
        await K3Webservice.postMethod(
            apisToUrls(Apis.getDiscountWithLocation),
            json.encode({
              "lat": position == null ? "0.0" : "${position.latitude}",
              "lng": position == null ? "0.0" : "${position.longitude}"
            }),
            {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    setState(() {
      _isLoading = false;
    });
    if (apiResponse.error) {
      showSnackBar(_scaffoldKey, apiResponse.message, null);
      return;
    } else {
      setState(() {
        _arrOffers = apiResponse.data.data;
      });
    }
  }
}
