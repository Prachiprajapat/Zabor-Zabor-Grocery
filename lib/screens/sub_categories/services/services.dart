import 'dart:convert';

import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/sub_categories/models/sub_categories_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:zabor/webservices/webservices.dart';
class SubCategoryService {
  int categoryId;

  SubCategoryService(this.categoryId);

  Future<ApiResponse<List<SubCategoryModel>>> getSubCategories() async {
    final response =
        await http.get("${apisToUrls(Apis.subCatgories)} + $categoryId");

    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == false) {
        return ApiResponse(error: true,message: '${jsonDecode(response.body)["msg"]}');
      } else {
        SubCategoryResponseModel subCategoryResponseModel =
            SubCategoryResponseModel.fromJson(jsonDecode(response.body));
        return ApiResponse<List<SubCategoryModel>>(data: subCategoryResponseModel.data);
      }
    } else if (response.statusCode == 422) {
      final responseModel =
          ErrorResponseModel.fromJson(jsonDecode(response.body));
      print(responseModel.errors[0].msg);
      return ApiResponse(error: true,message: '${responseModel.errors[0].msg}');
    } else {
      print('Something went wrong');
      return ApiResponse(error: true,message: 'Something went wrong');
    }
  }
}
