import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/categories/models/category_response_model.dart';
import 'package:zabor/screens/categories/models/search_category_response_model.dart';
import 'package:zabor/webservices/webservices.dart';

class CategoryService {
  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    final response = await http.get("${apisToUrls(Apis.categories)}");

    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse(
            error: true, message: '${jsonDecode(response.body)["msg"]}');
      } else {
        CategoryResponseModel categoryResponseModel =
            CategoryResponseModel.fromJson(jsonDecode(response.body));
        return ApiResponse<List<CategoryModel>>(
            data: categoryResponseModel.data);
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

  Future<ApiResponse<List<CategoryModel>>> searchedCategoryResults(
      String cat) async {
    final response = await http
        .post("${apisToUrls(Apis.searchCategories)}", body: {"cat": cat});

    print(response.body);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse(
            error: true, message: '${jsonDecode(response.body)["msg"]}');
      } else {
        SearchCategoryResponseModel searchCategoryResponseModel =
            SearchCategoryResponseModel.fromJson(jsonDecode(response.body));
        return ApiResponse<List<CategoryModel>>(
            data: searchCategoryResponseModel.data.category);
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
