import 'dart:async';

import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/friend_list/model/friend_list_model.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/utils/k3webservice.dart';

class UserListBloc {
  final _userListController = StreamController<UserListState>();
  Stream<UserListState> get userListStream => _userListController.stream;

  searchUser(String name) async {
    _userListController.sink.add(UserListState._initState('No Users'));
    _userListController.sink.add(UserListState._loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<SearchUserResponse> apiResponse =
        await K3Webservice.postMethod<SearchUserResponse>(
            apisToUrls(Apis.appusers),
            {"user_id": "$userId", "user": name},
            {"Authorization": "Bearer $token"});

    if (apiResponse.error) {
      _userListController.sink
          .add(UserListState._initState(apiResponse.message));
    } else {
      _userListController.sink
          .add(UserListState._userDataState(apiResponse.data.data));
    }
  }

  getMyFriends() async {
    _userListController.sink.add(UserListState._initState('No Users'));
    _userListController.sink.add(UserListState._loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<SearchUserResponse> apiResponse =
        await K3Webservice.postMethod<SearchUserResponse>(
            apisToUrls(Apis.myFriends),
            {"user_id": "$userId", "page": "1"},
            {"Authorization": "Bearer $token"});

    if (apiResponse.error) {
      _userListController.sink
          .add(UserListState._initState(apiResponse.message));
    } else {
      _userListController.sink
          .add(UserListState._userDataState(apiResponse.data.data));
    }
  }

  Future<List<AppUser>> getMoreMyFriends() async {
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<SearchUserResponse> apiResponse =
        await K3Webservice.postMethod<SearchUserResponse>(
            apisToUrls(Apis.myFriends),
            {"user_id": "$userId", "page": "1"},
            {"Authorization": "Bearer $token"});

    if (apiResponse.error) {
      _userListController.sink
          .add(UserListState._userDataState(apiResponse.data.data));
      return null;
    }

    return apiResponse.data.data;
  }

  sendFriendRequest(int requestUserId) async {
    _userListController.sink.add(UserListState._initState('No Users'));
    _userListController.sink.add(UserListState._loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod<CommonResponseModel>(
            apisToUrls(Apis.sendFriendRequest),
            {"user_id": "$userId", "requesteduser_id": "$requestUserId"},
            {"Authorization": "Bearer $token"});

    if (apiResponse.error) {
      _userListController.sink
          .add(UserListState._initState(apiResponse.message));
    } else {
      _userListController.sink
          .add(UserListState._successStatusState(apiResponse.data.msg));
    }
  }

  friendRequestAction(int requestId, int action) async {
    _userListController.sink.add(UserListState._initState('No Requests'));
    _userListController.sink.add(UserListState._loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod(apisToUrls(Apis.friendRequestAction), {
      "user_id": "$userId",
      "friend_request_id": "$requestId",
      "action": "$action"
    }, {
      "Authorization": "Bearer $token"
    });

    if (apiResponse.error) {
      _userListController.sink
          .add(UserListState._initState(apiResponse.message));
    } else {
      _userListController.sink
          .add(UserListState._successStatusState(apiResponse.data.msg));
    }
  }

  void dispose() {
    _userListController.close();
  }
}

class UserListState {
  UserListState();
  factory UserListState._initState(String message) = UserListInitState;
  factory UserListState._loadingState() = UserListLoadingState;
  factory UserListState._userDataState(List<AppUser> appUsers) =
      UserListDataState;
  factory UserListState._successStatusState(String message) =
      UserListSuccessStatusState;
}

class UserListInitState extends UserListState {
  final String message;
  UserListInitState(this.message);
}

class UserListLoadingState extends UserListState {}

class UserListDataState extends UserListState {
  final List<AppUser> appUsers;
  UserListDataState(this.appUsers);
}

class UserListSuccessStatusState extends UserListState {
  final String message;
  UserListSuccessStatusState(this.message);
}
