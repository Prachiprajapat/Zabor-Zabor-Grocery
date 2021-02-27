import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/home/widgets/restaurant_carview.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/profile/models/models.dart';
import 'package:zabor/screens/profile/profile_screen.dart';
import 'package:zabor/screens/profile_detail/bloc/bloc.dart';
import 'package:zabor/utils/bloc_state.dart';

import 'model/profile_detail_model.dart';

class ProfileDetailScreen extends StatefulWidget {
  final CheckIns checkIns;
  final int friendId;
  final ProfileDetailEntryPoint profileDetailEntryPoint;

  const ProfileDetailScreen(
      {Key key,
      this.checkIns,
      @required this.profileDetailEntryPoint,
      this.friendId})
      : super(key: key);

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  String _name = '';
  String _profilePic = '';
  String _city = '';
  String _number = '';
  String _about = '';
  ProfileDetailBloc _profileDetailBloc;
  List<LastcheckinInfo> lastcheckinInfo = [];
  _ProfileDetailScreenState();

  @override
  void initState() {
    super.initState();
    if (widget.profileDetailEntryPoint == ProfileDetailEntryPoint.profile) {
      getUserData(null);
    } else {
      callFriendDetailDataApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.profileDetailEntryPoint == ProfileDetailEntryPoint.profile
          ? buildBody(context)
          : StreamBuilder<BlocState>(
              stream: _profileDetailBloc.stream,
              builder: (context, snapshot) {
                if (snapshot.data is BlocLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data is FriendDetailState) {
                  FriendDetailState state = snapshot.data;
                  getUserData(state.data);
                  return buildBody(context);
                }

                if (snapshot.data is BlocFailureState) {
                  BlocFailureState state = snapshot.data;
                  return showMessage(state.message, () {}, false);
                }

                if (snapshot.data is BlocInitState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
    );
  }

  getUserData(FriendDetailData data) async {
    if (widget.profileDetailEntryPoint == ProfileDetailEntryPoint.profile) {
      User user = await AppUtils.getUser();
      setState(() {
        _name = user.name == null ? '' : user.name;
        _profilePic = user.profileimage == null ? '' : user.profileimage;
        _city = user.city == null ? '------' : user.city;
        _number = user.phone == null ? '------' : user.phone;
        _about = user.about == null ? '' : user.about;
      });
    } else {
      await Future.delayed(Duration(milliseconds
      :500));
       setState(() {
 _name =
            data.userinfo.first.name == null ? '' : data.userinfo.first.name;
        _profilePic = data.userinfo.first.profileimage == null
            ? ''
            : data.userinfo.first.profileimage;
        _city = data.userinfo.first.city == null
            ? '------'
            : data.userinfo.first.city;
        _number = data.userinfo.first.phone == null
            ? '------'
            : data.userinfo.first.phone;
        _about =
            data.userinfo.first.about == null ? '' : data.userinfo.first.about;
            lastcheckinInfo = data.lastcheckinInfo;
       });
      
    }
  }

  callFriendDetailDataApi() async {
    _profileDetailBloc = ProfileDetailBloc();
    _profileDetailBloc.getUserInfo(widget.friendId);
  }

  Stack buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover)),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            height: 300,
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/images/back.png'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'MY DETAILS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors().kWhiteColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 0,
                        left: 0,
                        top: 40,
                        bottom: 0,
                        child: Image.asset(
                          'assets/images/curve.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: MediaQuery.of(context).size.width / 2 - 50,
                        child: CachedNetworkImage(
                          imageUrl: baseUrl + _profilePic,
                          placeholder: (context, url) =>
                              new CircularBarIndicatorContainer(
                            height: 100,
                            width: 100,
                          ),
                          errorWidget: (context, url, error) =>
                              new ProfileErrorWidget(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: AppColors().kPrimaryColor),
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        top: 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            new ProfileUserInfoWidget(
                              name: _name,
                              city: _city,
                              number: _number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: AppColors().kWhiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Biography',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors().kBlackColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          _about,
                          style: TextStyle(
                              fontSize: 14, color: AppColors().kBlackColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      widget.profileDetailEntryPoint ==
                              ProfileDetailEntryPoint.profile
                          ? (widget.checkIns == null
                              ? Container(
                                  color: Colors.white,
                                  height: 500,
                                )
                              : buildLastActivityWidget())
                          : ((lastcheckinInfo.length == 0)
                              ? Container(
                                  color: Colors.white,
                                  height: 500,
                                )
                              : buildFriendLastActivityWidget())
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column buildLastActivityWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Activities',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors().kBlackColor),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/3.0x/map.png'),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Recently Check In',
                      style: TextStyle(
                          fontSize: 16, color: AppColors().kBlackColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.checkIns.resName != null
                          ? widget.checkIns.resName
                          : '',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors().kBlackColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.checkIns.address != null
                          ? widget.checkIns.address
                          : '',
                      style: TextStyle(
                          fontSize: 14, color: AppColors().kBlackColor),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Column buildFriendLastActivityWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Activities',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors().kBlackColor),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/3.0x/map.png'),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Recently Check In',
                      style: TextStyle(
                          fontSize: 16, color: AppColors().kBlackColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      lastcheckinInfo.first.name != null
                          ? lastcheckinInfo.first.name
                          : '',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors().kBlackColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      lastcheckinInfo.first.address != null
                          ? lastcheckinInfo.first.address
                          : '',
                      style: TextStyle(
                          fontSize: 14, color: AppColors().kBlackColor),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileUserInfoWidget extends StatelessWidget {
  final String name;
  final String city;
  final String number;

  const ProfileUserInfoWidget(
      {Key key,
      @required this.name,
      @required this.city,
      @required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/map.png'),
            SizedBox(
              width: 10,
            ),
            Text(city),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mobile.png'),
            SizedBox(
              width: 10,
            ),
            Text(number),
          ],
        ),
      ],
    );
  }
}
