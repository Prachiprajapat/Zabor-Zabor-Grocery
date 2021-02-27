import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/categories/categories_screen.dart';
import 'package:zabor/screens/friend_list/friend_list_model/friend_list_model.dart';
import 'package:zabor/screens/friend_list/friend_list_screen.dart';

class SearchUserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 95),
              child: Image.asset('assets/images/user_list_bg.png'),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          icon: Image.asset('assets/images/back2.png'),
                          onPressed: () => {Navigator.pop(context)}),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('USER LIST'),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate('Please check the user list here'),
                          style: TextStyle(
                              fontSize: 14, color: AppColors().kBlackColor),
                        )
                      ],
                    )
                  ],
                ),
                CustomSearchBar(
                  hintText: 'Search User',
                  onSumbitted: (text) {
                    print(text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserListScreen(
                                  userListEntryPoint:
                                      UserListEntryPoint.searchUserList,
                                  searchName: text,
                                )));
                  },
                )
              ],
            ),
            Positioned(
              child: Container(), //lowerWidgets(),
              bottom: 10,
              left: 10,
              right: 10,
            )
          ],
        ),
      ),
    );
  }

  Padding lowerWidgets() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Container(
            height: 45,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/facebook.png'),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(12)),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors().kPrimaryColor,
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              child: Text(
                'SEARCH FROM CONTACT LIST',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
