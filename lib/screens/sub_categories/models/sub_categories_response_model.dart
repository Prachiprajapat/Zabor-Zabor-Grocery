class SubCategoryResponseModel {
    bool status;
    String msg;
    List<SubCategoryModel> data;

    SubCategoryResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory SubCategoryResponseModel.fromJson(Map<String, dynamic> json) => SubCategoryResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<SubCategoryModel>.from(json["data"].map((x) => SubCategoryModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class SubCategoryModel {
    int id;
    String name;
    dynamic catimg;

    SubCategoryModel({
        this.id,
        this.name,
        this.catimg,
    });

    factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        catimg: json["catimg"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "catimg": catimg,
    };
}
