import 'dart:async';

import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/utils/bloc_state.dart';
import 'package:zabor/utils/k3webservice.dart';

class SuggestCategoryBloc {
  final _streamController = StreamController<BlocState>();
  Stream<BlocState> get stream => _streamController.stream;

  suggestCategory(String category) async {
    _streamController.sink.add(BlocState.loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod<CommonResponseModel>(
            apisToUrls(Apis.suggestCategory),
            {"user_id": "$userId", "category": category},
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
    _streamController.sink.add(BlocState.successState(apiResponse.data.msg));
  }

  initState() {
    _streamController.sink.add(BlocState.initState());
  }

  dispose() {
    _streamController.close();
  }


}
