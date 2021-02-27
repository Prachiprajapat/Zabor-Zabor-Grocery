import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/edit_profile/edit_profile_screen.dart';
import 'package:zabor/screens/feed/widgets/feed_card_view.dart';
import 'package:zabor/screens/friend_list/friend_list_model/friend_list_model.dart';
import 'package:zabor/screens/friend_list/friend_list_screen.dart';
import 'package:zabor/screens/home/widgets/restaurant_carview.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/profile/models/models.dart';
import 'package:zabor/screens/profile_detail/model/profile_detail_model.dart';
import 'package:zabor/screens/profile_detail/profile_detail_screen.dart';
import 'package:zabor/state_manager_widgets/is_user_logged_in.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';

const restImages = [
  'assets/images/amb1.jpg',
  'assets/images/amb2.jpeg',
  'assets/images/amb3.jpg',
];

const personImages = [
  'assets/images/person1.jpeg',
  'assets/images/person2.jpg',
  'assets/images/person3.jpeg',
];

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _profileImageUrl = '';
  bool _isLoading = false;
  int _page = 1;
  bool isCall = true;
  ScrollController _scrollController = new ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CheckIns> checkIns = [];
  @override
  void initState() {
    super.initState();
    //_getUsersCheckin();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page = _page + 1;
        print(_page);
        if (isCall) {
          _getUsersCheckin();
        }
      }
    });
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserLoggedInManager>(
      builder: (context, userLoggedInManager, child) => userLoggedInManager
              .isLoggedin
          ? Scaffold(
              key: _scaffoldKey,
              body: Stack(
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
                      controller: _scrollController,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                          ),
                          // Row(
                          //   children: <Widget>[
                          //     IconButton(
                          //       icon: Image.asset('assets/images/back.png'),
                          //       onPressed: () {
                          //         Navigator.pop(context);
                          //       },
                          //     ),
                          //     Text(
                          //       'PROFILE',
                          //       style: TextStyle(
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.w600,
                          //           color: AppColors().kWhiteColor),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 300,
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
                                  right: MediaQuery.of(context).size.width / 2 -
                                      50,
                                  child: CachedNetworkImage(
                                    imageUrl: baseUrl + _profileImageUrl,
                                    placeholder: (context, url) =>
                                        new CircularBarIndicatorContainer(
                                      height: 100,
                                      width: 100,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new ProfileErrorWidget(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: AppColors().kPrimaryColor),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: imageProvider)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  top: 110,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15,
                                      ),
                                      ProfileUserName(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ProfileButtonRow(
                                        recentCheckin: checkIns != null
                                            ? (checkIns.length > 0
                                                ? checkIns.first
                                                : null)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(height: 200,color: Colors.white),
                          // _isLoading
                          //     ? ListView.builder(
                          //         physics: NeverScrollableScrollPhysics(),
                          //         shrinkWrap: true,
                          //         itemCount: 10,
                          //         itemBuilder: (context, index) =>
                          //             ShimmerFeedCardView(),
                          //       )
                          //     : checkIns.length == 0
                          //         ? Container(
                          //             height: 200,
                          //             width: MediaQuery.of(context).size.width,
                          //             color: Colors.white,
                          //             child: Center(
                          //               child: Text('No check-In'),
                          //             ),
                          //           )
                          //         : ListView.builder(
                          //             physics: NeverScrollableScrollPhysics(),
                          //             shrinkWrap: true,
                          //             itemCount: checkIns.length,
                          //             itemBuilder: (context, index) =>
                          //                 FeedCardView(
                          //               checkIns: checkIns[index],
                          //             ),
                          //           ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : promptUserLoingWidget(),
    );
  }

  Container promptUserLoingWidget() {
    return Container(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 50,
                color: AppColors().kPrimaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'You are not logged in\n',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(text: 'Please'),
                      TextSpan(
                          text: ' login ',
                          style: TextStyle(
                              color: AppColors().kPrimaryColor,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginSignupScreen()));
                            }),
                      TextSpan(text: 'to see the profile')
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getUserData() async {
    try {
      User user = await AppUtils.getUser();
      setState(() {
        _profileImageUrl = user.profileimage;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _getUsersCheckin() async {
    User user = await AppUtils.getUser();

    if (user == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    int userID = user.id;
    _profileImageUrl = user.profileimage == null ? '' : user.profileimage;
    dynamic token = await AppUtils.getToken();
    ApiResponse<UserCheckInResponse> apiResponse =
        await K3Webservice.postMethod<UserCheckInResponse>(
            '${apisToUrls(Apis.userCheckIns)}',
            {"user_id": "$userID", "page": "$_page"},
            {"Authorization": 'Bearer $token'});
    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        showSnackBar(
            _scaffoldKey,
            sessionExpiredText,
            SnackBarAction(
              label: 'Login',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginSignupScreen()));
              },
            ));
      }
      print(apiResponse.message);
    } else {
      setState(() {
        checkIns.addAll(apiResponse.data.data);
        if (apiResponse.data.data.length < 10) {
          isCall = false;
        }
        //checkIns = apiResponse.data.data;
      });
    }
  }
}

class ProfileErrorWidget extends StatelessWidget {
  const ProfileErrorWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Icon(
          Icons.account_circle,
          size: 50,
        ),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(50)));
  }
}

class ProfileButtonRow extends StatelessWidget {
  const ProfileButtonRow({
    Key key,
    this.recentCheckin,
  }) : super(key: key);
  final CheckIns recentCheckin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ProfileButtons(
            title: AppLocalizations.of(context).translate('View As'),
            image: 'assets/images/view_as.png',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileDetailScreen(
                            checkIns: recentCheckin,
                            profileDetailEntryPoint:
                                ProfileDetailEntryPoint.profile,
                          )));
            },
          ),
          Container(
            height: 75,
            width: 0.2,
            color: Colors.black,
          ),
          ProfileButtons(
            title: AppLocalizations.of(context).translate('Edit Profile'),
            image: 'assets/images/edit_profile.png',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
          ),
          // Container(
          //   height: 75,
          //   width: 0.2,
          //   color: Colors.black,
          // ),
          // ProfileButtons(
          //   title: AppLocalizations.of(context).translate('My Friends'),
          //   image: 'assets/images/my_friends.png',
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => UserListScreen(
          //                   userListEntryPoint: UserListEntryPoint.profile,
          //                 )));
          //   },
          // ),
        ],
      ),
    );
  }
}

class ProfileUserName extends StatefulWidget {
  @override
  _ProfileUserNameState createState() => _ProfileUserNameState();
}

class _ProfileUserNameState extends State<ProfileUserName> {
  String _userName = '';

  _getUserName() async {
    User userModel = await AppUtils.getUser();
    setState(() {
      _userName = userModel.name == null ? '' : userModel.name;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  @override
  void didUpdateWidget(ProfileUserName oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _userName,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    Key key,
    this.image,
    this.title,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: AppColors().kGreyColor100,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: AssetImage(image))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  color: AppColors().kBlackColor, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
