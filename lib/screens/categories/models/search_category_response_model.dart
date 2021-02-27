import 'category_response_model.dart';

class SearchCategoryResponseModel {
    bool status;
    String msg;
    SearchCategoryModel data;

    SearchCategoryResponseModel({
        this.status,
        this.msg,
        this.data,
    });

    factory SearchCategoryResponseModel.fromJson(Map<String, dynamic> json) => SearchCategoryResponseModel(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : SearchCategoryModel.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
    };
}

class SearchCategoryModel {
    List<CategoryModel> category;

    SearchCategoryModel({
        this.category,
    });

    factory SearchCategoryModel.fromJson(Map<String, dynamic> json) => SearchCategoryModel(
        category: json["category"] == null ? null : List<CategoryModel>.from(json["category"].map((x) => CategoryModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "category": category == null ? null : List<dynamic>.from(category.map((x) => x.toJson())),
    };
}
