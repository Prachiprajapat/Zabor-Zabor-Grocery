import 'package:zabor/screens/offers_screen/offers_response_model.dart';

class RestuarantDetailsResponseModel {
    bool status;
    String msg;
    RestaurantDetailModel data;

    RestuarantDetailsResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory RestuarantDetailsResponseModel.fromJson(Map<String, dynamic> json) => RestuarantDetailsResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : RestaurantDetailModel.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
    };
}

class RestaurantDetailModel {
    List<RestaurantDetail> restaurantDetail;
    List<Review> review;
    List<Openclosetime> openclosetime;
    List<Offer> discounts;

    RestaurantDetailModel({
        this.restaurantDetail,
        this.review,
        this.openclosetime,
        this.discounts
    });


     factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) => RestaurantDetailModel(
        restaurantDetail: json["restaurantDetail"] == null ? null : List<RestaurantDetail>.from(json["restaurantDetail"].map((x) => RestaurantDetail.fromJson(x))),
        review: json["review"] == null ? null : List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        openclosetime: json["openclosetime"] == null ? null : List<Openclosetime>.from(json["openclosetime"].map((x) => Openclosetime.fromJson(x))),
        discounts: json["discounts"] == null ? null : List<Offer>.from(json["discounts"].map((x) => Offer.fromJson(x)))
    );

    Map<String, dynamic> toJson() => {
        "restaurantDetail": restaurantDetail == null ? null : List<dynamic>.from(restaurantDetail.map((x) => x.toJson())),
        "review": review == null ? null : List<dynamic>.from(review.map((x) => x.toJson())),
        "openclosetime": openclosetime == null ? null : List<dynamic>.from(openclosetime.map((x) => x.toJson())),
        "discounts": discounts == null ? null : List<dynamic>.from(discounts.map((x) => x.toJson())),
    };
}

class RestaurantDetail {
    int id;
    String restaurantName;
    dynamic avgCost;
    String categoryName;
    String openTime;
    String closeTime;
    String contact;
    String description;
    String subcategory;
    String subcatName;
    String restaurantpic;
    String city;
    String address;
    double latitude;
    double longitude;
    double rating;

    RestaurantDetail({
        this.id,
        this.restaurantName,
        this.avgCost,
        this.categoryName,
        this.openTime,
        this.closeTime,
        this.contact,
        this.description,
        this.subcategory,
        this.subcatName,
        this.restaurantpic,
        this.city,
        this.address,
        this.latitude,
        this.longitude,
        this.rating,
    });

    factory RestaurantDetail.fromJson(Map<String, dynamic> json) => RestaurantDetail(
        id: json["id"] == null ? null : json["id"],
        restaurantName: json["restaurant_name"] == null ? null : json["restaurant_name"],
        avgCost: json["avg_cost"] == null ? null : json["avg_cost"],
        categoryName: json["category_name"] == null ? null : json["category_name"],
        openTime: json["open_time"] == null ? null : json["open_time"],
        closeTime: json["close_time"] == null ? null : json["close_time"],
        contact: json["contact"] == null ? null : json["contact"],
        description: json["description"] == null ? null : json["description"],
        subcategory: json["subcategory"] == null ? null : json["subcategory"],
        subcatName: json["subcat_name"] == null ? null : json["subcat_name"],
        restaurantpic: json["restaurantpic"] == null ? null : json["restaurantpic"],
        city: json["city"] == null ? null : json["city"],
        address: json["address"] == null ? null : json["address"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "restaurant_name": restaurantName == null ? null : restaurantName,
        "avg_cost": avgCost == null ? null : avgCost,
        "category_name": categoryName == null ? null : categoryName,
        "open_time": openTime == null ? null : openTime,
        "close_time": closeTime == null ? null : closeTime,
        "contact": contact == null ? null : contact,
        "description": description == null ? null : description,
        "subcategory": subcategory == null ? null : subcategory,
        "subcat_name": subcatName == null ? null : subcatName,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "city": city == null ? null : city,
        "address": address == null ? null : address,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "rating": rating == null ? null : rating,
    };
}

class Openclosetime {
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

    Openclosetime({
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
    });

    factory Openclosetime.fromJson(Map<String, dynamic> json) => Openclosetime(
        monopenTime: json["monopen_time"] == null ? null : json["monopen_time"],
        moncloseTime: json["monclose_time"] == null ? null : json["monclose_time"],
        tueopenTime: json["tueopen_time"] == null ? null : json["tueopen_time"],
        tuecloseTime: json["tueclose_time"] == null ? null : json["tueclose_time"],
        wedopenTime: json["wedopen_time"] == null ? null : json["wedopen_time"],
        wedcloseTime: json["wedclose_time"] == null ? null : json["wedclose_time"],
        thuopenTime: json["thuopen_time"] == null ? null : json["thuopen_time"],
        thucloseTime: json["thuclose_time"] == null ? null : json["thuclose_time"],
        friopenTime: json["friopen_time"] == null ? null : json["friopen_time"],
        fricloseTime: json["friclose_time"] == null ? null : json["friclose_time"],
        satopenTime: json["satopen_time"] == null ? null : json["satopen_time"],
        satcloseTime: json["satclose_time"] == null ? null : json["satclose_time"],
        sunopenTime: json["sunopen_time"] == null ? null : json["sunopen_time"],
        suncloseTime: json["sunclose_time"] == null ? null : json["sunclose_time"],
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
    };
}

class Review {
    int id;
    int resId;
    int userId;
    double rating;
    int waiting;
    int restrooms;
    int ambience;
    int service;
    int food;
    int pricing;
    int management;
    int locality;
    String comment;
    DateTime createdAt;
    DateTime updatedAt;
    String userName;
    String profileimage;

    Review({
        this.id,
        this.resId,
        this.userId,
        this.rating,
        this.waiting,
        this.restrooms,
        this.ambience,
        this.service,
        this.food,
        this.pricing,
        this.management,
        this.locality,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.userName,
        this.profileimage,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"] == null ? null : json["id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        waiting: json["waiting"] == null ? null : json["waiting"],
        restrooms: json["restrooms"] == null ? null : json["restrooms"],
        ambience: json["ambience"] == null ? null : json["ambience"],
        service: json["service"] == null ? null : json["service"],
        food: json["food"] == null ? null : json["food"],
        pricing: json["pricing"] == null ? null : json["pricing"],
        management: json["management"] == null ? null : json["management"],
        locality: json["locality"] == null ? null : json["locality"],
        comment: json["comment"] == null ? null : json["comment"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userName: json["user_name"] == null ? null : json["user_name"],
        profileimage: json["profileimage"] == null ? null : json["profileimage"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "res_id": resId == null ? null : resId,
        "user_id": userId == null ? null : userId,
        "rating": rating == null ? null : rating,
        "waiting": waiting == null ? null : waiting,
        "restrooms": restrooms == null ? null : restrooms,
        "ambience": ambience == null ? null : ambience,
        "service": service == null ? null : service,
        "food": food == null ? null : food,
        "pricing": pricing == null ? null : pricing,
        "management": management == null ? null : management,
        "locality": locality == null ? null : locality,
        "comment": comment == null ? null : comment,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "user_name": userName == null ? null : userName,
        "profileimage": profileimage == null ? null : profileimage,
    };
}