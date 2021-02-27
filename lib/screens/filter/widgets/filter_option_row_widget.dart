import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/filter/providers/filter_option_provider.dart';

class FilterOptionRow extends StatelessWidget {
  const FilterOptionRow({
    Key key,
    this.title,
    this.index,
  }) : super(key: key);

  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    final filterOptionSelection =
        Provider.of<FilterOptionSelection>(context, listen: false);
    return FlatButton(
      onPressed: () {
        filterOptionSelection.select(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: index == 0
                          ? AppColors().kBlackColor
                          : index == 1
                              ? Colors.red
                              : index == 2
                                  ? Colors.green
                                  : Colors.black,
                    ),
                  ),
                ),
                Consumer<FilterOptionSelection>(
                    builder: (context, filterOptionSelection, child) =>
                        filterOptionSelection.option == index
                            ? Image.asset(
                                'assets/images/3.0x/check.png',
                                height: 25,
                              )
                            : Image.asset(
                                'assets/images/3.0x/uncheck.png',
                                height: 25,
                              )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
