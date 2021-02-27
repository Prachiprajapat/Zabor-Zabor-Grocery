import 'package:flutter/material.dart';
import 'package:zabor/constants/constants.dart';

class DetailRestaurantRow extends StatelessWidget {
  const DetailRestaurantRow({
    Key key,
    this.title,
    this.description,
  }) : super(key: key);

  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors().kBlackColor),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                description,
                textAlign: TextAlign.end,
              ))
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}