import 'dart:async';

import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/constants/apis.dart';

class ShareFeedBackBloc {
  final _shareFeedBackBloc = StreamController<ShareFeedBackState>();
  Stream<ShareFeedBackState> get shareFeedBackStream =>
      _shareFeedBackBloc.stream;

  postFeedBack(String subject, String feedback) async {
    _shareFeedBackBloc.sink.add(ShareFeedBackState.loadingState());
    User user = await AppUtils.getUser();
    int userId = user.id;
    dynamic token = await AppUtils.getToken();
    ApiResponse<CommonResponseModel> apiResponse =
        await K3Webservice.postMethod<CommonResponseModel>(
            apisToUrls(Apis.shareFeedback), {
      "user_id": "$userId",
      "subject": subject,
      "feedback": feedback,
    }, {
      "Authorization": "Bearer $token"
    });

    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        _shareFeedBackBloc.sink
            .add(ShareFeedBackState.authError(sessionExpiredText));
        return;
      }
      _shareFeedBackBloc.sink
          .add(ShareFeedBackState.failureState(apiResponse.message));
      return;
    }
    _shareFeedBackBloc.sink
        .add(ShareFeedBackState.sucessState(apiResponse.data.msg));
  }

  dispose() {
    _shareFeedBackBloc.close();
  }
}

class ShareFeedBackState {
  ShareFeedBackState();
  factory ShareFeedBackState.initState() = ShareFeedBackIntState;
  factory ShareFeedBackState.loadingState() = ShareFeedBackLoadingState;
  factory ShareFeedBackState.sucessState(String message) =
      ShareFeedBackSuccessState;
  factory ShareFeedBackState.failureState(String message) =
      ShareFeedBackFailureState;
  factory ShareFeedBackState.authError(String message) = ShareFeedBackAuthError;
}

class ShareFeedBackIntState extends ShareFeedBackState {}

class ShareFeedBackLoadingState extends ShareFeedBackState {}

class ShareFeedBackSuccessState extends ShareFeedBackState {
  final String message;
  ShareFeedBackSuccessState(this.message);
}

class ShareFeedBackFailureState extends ShareFeedBackState {
  final String message;
  ShareFeedBackFailureState(this.message);
}

class ShareFeedBackAuthError extends ShareFeedBackState {
  final String message;
  ShareFeedBackAuthError(this.message);
}
