class FeedResponseModel {
    bool status;
    String msg;
    List<Feed> data;

    FeedResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory FeedResponseModel.fromJson(Map<String, dynamic> json) => FeedResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<Feed>.from(json["data"].map((x) => Feed.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Feed {
    int id;
    int userId;
    int resId;
    String comment;
    DateTime createdAt;
    DateTime updatedAt;
    String userName;
    String profileimage;
    String resName;
    String restaurantpic;
    String pic;
    int checkinlike;

    Feed({
        this.id,
        this.userId,
        this.resId,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.userName,
        this.profileimage,
        this.resName,
        this.restaurantpic,
        this.pic,
        this.checkinlike,
    });

    factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        resId: json["res_id"] == null ? null : json["res_id"],
        comment: json["comment"] == null ? "" : json["comment"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userName: json["user_name"] == null ? "" : json["user_name"],
        profileimage: json["profileimage"] == null ? "" : json["profileimage"],
        resName: json["res_name"] == null ? "" : json["res_name"],
        restaurantpic: json["restaurantpic"] == null ? "" : json["restaurantpic"],
        pic: json["pic"] == null ? "" : json["pic"],
        checkinlike: json["checkinlike"] == null ? null : json["checkinlike"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "res_id": resId == null ? null : resId,
        "comment": comment == null ? null : comment,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "user_name": userName == null ? null : userName,
        "profileimage": profileimage == null ? null : profileimage,
        "res_name": resName == null ? null : resName,
        "restaurantpic": restaurantpic == null ? null : restaurantpic,
        "pic": pic == null ? null : pic,
        "checkinlike": checkinlike == null ? null : checkinlike,
    };
}