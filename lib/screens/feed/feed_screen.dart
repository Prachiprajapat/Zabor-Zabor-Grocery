import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/screens/feed/bloc/feed_bloc.dart';
import 'package:zabor/screens/feed/widgets/feed_card_view.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import '../../constants/constants.dart';
import 'models/feed_models.dart';

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

class FeedsScreen extends StatefulWidget {
  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  ScrollController _scrollController = new ScrollController();
  FeedBloc _feedBloc;
  int _page = 1;
  bool _isCall = false;
  List<Feed> feeds = [];
  @override
  void initState() {
    super.initState();
    _feedBloc = FeedBloc();
    _feedBloc.getFeeds();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page = _page + 1;
        print(_page);
        if (_isCall) {
          List<Feed> tempFeeds = await _feedBloc.loadMore(_page);
          setState(() {
            feeds.addAll(tempFeeds);
            if (tempFeeds.length < 10) {
              _isCall = false;
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _feedBloc.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('FEED'),
                style: AppFontStyle().kHeadingTextStyle,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<FeedState>(
              stream: _feedBloc.feedStream,
              initialData: FeedInitState(),
              builder: (context, snapshot) {
                if (snapshot.data is FeedInitState) {
                  return shimmerFeedCardView();
                }

                if (snapshot.data is FeedLoadingState) {
                  return shimmerFeedCardView();
                }

                if (snapshot.data is FeedDataState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FeedDataState state = snapshot.data;
                    setState(() {
                      feeds = state.feeds;
                      if (state.feeds.length == 10) {
                        _isCall = true;
                      }
                    });
                  });
                  return FeedfeedCardView();
                }

                if (snapshot.data is FeedAuthErrorState) {
                  FeedAuthErrorState state = snapshot.data;
                  return buildAuthWigdet(context, state);
                }

                if (snapshot.data is FeedFailureState) {
                  FeedFailureState state = snapshot.data;
                  return buildFailureWidget(state);
                }

                if (snapshot.data is UserNotLoggedInState) {
                  return promptUserLoingWidget();
                }
              }),
        ],
      ),
    );
  }

  Expanded buildFailureWidget(FeedFailureState state) {
    return Expanded(
      child: Center(
        child: Text(state.message),
      ),
    );
  }

  Expanded buildAuthWigdet(BuildContext context, FeedAuthErrorState state) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginSignupScreen()));
          if (_feedBloc == null) _feedBloc = FeedBloc();
          _feedBloc.getFeeds();
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error,
                color: AppColors().kPrimaryColor,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                state.message,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded shimmerFeedCardView() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) => ShimmerFeedCardView(),
        itemCount: restImages.length,
      ),
    );
  }

  Expanded FeedfeedCardView() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return index == feeds.length
              ? Center(
                  child: _isCall
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : Container())
              : FeedCardView(
                  feed: feeds[index],
                );
        },
        itemCount: feeds.length + 1,
      ),
    );
  }

  Expanded promptUserLoingWidget() {
    return Expanded(
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
                      TextSpan(text: 'to see the feeds')
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
