import 'package:flutter/material.dart';
import 'package:zabor/constants/constants.dart';

class MoreOptionWidget extends StatelessWidget {
  const MoreOptionWidget({
    Key key, this.title, this.onPressed,
  }) : super(key: key);

final String title;
final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              children: <Widget>[
                Text(title, style: AppFontStyle().kHeadingTextStyle)
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
