import 'dart:async';

import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/profile_detail/model/profile_detail_model.dart';
import 'package:zabor/utils/bloc_state.dart';
import 'package:zabor/utils/k3webservice.dart';

class ProfileDetailBloc {
  final _streamController = StreamController<BlocState>();

  Stream<BlocState> get stream => _streamController.stream;

  getUserInfo(int friendId) async {
    _streamController.sink.add(BlocState.loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<FriendDetailResponseModel> apiResponse =
        await K3Webservice.postMethod<FriendDetailResponseModel>(
            apisToUrls(Apis.friendDetail),
            {"user_id": '$userId', "friend_id": '$friendId'},
            {"Authorization": "Bearer $token"});

    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        _streamController.sink
            .add(BlocState.authErrorState(sessionExpiredText));
        return;
      }
      _streamController.sink.add(BlocState.failureState(apiResponse.message));
      return;
    }
    _streamController.sink.add(BlocState.friendDetail(apiResponse.data.data));
  }

  dispose() {
    _streamController.close();
  }
}
