import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/screens/offers_screen/offers_screen.dart';
import '../../../constants/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
    this.filterTapped,
    this.notificationPressed,
  }) : super(key: key);

  final Function filterTapped;
  final Function notificationPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Image.asset('assets/images/filter.png'),
            onPressed: filterTapped,
          ),
          Text(
            AppLocalizations.of(context).translate('HOME'),
            style: AppFontStyle().kHeadingTextStyle,
          ),
          Row(
            children: <Widget>[
              // IconButton(
              //   icon: Image.asset('assets/images/notification.png'),
              //   onPressed: notificationPressed,
              // ),
              IconButton(
                  // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                  icon: FaIcon(FontAwesomeIcons.tags),
                  onPressed: () {
                    print("Pressed");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OffersScreen()));
                  })
            ],
          ),
        ],
      ),
    );
  }
}
