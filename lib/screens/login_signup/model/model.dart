class RegistrationResponseModel {
    bool status;
    String msg;

    RegistrationResponseModel({
        this.status,
        this.msg,
    });

    factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) => RegistrationResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
    };
}

class LoginResponseModel {
    bool status;
    String msg;
    Data data;

    LoginResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
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
    User user;
    String token;

    Data({
        this.user,
        this.token,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"] == null ? null : json["token"],
    );

    Map<String, dynamic> toJson() => {
        "user": user == null ? null : user.toJson(),
        "token": token == null ? null : token,
    };
}

class User {

    int id;
    String name;
    String email;
    dynamic profileimage;
    dynamic address;
    dynamic city;
    dynamic latitude;
    dynamic longitude;
    dynamic dob;
    dynamic about;
    dynamic phone;
    String role;
    int status;
    dynamic fbToken;
    dynamic googleToken;
    dynamic instragramToken;
    dynamic twitterToken;
    String token;
    dynamic resetToken;
    DateTime createdDate;
    String prefLang;
    User({
        this.id,
        this.name,
        this.email,
        this.profileimage,
        this.address,
        this.city,
        this.latitude,
        this.longitude,
        this.dob,
        this.about,
        this.phone,
        this.role,
        this.status,
        this.fbToken,
        this.googleToken,
        this.instragramToken,
        this.twitterToken,
        this.token,
        this.resetToken,
        this.createdDate,
        this.prefLang,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        profileimage: json["profileimage"],
        address: json["address"],
        city: json["city"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        dob: json["dob"],
        about: json["about"],
        phone: json["phone"],
        role: json["role"] == null ? null : json["role"],
        status: json["status"] == null ? null : json["status"],
        fbToken: json["fb_token"],
        googleToken: json["google_token"],
        instragramToken: json["instragram_token"],
        twitterToken: json["twitter_token"],
        token: json["token"] == null ? null : json["token"],
        prefLang: json["pref_lang"] == null ? null : json["pref_lang"],
        resetToken: json["reset_token"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "profileimage": profileimage,
        "address": address,
        "city": city,
        "latitude": latitude,
        "longitude": longitude,
        "dob": dob,
        "about": about,
        "phone": phone,
        "role": role == null ? null : role,
        "status": status == null ? null : status,
        "fb_token": fbToken,
        "google_token": googleToken,
        "instragram_token": instragramToken,
        "twitter_token": twitterToken,
        "token": token == null ? null : token,
        "pref_lang": prefLang == null ? null : prefLang,
        "reset_token": resetToken,
        "created_date": createdDate == null ? null : createdDate.toIso8601String(),
    };

}
