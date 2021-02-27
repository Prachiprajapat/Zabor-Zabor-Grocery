import 'dart:async';

import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/friend_list/model/friend_list_model.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/utils/k3webservice.dart';

class FriendRequestBloc {
  final _friendRequestStreamController = StreamController<FriendListState>();
  Stream<FriendListState> get friendListStream =>
      _friendRequestStreamController.stream;

  loadFriendRequests() async {
    _friendRequestStreamController.sink
        .add(FriendListState._initState('No Users'));
    _friendRequestStreamController.sink.add(FriendListState._loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<SearchUserResponse> apiResponse =
        await K3Webservice.postMethod<SearchUserResponse>(
            apisToUrls(Apis.friendRequestList),
            {"user_id": "$userId", "page": "1"},
            {"Authorization": "Bearer $token"});

    if (apiResponse.error) {
      _friendRequestStreamController.sink
          .add(FriendListState._initState(apiResponse.message));
    } else {
      _friendRequestStreamController.sink
          .add(FriendListState._dataState(apiResponse.data.data));
    }
  }

  friendRequestAction(int requestId, int action) async {
    _friendRequestStreamController.sink
        .add(FriendListState._initState('No Requests'));
    _friendRequestStreamController.sink.add(FriendListState._loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<CommonResponseModel> apiResponse = await K3Webservice.postMethod(apisToUrls(Apis.friendRequestAction), {
      "user_id":"$userId",
      "friend_request_id":"$requestId",
      "action":"$action"
    }, {"Authorization": "Bearer $token"});

    if (apiResponse.error) {
      _friendRequestStreamController.sink.add(FriendListState._initState(apiResponse.message));
    }else{
      _friendRequestStreamController.sink.add(FriendListState._successStatusState(apiResponse.data.msg));
    }
  }

  dispose() {
    _friendRequestStreamController.close();
  }
}

class FriendListState {
  FriendListState();
  factory FriendListState._initState(String message) = FriendListInitState;
  factory FriendListState._loadingState() = FriendListLoadingState;
  factory FriendListState._dataState(List<AppUser> appUsers) =
      FriendListDataState;
  factory FriendListState._successStatusState(String message) =
      FriendListSuccessStatusState;
}

class FriendListInitState extends FriendListState {
  final String message;
  FriendListInitState(this.message);
}

class FriendListLoadingState extends FriendListState {}

class FriendListDataState extends FriendListState {
  final List<AppUser> appUsers;
  FriendListDataState(this.appUsers);
}

class FriendListSuccessStatusState extends FriendListState {
  final String message;
  FriendListSuccessStatusState(this.message);
}
