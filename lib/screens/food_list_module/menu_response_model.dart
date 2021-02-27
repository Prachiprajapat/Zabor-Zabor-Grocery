class MenulResponseModel {
  bool status;
  String msg;
  List<ItemHeader> data;
  List<Customization> customizations;
  List<dynamic> gallery;
  Taxes taxes;

  MenulResponseModel({
    this.status,
    this.msg,
    this.data,
    this.customizations,
    this.gallery,
    this.taxes,
  });

  factory MenulResponseModel.fromJson(Map<String, dynamic> json) =>
      MenulResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: List<ItemHeader>.from(
            json["data"].map((x) => ItemHeader.fromJson(x))),
        customizations: List<Customization>.from(
            json["customizations"].map((x) => Customization.fromJson(x))),
        gallery: List<dynamic>.from(json["gallery"].map((x) => x)),
        taxes: Taxes.fromJson(json["taxes"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "customizations":
            List<dynamic>.from(customizations.map((x) => x.toJson())),
        "gallery": List<dynamic>.from(gallery.map((x) => x)),
        "taxes": taxes.toJson(),
      };
}

class Customization {
  String name;
  int cusid;
  List<CustomizationItem> items;

  Customization({
    this.name,
    this.cusid,
    this.items,
  });

  factory Customization.fromJson(Map<String, dynamic> json) => Customization(
        name: json["name"],
        cusid: json["cusid"],
        items: List<CustomizationItem>.from(
            json["items"].map((x) => CustomizationItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cusid": cusid,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class CustomizationItem {
  String optionName;
  dynamic optionPrice;
  int ciId;

  CustomizationItem({
    this.optionName,
    this.optionPrice,
    this.ciId,
  });

  factory CustomizationItem.fromJson(Map<String, dynamic> json) =>
      CustomizationItem(
        optionName: json["option_name"],
        optionPrice: json["option_price"],
        ciId: json["ci_id"],
      );

  Map<String, dynamic> toJson() => {
        "option_name": optionName,
        "option_price": optionPrice,
        "ci_id": ciId,
      };
}

class ItemHeader {
  String name;
  int groupid;
  String groupPic;
  List<MenuItem> items;

  ItemHeader({
    this.name,
    this.groupid,
    this.groupPic,
    this.items,
  });

  factory ItemHeader.fromJson(Map<String, dynamic> json) => ItemHeader(
        name: json["name"],
        groupid: json["groupid"],
        groupPic: json["groupPic"],
        items: List<MenuItem>.from(json["items"].map((x) => MenuItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "groupid": groupid,
        "groupPic": groupPic,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class MenuItem {
  int itemId;
  String itemName;
  String itemCat;
  dynamic itemPrice;
  dynamic sp;
  String customizations;
  String taxtype;
  dynamic itemQuantity;
  String itemPic;
  String itemDes;
  dynamic cityTax;
  dynamic stateTax;
  dynamic customQunatity;
  int min_qty;
  dynamic is_stamp;
  bool is_fav;

  MenuItem(
      {this.itemId,
      this.itemName,
      this.itemCat,
      this.itemPrice,
      this.sp,
      this.customizations,
      this.taxtype,
      this.itemQuantity,
      this.itemPic,
      this.is_stamp,
      this.itemDes,
      this.cityTax,
      this.stateTax,
      this.min_qty,
      this.customQunatity,
      this.is_fav
      });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        itemId: json["item_id"],
        itemName: json["item_name"],
        itemCat: json["item_cat"] == null ? null : json["item_cat"],
        itemPrice: json["item_price"],
        sp: json["sp"] == null ? null : json["sp"],
        customizations: json["customizations"],
        taxtype: json["taxtype"],
        itemQuantity: json["item_quantity"] == null ? null : json["item_quantity"],
        itemPic: json["item_pic"] == null ? null : json["item_pic"],
        is_stamp: json["is_stamp"] == null ? null : json["is_stamp"],
        itemDes: json["item_des"] == null ? null : json["item_des"],
        cityTax: json["city_tax"] == null ? null : json["city_tax"],
        stateTax: json["state_tax"] == null ? null : json["state_tax"],
        customQunatity: json["custom_qua"] == null ? null : json["custom_qua"],
        min_qty: json["min_qty"] == null ? null : json["min_qty"],
        is_fav: json["is_fav"] == null ? null : json["is_fav"],

      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "item_name": itemName,
        "item_cat": itemCat == null ? null : itemCat,
        "sp": sp == null ? null : sp,
        "item_price": itemPrice,
        "customizations": customizations,
        "taxtype": taxtype,
        "item_quantity": itemQuantity == null ? null : itemQuantity,
        "item_pic": itemPic == null ? null : itemPic,
        "is_stamp": is_stamp == null ? null : is_stamp,
        "item_des": itemDes == null ? null : itemDes,
        "city_tax": cityTax == null ? null : cityTax,
        "state_tax": stateTax == null ? null : stateTax,
        "custom_qua": customQunatity == null ? null : customQunatity,
        "min_qty":  min_qty == null ? null : min_qty,
        "is_fav":  is_fav == null ? null : is_fav,
      };
}

class Taxes {
  String foodTax;
  String drinkTax;
  String grandTax;
  String cityTax;
  String stateTax;

  Taxes({
    this.foodTax,
    this.drinkTax,
    this.grandTax,
    this.cityTax,
    this.stateTax,
  });

  factory Taxes.fromJson(Map<String, dynamic> json) => Taxes(
        foodTax: json["food_tax"],
        drinkTax: json["drink_tax"],
        cityTax: json["city_tax"] == null ? null : json["city_tax"],
        stateTax: json["state_tax"] == null ? null : json["state_tax"],
        grandTax: json["grand_tax"],
      );

  Map<String, dynamic> toJson() => {
        "food_tax": foodTax,
        "drink_tax": drinkTax,
        "grand_tax": grandTax,
        "city_tax": cityTax == null ? null : cityTax,
        "state_tax": stateTax == null ? null : stateTax,
      };
}

class Gallery {
  int id;
  int resId;
  String image;
  DateTime createdAt;

  Gallery({
    this.id,
    this.resId,
    this.image,
    this.createdAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        id: json["id"],
        resId: json["res_id"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "res_id": resId,
        "image": image,
        "created_at": createdAt.toIso8601String(),
      };
}

class MenuQtyModel {
  List<FoodGroup> foodGroup;
  MenuQtyModel({this.foodGroup});
}

class FoodGroup {
  int groupID;
  List<ItemQtyModel> itemQtyModel;
  FoodGroup({this.groupID, this.itemQtyModel});
}

class ItemQtyModel {
  int itemId;
  dynamic qty;
  ItemQtyModel({this.itemId, this.qty});
}
