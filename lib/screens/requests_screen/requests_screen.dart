import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/friend_list/model/friend_list_model.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/profile_detail/model/profile_detail_model.dart';
import 'package:zabor/screens/profile_detail/profile_detail_screen.dart';
import 'package:zabor/screens/requests_screen/bloc/request_screen_bloc.dart';
import 'package:zabor/screens/requests_screen/widgets/request_user_row.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  FriendRequestBloc _friendRequestBloc;

  @override
  void initState() {
    super.initState();
    _friendRequestBloc = FriendRequestBloc();
    _friendRequestBloc.loadFriendRequests();
  }

  @override
  void dispose() {
    super.dispose();
    _friendRequestBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            navBar(context),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<FriendListState>(
              initialData: FriendListInitState('No Friend Request'),
              stream: _friendRequestBloc.friendListStream,
              builder: (context, snapshot) {
                if (snapshot.data is FriendListLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data is FriendListDataState) {
                  FriendListDataState state = snapshot.data;
                  return Expanded(
                      child: buildUserList(context, state.appUsers));
                }

                if (snapshot.data is FriendListInitState) {
                  FriendListInitState state = snapshot.data;
                  return buildStateInit(state);
                }

                if (snapshot.data is FriendListSuccessStatusState) {
                  FriendListSuccessStatusState state = snapshot.data;
                  return buildSuccessRequestSend(state);
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Expanded buildSuccessRequestSend(FriendListSuccessStatusState state) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _friendRequestBloc.loadFriendRequests();
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                child: Icon(
                  Icons.check,
                  size: 150,
                  color: AppColors().kPrimaryColor,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors().kPrimaryColor)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildStateInit(FriendListInitState state) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(state.message),
            FlatButton(
              child: Text(
                state.message == sessionExpiredText
                    ? 'Login'
                    : AppLocalizations.of(context).translate('Reload'),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              color: AppColors().kPrimaryColor,
              textColor: AppColors().kWhiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                if (state.message == sessionExpiredText) {
                  navigateToLogin(context);
                } else {
                  _friendRequestBloc.loadFriendRequests();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void navigateToLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginSignupScreen()));
  }

  ListView buildUserList(BuildContext context, List<AppUser> appUsers) {
    return ListView.builder(
      itemCount: appUsers.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileDetailScreen(
                        profileDetailEntryPoint:
                            ProfileDetailEntryPoint.friend_list,
                        friendId: appUsers[index].friendId,
                      )));
        },
        child: FriendRequestListRow(
          appUser: appUsers[index],
          acceptedButtonPressed: () {
            _friendRequestBloc.friendRequestAction(appUsers[index].id, 1);
          },
          ignoreButtonPressed: () {
            _friendRequestBloc.friendRequestAction(appUsers[index].id, -1);
          },
        ),
      ),
    );
  }

  Row navBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Image.asset('assets/images/back2.png'),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('REQUESTS'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context).translate(
                    'Please accept/reject your friend request from here'),
                style: TextStyle(fontSize: 14, color: AppColors().kBlackColor),
              )
            ],
          ),
        ),
      ],
    );
  }
}
