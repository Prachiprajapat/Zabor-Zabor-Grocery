import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';

class RestuarantDetailTopWidget extends StatelessWidget {
  const RestuarantDetailTopWidget({
    Key key, this.restuarantModel, this.heroTag,
  }) : super(key: key);

  final RestaurantModel restuarantModel;
  final String heroTag;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(650),
      color: AppColors().kBlackColor,
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
              imageUrl: baseUrl + restuarantModel.restaurantpic,
              placeholder: (context,url) => new TopImageCircularIndicator(),
              errorWidget: (context, url, error) => Container(
                child: Icon(Icons.broken_image),
              ),
              imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    color: AppColors().kPrimaryColor,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover
                    )
                  ),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        restuarantModel.name == null ? '' :restuarantModel.name,
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
                        restuarantModel.address == null ? '' : restuarantModel.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors().kWhiteColor, fontSize: 12),
                      )
                    ],
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       color: AppColors().kPrimaryColor,
                //       borderRadius: BorderRadius.circular(5)),
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                //     child: Text(
                //       restuarantModel.avgrating == null ? '0.0' : restuarantModel.avgrating.toStringAsFixed(1),
                //       style: TextStyle(color: AppColors().kWhiteColor),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          Positioned(
            top: ScreenUtil.getInstance().setHeight(40),
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () => {Navigator.pop(context)},
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/images/return.png',height: 30),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
//Image.asset('assets/images/back2.png')
class TopImageCircularIndicator extends StatelessWidget {
  const TopImageCircularIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: CircularProgressIndicator(),),);
  }
}
