import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/screens/home/widgets/restaurant_carview.dart';
import 'package:zabor/screens/restaurant_detail/restaurant_detail_screen.dart';
import '../../../constants/constants.dart';

const images = [
  'assets/images/rest1.jpg',
  'assets/images/rest2.jpg',
  'assets/images/rest3.png',
  'assets/images/rest4.jpg',
  'assets/images/rest5.jpeg',
  'assets/images/rest6.jpg',
  'assets/images/rest7.jpg',
  'assets/images/rest8.jpg',
];

// class RestuarantModel {
//   final int id;
//   final String name;
//   final String address;
//   final String image;
//   RestuarantModel(this.id, this.name,this.address,this.image);
// }

class HomeSections extends StatelessWidget {
  const HomeSections({
    Key key,
    this.title,
    this.arrRestaurants,
    @required this.seeAllPressed,
  }) : super(key: key);

  final List<RestaurantModel> arrRestaurants;
  final Function seeAllPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$title', style: AppFontStyle().kHeadingTextStyle),
                GestureDetector(
                  onTap: seeAllPressed,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors().kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                          AppLocalizations.of(context).translate('SEE ALL'),
                          style: AppFontStyle().kHeadingTextButtonStyle),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 176,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantDetailScreen(
                                restuarantModel: arrRestaurants[index],
                              )));
                },
                child: ResturantCardView(
                  restuarantModel: arrRestaurants[index],
                ),
              ),
              itemCount: arrRestaurants.length,
            ),
          )
        ],
      ),
    );
  }
}
