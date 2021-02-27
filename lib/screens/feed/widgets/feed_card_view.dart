import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/screens/checkin_detail_screen/checkin_detail_screen.dart';
import 'package:zabor/screens/feed/bloc/feed_bloc.dart';
import 'package:zabor/screens/feed/models/feed_models.dart';
import 'package:zabor/screens/home/widgets/restaurant_carview.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/profile/models/models.dart';
import '../../../constants/constants.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class FeedCardView extends StatefulWidget {
  const FeedCardView({
    Key key,
    this.checkIns,
    this.feed,
  }) : super(key: key);

  final CheckIns checkIns;
  final Feed feed;
  @override
  _FeedCardViewState createState() => _FeedCardViewState();
}

class _FeedCardViewState extends State<FeedCardView> {
  String _formattedDate = '';
  String _username = '';
  String _comment = '';
  String _restPic = '';
  String _userProfileImage = '';
  String _restName = '';
  bool _liked = false;
  FeedBloc _feedBloc;
  bool _loadingShareState = false;

  _getUserData() async {
    User user = await AppUtils.getUser();
    setState(() {
      _userProfileImage = baseUrl + user.profileimage;
    });
  }

  @override
  void initState() {
    super.initState();
    _feedBloc = FeedBloc();
    if (widget.feed != null) {
      _formattedDate =
          DateFormat('dd MMM kk:mm a').format(widget.feed.createdAt);
      _username = widget.feed.userName == null ? '' : widget.feed.userName;
      _comment = widget.feed.comment == null ? '' : widget.feed.comment;
      _restPic = widget.feed.pic == null ? baseUrl + widget.feed.restaurantpic : baseUrl + widget.feed.pic;
      _userProfileImage = baseUrl + widget.feed.profileimage;
      _restName = widget.feed.resName == null ? '' : widget.feed.resName;
      _liked = widget.feed.checkinlike == null
          ? false
          : (widget.feed.checkinlike == 1 ? true : false);
      return;
    }

    _username =
        widget.checkIns.userName == null ? '' : widget.checkIns.userName;
    _comment = widget.checkIns.comment == null ? '' : widget.checkIns.comment;
    _restPic = widget.checkIns.pic == null ? widget.checkIns.restaurantpic : baseUrl + widget.checkIns.pic;
    _restName = widget.checkIns.resName == null ? '' : widget.checkIns.resName;
    _formattedDate =
        DateFormat('dd MMM kk:mm a').format(widget.checkIns.createdAt);
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckinDetailScreen(
                      restId: widget.feed != null
                          ? widget.feed.resId
                          : widget.checkIns.resId,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: AppColors().kGreyColor100,
                          border: Border.all(
                              width: 2, color: AppColors().kPrimaryColor),
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  _userProfileImage))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$_username is at $_restName',
                            style: AppFontStyle().kHeadingTextStyle,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(_formattedDate)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('$_comment'),
                SizedBox(
                  height: 10,
                ),
                CachedNetworkImage(
                  imageUrl: _restPic,
                  placeholder: (context, url) =>
                      new CircularBarIndicatorContainer(
                    height: 180,
                    width: 160,
                  ),
                  errorWidget: (context, url, error) => new ErrorImageContainer(
                    height: 180,
                    width: 160,
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 180,
                    decoration: BoxDecoration(
                        color: AppColors().kPrimaryColor,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    _loadingShareState ?
                    SizedBox(
                      height:15,
                      width:15,
                      child: CircularProgressIndicator(strokeWidth: 1,)) :
                    GestureDetector(
                      child: Image.asset('assets/images/share.png', height: 40, width:40),
                      onTap: (){
                        shareFeed();
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      child: _liked
                          ? Image.asset(
                              'assets/images/like1.png',
                              height: 40,
                            )
                          : Image.asset(
                              'assets/images/like.png',
                              height: 40,
                            ),
                      onTap: () {
                        setState(() {
                          _liked = !_liked;
                        });
                        _feedBloc.likeUnlike(widget.feed.id, !_liked);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          decoration: BoxDecoration(color: AppColors().kWhiteColor, boxShadow: [
            BoxShadow(
                color: Colors.black12, spreadRadius: 1.0, offset: Offset(2, 2))
          ]),
        ),
      ),
    );
  }

  shareFeed() async {
    //Share.share('$_comment\n$_restPic');
    setState(() {
      _loadingShareState = true;
    });
    var request = await HttpClient().getUrl(Uri.parse(_restPic));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file(
        appName, '$appName${DateTime.now()}.jpg', bytes, 'image/jpg',
        text: '$_comment');
        setState(() {
      _loadingShareState = false;
    });
  }
}

class ShimmerFeedCardView extends StatelessWidget {
  const ShimmerFeedCardView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Shimmer.fromColors(
                    baseColor: AppColors().kGreyColor100,
                    highlightColor: AppColors().kGreyColor200,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors().kGreyColor100,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors().kGreyColor100),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: AppColors().kGreyColor100,
                          highlightColor: AppColors().kGreyColor200,
                          child: Container(
                            color: AppColors().kGreyColor100,
                            child: Text(
                              'Kridegten is at The Freigeded Restaurant',
                              style: AppFontStyle().kHeadingTextStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Shimmer.fromColors(
                            baseColor: AppColors().kGreyColor100,
                            highlightColor: AppColors().kGreyColor200,
                            child: Container(
                                color: AppColors().kGreyColor100,
                                child: Text('21 Sept at 20.:39 pm')))
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: AppColors().kGreyColor100,
                highlightColor: AppColors().kGreyColor200,
                child: Container(
                  color: AppColors().kGreyColor100,
                  child: Text(
                      'jsfj sjfks fkjs fkjskfjlshfjs fjsk askjf sfksfj ksjf'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: AppColors().kGreyColor100,
                highlightColor: AppColors().kGreyColor200,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                      color: AppColors().kGreyColor100,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Image.asset('assets/images/share.png'),
                    onTap: () {},
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    child: Image.asset('assets/images/like.png'),
                    onTap: () {},
                  ),
                ],
              )
            ],
          ),
        ),
        decoration: BoxDecoration(color: AppColors().kWhiteColor, boxShadow: [
          BoxShadow(
              color: Colors.black12, spreadRadius: 1.0, offset: Offset(2, 2))
        ]),
      ),
    );
  }

}
