import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/filter/widgets/filter_option_row_widget.dart';
import 'package:zabor/screens/restaurant_list/restaurant_list_screen.dart';
import 'package:zabor/screens/restaurant_list/services/restaurant_list_services.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';

final filterOptions = [
  'Location (nearest first)',
  'Price',
  'Reviews',
];

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
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
                      AppLocalizations.of(context).translate('FILTER'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(5),
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('Select the option from below'),
                      style: TextStyle(
                          fontSize: 14, color: AppColors().kBlackColor),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filterOptions.length + 1,
                itemBuilder: (context, index) => (filterOptions.length) == index
                    ? ButtonWidget(
                        title: 'APPLY',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantListScreen(
                                  restaurantListEntryPoint:
                                      RestaurantListEntryPoint.filter),
                            ),
                          );
                        },
                      )
                    : FilterOptionRow(
                        title: AppLocalizations.of(context)
                            .translate(filterOptions[index]),
                        index: index,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
