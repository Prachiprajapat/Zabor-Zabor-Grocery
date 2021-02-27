class DeliveryAddressListResponseModel {
    bool status;
    String msg;
    List<Address> address;

    DeliveryAddressListResponseModel({
        this.status,
        this.msg,
        this.address,
    });

    factory DeliveryAddressListResponseModel.fromJson(Map<String, dynamic> json) => DeliveryAddressListResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        address: json["address"] == null ? null : List<Address>.from(json["address"].map((x) => Address.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "address": address == null ? null : List<dynamic>.from(address.map((x) => x.toJson())),
    };
}

class Address {
    int id;
    int userId;
    String firstname;
    String lastname;
    String phone;
    String email;
    String address;
    String city;
    int pincode;
    String country;
    String houseno;
    DateTime createdDate;
    dynamic lat;
    dynamic lng;    

    Address({
        this.id,
        this.userId,
        this.firstname,
        this.lastname,
        this.phone,
        this.email,
        this.address,
        this.city,
        this.pincode,
        this.country,
        this.houseno,
        this.createdDate,
        this.lat,
        this.lng,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
        address: json["address"] == null ? null : json["address"],
        city: json["city"] == null ? null : json["city"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        country: json["country"] == null ? null : json["country"],
        houseno: json["houseno"] == null ? null : json["houseno"],
        lat: json["lat"] == null ? null : json["lat"],
        lng: json["lng"] == null ? null : json["lng"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
        "address": address == null ? null : address,
        "city": city == null ? null : city,
        "pincode": pincode == null ? null : pincode,
        "country": country == null ? null : country,
        "houseno": houseno == null ? null : houseno,
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
        "created_date": createdDate == null ? null : createdDate.toIso8601String(),
    };
}

enum DeliveryCurdMode{
  add,
  edit
}