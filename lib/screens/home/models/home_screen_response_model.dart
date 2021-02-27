class HomeScreenResponseModel {
  bool status;
  Data data;
  dynamic androidVersion;
  dynamic iOSVersion;

  HomeScreenResponseModel({
    this.status,
    this.data,
    this.androidVersion,
    this.iOSVersion,
  });

  factory HomeScreenResponseModel.fromJson(Map<String, dynamic> json) =>
      HomeScreenResponseModel(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        androidVersion:
            json["androidVersion"] == null ? null : json["androidVersion"],
        iOSVersion: json["iOSVersion"] == null ? null : json["iOSVersion"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data.toJson(),
        "androidVersion": androidVersion == null ? null : androidVersion,
        "iOSVersion": iOSVersion == null ? null : iOSVersion,
      };
}

class Data {
  List<RestaurantModel> mostpopular;
  List<RestaurantModel> newestRestaurant;
  List<RestaurantModel> bannerRestaurant;
  Data({this.mostpopular, this.newestRestaurant, this.bannerRestaurant});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mostpopular: json["mostpopular"] == null
            ? null
            : List<RestaurantModel>.from(
                json["mostpopular"].map((x) => RestaurantModel.fromJson(x))),
        newestRestaurant: json["newestRestaurant"] == null
            ? null
            : List<RestaurantModel>.from(json["newestRestaurant"]
                .map((x) => RestaurantModel.fromJson(x))),
        bannerRestaurant: json["bannerRestaurant"] == null
            ? null
            : List<RestaurantModel>.from(json["bannerRestaurant"]
                .map((x) => RestaurantModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mostpopular": mostpopular == null
            ? null
            : List<dynamic>.from(mostpopular.map((x) => x.toJson())),
        "newestRestaurant": newestRestaurant == null
            ? null
            : List<dynamic>.from(newestRestaurant.map((x) => x.toJson())),
        "bannerRestaurant": bannerRestaurant == null
            ? null
            : List<dynamic>.from(bannerRestaurant.map((x) => x.toJson())),
      };
}

class RestaurantModel {
  int id;
  String name;
  String restaurantpic;
  String address;
  double distance;
  double avgrating;
  DateTime createdAt;

  RestaurantModel({
    this.id,
    this.name,
    this.restaurantpic,
    this.address,
    this.distance,
    this.avgrating,
    this.createdAt,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      RestaurantModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        restaurantpic:
            json["restaurantpic"] == null ? null : json["restaurantpic"],
        address: json["address"] == null ? null : json["address"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        avgrating:
            json["avgrating"] == null ? null : json["avgrating"].toDouble(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "address": address == null ? null : address,
        "distance": distance == null ? null : distance,
        "avgrating": avgrating == null ? null : avgrating,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
      };
}

class BannerRestaurant {
  int id;
  int restaurantId;
  String pic;
  dynamic name;
  dynamic address;

  BannerRestaurant({
    this.id,
    this.restaurantId,
    this.pic,
    this.name,
    this.address,
  });

  factory BannerRestaurant.fromJson(Map<String, dynamic> json) =>
      BannerRestaurant(
        id: json["id"] == null ? null : json["id"],
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        pic: json["pic"] == null ? null : json["pic"],
        name: json["name"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "pic": pic == null ? null : pic,
        "name": name,
        "address": address,
      };
}

class ResseachResponseModel {
  bool status;
  String msg;
  Data1 data;

  ResseachResponseModel({
    this.status,
    this.msg,
    this.data,
  });

  factory ResseachResponseModel.fromJson(Map<String, dynamic> json) =>
      ResseachResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Data1.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
      };
}

class Data1 {
  List<Response> response;

  Data1({
    this.response,
  });

  factory Data1.fromJson(Map<String, dynamic> json) => Data1(
        response: json["response"] == null
            ? null
            : List<Response>.from(
                json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response == null
            ? null
            : List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Response {
  String monopenTime;
  String moncloseTime;
  String tueopenTime;
  String tuecloseTime;
  String wedopenTime;
  String wedcloseTime;
  String thuopenTime;
  String thucloseTime;
  String friopenTime;
  String fricloseTime;
  String satopenTime;
  String satcloseTime;
  String sunopenTime;
  String suncloseTime;
  String contact;
  dynamic avgCost;
  String restaurantpic;
  int id;
  String name;
  String address;
  int catId;
  String catName;
  double distance;
  dynamic avgrating;

  Response({
    this.monopenTime,
    this.moncloseTime,
    this.tueopenTime,
    this.tuecloseTime,
    this.wedopenTime,
    this.wedcloseTime,
    this.thuopenTime,
    this.thucloseTime,
    this.friopenTime,
    this.fricloseTime,
    this.satopenTime,
    this.satcloseTime,
    this.sunopenTime,
    this.suncloseTime,
    this.contact,
    this.avgCost,
    this.restaurantpic,
    this.id,
    this.name,
    this.address,
    this.catId,
    this.catName,
    this.distance,
    this.avgrating,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        monopenTime: json["monopen_time"] == null ? null : json["monopen_time"],
        moncloseTime:
            json["monclose_time"] == null ? null : json["monclose_time"],
        tueopenTime: json["tueopen_time"] == null ? null : json["tueopen_time"],
        tuecloseTime:
            json["tueclose_time"] == null ? null : json["tueclose_time"],
        wedopenTime: json["wedopen_time"] == null ? null : json["wedopen_time"],
        wedcloseTime:
            json["wedclose_time"] == null ? null : json["wedclose_time"],
        thuopenTime: json["thuopen_time"] == null ? null : json["thuopen_time"],
        thucloseTime:
            json["thuclose_time"] == null ? null : json["thuclose_time"],
        friopenTime: json["friopen_time"] == null ? null : json["friopen_time"],
        fricloseTime:
            json["friclose_time"] == null ? null : json["friclose_time"],
        satopenTime: json["satopen_time"] == null ? null : json["satopen_time"],
        satcloseTime:
            json["satclose_time"] == null ? null : json["satclose_time"],
        sunopenTime: json["sunopen_time"] == null ? null : json["sunopen_time"],
        suncloseTime:
            json["sunclose_time"] == null ? null : json["sunclose_time"],
        contact: json["contact"] == null ? null : json["contact"],
        avgCost: json["avg_cost"] == null ? null : json["avg_cost"],
        restaurantpic:
            json["restaurantpic"] == null ? null : json["restaurantpic"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        address: json["address"] == null ? null : json["address"],
        catId: json["cat_id"] == null ? null : json["cat_id"],
        catName: json["cat_name"] == null ? null : json["cat_name"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        avgrating: json["avgrating"],
      );

  Map<String, dynamic> toJson() => {
        "monopen_time": monopenTime == null ? null : monopenTime,
        "monclose_time": moncloseTime == null ? null : moncloseTime,
        "tueopen_time": tueopenTime == null ? null : tueopenTime,
        "tueclose_time": tuecloseTime == null ? null : tuecloseTime,
        "wedopen_time": wedopenTime == null ? null : wedopenTime,
        "wedclose_time": wedcloseTime == null ? null : wedcloseTime,
        "thuopen_time": thuopenTime == null ? null : thuopenTime,
        "thuclose_time": thucloseTime == null ? null : thucloseTime,
        "friopen_time": friopenTime == null ? null : friopenTime,
        "friclose_time": fricloseTime == null ? null : fricloseTime,
        "satopen_time": satopenTime == null ? null : satopenTime,
        "satclose_time": satcloseTime == null ? null : satcloseTime,
        "sunopen_time": sunopenTime == null ? null : sunopenTime,
        "sunclose_time": suncloseTime == null ? null : suncloseTime,
        "contact": contact == null ? null : contact,
        "avg_cost": avgCost == null ? null : avgCost,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "address": address == null ? null : address,
        "cat_id": catId == null ? null : catId,
        "cat_name": catName == null ? null : catName,
        "distance": distance == null ? null : distance,
        "avgrating": avgrating,
      };
}
