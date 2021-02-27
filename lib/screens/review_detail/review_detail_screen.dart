import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:zabor/screens/give_rating/give_rating_provider/give_rating_provider.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';

class ReviewDetailScreen extends StatelessWidget {
  ReviewDetailScreen({Key key, this.review}) : super(key: key);

  final Review review;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            navBar(context),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                       baseUrl + (review.profileimage == null
                                            ? '': review.profileimage )
                                            ),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  review.userName == null
                                      ? ''
                                      : review.userName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors().kBlackColor,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Customer'),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(review.comment == null ? '' : review.comment),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 500,
                        color: AppColors().kGreyColor100,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SmoothStarRating(
                                      allowHalfRating: false,
                                      onRatingChanged: (v) {},
                                      starCount: 5,
                                      rating: review.rating.toDouble(),
                                      size: 25.0,
                                      color: AppColors().kPrimaryColor,
                                      borderColor: AppColors().kPrimaryColor,
                                      spacing: 0.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        review.rating == null ? '' : review.rating.toString(),
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors().kPrimaryColor),
                                      ),
                                      Text(
                                        'Average Rating*',
                                        style: TextStyle(
                                            color: AppColors().kBlackColor,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    getRatingRowModelArray(review).length,
                                itemBuilder: (context, index) =>
                                    RatingProgressView(
                                      ratingRowModel:
                                          getRatingRowModelArray(review)[index],
                                    ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<RatingRowModel> getRatingRowModelArray(Review review) {
    return [
      RatingRowModel('Waiting', review.waiting.toDouble()),
      RatingRowModel('Restrooms', review.restrooms.toDouble()),
      RatingRowModel('Ambience', review.ambience.toDouble()),
      RatingRowModel('Service', review.service.toDouble()),
      RatingRowModel('Food', review.food.toDouble()),
      RatingRowModel('Pricing', review.pricing.toDouble()),
      RatingRowModel('Locality', review.locality.toDouble())
    ];
  }

  Row navBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Image.asset('assets/images/back2.png'),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'REVIEWS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

class RatingProgressView extends StatelessWidget {
  const RatingProgressView({
    Key key,
    this.ratingRowModel,
  }) : super(key: key);
  final RatingRowModel ratingRowModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              ratingRowModel.ratingType,
              style: TextStyle(fontSize: 16, color: AppColors().kBlackColor),
            ),
          ),
          LinearPercentIndicator(
            width: 220,
            lineHeight: 12.0,
            percent: (ratingRowModel.rating * 2) / 10,
            progressColor: AppColors().kPrimaryColor,
            linearStrokeCap: LinearStrokeCap.butt,
          ),
        ],
      ),
    );
  }
}
