import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/webservices/webservices.dart';

class GiveRatingService {
  Future<ApiResponse<String>> postRatings(resId, userId, waiting, restrooms,
      ambience, service, food, pricing, management, locality, comment) async {

          String token = 'Bearer '+'${await AppUtils.getToken() == null ? '' : await AppUtils.getToken()}';

          Map<String,dynamic> body = {
      "res_id":"$resId",
      "user_id":"$userId",
      "waiting":waiting,
      "restrooms":restrooms,
      "ambience":ambience,
      "service":service,
      "food":food,
      "pricing":pricing,
      "management":management,
      "locality":locality,
      "comment":"$comment"
    };
    
    final response =
        await http.post("${apisToUrls(Apis.rateRestaurants)}", body: jsonEncode(body),headers: {
      "Authorization":token,
      "Content-Type": "application/json"
    });

    print(response.body);

    if (jsonDecode(response.body)["message"] == "Auth failed" || jsonDecode(response.body)["msg"] == "Auth failed"){
        return ApiResponse(
            error: true, message: sessionExpiredText);
    }

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse(
            error: true, message: '${jsonDecode(response.body)["msg"]}');
      } else {
        return ApiResponse(data: '${jsonDecode(response.body)["msg"]}');
      }
    } else if (response.statusCode == 422) {
      final responseModel =
          ErrorResponseModel.fromJson(jsonDecode(response.body));
      print(responseModel.errors[0].msg);
      return ApiResponse(
          error: true, message: '${responseModel.errors[0].msg}');
    } else {
      print('Something went wrong');
      return ApiResponse(error: true, message: 'Something went wrong');
    }
  }
}
