enum ProfileDetailEntryPoint { profile, friend_list }

class FriendDetailResponseModel {
  bool status;
  String msg;
  FriendDetailData data;

  FriendDetailResponseModel({
    this.status,
    this.msg,
    this.data,
  });

  factory FriendDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      FriendDetailResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : FriendDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
      };
}

class FriendDetailData {
  List<Userinfo> userinfo;
  List<LastcheckinInfo> lastcheckinInfo;

  FriendDetailData({
    this.userinfo,
    this.lastcheckinInfo,
  });

  factory FriendDetailData.fromJson(Map<String, dynamic> json) => FriendDetailData(
        userinfo: json["userinfo"] == null
            ? null
            : List<Userinfo>.from(
                json["userinfo"].map((x) => Userinfo.fromJson(x))),
        lastcheckinInfo: json["lastcheckin_info"] == null
            ? null
            : List<LastcheckinInfo>.from(json["lastcheckin_info"]
                .map((x) => LastcheckinInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userinfo": userinfo == null
            ? null
            : List<dynamic>.from(userinfo.map((x) => x.toJson())),
        "lastcheckin_info": lastcheckinInfo == null
            ? null
            : List<dynamic>.from(lastcheckinInfo.map((x) => x.toJson())),
      };
}

class LastcheckinInfo {
  String name;
  String address;

  LastcheckinInfo({
    this.name,
    this.address,
  });

  factory LastcheckinInfo.fromJson(Map<String, dynamic> json) =>
      LastcheckinInfo(
        name: json["name"] == null ? null : json["name"],
        address: json["address"] == null ? null : json["address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "address": address == null ? null : address,
      };
}

class Userinfo {
  String name;
  String city;
  String address;
  String phone;
  String profileimage;
  dynamic about;

  Userinfo({
    this.name,
    this.city,
    this.address,
    this.phone,
    this.profileimage,
    this.about,
  });

  factory Userinfo.fromJson(Map<String, dynamic> json) => Userinfo(
        name: json["name"] == null ? null : json["name"],
        city: json["city"] == null ? null : json["city"],
        address: json["address"] == null ? null : json["address"],
        phone: json["phone"] == null ? null : json["phone"],
        profileimage:
            json["profileimage"] == null ? null : json["profileimage"],
        about: json["about"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "city": city == null ? null : city,
        "address": address == null ? null : address,
        "phone": phone == null ? null : phone,
        "profileimage": profileimage == null ? null : profileimage,
        "about": about,
      };
}
