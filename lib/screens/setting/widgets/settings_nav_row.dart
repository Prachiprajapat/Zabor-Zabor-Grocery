
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zabor/constants/constants.dart';

class SettingsNavRow extends StatelessWidget {
  const SettingsNavRow({
    Key key,
    this.title,
    this.tapAction,
  }) : super(key: key);

  final String title;
  final Function tapAction;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: tapAction,
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title, style: AppFontStyle().kHeadingTextStyle),
                FaIcon(FontAwesomeIcons.chevronRight, color: AppColors().kPrimaryColor, size: 15,), 
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}