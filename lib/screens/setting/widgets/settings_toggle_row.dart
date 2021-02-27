import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zabor/app_localizations/app_language_provider.dart';
import 'package:zabor/constants/constants.dart';

class SettingsToggleRow extends StatefulWidget {
  const SettingsToggleRow({
    Key key,
    this.title,
    this.tapAction,
  }) : super(key: key);

  final String title;
  final Function(bool) tapAction;

  @override
  _SettingsToggleRowState createState() => _SettingsToggleRowState();
}

class _SettingsToggleRowState extends State<SettingsToggleRow> {
  bool _toggleValue = false;
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return FlatButton(
      onPressed: () {},
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.title, style: AppFontStyle().kHeadingTextStyle),
                Switch(
                  value: appLanguage.appLocal == Locale('en') ? false : true,
                  onChanged: (action) {
                    print(action);
                    widget.tapAction(action);
                    setState(() {
                      _toggleValue = action;
                    });
                  },
                  activeTrackColor: AppColors().kGreyColor100,
                  activeColor: AppColors().kPrimaryColor,
                  inactiveThumbColor: AppColors().kPrimaryColor,
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
