
import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/categories/models/category_response_model.dart';
import 'package:zabor/screens/restaurant_list/restaurant_list_screen.dart';
import 'package:zabor/screens/restaurant_list/services/restaurant_list_services.dart';
import 'package:zabor/screens/sub_categories/services/services.dart';
import 'models/sub_categories_response_model.dart';

List<String> arrSubCategories = [
  'Italian Food',
  'Chinese Food',
  'South Indian Food',
  'Thy Food'
];

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({Key key, this.category}) : super(key: key);

  @override
  _SubCategoriesScreenState createState() =>
      _SubCategoriesScreenState(category);
  final CategoryModel category;
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  _SubCategoriesScreenState(this.category);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  List<SubCategoryModel> _subcategories;
  final CategoryModel category;
  @override
  void initState() {
    super.initState();
    callSubCategoryApi(context);
  }

  void callSubCategoryApi(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final subCategoryService = SubCategoryService(category.id);
    ApiResponse apiResponse = await subCategoryService.getSubCategories();
    if (apiResponse.error) {
      _showSnackBar(context, apiResponse.message);
    } else {
      _subcategories = apiResponse.data;
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
            SizedBox(
              height: 20,
            ),
            _isLoading
                ? CircularProgressIndicator()
                :  Expanded(
                        child: _subcategories == null
                    ? Center(child: Text(AppLocalizations.of(context).translate('No Data')),)
                    : ListView.builder(
                          itemCount: _subcategories.length,
                          itemBuilder: (context, index) => FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RestaurantListScreen(subCatId: _subcategories[index].id,restaurantListEntryPoint: RestaurantListEntryPoint.subCategoryScreen,)));
                                },
                                child: SubCateogoryView(
                                  index: index,
                                  subCategory: _subcategories[index],
                                ),
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
            Text(AppLocalizations.of(context).translate('SUB-CATEGORIES')
              ,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(AppLocalizations.of(context).translate('Select the sub-category from below')
              ,
              style: TextStyle(fontSize: 14, color: AppColors().kBlackColor),
            )
          ],
        ),
      ],
    );
  }
}

class SubCateogoryView extends StatelessWidget {
  const SubCateogoryView({
    Key key,
    this.index,
    @required this.subCategory,
  }) : super(key: key);
  final int index;
  final SubCategoryModel subCategory;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(
                subCategory.name,
                style: TextStyle(
                    color: AppColors().kBlackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              )),
              Image.asset(
                'assets/images/Uf105.png',
                height: 25,
                width: 25,
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
