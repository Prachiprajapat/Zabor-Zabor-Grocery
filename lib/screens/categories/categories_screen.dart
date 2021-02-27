import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/categories/models/category_response_model.dart';
import 'package:zabor/screens/categories/services/services.dart';
import 'package:zabor/screens/restaurant_list/restaurant_list_screen.dart';
import 'package:zabor/screens/restaurant_list/services/restaurant_list_services.dart';
import 'package:zabor/screens/sub_categories/sub_categories_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  List<CategoryModel> _categories;
  @override
  void initState() {
    super.initState();
    callCategoryApi(context);
  }

  void callCategoryApi(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final categoryService = CategoryService();
    ApiResponse apiResponse = await categoryService.getCategories();
    if (apiResponse.error) {
      print(apiResponse.message);
      _showSnackBar(context, apiResponse.message);
    } else {
      _categories = apiResponse.data;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void callSearchCategoryApi(BuildContext context, String string) async {
    setState(() {
      _isLoading = true;
    });
    final categoryService = CategoryService();

    ApiResponse apiResponse =
        await categoryService.searchedCategoryResults(string);
    if (apiResponse.error) {
      print(apiResponse.message);
      _showSnackBar(context, apiResponse.message);
    } else {
      _categories = apiResponse.data;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            navBar(context),
            new CustomSearchBar(
              hintText:
                  AppLocalizations.of(context).translate('Search Restaurants'),
              onSumbitted: (string) {
                // callSearchCategoryApi(context,string);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantListScreen(
                              query: string,
                              restaurantListEntryPoint:
                                  RestaurantListEntryPoint.resSearch,
                            )));
              },
            ),
            SizedBox(
              height: 20,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _categories == null
                    ? Center(
                        child: Text('No Data'),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _categories.length,
                          itemBuilder: (context, index) => FlatButton(
                            child: new CategoryRow(
                              index: index,
                              category: _categories[index],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubCategoriesScreen(
                                            category: _categories[index],
                                          )));
                            },
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }

  Row navBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Image.asset('assets/images/back2.png'),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('SEARCH RESTAURANTS'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)
                  .translate('Filter restaurants by categories'),
              style: TextStyle(fontSize: 14, color: AppColors().kBlackColor),
            )
          ],
        ),
      ],
    );
  }
}

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    Key key,
    this.index,
    this.category,
  }) : super(key: key);

  final CategoryModel category;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                height: 25,
                width: 25,
                fit: BoxFit.cover,
                imageUrl:
                    baseUrl + (category.catimg == null ? "" : category.catimg),
                placeholder: (context, url) => CircularProgressIndicator(
                  strokeWidth: 1.0,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Text(
                category.name,
                style: TextStyle(
                    color: AppColors().kBlackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ))
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    Key key,
    this.onSumbitted,
    @required this.hintText,
  }) : super(key: key);
  final Function onSumbitted;
  final String hintText;

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  String _string = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: AppColors().kWhiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, spreadRadius: 0.1, blurRadius: 10)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Container(
                  child: Expanded(
                      child: TextField(
                        onChanged: (text){
                          setState(() {
                            _string = text;
                          });
                        },
                    onSubmitted: widget.onSumbitted,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: widget.hintText),
                  )),
                ),
                IconButton(
                  icon: Image.asset('assets/images/search22.png'),
                  onPressed: () {
                    widget.onSumbitted(_string);
                  },
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
