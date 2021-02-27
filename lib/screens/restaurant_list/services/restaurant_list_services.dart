import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/screens/restaurant_list/model/restuarant_list_model.dart';
import 'package:zabor/utils/location_services.dart';
import 'package:zabor/webservices/webservices.dart';

enum RestaurantListEntryPoint {
  subCategoryScreen,
  filter,
  seeAllPopularRestaurants,
  seeAllNewRestaurants,
  resSearch
}

class RestaurantListServices {
  Future<ApiResponse<List<RestaurantModel>>> getRestaurantCatWise(
      String subCat, String page) async {
    if (position == null) {
      try {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (error) {
        position = Position(latitude: 18.031376, longitude: -66.587883);
        // if (error.code == "PERMISSION_DENIED") {
        //   return ApiResponse(
        //       error: true, message: "Please give access to location.");
        // }
      }
    }
    print(position.latitude);
    print(position.longitude);

    final response =
        await http.post("${apisToUrls(Apis.searchRestbyCat)}", body: {
      "latitude": position == null ? "0.0" : "${position.latitude}",
      "longitude": position == null ? "0.0" : "${position.longitude}",
      "subcat_id": subCat,
      "page": page
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse(
            error: true, message: '${jsonDecode(response.body)["msg"]}');
      } else {
        RestaurantListResponseModel responseModel =
            RestaurantListResponseModel.fromJson(jsonDecode(response.body));
        return ApiResponse<List<RestaurantModel>>(
            data: responseModel.data.restaurant);
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

  Future<ApiResponse<List<RestaurantModel>>> getRestaurantSearchWise(
      String query, String page) async {
    if (position == null) {
      try {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (error) {
        position = Position(latitude: 18.031376, longitude: -66.587883);
        // if (error.code == "PERMISSION_DENIED") {
        //   return ApiResponse(
        //       error: true, message: "Please give access to location.");
        // }
      }
    }
    print(position.latitude);
    print(position.longitude);

    final response =
        await http.post("${apisToUrls(Apis.searchRestByQuery)}", body: {
      "latitude": position == null ? "0.0" : "${position.latitude}",
      "longitude": position == null ? "0.0" : "${position.longitude}",
      "restaurant": query,
      "page": page
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse(
            error: true, message: '${jsonDecode(response.body)["msg"]}');
      } else {
        ResseachResponseModel responseModel =
            ResseachResponseModel.fromJson(jsonDecode(response.body));
        List<RestaurantModel> _arrRestuarantModel = [];
        if (responseModel.data != null) {
          if (responseModel.data.response != null) {
            for (int i = 0; i < responseModel.data.response.length; i++) {
              Response response = responseModel.data.response[i];
              _arrRestuarantModel.add(RestaurantModel(
                  id: response.id,
                  name: response.name,
                  restaurantpic: response.restaurantpic,
                  address: response.address,
                  distance: response.distance,
                  avgrating: response.avgrating,
                  createdAt: DateTime.now()));
            }
          }
        }
        return ApiResponse<List<RestaurantModel>>(data: _arrRestuarantModel);
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

  Future<ApiResponse<List<RestaurantModel>>> getRestaurantFiltered(
      int filteredType, String page) async {
    if (position == null) {
      try {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (error) {
        position = Position(latitude: 18.031376, longitude: -66.587883);
        // if (error.code == "PERMISSION_DENIED") {
        //   return ApiResponse(
        //       error: true, message: "Please give access to location.");
        // }
      }
    }
    print(position.latitude);
    print(position.longitude);

    final response =
        await http.post("${apisToUrls(Apis.filterRestaurants)}", body: {
      "latitude": position == null ? "0.0" : "${position.latitude}",
      "longitude": position == null ? "0.0" : "${position.longitude}",
      "filtertype": '$filteredType',
      "page": page
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse(
            error: true, message: '${jsonDecode(response.body)["msg"]}');
      } else {
        RestaurantListResponseModel responseModel =
            RestaurantListResponseModel.fromJson(jsonDecode(response.body));
        return ApiResponse<List<RestaurantModel>>(
            data: responseModel.data.restaurant);
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

  Future<ApiResponse<List<RestaurantModel>>> getSeeAllRestaurant(
      RestaurantListEntryPoint restaurantListEntryPoint, String page) async {
    if (position == null) {
      try {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (error) {
        if (error.code == "PERMISSION_DENIED") {
          return ApiResponse(
              error: true, message: "Please give access to location.");
        }
      }
    }
    print(position.latitude);
    print(position.longitude);
    String urlString = '';

    if (restaurantListEntryPoint ==
        RestaurantListEntryPoint.seeAllNewRestaurants) {
      urlString = "${apisToUrls(Apis.newRestaurants)}";
    } else if (restaurantListEntryPoint ==
        RestaurantListEntryPoint.seeAllPopularRestaurants) {
      urlString = "${apisToUrls(Apis.popularRestaurants)}";
    } else {
      urlString = '';
    }
    final response = await http.post(urlString, body: {
      "latitude": position == null ? "0.0" : "${position.latitude}",
      "longitude": position == null ? "0.0" : "${position.longitude}",
      "page": page
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse(
            error: true, message: '${jsonDecode(response.body)["msg"]}');
      } else {
        RestaurantListResponseModel responseModel =
            RestaurantListResponseModel.fromJson(jsonDecode(response.body));
        return ApiResponse<List<RestaurantModel>>(
            data: responseModel.data.restaurant);
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
