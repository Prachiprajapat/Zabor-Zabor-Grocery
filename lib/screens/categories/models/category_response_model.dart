class CategoryResponseModel {
    bool status;
    String msg;
    List<CategoryModel> data;

    CategoryResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory CategoryResponseModel.fromJson(Map<String, dynamic> json) => CategoryResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : List<CategoryModel>.from(json["data"].map((x) => CategoryModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CategoryModel {
    int id;
    String name;
    String catimg;

    CategoryModel({
        this.id,
        this.name,
        this.catimg,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        catimg: json["catimg"] == null ? null : json["catimg"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "catimg": catimg == null ? null : catimg,
    };
}