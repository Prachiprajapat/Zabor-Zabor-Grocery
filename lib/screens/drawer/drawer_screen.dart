import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/categories/categories_screen.dart';
import 'package:zabor/screens/categories/models/category_response_model.dart';
import 'package:zabor/screens/categories/services/services.dart';
import 'package:zabor/screens/sub_categories/sub_categories_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
    bool _isLoading = false;
  List<CategoryModel> _categories;

  @override
  void initState() {
    super.initState();
     callCategoryApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
              child: Column(
          children:[
             SizedBox(
                height: 20,
              ),
              navBar(context),
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
          ]
        ),
      ),
    );
  }

  Row navBar(BuildContext context) {
    return Row(
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: IconButton(
        //     icon: Image.asset('assets/images/back2.png'),
        //     onPressed: () => {Navigator.pop(context)},
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('Categories').toUpperCase(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)
                    .translate('Filter stores by categories'),
                style: TextStyle(fontSize: 14, color: AppColors().kBlackColor),
              )
            ],
          ),
        ),
      ],
    );
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
    } else {
      _categories = apiResponse.data;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void callCategoryApi(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final categoryService = CategoryService();
    ApiResponse apiResponse = await categoryService.getCategories();
    if (apiResponse.error) {
      print(apiResponse.message);
    } else {
      _categories = apiResponse.data;
    }
    setState(() {
      _isLoading = false;
    });
  }


}