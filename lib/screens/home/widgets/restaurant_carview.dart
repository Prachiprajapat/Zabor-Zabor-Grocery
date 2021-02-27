import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';

class ResturantCardView extends StatelessWidget {
  const ResturantCardView({
    Key key,
    this.restuarantModel,
  }) : super(key: key);

  final RestaurantModel restuarantModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 2),
                  spreadRadius: 0.1,
                  color: Colors.black26,
                  blurRadius: 3)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: baseUrl + restuarantModel.restaurantpic,
              placeholder: (context, url) => new CircularBarIndicatorContainer(
                    height: 90,
                    width: 160,
                  ),
              errorWidget: (context, url, error) => new ErrorImageContainer(
                height: 90,
                width: 160,
              ),
              imageBuilder: (context, imageProvider) => Container(
                    width: 160,
                    height: 90,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider),
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6))),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    restuarantModel.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    restuarantModel.address,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularBarIndicatorContainer extends StatelessWidget {
  const CircularBarIndicatorContainer({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorImageContainer extends StatelessWidget {
  const ErrorImageContainer({
    Key key,@required this.height,@required this.width,
  }) : super(key: key);
final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Icon(Icons.broken_image),
        width: width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 0.5,
                          blurRadius: 5
                        )
                      ],
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6))),
                );
  }
}
