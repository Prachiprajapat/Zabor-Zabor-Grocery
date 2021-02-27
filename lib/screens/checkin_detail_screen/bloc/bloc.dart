import 'dart:async';

import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/utils/bloc_state.dart';
import 'package:zabor/utils/k3webservice.dart';

class CheckinDetailBloc {
  final _streamController = StreamController<BlocState>();
  Stream<BlocState> get stream => _streamController.stream;

  getDetail(int restId) async {
    _streamController.sink.add(BlocState.loadingState());

    ApiResponse<RestuarantDetailsResponseModel> apiResponse =
        await K3Webservice.postMethod<RestuarantDetailsResponseModel>(
            apisToUrls(Apis.restaurantDetail), {"res_id": "$restId"}, null);

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
        .add(BlocState.restuarantDetailData(apiResponse.data.data));
  }

  dispose() {
    _streamController.close();
  }
}
