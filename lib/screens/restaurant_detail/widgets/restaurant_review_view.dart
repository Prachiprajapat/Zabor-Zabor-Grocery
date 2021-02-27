import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/screens/restaurant_detail/widgets/star_rating_widget.dart';

class RestaurantReviewView extends StatelessWidget {
  const RestaurantReviewView({Key key, this.onTap, @required this.review})
      : super(key: key);

  final Function onTap;
  final Review review;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: AppColors().kGreyColor200,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(baseUrl +
                              (review.profileimage == null
                                  ? ''
                                  : review.profileimage)),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5)),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              review.userName == null ? '' : review.userName,
                              style: TextStyle(
                                  color: AppColors().kBlackColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Customer',
                              style: TextStyle(
                                  color: AppColors().kBlackColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SmoothStarRating(
                          allowHalfRating: false,
                          onRatingChanged: (v) {},
                          starCount: 5,
                          rating: review.rating.toDouble(),
                          size: 20.0,
                          color: AppColors().kPrimaryColor,
                          borderColor: AppColors().kPrimaryColor,
                          spacing: 0.0)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              review.comment == null ? '' : review.comment,
              style: TextStyle(color: AppColors().kBlackColor, fontSize: 13),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
