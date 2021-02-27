import 'dart:async';

import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/restuarant_gallery_screen/model/model.dart';
import 'package:zabor/utils/bloc_state.dart';
import 'package:zabor/utils/k3webservice.dart';

class RestaurantGalleryBloc {
  final _streamController = StreamController<BlocState>();
  Stream<BlocState> get stream => _streamController.stream;

  getGallery(int restId, int page) async {
    _streamController.sink.add(BlocState.loadingState());
    ApiResponse<GalleryResponseModel> apiResponse =
        await K3Webservice.postMethod<GalleryResponseModel>(
            apisToUrls(Apis.restaurantGallery),
            {"page": '$page', "res_id": '$restId'},
            null);
    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        _streamController.sink
            .add(BlocState.authErrorState(sessionExpiredText));
        return;
      }
      _streamController.sink.add(BlocState.failureState(apiResponse.message));
      return;
    }
    _streamController.sink.add(BlocState.galleryData(apiResponse.data.data));
  }

    Future<List<Gallery>> loadMoreGallery(int restId, int page) async {
    ApiResponse<GalleryResponseModel> apiResponse =
        await K3Webservice.postMethod<GalleryResponseModel>(
            apisToUrls(Apis.restaurantGallery),
            {"page": '$page', "res_id": '$restId'},
            null);
    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        _streamController.sink
            .add(BlocState.authErrorState(sessionExpiredText));
        return null;
      }
      _streamController.sink.add(BlocState.failureState(apiResponse.message));
      return null;
    }
    return apiResponse.data.data;
  }

  dispose() {
    _streamController.close();
  }
}
