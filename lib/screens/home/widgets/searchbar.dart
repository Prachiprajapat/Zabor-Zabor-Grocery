import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/screens/categories/categories_screen.dart';
import 'package:zabor/screens/restaurant_list/restaurant_list_screen.dart';
import 'package:zabor/screens/restaurant_list/services/restaurant_list_services.dart';
import 'package:zabor/utils/utils.dart';

import '../../../constants/constants.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String string = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  GestureDetector(
                    child: Image.asset('assets/images/gps.png'),
                    onTap: () {},
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Container(
                child: Expanded(
                    child: TextField(
                  onChanged: (text) {
                    setState(() {
                      string = text;
                    });
                  },
                  onSubmitted: (text) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantListScreen(
                                  query: text,
                                  restaurantListEntryPoint:
                                      RestaurantListEntryPoint.resSearch,
                                )));
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)
                          .translate('Stores in current location')),
                )),
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: AppColors().kPrimaryColor,
                onPressed: () {
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
            ],
          ),
        ),
      ),
    );
  }
}
