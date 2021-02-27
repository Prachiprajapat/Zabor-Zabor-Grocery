import 'package:zabor/screens/notification_screen/model/model.dart';
import 'package:zabor/screens/profile_detail/model/profile_detail_model.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/screens/restuarant_gallery_screen/model/model.dart';

class BlocState {
  BlocState();
  factory BlocState.initState() = BlocInitState;
  factory BlocState.loadingState() = BlocLoadingState;
  factory BlocState.failureState(String message) = BlocFailureState;
  factory BlocState.successState(String message) = BlocSuccessState;
  factory BlocState.authErrorState(String message) = BlocAuthErrorState;
  factory BlocState.friendDetail(FriendDetailData data) = FriendDetailState;
  factory BlocState.galleryData(List<Gallery> data) = GalleryDataState;
  factory BlocState.notificationData(List<NotificationModel> data) = BlocNotificationDataState;
  factory BlocState.restuarantDetailData(RestaurantDetailModel data) =
      RestaurantDetailState;
}

class BlocInitState extends BlocState {}

class BlocLoadingState extends BlocState {}

class BlocFailureState extends BlocState {
  final String message;
  BlocFailureState(this.message);
}

class BlocAuthErrorState extends BlocState {
  final String message;
  BlocAuthErrorState(this.message);
}

class BlocSuccessState extends BlocState {
  final String message;
  BlocSuccessState(this.message);
}

class FriendDetailState extends BlocState {
  final FriendDetailData data;
  FriendDetailState(this.data);
}

class GalleryDataState extends BlocState {
  final List<Gallery> data;
  GalleryDataState(this.data);
}

class RestaurantDetailState extends BlocState {
  final RestaurantDetailModel data;
  RestaurantDetailState(this.data);
}

class BlocNotificationDataState extends BlocState{
  final List<NotificationModel> data;
  BlocNotificationDataState(this.data);
}