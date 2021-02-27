import 'package:flutter/material.dart';
import 'package:zabor/screens/give_rating/give_rating_provider/give_rating_provider.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/screens/restaurant_detail/widgets/restaurant_review_view.dart';
import 'package:zabor/screens/review_detail/review_detail_screen.dart';



class RestaurantReviewTabView extends StatelessWidget {

  final List<Review> reviews;

  const RestaurantReviewTabView({Key key, this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) => RestaurantReviewView(
        review: reviews[index],
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewDetailScreen(
            review: reviews[index],
          )));
        },
      ),
    );
  }
}