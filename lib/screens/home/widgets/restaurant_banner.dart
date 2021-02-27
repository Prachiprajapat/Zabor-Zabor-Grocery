import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/screens/restaurant_detail/widgets/restuarant_detail_top_widget.dart';
import 'package:zabor/utils/utils.dart';
import '../../../constants/constants.dart';

class RestaurantBanner extends StatelessWidget {
  const RestaurantBanner({
    Key key,
    this.restaurantModel,
  }) : super(key: key);

  final RestaurantModel restaurantModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenAwareSize(300, context),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: baseUrl + restaurantModel.restaurantpic,
            placeholder: (context, url) => new TopImageCircularIndicator(),
            errorWidget: (context, url, error) => Container(
                  child: Icon(Icons.broken_image),
                ),
            imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: imageProvider)),
                ),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColors().kPrimaryColor,
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [Colors.black45, Colors.transparent])),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  restaurantModel.name == null ? '' : restaurantModel.name,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(
                      color: AppColors().kWhiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  restaurantModel.address == null
                      ? ''
                      : restaurantModel.address,
                  softWrap: false,
                  maxLines: 1,
                  style:
                      TextStyle(color: AppColors().kWhiteColor, fontSize: 12),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
