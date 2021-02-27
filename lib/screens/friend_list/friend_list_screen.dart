import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/friend_list/friend_list_model/friend_list_model.dart';
import 'package:zabor/screens/friend_list/widgets/friend_list_row.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/profile_detail/model/profile_detail_model.dart';
import 'package:zabor/screens/profile_detail/profile_detail_screen.dart';

import 'bloc/user_list_bloc.dart';
import 'model/friend_list_model.dart';

const images = [
  'assets/images/person1.jpeg',
  'assets/images/person3.jpeg',
  'assets/images/person4.jpeg',
  'assets/images/person5.jpeg',
  'assets/images/person2.jpg',
  'assets/images/person1.jpeg',
  'assets/images/person3.jpeg',
  'assets/images/person4.jpeg',
  'assets/images/person5.jpeg',
  'assets/images/person2.jpg',
];

class UserListScreen extends StatefulWidget {
  final UserListEntryPoint userListEntryPoint;
  final String searchName;
  const UserListScreen(
      {Key key, @required this.userListEntryPoint, this.searchName})
      : super(key: key);
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  UserListBloc userListBloc;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool _isCall = true;
  List<AppUser> users = [];
  @override
  void initState() {
    super.initState();
    userListBloc = UserListBloc();
    if (widget.userListEntryPoint == UserListEntryPoint.profile) {
      userListBloc.getMyFriends();
      return;
    }
    userListBloc.searchUser(widget.searchName);

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page = _page + 1;
        print(_page);
        if (_isCall) {
          if (widget.userListEntryPoint == UserListEntryPoint.profile) {
            List<AppUser> temp = await userListBloc.getMoreMyFriends();
            users.addAll(temp);
            if (temp.length < 10) {
              _isCall = false;
            }
            return;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    userListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
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
            StreamBuilder<UserListState>(
                initialData: UserListInitState('No users'),
                stream: userListBloc.userListStream,
                builder: (context, snapshot) {
                  if (snapshot.data is UserListLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data is UserListDataState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      UserListDataState state = snapshot.data;
                      setState(() {
                        users = state.appUsers;
                      });
                    });

                    return Expanded(child: buildUserList(context));
                  }
                  if (snapshot.data is UserListInitState) {
                    UserListInitState state = snapshot.data;
                    return buildStateInit(state);
                  }

                  if (snapshot.data is UserListSuccessStatusState) {
                    UserListSuccessStatusState state = snapshot.data;
                    return buildSuccessRequestSend(state);
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }

  Expanded buildSuccessRequestSend(UserListSuccessStatusState state) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (widget.userListEntryPoint == UserListEntryPoint.profile) {
            userListBloc.getMyFriends();
          } else {
            userListBloc.searchUser(widget.searchName);
          }
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

  Expanded buildStateInit(UserListInitState state) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(state.message),
            FlatButton(
              child: Text(
                state.message == sessionExpiredText ? 'Login' : 'Reload',
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
                  if (widget.userListEntryPoint == UserListEntryPoint.profile) {
                    userListBloc.getMyFriends();
                    return;
                  }
                  userListBloc.searchUser(widget.searchName);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  ListView buildUserList(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileDetailScreen(
                        profileDetailEntryPoint:
                            ProfileDetailEntryPoint.friend_list,
                        friendId: widget.userListEntryPoint ==
                                UserListEntryPoint.profile
                            ? users[index].friendId
                            : users[index].id,
                      )));
        },
        child: FriendListRow(
          appUser: users[index],
          userListEntryPoint: widget.userListEntryPoint,
          sendRequestButtonPressed: () {
            userListBloc.sendFriendRequest(users[index].id);
          },
          unFriendButtonPressed: () {
            userListBloc.friendRequestAction(users[index].id, -1);
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.userListEntryPoint == UserListEntryPoint.profile
                  ? 'FRIEND LIST'
                  : AppLocalizations.of(context).translate('USER LIST'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.userListEntryPoint == UserListEntryPoint.profile
                  ? 'Please check your friends here.'
                  : AppLocalizations.of(context)
                      .translate('Please check the user list here'),
              style: TextStyle(fontSize: 14, color: AppColors().kBlackColor),
            )
          ],
        ),
      ],
    );
  }

  showSnackBar(BuildContext context, String message, SnackBarAction action) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      action: action,
    ));
  }

  void navigateToLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginSignupScreen()));
  }
}
