import 'dart:async';

import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/feed/models/feed_models.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/utils/k3webservice.dart';

class FeedBloc {
  final StreamController _feedSteamController = StreamController<FeedState>();
  Stream<FeedState> get feedStream => _feedSteamController.stream;

  getFeeds() async {
    bool _isUserLoggedIn = false;

    _feedSteamController.sink.add(FeedState.loadingState());

    _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
        ? false
        : await AppUtils.isUserLoggedIn();

    if (!_isUserLoggedIn) {
      _feedSteamController.sink.add(FeedState.userNotLoggedState());
      return;
    }

    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<FeedResponseModel> apiResponse =
        await K3Webservice.postMethod<FeedResponseModel>(
            apisToUrls(Apis.feeds),
            {"user_id": "$userId", "page": "1"},
            {"Authorization": "Bearer $token"});

    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        _feedSteamController.sink
            .add(FeedState.authErrorState(sessionExpiredText));
        return;
      }
      _feedSteamController.sink
          .add(FeedState.failureState(apiResponse.message));
      return;
    }
    _feedSteamController.sink
        .add(FeedState.feedDataState(apiResponse.data.data));
  }

  Future<List<Feed>> loadMore(int page) async {
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<FeedResponseModel> apiResponse =
        await K3Webservice.postMethod<FeedResponseModel>(
            apisToUrls(Apis.feeds),
            {"user_id": "$userId", "page": page.toString()},
            {"Authorization": "Bearer $token"});

    if (apiResponse.error == false) {
      return apiResponse.data.data;
    } else {
      return [];
    }
  }

  likeUnlike(int checkinId, bool isLiked) async {
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();

    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod<CommonResponseModel>(
            apisToUrls(isLiked ? Apis.unlike : Apis.like),
            {"user_id": userId.toString(), "checkin_id": checkinId.toString()},
            {"Authorization": "Bearer $token"});
  }

  dispose() {
    _feedSteamController.close();
  }
}

class FeedState {
  FeedState();
  factory FeedState.initState() = FeedInitState;
  factory FeedState.loadingState() = FeedLoadingState;
  factory FeedState.successState(bool isLiked) = FeedSuccessState;
  factory FeedState.failureState(String message) = FeedFailureState;
  factory FeedState.authErrorState(String message) = FeedAuthErrorState;
  factory FeedState.feedDataState(List<Feed> feeds) = FeedDataState;
  factory FeedState.userNotLoggedState() = UserNotLoggedInState;
}

class FeedLoadingState extends FeedState {}

class FeedInitState extends FeedState {}

class FeedSuccessState extends FeedState {
  final bool isLiked;
  FeedSuccessState(this.isLiked);
}

class FeedFailureState extends FeedState {
  final String message;
  FeedFailureState(this.message);
}

class FeedAuthErrorState extends FeedState {
  final String message;
  FeedAuthErrorState(this.message);
}

class FeedDataState extends FeedState {
  final List<Feed> feeds;
  FeedDataState(this.feeds);
}

class UserNotLoggedInState extends FeedState {}
