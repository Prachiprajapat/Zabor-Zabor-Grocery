import 'dart:async';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/notification_screen/model/model.dart';
import 'package:zabor/utils/bloc_state.dart';
import 'package:zabor/utils/k3webservice.dart';

class NotificationBloc {
  final _streamController = StreamController<BlocState>();
  Stream<BlocState> get stream => _streamController.stream;

  getNotificationList(int page) async {
    _streamController.sink.add(BlocState.loadingState());

    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();

    ApiResponse<NotificationResponseModel> apiResponse =
        await K3Webservice.postMethod<NotificationResponseModel>(
            apisToUrls(Apis.notificationList),
            {"page": '$page', "user_id": '$userId'},
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
    _streamController.sink
        .add(BlocState.notificationData(apiResponse.data.response));
  }

  Future<List<NotificationModel>> loadMoreNotification(int page) async {
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();

    ApiResponse<NotificationResponseModel> apiResponse =
        await K3Webservice.postMethod<NotificationResponseModel>(
            apisToUrls(Apis.notificationList),
            {"page": '$page', "user_id": '$userId'},
            {"Authorization": "Bearer $token"});
    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        _streamController.sink
            .add(BlocState.authErrorState(sessionExpiredText));
        return null;
      }
      _streamController.sink.add(BlocState.failureState(apiResponse.message));
      return null;
    }
    return apiResponse.data.response;
  }

  dispose() {
    _streamController.close();
  }
}
