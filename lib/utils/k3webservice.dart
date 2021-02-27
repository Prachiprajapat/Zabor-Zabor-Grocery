import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/add_address_module/order_success_respons_model.dart';
import 'package:zabor/screens/basket_screen_module/basket_response_model.dart';
import 'package:zabor/screens/basket_screen_module/taxes_response_model.dart';
import 'package:zabor/screens/delivery_address_list_module/delivery_list_response_model.dart';
import 'package:zabor/screens/feed/models/feed_models.dart';
import 'package:zabor/screens/food_list_module/menu_response_model.dart';
import 'package:zabor/screens/friend_list/model/friend_list_model.dart';
import 'package:zabor/screens/home/models/advert_response_model.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/my_reservation_module/my_reservation_response_model.dart';
import 'package:zabor/screens/offers_screen/offers_response_model.dart';
import 'package:zabor/screens/order_history_screen_module/order_history_response_model.dart';
import 'package:zabor/screens/profile/models/models.dart';
import 'package:zabor/screens/profile_detail/model/profile_detail_model.dart';
import 'package:zabor/screens/reserve_seat_module/slot_response_model.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/screens/restuarant_gallery_screen/model/model.dart';
import 'package:zabor/screens/static_pages/model/static_page_model.dart';
import 'package:zabor/screens/timeline_screen/timeline_response_model.dart';

class K3Webservice {
  static Future<ApiResponse<T>> postMethod<T>(
      String url, dynamic data, dynamic headers) async {
    print('hitting url: ' + url);
    print('with parameter: ' + data.toString());
    print('with headers: ' + headers.toString());
    try {
      var response = await http.post(url, body: data, headers: headers);
      print("response.body!!!!!!!!!!!!!!");
      print(url);

      print(response.body);
      if (jsonDecode(response.body)["message"] == "Auth failed" ||
          jsonDecode(response.body)["msg"] == "Auth failed") {
        return ApiResponse(error: true, message: sessionExpiredText);
      }
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)["status"] == false) {
          return ApiResponse<T>(
              error: true, message: jsonDecode(response.body)["msg"]);
        }
        return ApiResponse<T>(data: fromJson<T>(jsonDecode(response.body)));
      } else if (response.statusCode == 422) {
        return ApiResponse<T>(error: true, message: "Something went wrong");
      } else {
        return ApiResponse<T>(error: true, message: "Something went wrong");
      }
    } catch (e) {
      return ApiResponse<T>(error: true, message: "Something went wrong");
    }
  }

  static Future<ApiResponse<T>> getMethod<T>(
      String url, dynamic headers) async {
    print('hitting url: ' + url);
    print('with headers: ' + headers.toString());

    var response = await http.get(url, headers: headers);
    print(response.body);
    if (jsonDecode(response.body)["message"] == "Auth failed" ||
        jsonDecode(response.body)["msg"] == "Auth failed") {
      return ApiResponse(error: true, message: sessionExpiredText);
    }
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse<T>(
            error: true, message: jsonDecode(response.body)["msg"]);
      }
      return ApiResponse<T>(data: fromJson<T>(jsonDecode(response.body)));
    } else if (response.statusCode == 422) {
      return ApiResponse<T>(error: true, message: "Something went wrong");
    } else {
      return ApiResponse<T>(error: true, message: "Something went wrong");
    }
  }

  static T fromJson<T>(dynamic json) {
    if (T == CommonResponseModel) {
      return CommonResponseModel.fromJson(json) as T;
    } else if (T == StaticPageResponse) {
      return StaticPageResponse.fromJson(json) as T;
    } else if (T == UserCheckInResponse) {
      return UserCheckInResponse.fromJson(json) as T;
    } else if (T == SearchUserResponse) {
      return SearchUserResponse.fromJson(json) as T;
    } else if (T == FeedResponseModel) {
      return FeedResponseModel.fromJson(json) as T;
    } else if (T == FriendDetailResponseModel) {
      return FriendDetailResponseModel.fromJson(json) as T;
    } else if (T == RestuarantDetailsResponseModel) {
      return RestuarantDetailsResponseModel.fromJson(json) as T;
    } else if (T == GalleryResponseModel) {
      return GalleryResponseModel.fromJson(json) as T;
    } else if (T == MenulResponseModel) {
      return MenulResponseModel.fromJson(json) as T;
    } else if (T == BasketResponseModel) {
      return BasketResponseModel.fromJson(json) as T;
    } else if (T == DeliveryAddressListResponseModel) {
      return DeliveryAddressListResponseModel.fromJson(json) as T;
    } else if (T == OrderHistoryResponseModel) {
      return OrderHistoryResponseModel.fromJson(json) as T;
    } else if (T == LoginResponseModel) {
      return LoginResponseModel.fromJson(json) as T;
    } else if (T == MyReservationResponseModel) {
      return MyReservationResponseModel.fromJson(json) as T;
    } else if (T == SlotResponseModel) {
      return SlotResponseModel.fromJson(json) as T;
    } else if (T == TaxesResponseModel) {
      return TaxesResponseModel.fromJson(json) as T;
    } else if (T == AdvertResponseModel) {
      return AdvertResponseModel.fromJson(json) as T;
    } else if (T == TimeLineRepsonseModel) {
      return TimeLineRepsonseModel.fromJson(json) as T;
    } else if (T == OrderSuccessResponseModel) {
      return OrderSuccessResponseModel.fromJson(json) as T;
    } else if (T == OrderDetailResponseModel) {
      return OrderDetailResponseModel.fromJson(json) as T;
    } else if (T == OffersResponseModel) {
      return OffersResponseModel.fromJson(json) as T;
    } else if (T == TimeSlotGroceryResponseModel) {
      return TimeSlotGroceryResponseModel.fromJson(json) as T;
    } else {
      return null;
      //throw Exception("Unknown class");
    }
  }
}
