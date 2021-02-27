import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/food_list_module/menu_response_model.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';
// import 'package:http/http.dart' as http;

import 'cart_model.dart';
import 'food_list_provider.dart';

class FoodListScreen extends StatefulWidget {
  final String restName;
  final int restId;
  const FoodListScreen(
      {Key key, @required this.restName, @required this.restId})
      : super(key: key);
  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  bool _isLoading = false;
  List<ItemHeader> _itemHeaders = [];
  List<ItemHeader> _itemHeadersFull = [];
  List<Customization> _customizations = [];
  Set<String> _itemCats = Set<String>();
  MenuQtyModel _menuQtyModel;
  List<Cart> _arrCartItem = [];
  List<CartCustomization> _arrCartCustomization = [];
  FoodListProvider foodListprovider;
  MenulResponseModel _menulResponseModel;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double totalPrice = 0.0;
  String headerImageUrl = null;

  @override
  void initState() {
    super.initState();
    _menuQtyModel = MenuQtyModel();
    callMenuApi();
  }

  @override
  void dispose() {
    super.dispose();
    foodListprovider.cartModel = CartModel();
    foodListprovider.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    foodListprovider = Provider.of<FoodListProvider>(context, listen: false);
    foodListprovider.cartModel.resId = widget.restId;
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body:
          _isLoading ? Center(child: CircularProgressIndicator()) : buildBody(),
    );
  }

  Padding buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          buildCategoryContainer(),
          // headerImageUrl != null ? Container(
          //   height: 40,
          //   child: CachedNetworkImage(
          //       imageUrl: baseUrl + headerImageUrl,
          //       imageBuilder: (context, imageProvider) =>
          //           Container(
          //             width: double.infinity,
          //             height: MediaQuery.of(context).size.width / 3,
          //             decoration: BoxDecoration(
          //               image: DecorationImage(
          //                 image: imageProvider,
          //                 fit: BoxFit.contain,
          //               ),
          //             ),
          //           ),
          //       placeholder: (context, url) => Container(
          //           width: double.infinity,
          //           height: MediaQuery.of(context).size.width / 10,
          //           child: Center(
          //               child: CircularProgressIndicator())),
          //       errorWidget: (context, url, error) =>
          //           Container()),
          // ) : Container(),
          // SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors().kGreyColor100,
                    border: Border.all(color: AppColors().kGreyColor200, width: 1),
                    borderRadius: BorderRadius.circular(40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        // GestureDetector(
                        //   child: Image.asset('assets/images/gps.png'),
                        //   onTap: () {},
                        // ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Container(
                      child: Expanded(
                          child: TextField(
                        onChanged: (text) {
                          searchViaGroup(text);
                        },
                        onSubmitted: (text) {
                          searchViaGroup(text);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context).translate('Search here...')),
                      )),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      color: AppColors().kPrimaryColor,
                      onPressed: () {
                        //       Navigator.push(
                        // context,
                        // MaterialPageRoute(
                        //     builder: (context) => RestaurantListScreen(
                        //           query: string,
                        //           restaurantListEntryPoint:
                        //               RestaurantListEntryPoint.resSearch,
                        //         )));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: getHeaders()),
            ),
          ),
          Consumer<FoodListProvider>(
            builder: (context, flp, child) => flp.isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : ButtonWidget(
                    title: AppLocalizations.of(context).translate('VIEW BASKET'),
                    onPressed: () {
                      _addToCartPressed();
                    },
                  ),

          ),
        ],
      ),
    );
  }

  double calculateTotalItemPrice() {
    double price = 0.0;
    for (int i = 0; i < _arrCartItem.length; i++) {
      price += (_arrCartItem[i].itemPrice * _arrCartItem[i].quantity);
    }
    return price;
  }

  Container buildCategoryContainer() {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _itemHeadersFull.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    sortViaGroup(index);
                    //sortViaCategory(_itemCats.toList()[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppColors().kPrimaryColor,
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Text(_itemHeadersFull[index].name.toString(),
                              style: TextStyle(color: AppColors().kWhiteColor)),
                        )),
                  ),
                )));
  }

  _addToCartPressed() async {
    User userModel = await AppUtils.getUser();

    if (foodListprovider.cartModel.cart == null ||
        foodListprovider.cartModel.cart.length == 0) return;

    if (userModel == null || userModel.id == null) {
      // foodListprovider.cartModel.userId = -1;
      // foodListprovider.cartModel.tax =
      //     double.parse(_menulResponseModel.taxes.grandTax);
      // foodListprovider.callAddToCartApi(_scaffoldKey, context, true);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginSignupScreen()));
    } else {
      foodListprovider.cartModel.userId = userModel.id;
      foodListprovider.cartModel.appendTax = double.parse(_menulResponseModel.taxes.grandTax);
      foodListprovider.callAddToCartApi(_scaffoldKey, context, false);
    }
  }

  List<Widget> getHeaders() {
    List<Widget> arr = [];
    for (int i = 0; i < _itemCats.length; i++) {
      arr.add(buildItemHeader(i));
    }
    return arr;
  }

  List<Widget> getCustomizationHeaders(
      List<Customization> customizations, int itemId) {
    List<Widget> arr = [];
    for (int i = 0; i < customizations.length; i++) {
      arr.add(buildCustomizationHeader(i, customizations, itemId));
    }
    return arr;
  }

  List<Widget> getItems(int index) {
    List<Widget> arr = [];
    for (int i = 0; i < _itemHeaders[index].items.length; i++) {
      arr.add(buildFoodItemRow(index, i));
    }
    return arr;
  }

  List<Widget> getCustomizationItems(
      int index, List<Customization> customizations, int itemId) {
    List<Widget> arr = [];
    for (int i = 0; i < customizations[index].items.length; i++) {
      arr.add(buildCustomizationItem(index, i, customizations, itemId));
    }
    return arr;
  }

  Widget buildItemHeader(int index) {
    return ExpansionTile(
      title: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  _itemCats.toList()[index].toString(),
                  //_itemHeaders[index].name,
                  style: TextStyle(
                      color: AppColors().kBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '',
                style: TextStyle(
                  color: AppColors().kGrey,
                  fontSize: 16,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 0.4,
            children: new List<Widget>.generate(
                _itemHeaders[index].items.length, (ind) {
              return buildFoodItemRow(index, ind);
            }),
          ),
        ),
        // Container(
        //   height: MediaQuery.of(context).size.height * 0.6,
        //   child: ListView.builder(
        //       itemCount: _itemHeaders[index].items.length,
        //       itemBuilder: (context, i) => _buildShopItem(index, i)),
        // )
        //Column(children: getItems(index))
      ],
    );
  }

  Widget buildCustomizationHeader(
      int index, List<Customization> customizations, int itemId) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            customizations[index].name,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 10),
        Column(children: getCustomizationItems(index, customizations, itemId))
      ],
    );
  }

  Widget buildCustomizationItem(int outerIndex, int innerIndex,
      List<Customization> customizations, int itemId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<FoodListProvider>(
        builder: (context, flistProvider, child) => ListTile(
            leading: Image.asset(
              flistProvider.isCustomizationExists(itemId,
                      _customizations[outerIndex].items[innerIndex].ciId)
                  ? 'assets/images/3.0x/check.png'
                  : 'assets/images/3.0x/uncheck.png',
              height: 22,
            ),
            title: new Text(
                customizations[outerIndex].items[innerIndex].optionName),
            trailing: Text(
                '\$${customizations[outerIndex].items[innerIndex].optionPrice}'),
            onTap: () => {
                  flistProvider.isCustomizationExists(itemId,
                          _customizations[outerIndex].items[innerIndex].ciId)
                      ? removeCartCustomization(outerIndex, innerIndex, itemId)
                      : addItemToCartCustomizationArray(
                          outerIndex, innerIndex, itemId)
                }),
      ),
    );
  }

  Widget buildFoodItemRow(int outerIndex, int innerIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _itemHeaders[outerIndex].items[innerIndex].sp == null
              ? Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Row(children: <Widget>[
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => ImageDialog(
                                      imgUrl: baseUrl + (_itemHeaders[outerIndex].items[innerIndex].itemPic == null ? "" : _itemHeaders[outerIndex].items[innerIndex].itemPic),
                                      name: _itemHeaders[outerIndex].items[innerIndex].itemName ?? "",
                                      description: _itemHeaders[outerIndex].items[innerIndex].itemDes ?? ""));
                            },
                            child:
                              CachedNetworkImage(
                                imageUrl: baseUrl + (_itemHeaders[outerIndex].items[innerIndex].itemPic == null ? "" : _itemHeaders[outerIndex].items[innerIndex].itemPic),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      child: (
                                          Container(
                                              width: 10,
                                              height: 10,
                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _itemHeaders[outerIndex].items[innerIndex].is_stamp
                                                        ? (Image.asset('assets/images/foodstamp.png', width: 30, height: 30)) :
                                                    Container()
                                                  ]
                                              )
                                          )
                                      )
                                    ),
                                placeholder: (context, url) => Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.width / 3,
                                    child: Center(child: CircularProgressIndicator())),
                                errorWidget: (context, url, error) =>
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.width / 3,
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage('assets/images/dish_placeholder.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      child: (
                                        Container(
                                          width: 10,
                                          height: 10,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _itemHeaders[outerIndex].items[innerIndex].is_stamp
                                                  ? (Image.asset('assets/images/foodstamp.png', width: 30, height: 30)) : Container()
                                            ]
                                          )
                                        )
                                      )
                                    )
                            ),

                          ),
                          Text(
                              _itemHeaders[outerIndex].items[innerIndex].itemName ?? "",
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              maxLines: 2),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container()
                    // Container(
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(4.0),
                    //       child: Text(
                    //         'Stock Out',
                    //         style: TextStyle(fontSize: 11),
                    //       ),
                    //     ),
                    //     color: AppColors().kYellowColor),
                  ]),
                )
              : Banner(
                  message: 'Special',
                  location: BannerLocation.topEnd,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Row(children: <Widget>[
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => ImageDialog(
                                        imgUrl: baseUrl + (_itemHeaders[outerIndex].items[innerIndex].itemPic == null ? "" : _itemHeaders[outerIndex].items[innerIndex].itemPic),
                                        name: _itemHeaders[outerIndex].items[innerIndex].itemName ?? "",
                                        description: _itemHeaders[outerIndex].items[innerIndex].itemDes ?? ""));
                              },
                              child: CachedNetworkImage(
                                  imageUrl: baseUrl +
                                      (_itemHeaders[outerIndex]
                                                  .items[innerIndex]
                                                  .itemPic == null ? "" : _itemHeaders[outerIndex].items[innerIndex].itemPic),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.width / 3,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) => Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.width / 3,
                                      child: Center(
                                          child: CircularProgressIndicator())),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        'assets/images/dish_placeholder.png',
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.width / 3,
                                        fit: BoxFit.contain,
                                      )),

                            ),
                            Text(
                                _itemHeaders[outerIndex]
                                        .items[innerIndex]
                                        .itemName ??
                                    "",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                                maxLines: 2),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Container()
                      // Container(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(4.0),
                      //       child: Text(
                      //         'Stock Out',
                      //         style: TextStyle(fontSize: 11),
                      //       ),
                      //     ),
                      //     color: AppColors().kYellowColor),
                    ]),
                  ),
                ),
          RichText(
            text: new TextSpan(
              text: '',
              children: <TextSpan>[
                new TextSpan(
                  text: _itemHeaders[outerIndex].items[innerIndex].sp == null
                      ? ''
                      : '\$${double.parse(_itemHeaders[outerIndex].items[innerIndex].itemPrice.toString()).toStringAsFixed(2) ?? 0.0}',
                  style: new TextStyle(
                    color: AppColors().redkGrey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                new TextSpan(
                  text: _itemHeaders[outerIndex].items[innerIndex].sp == null
                      ? '\$${double.parse(_itemHeaders[outerIndex].items[innerIndex].itemPrice.toString()).toStringAsFixed(2) ?? 0.0}'
                      : ' \$${double.parse(_itemHeaders[outerIndex].items[innerIndex].sp.toString()).toStringAsFixed(2) ?? 0.0}',
                  style: new TextStyle(
                      color: AppColors().kBlackColor, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text((_itemHeaders[outerIndex].items[innerIndex].itemQuantity ==
                //             null ||
                //         int.parse((_itemHeaders[outerIndex]
                //                             .items[innerIndex]
                //                             .itemQuantity ==
                //                         "null" ||
                //                     _itemHeaders[outerIndex]
                //                             .items[innerIndex]
                //                             .itemQuantity ==
                //                         "")
                //                 ? "0"
                //                 : _itemHeaders[outerIndex]
                //                     .items[innerIndex]
                //                     .itemQuantity
                //                     .toString()) ==
                //             0)
                //     ? 'Out of Stock'
                //     : '${_itemHeaders[outerIndex].items[innerIndex].itemQuantity} in Stock'),
                InkWell(
                  onTap: () {
                    List<String> arrIntCustomization = _itemHeaders[outerIndex].items[innerIndex].customizations.toString().split(',').toList();
                    List<Customization> arrItemCustomization = [];
                    for (int i = 0; i < _customizations.length; i++) {
                      for (int j = 0; j < arrIntCustomization.length; j++)
                        if ("${_customizations[i].cusid}" == arrIntCustomization[j]) {
                          arrItemCustomization.add(_customizations[i]);
                        }
                    }
                    _settingModalBottomSheet(context, outerIndex, innerIndex, arrItemCustomization, getCustomizationHeaders(arrItemCustomization, _itemHeaders[outerIndex].items[innerIndex].itemId));
                  },
                  child: Text(
                    (_itemHeaders[outerIndex].items[innerIndex].customizations == null ||
                            _itemHeaders[outerIndex].items[innerIndex].customizations == "null" ||
                            _itemHeaders[outerIndex].items[innerIndex].customizations == "")
                        ? 'test'
                        : 'Customizable',
                    style: TextStyle(
                      color: AppColors().kGrey,
                      fontSize: 11,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  child: Column(
                    children: <Widget>[
                      IconButton (
                        icon:  Icon(_itemHeaders[outerIndex].items[innerIndex].is_fav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.lightBlue,
                          size: 30,
                        ),
                        color: Colors.lightBlue,
                        iconSize: 30,
                        onPressed: () => {
                          this.toggleFavorite(_itemHeaders[outerIndex].items[innerIndex])
                        }
                      )
                    ]
                  )
                ),
                SizedBox(height: 10),
                buildIncDecrContainer(outerIndex, innerIndex)
              ]),
        ],
      ),
    );
  }

  FlatButton buildIncDecrContainer(int outerIndex, int innerIndex) {
    return FlatButton (
      color: Colors.white,
      onPressed: () {
        print("add");
        setState(() {
          // _itemHeaders[outerIndex].items[innerIndex].customQunatity = 1;
          addItemToCartArray(
              outerIndex,
              innerIndex,
              _itemHeaders[outerIndex].items[innerIndex].min_qty,
              _arrCartItem.length + 1,
              _itemHeaders[outerIndex].items[innerIndex].is_stamp,
          );
          totalPrice = calculateTotalItemPrice();

          // if (_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty == 1) {
          //   if (_itemHeaders[outerIndex].items[innerIndex].customizations == null
          //       || _itemHeaders[outerIndex].items[innerIndex].customizations == "null"
          //       || _itemHeaders[outerIndex].items[innerIndex].customizations == "") return;
          //   if (_itemHeaders[outerIndex].items[innerIndex].customizations != null
          //       || _itemHeaders[outerIndex].items[innerIndex].customizations != "null") {
          //     List<String> arrIntCustomization = _itemHeaders[outerIndex].items[innerIndex].customizations.toString().split(',').toList();
          //     List<Customization> arrItemCustomization = [];
          //     for (int i = 0; i < _customizations.length; i++) {
          //       for (int j = 0; j < arrIntCustomization.length; j++)
          //         if ("${_customizations[i].cusid}" == arrIntCustomization[j]) {
          //           arrItemCustomization.add(_customizations[i]);
          //         }
          //     }
          //     _settingModalBottomSheet(
          //         context,
          //         outerIndex,
          //         innerIndex,
          //         arrItemCustomization,
          //         getCustomizationHeaders(arrItemCustomization, _itemHeaders[outerIndex].items[innerIndex].itemId));
          //   }
          // }
        });
      },
      child: Text(AppLocalizations.of(context).translate('Add + '),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //       color: AppColors().kWhiteColor,
    //       boxShadow: [
    //         BoxShadow(
    //             color: AppColors().kBlackColor38,
    //             blurRadius: 5,
    //             spreadRadius: 0.2),
    //       ],
    //       borderRadius: BorderRadius.circular(5)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(4.0),
    //     child:ButtonWidget(
    //       title:
    //       AppLocalizations.of(context).translate('Add + '),
    //       onPressed: () {
    //         print("add");
    //       },
    //     ),
    //     child: GestureDetector(
    //       onTap: () {
    //         print("add");
    //         setState(() {
    //           // _itemHeaders[outerIndex].items[innerIndex].customQunatity = 1;
    //           addItemToCartArray(
    //             outerIndex,
    //             innerIndex,
    //             _itemHeaders[outerIndex].items[innerIndex].min_qty,
    //             _arrCartItem.length + 1);
    //           totalPrice = calculateTotalItemPrice();
    //
    //           // if (_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty == 1) {
    //           //   if (_itemHeaders[outerIndex].items[innerIndex].customizations == null
    //           //       || _itemHeaders[outerIndex].items[innerIndex].customizations == "null"
    //           //       || _itemHeaders[outerIndex].items[innerIndex].customizations == "") return;
    //           //   if (_itemHeaders[outerIndex].items[innerIndex].customizations != null
    //           //       || _itemHeaders[outerIndex].items[innerIndex].customizations != "null") {
    //           //     List<String> arrIntCustomization = _itemHeaders[outerIndex].items[innerIndex].customizations.toString().split(',').toList();
    //           //     List<Customization> arrItemCustomization = [];
    //           //     for (int i = 0; i < _customizations.length; i++) {
    //           //       for (int j = 0; j < arrIntCustomization.length; j++)
    //           //         if ("${_customizations[i].cusid}" == arrIntCustomization[j]) {
    //           //           arrItemCustomization.add(_customizations[i]);
    //           //         }
    //           //     }
    //           //     _settingModalBottomSheet(
    //           //         context,
    //           //         outerIndex,
    //           //         innerIndex,
    //           //         arrItemCustomization,
    //           //         getCustomizationHeaders(arrItemCustomization, _itemHeaders[outerIndex].items[innerIndex].itemId));
    //           //   }
    //           // }
    //         });
    //       },
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Text(
    //             // '${_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty}',
    //             'Add',
    //             style: TextStyle(fontSize: 16),
    //           ),
    //           InkWell(
    //               child: Icon(
    //                 Icons.add,
    //                 size: 20,
    //               ),
    //               onTap: () {
    //
    //               })
    //           // InkWell(
    //           //     child: Icon(
    //           //       Icons.remove,
    //           //       size: 20,
    //           //     ),
    //           //     onTap: () {
    //           //       print("minus");
    //           //       setState(() {
    //           //         if (_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty == 0) {
    //           //           totalPrice = calculateTotalItemPrice();
    //           //           return;
    //           //         }
    //           //
    //           //         if (_itemHeaders[outerIndex].items[innerIndex].customQunatity == 1) {
    //           //           if (_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty == 1) {
    //           //             _menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty -= 1;
    //           //           } else {
    //           //             _menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty -= 0.25;
    //           //           }
    //           //         } else {
    //           //           _menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty -= 1;
    //           //         }
    //           //
    //           //         removeCartItemFromArray(_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].itemId);
    //           //         totalPrice = calculateTotalItemPrice();
    //           //       });
    //           //     }),
    //           // SizedBox(
    //           //   width: 8,
    //           // ),
    //           // Text(
    //           //   '${_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty}',
    //           //   style: TextStyle(fontSize: 16),
    //           // ),
    //           // SizedBox(
    //           //   width: 8,
    //           // ),
    //           // InkWell(
    //           //     child: Icon(
    //           //       Icons.add,
    //           //       size: 20,
    //           //     ),
    //           //     onTap: () {
    //           //       print("plus");
    //           //       setState(() {
    //           //         if (_itemHeaders[outerIndex].items[innerIndex].customQunatity == 1) {
    //           //           if (_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty == 0) {
    //           //             _menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty += 1;
    //           //           } else {
    //           //             _menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty += 0.25;
    //           //           }
    //           //         } else {
    //           //           _menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty += 1;
    //           //         }
    //           //
    //           //         addItemToCartArray(
    //           //             outerIndex,
    //           //             innerIndex,
    //           //             _menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty,
    //           //             _menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].itemId);
    //           //
    //           //         totalPrice = calculateTotalItemPrice();
    //           //         if (_menuQtyModel.foodGroup[outerIndex].itemQtyModel[innerIndex].qty == 1) {
    //           //           if (_itemHeaders[outerIndex].items[innerIndex].customizations == null
    //           //               || _itemHeaders[outerIndex].items[innerIndex].customizations == "null"
    //           //               || _itemHeaders[outerIndex].items[innerIndex].customizations == "") return;
    //           //           if (_itemHeaders[outerIndex].items[innerIndex].customizations != null
    //           //               || _itemHeaders[outerIndex].items[innerIndex].customizations != "null") {
    //           //             List<String> arrIntCustomization = _itemHeaders[outerIndex].items[innerIndex].customizations.toString().split(',').toList();
    //           //             List<Customization> arrItemCustomization = [];
    //           //             for (int i = 0; i < _customizations.length; i++) {
    //           //               for (int j = 0; j < arrIntCustomization.length; j++)
    //           //                 if ("${_customizations[i].cusid}" == arrIntCustomization[j]) {
    //           //                   arrItemCustomization.add(_customizations[i]);
    //           //                 }
    //           //             }
    //           //             _settingModalBottomSheet(
    //           //                 context,
    //           //                 outerIndex,
    //           //                 innerIndex,
    //           //                 arrItemCustomization,
    //           //                 getCustomizationHeaders(arrItemCustomization, _itemHeaders[outerIndex].items[innerIndex].itemId));
    //           //           }
    //           //         }
    //           //       });
    //           //     })
    //         ],
    //       ),
    //     )
    //   ),
    // );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.restName,
      ),
      backgroundColor: AppColors().kWhiteColor,
      iconTheme: IconThemeData(color: AppColors().kBlackColor),
      textTheme: TextTheme(
          title: TextStyle(
              color: AppColors().kBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w600)),
      actions: [
        Icon(Icons.shopping_cart),
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('\$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  color: AppColors().kBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
        ))
      ],
    );
  }

  Future<void> callMenuApi() async {
    setState(() {
      _isLoading = true;
    });

    User user = await AppUtils.getUser();

    if (user == null || user.id == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginSignupScreen()));
    } else {
      ApiResponse<MenulResponseModel> apiResponse = await K3Webservice.postMethod<MenulResponseModel>(apisToUrls(Apis.menu), {"res_id": "${widget.restId}", "user_id": "${user.id}"}, null);
      setState(() {
        _isLoading = false;
      });
      if (apiResponse.error) {
        showSnackBar(_scaffoldKey, apiResponse.message, null);
      } else {
        // setState(() {
        _menulResponseModel = apiResponse.data;
        print('_menulResponseModel');
        print(jsonEncode(_menulResponseModel).toString());
        _itemHeaders = apiResponse.data.data;
        if (_itemHeaders == null || _itemHeaders.isEmpty) return;
        _itemHeadersFull = apiResponse.data.data;
        _itemCats = Set<String>();
        _itemCats.add('All');
        _customizations = apiResponse.data.customizations;
        for (int i = 0; i < _customizations.length; i++) {
          List<CheckUncheckCustomizationInnerModel>
          checkUncheckCustomizationInnerModel = [];
          for (int j = 0; j < _customizations[i].items.length; j++) {
            checkUncheckCustomizationInnerModel
                .add(CheckUncheckCustomizationInnerModel(isExits: false));
          }
          foodListprovider.addData(CheckUncheckCustomizationOuterModel(
              id: _customizations[i].cusid,
              checkUncheckCustomizationInnerModel:
              checkUncheckCustomizationInnerModel));
        }
        List<FoodGroup> arrFoodGroup = [];
        for (int i = 0; i < _itemHeaders.length; i++) {
          List<ItemQtyModel> arrItemQtyModel = [];
          for (int j = 0; j < _itemHeaders[i].items.length; j++) {
            arrItemQtyModel.add(
                ItemQtyModel(itemId: _itemHeaders[i].items[j].itemId, qty: 0));
            _itemCats.add(_itemHeaders[i].items[j].itemCat.toString());
          }
          arrFoodGroup.add(FoodGroup(
              groupID: _itemHeaders[i].groupid, itemQtyModel: arrItemQtyModel));
        }
        print(_itemCats);
        _menuQtyModel.foodGroup = arrFoodGroup;
        if (_itemHeadersFull.isNotEmpty) sortViaGroup(0);
        // });
      }
    }
  }

  void _settingModalBottomSheet(context, int outerIndex, int innerIndex,
      List<Customization> customizations, List<Widget> widgets) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors().kPrimaryColor,
                    child: Center(
                        child: Text(
                      _itemHeaders[outerIndex].items[innerIndex].itemName ?? "",
                      style: TextStyle(fontSize: 20),
                    ))),
                Column(children: widgets),
              ],
            ),
          );
        });
  }

  addItemToCartArray(
      int outerIndex, int innerIndex, int quantity, int itemId, bool isStamp) {
    for (int i = 0; i < _arrCartItem.length; i++) {
      if (_arrCartItem[i].itemId == itemId) {
        _arrCartItem[i].quantity = quantity;
        return;
      }
    }

    if (_itemHeaders[outerIndex]
            .items[innerIndex]
            .is_stamp
            .toString()
            .toLowerCase() == "true") {
      _itemHeaders[outerIndex].items[innerIndex].cityTax = 0;
      _itemHeaders[outerIndex].items[innerIndex].stateTax = 0;
    }

    _arrCartItem.add(Cart(
      itemId: _itemHeaders[outerIndex].items[innerIndex].itemId,
      // itemId: _itemHeaders[outerIndex].items[innerIndex].itemId,
      itemName: _itemHeaders[outerIndex].items[innerIndex].itemName,
      itemPrice: _itemHeaders[outerIndex].items[innerIndex].sp == null
          ? double.parse(_itemHeaders[outerIndex].items[innerIndex].itemPrice.toString())
          : double.parse(_itemHeaders[outerIndex].items[innerIndex].sp.toString()),
      sp: _itemHeaders[outerIndex].items[innerIndex].sp == null
          ? null
          : double.parse(_itemHeaders[outerIndex].items[innerIndex].sp.toString()),
      quantity: quantity,
      taxtype: _itemHeaders[outerIndex].items[innerIndex].taxtype,
      cityTax: _itemHeaders[outerIndex].items[innerIndex].cityTax,
      stateTax: _itemHeaders[outerIndex].items[innerIndex].stateTax,
      customQunatity: _itemHeaders[outerIndex].items[innerIndex].customQunatity,
      taxvalue: 0.0,
      min_qty: quantity,
      citytaxvalue: _itemHeaders[outerIndex].items[innerIndex].cityTax == 1 ? double.parse(_menulResponseModel.taxes.cityTax) : double.parse("0.0"),
      statetaxvalue: _itemHeaders[outerIndex].items[innerIndex].stateTax == 1 ? double.parse(_menulResponseModel.taxes.stateTax) : double.parse("0.0"),
      is_stamp: isStamp
    ));
    foodListprovider.cartModel.cart = _arrCartItem;
  }

  addItemToCartCustomizationArray(int outerIndex, int innerIndex, int itemId) {
    if (foodListprovider.cartModel.cart == null) return;
    for (int i = 0; i < foodListprovider.cartModel.cart.length; i++) {
      if (foodListprovider.cartModel.cart[i].itemId == itemId) {
        _arrCartCustomization.add(CartCustomization(
            optionId: _customizations[outerIndex].items[innerIndex].ciId,
            optionName:
                _customizations[outerIndex].items[innerIndex].optionName,
            optionPrice:
                _customizations[outerIndex].items[innerIndex].optionPrice));
        if (foodListprovider.cartModel.cart[i].customization == null) {
          foodListprovider.cartModel.cart[i].customization = [
            CartCustomization(
                optionId: _customizations[outerIndex].items[innerIndex].ciId,
                optionName:
                    _customizations[outerIndex].items[innerIndex].optionName,
                optionPrice:
                    _customizations[outerIndex].items[innerIndex].optionPrice)
          ];
        } else {
          foodListprovider.cartModel.cart[i].customization.add(
              CartCustomization(
                  optionId: _customizations[outerIndex].items[innerIndex].ciId,
                  optionName: _customizations[outerIndex].items[innerIndex].optionName,
                  optionPrice: _customizations[outerIndex].items[innerIndex].optionPrice));
        }

        foodListprovider.addItemToCartCustomizationArray(outerIndex, innerIndex);
      }
    }
  }

  removeCartCustomization(int outerIndex, int innerIndex, int itemId) {
    for (int i = 0; i < foodListprovider.cartModel.cart.length; i++) {
      if (foodListprovider.cartModel.cart[i].itemId == itemId) {
        for (int j = 0;
            j < foodListprovider.cartModel.cart[i].customization.length;
            j++) {
          if (foodListprovider.cartModel.cart[i].customization[j].optionId ==
              _customizations[outerIndex].items[innerIndex].ciId) {
            _arrCartCustomization.removeAt(j);
            foodListprovider.cartModel.cart[i].customization.removeAt(j);
            foodListprovider.removeCartCustomization(outerIndex, innerIndex);
          }
        }
      }
    }
  }

  bool isCartCustomizationExist(int outerIndex, int innerIndex) {
    for (int i = 0; i < _arrCartCustomization.length; i++) {
      if (_arrCartCustomization[i].optionId ==
          _customizations[outerIndex].items[innerIndex].ciId) {
        return true;
      }
    }
    return false;
  }

  // removeCartItemFromArray(int itemId) {
  //   for (int i = 0; i < _arrCartItem.length; i++) {
  //     if (_arrCartItem[i].itemId == itemId) {
  //       if (_arrCartItem[i].quantity == 1) {
  //         _arrCartItem.removeAt(i);
  //         foodListprovider.cartModel.cart = _arrCartItem;
  //       } else {
  //         if (_arrCartItem[i].customQunatity == 1) {
  //           _arrCartItem[i].quantity -= 0.25;
  //         } else {
  //           _arrCartItem[i].quantity -= 1;
  //         }
  //
  //         foodListprovider.cartModel.cart = _arrCartItem;
  //       }
  //     }
  //   }
  // }

  Widget _buildShopItem(int outerIndex, int innerIndex) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      margin: EdgeInsets.only(bottom: 20.0),
      //height: 500,
      child: Row(
        children: <Widget>[
          Expanded(
              child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0)
                  ]),
            ),
            imageUrl:
                baseUrl + _itemHeaders[outerIndex].items[innerIndex].itemPic ??
                    "",
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0)
                    ]),
                child: Center(child: CircularProgressIndicator())),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0)
                  ]),
              child: Image.asset(
                'assets/images/dish_placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
          )),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _itemHeaders[outerIndex].items[innerIndex].itemName ?? "",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('',
                      style: TextStyle(color: Colors.grey, fontSize: 18.0)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                      '\$${_itemHeaders[outerIndex].items[innerIndex].itemPrice ?? 0.0}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30.0,
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('',
                      style: TextStyle(
                          fontSize: 18.0, color: Colors.grey, height: 1.5)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            List<String> arrIntCustomization =
                                _itemHeaders[outerIndex]
                                    .items[innerIndex]
                                    .customizations
                                    .toString()
                                    .split(',')
                                    .toList();
                            List<Customization> arrItemCustomization = [];
                            for (int i = 0; i < _customizations.length; i++) {
                              for (int j = 0;
                                  j < arrIntCustomization.length;
                                  j++)
                                if ("${_customizations[i].cusid}" ==
                                    arrIntCustomization[j]) {
                                  arrItemCustomization.add(_customizations[i]);
                                }
                            }
                            _settingModalBottomSheet(
                                context,
                                outerIndex,
                                innerIndex,
                                arrItemCustomization,
                                getCustomizationHeaders(
                                    arrItemCustomization,
                                    _itemHeaders[outerIndex]
                                        .items[innerIndex]
                                        .itemId));
                          },
                          child: Text(
                            (_itemHeaders[outerIndex]
                                            .items[innerIndex]
                                            .customizations ==
                                        null ||
                                    _itemHeaders[outerIndex]
                                            .items[innerIndex]
                                            .customizations ==
                                        "null" ||
                                    _itemHeaders[outerIndex]
                                            .items[innerIndex]
                                            .customizations ==
                                        "")
                                ? ''
                                : 'Customizable',
                            style: TextStyle(
                              color: AppColors().kGrey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        buildIncDecrContainer(outerIndex, innerIndex)
                      ])
                ],
              ),
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0)
                  ]),
            ),
          )
        ],
      ),
    );
  }

  searchViaGroup(String value) {
    if (value == '') {
      sortViaGroup(0);
      return;
    }
    _itemCats = Set<String>();

    for (int index = 0; index < _itemHeadersFull.length; index++) {
      for (int i = 0; i < _itemHeadersFull[index].items.length; i++) {
        if (_itemHeadersFull[index].items[i].itemCat != null) {
          if (_itemHeadersFull[index]
              .items[i]
              .itemName
              .toLowerCase()
              .contains(value.toLowerCase()))
            _itemCats.add(_itemHeadersFull[index].items[i].itemCat);
        }
      }
    }
    // _itemHeaders = [];
    // for (int index = 0; index < _itemHeadersFull.length; index++) {
    //   List<ItemHeader> tempItemHeaders = [];
    //   for (int i = 0; i < _itemCats.length; i++) {
    //     List<MenuItem> items = [];
    //     for (int j = 0; j < _itemHeadersFull[index].items.length; j++) {
    //       if (_itemCats.toList()[i] ==
    //           _itemHeadersFull[index].items[j].itemCat) {
    //         if (_itemHeadersFull[index]
    //             .items[i]
    //             .itemName
    //             .toLowerCase()
    //             .contains(value)) items.add(_itemHeadersFull[index].items[j]);
    //       }
    //     }
    //     tempItemHeaders.add(ItemHeader(
    //         groupid: _itemHeadersFull[index].groupid,
    //         name: _itemHeadersFull[index].name,
    //         items: items));
    //   }
    //   _itemHeaders = tempItemHeaders;
    // }
    _itemHeaders = [];

    for (int i = 0; i < _itemCats.length; i++) {
      List<MenuItem> items = [];

      for (int index = 0; index < _itemHeadersFull.length; index++) {
        for (int j = 0; j < _itemHeadersFull[index].items.length; j++) {
          if (_itemHeadersFull[index].items[j].itemCat ==
              _itemCats.toList()[i]) {
            if (_itemHeadersFull[index]
                .items[j]
                .itemName
                .toLowerCase()
                .contains(value.toLowerCase())) {
              items.add(_itemHeadersFull[index].items[j]);
            }
          }
        }
      }
      _itemHeaders.add(ItemHeader(
          groupid: _itemHeadersFull[i].groupid,
          name: _itemHeadersFull[i].name,
          items: items));
    }

    // for (int index = 0; index < _itemHeadersFull.length; index++) {
    //   List<MenuItem> items = [];
    //   for (int j = 0; j < _itemHeadersFull[index].items.length; j++) {
    //     if (_itemCats.contains(_itemHeadersFull[index].items[j].itemCat)) {
    //       if (_itemHeadersFull[index]
    //           .items[j]
    //           .itemName
    //           .toLowerCase()
    //           .contains(value)) {
    //         items.add(_itemHeadersFull[index].items[j]);
    //       }
    //     }
    //   }
    //   _itemHeaders.add(ItemHeader(
    //       groupid: _itemHeadersFull[index].groupid,
    //       name: _itemHeadersFull[index].name,
    //       items: items));
    // }

    List<FoodGroup> arrFoodGroup = [];
    for (int i = 0; i < _itemHeaders.length; i++) {
      List<ItemQtyModel> arrItemQtyModel = [];
      List<MenuItem> items = [];
      for (int j = 0; j < _itemHeaders[i].items.length; j++) {
        items.add(_itemHeaders[i].items[j]);
        arrItemQtyModel
            .add(ItemQtyModel(itemId: _itemHeaders[i].items[j].itemId, qty: 0));
      }
      arrFoodGroup.add(FoodGroup(
          groupID: _itemHeaders[i].groupid, itemQtyModel: arrItemQtyModel));
    }
    _menuQtyModel.foodGroup = arrFoodGroup;
    setState(() {});
  }

  sortViaGroup(int index) {
    _itemCats = Set<String>();
    for (int i = 0; i < _itemHeadersFull[index].items.length; i++) {
      if (_itemHeadersFull[index].items[i].itemCat != null)
        _itemCats.add(_itemHeadersFull[index].items[i].itemCat);
    }
    _itemHeaders = [];
    for (int i = 0; i < _itemCats.length; i++) {
      List<MenuItem> items = [];
      for (int j = 0; j < _itemHeadersFull[index].items.length; j++) {
        if (_itemCats.toList()[i] == _itemHeadersFull[index].items[j].itemCat) {
          items.add(_itemHeadersFull[index].items[j]);
        }
      }
      _itemHeaders.add(ItemHeader(
          groupid: _itemHeadersFull[index].groupid,
          name: _itemHeadersFull[index].name,
          items: items));
    }
    List<FoodGroup> arrFoodGroup = [];
    for (int i = 0; i < _itemHeaders.length; i++) {
      List<ItemQtyModel> arrItemQtyModel = [];
      List<MenuItem> items = [];
      for (int j = 0; j < _itemHeaders[i].items.length; j++) {
        items.add(_itemHeaders[i].items[j]);
        arrItemQtyModel
            .add(ItemQtyModel(itemId: _itemHeaders[i].items[j].itemId, qty: 0));
      }
      arrFoodGroup.add(FoodGroup(
          groupID: _itemHeaders[i].groupid, itemQtyModel: arrItemQtyModel));
    }
    _menuQtyModel.foodGroup = arrFoodGroup;
    headerImageUrl = _itemHeadersFull[index].groupPic;

    setState(() {});
  }

  sortViaCategory(String cat) {
    _itemHeaders = [];
    List<FoodGroup> arrFoodGroup = [];
    for (int i = 0; i < _itemHeadersFull.length; i++) {
      List<ItemQtyModel> arrItemQtyModel = [];
      List<MenuItem> items = [];
      bool isThere = false;
      for (int j = 0; j < _itemHeadersFull[i].items.length; j++) {
        if (_itemHeadersFull[i].items[j].itemCat == cat) {
          isThere = true;
          items.add(_itemHeadersFull[i].items[j]);
          // _itemHeaders.add(_itemHeadersFull[i]);
          arrItemQtyModel.add(ItemQtyModel(
              itemId: _itemHeadersFull[i].items[j].itemId, qty: 0));
        }
      }
      if (isThere) {
        _itemHeaders.add(ItemHeader(
            name: _itemHeadersFull[i].name,
            groupid: _itemHeadersFull[i].groupid,
            items: items));
        arrFoodGroup.add(FoodGroup(
            groupID: _itemHeadersFull[i].groupid,
            itemQtyModel: arrItemQtyModel));
      }
    }
    _menuQtyModel.foodGroup = arrFoodGroup;

    if (cat == "All") {
      for (int i = 0; i < _itemHeadersFull.length; i++) {
        List<ItemQtyModel> arrItemQtyModel = [];
        List<MenuItem> items = [];
        for (int j = 0; j < _itemHeadersFull[i].items.length; j++) {
          items.add(_itemHeadersFull[i].items[j]);
          // _itemHeaders.add(_itemHeadersFull[i]);
          arrItemQtyModel.add(ItemQtyModel(
              itemId: _itemHeadersFull[i].items[j].itemId, qty: 0));
        }
        _itemHeaders.add(ItemHeader(
            name: _itemHeadersFull[i].name,
            groupid: _itemHeadersFull[i].groupid,
            items: items));
        arrFoodGroup.add(FoodGroup(
            groupID: _itemHeadersFull[i].groupid,
            itemQtyModel: arrItemQtyModel));
      }
      _menuQtyModel.foodGroup = arrFoodGroup;
    }
    setState(() {});

    //_itemHeaders = _itemHeadersFull;
  }

  searchViaText(String cat) {
    _itemHeaders = [];
    List<FoodGroup> arrFoodGroup = [];
    for (int i = 0; i < _itemHeadersFull.length; i++) {
      List<ItemQtyModel> arrItemQtyModel = [];
      List<MenuItem> items = [];
      bool isThere = false;
      for (int j = 0; j < _itemHeadersFull[i].items.length; j++) {
        if (_itemHeadersFull[i]
            .items[j]
            .itemName
            .toLowerCase()
            .contains(cat.toLowerCase())) {
          isThere = true;
          items.add(_itemHeadersFull[i].items[j]);
          // _itemHeaders.add(_itemHeadersFull[i]);
          arrItemQtyModel.add(ItemQtyModel(
              itemId: _itemHeadersFull[i].items[j].itemId, qty: 0));
        }
      }
      if (isThere) {
        _itemHeaders.add(ItemHeader(
            name: _itemHeadersFull[i].name,
            groupid: _itemHeadersFull[i].groupid,
            items: items));
        arrFoodGroup.add(FoodGroup(
            groupID: _itemHeadersFull[i].groupid,
            itemQtyModel: arrItemQtyModel));
      }
    }
    _menuQtyModel.foodGroup = arrFoodGroup;

    if (cat == "All") {
      for (int i = 0; i < _itemHeadersFull.length; i++) {
        List<ItemQtyModel> arrItemQtyModel = [];
        List<MenuItem> items = [];
        for (int j = 0; j < _itemHeadersFull[i].items.length; j++) {
          items.add(_itemHeadersFull[i].items[j]);
          // _itemHeaders.add(_itemHeadersFull[i]);
          arrItemQtyModel.add(ItemQtyModel(
              itemId: _itemHeadersFull[i].items[j].itemId, qty: 0));
        }
        _itemHeaders.add(ItemHeader(
            name: _itemHeadersFull[i].name,
            groupid: _itemHeadersFull[i].groupid,
            items: items));
        arrFoodGroup.add(FoodGroup(
            groupID: _itemHeadersFull[i].groupid,
            itemQtyModel: arrItemQtyModel));
      }
      _menuQtyModel.foodGroup = arrFoodGroup;
    }
    setState(() {});

    //_itemHeaders = _itemHeadersFull;
  }

  Future<void> toggleFavorite(MenuItem item) async {

    User user = await AppUtils.getUser();
    dynamic token = await AppUtils.getToken();

    if (user == null || user.id == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginSignupScreen()));
    } else {
      ApiResponse<CommonResponseModel> response = await K3Webservice.postMethod(
        apisToUrls(Apis.favorite), jsonEncode({"user_id": "${user.id}", "item_id": "${item.itemId}", "is_fav ": !item.is_fav}), {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
      // ApiResponse<CommonResponseModel> apiResponse =
      // await K3Webservice.postMethod(
      //     apisToUrls(Apis.cancelOrder), jsonEncode({'order_id': orderId}), {
      //   "Authorization": "Bearer $token",
      //   "Content-Type": "application/json"
      // });
      if (response.data.status) {
        item.is_fav = !item.is_fav;
        setState((){

        });
      }
    }
  }
}

class ImageDialog extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String description;
  const ImageDialog({Key key, this.imgUrl, this.name, this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 500,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                  imageUrl: imgUrl,
                  imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width / 2,
                      child: Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Image.asset(
                        'assets/images/dish_placeholder.png',
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.contain,
                      )),
              SizedBox(height: 20),
              Text(
                name ?? '',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                description ?? '',
                textAlign: TextAlign.center,
                maxLines: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
