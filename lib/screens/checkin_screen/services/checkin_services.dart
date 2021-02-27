import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:http/http.dart' as http;
import 'package:zabor/constants/constants.dart';

class CheckinService {
  Future<ApiResponse<String>> postCheckIn(
      int userId, int resId, String comment,File imageFile) async {
    String token = 'Bearer ' +
        '${await AppUtils.getToken() == null ? '' : await AppUtils.getToken()}';

      var uri = Uri.parse("${apisToUrls(Apis.checkIn)}");
      print("${uri}");
      print("${token}");

      var request = new http.MultipartRequest("POST", uri);

    request.headers["Authorization"] = token;
    if (imageFile != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var multipartFile = new http.MultipartFile('pic', stream, length,
          filename: basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));
      request.files.add(multipartFile);
    }

    request.fields["user_id"] = "$userId";
    request.fields["res_id"] = "$resId";
    request.fields["comment"] = comment;

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
      return ApiResponse<String>(data: '${jsonDecode(response.body)["msg"]}');
    } else {
      return ApiResponse(error: true, message: 'Something went wrong');
    }
  }
}
