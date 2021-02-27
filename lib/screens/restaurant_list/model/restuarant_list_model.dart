import 'package:zabor/screens/home/models/home_screen_response_model.dart';

class RestaurantListResponseModel {
    bool status;
    String msg;
    Data data;

    RestaurantListResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory RestaurantListResponseModel.fromJson(Map<String, dynamic> json) => RestaurantListResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    List<RestaurantModel> restaurant;

    Data({
        this.restaurant,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        restaurant: json["restaurant"] == null ? null : List<RestaurantModel>.from(json["restaurant"].map((x) => RestaurantModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "restaurant": restaurant == null ? null : List<dynamic>.from(restaurant.map((x) => x.toJson())),
    };
}
