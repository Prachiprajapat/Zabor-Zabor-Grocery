
class SearchUserResponse {
    bool status;
    String msg;
    List<AppUser> data;

    SearchUserResponse({
        this.status,
        this.msg,
        this.data,
    });

    factory SearchUserResponse.fromJson(Map<String, dynamic> json) => SearchUserResponse(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<AppUser>.from(json["data"].map((x) => AppUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class AppUser {
    DateTime createdAt;
    int id;
    int friendId;
    String profileimage;
    String name;

    AppUser({
        this.createdAt,
        this.id,
        this.friendId,
        this.profileimage,
        this.name,
    });

    factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"] == null ? null : json["id"],
        friendId: json["friend_id"] == null ? null : json["friend_id"],
        profileimage: json["profileimage"] == null ? null : json["profileimage"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "id": id == null ? null : id,
        "friend_id": friendId == null ? null : friendId,
        "profileimage": profileimage == null ? null : profileimage,
        "name": name == null ? null : name,
    };
}
