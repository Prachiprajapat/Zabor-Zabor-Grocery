import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/give_rating/services/give_rating_services.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';

import 'give_rating_provider/give_rating_provider.dart';

var arrRatingRowModel = [
  RatingRowModel('Waiting', 4),
  RatingRowModel('Restrooms', 3),
  RatingRowModel('Ambience', 3),
  RatingRowModel('Service', 2),
  RatingRowModel('Food', 1),
  RatingRowModel('Pricing', 2),
  RatingRowModel('Management', 4),
  RatingRowModel('Locality', 3),
];

class GiveRatingScreen extends StatefulWidget {
  final RestaurantDetail restaurantDetail;

  const GiveRatingScreen({Key key, @required this.restaurantDetail})
      : super(key: key);

  @override
  _GiveRatingScreenState createState() => _GiveRatingScreenState();
}

class _GiveRatingScreenState extends State<GiveRatingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _comment = '';
  bool _isLoading = false;
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
            navBar(context),
            SizedBox(
              height: 20,
            ),
             Consumer<GiveRatingProvider>(
                    builder: (context, ratings, child) => Expanded(
                      child: ListView.builder(
                        itemCount: ratings.getRatings().length + 2,
                        itemBuilder: (context, index) => index ==
                                ratings.getRatings().length + 1
                            ? (!_isLoading ? ButtonWidget(
                                title: 'DONE',
                                onPressed: () async {
                                  _callGiveRatingApi(ratings);
                                },
                              ) : Center(child: CircularProgressIndicator()))
                            : index == ratings.getRatings().length
                                ? FeedbackContentWidget(
                                    hintText: 'Write your comment here',
                                    onTextChanged: (text) {
                                      setState(() {
                                        _comment = text;
                                      });
                                    },
                                  )
                                : RatingRow(
                                    ratingType:
                                        ratings.getRatings()[index].ratingType,
                                    rating: ratings.getRatings()[index].rating,
                                    index: index,
                                  ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _callGiveRatingApi(GiveRatingProvider ratings) async {
    setState(() {
      _isLoading = true;
    });
    GiveRatingService giveRatingService = GiveRatingService();
    User userModel = await AppUtils.getUser();
    int userId = userModel.id;
    ApiResponse<String> apiResponse = await giveRatingService.postRatings(
        widget.restaurantDetail.id,
        userId,
        ratings.waiting.round(),
        ratings.restroom.round(),
        ratings.ambience.round(),
        ratings.service.round(),
        ratings.food.round(),
        ratings.pricing.round(),
        ratings.management.round(),
        ratings.locality.round(),
        _comment);

    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        final _ = await showAlert(context, sessionExpiredText);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
        return;
      }
      _showSnackBar(context, apiResponse.message);
    } else {
      final _ = await showAlert(context, apiResponse.data);
      //Navigator.pop(context);
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Row navBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<GiveRatingProvider>(
            builder: (context, ratingProvider, child) => IconButton(
              icon: Image.asset('assets/images/back2.png'),
              onPressed: () =>
                  {ratingProvider.resetRatings(), Navigator.pop(context)},
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'GIVE RATING',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please give ratings below.',
              style: TextStyle(fontSize: 14, color: AppColors().kBlackColor),
            ),
          ],
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String errorMessage) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(errorMessage),
    ));
  }
}

class RatingRow extends StatelessWidget {
  const RatingRow({
    Key key,
    this.ratingType,
    this.rating,
    this.index,
  }) : super(key: key);

  final String ratingType;
  final double rating;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            ratingType,
            style: TextStyle(
                color: AppColors().kBlackColor,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          Consumer<GiveRatingProvider>(
            builder: (context, ratingProvider, child) => SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  ratingProvider.setRatings(index, v);
                },
                starCount: 5,
                rating: rating,
                size: 30.0,
                color: AppColors().kPrimaryColor,
                borderColor: AppColors().kPrimaryColor,
                spacing: 0.0),
          )
        ],
      ),
    );
  }
}
