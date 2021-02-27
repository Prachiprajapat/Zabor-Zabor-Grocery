import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';

class UpdateProfileService {
  Future<ApiResponse<User>> updateProfile(
      String name,
      String email,
      String city,
      String address,
      String dob,
      String about,
      String phone,
      int userId,
      File imageFile, String prefLang) async {
    String token = 'Bearer ' +
        '${await AppUtils.getToken() == null ? '' : await AppUtils.getToken()}';

        print(token);
        print(userId);
        print(imageFile);

    var uri = Uri.parse("${apisToUrls(Apis.updateProfile)}?user_id=$userId");
    print(uri);

    var request = new http.MultipartRequest("POST", uri);

    request.headers["Authorization"] = token;
    if (imageFile != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var multipartFile = new http.MultipartFile('profilepic', stream, length,
          filename: basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));
      request.files.add(multipartFile);
    }

    request.fields["name"] = name;
    request.fields["email"] = email;
    request.fields["city"] = city;
    request.fields["address"] = address;
    request.fields["dob"] = dob;
    request.fields["about"] = about;
    request.fields["phone"] = phone;
    request.fields["pref_lang"] = prefLang;
    request.fields["user_id"] = '$userId';

    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (jsonDecode(response.body)["message"] == "Auth failed") {
      return ApiResponse(error: true, message: sessionExpiredText);
    }
    if (jsonDecode(response.body)["status"] == false) {
      return ApiResponse(
          error: true, message: jsonDecode(response.body)["msg"]);
    } else if (jsonDecode(response.body)["status"] == true) {
      return ApiResponse<User>(
          data: User.fromJson(jsonDecode(response.body)["data"]));
    } else {
      return ApiResponse(error: true, message: 'Something went wrong');
    }
  }
}
