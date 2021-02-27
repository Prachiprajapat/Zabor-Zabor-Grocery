import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/notification_screen/bloc/notification_bloc.dart';
import 'package:zabor/screens/notification_screen/model/model.dart';
import 'package:zabor/state_manager_widgets/is_user_logged_in.dart';
import 'package:zabor/utils/bloc_state.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationBloc _notificationBloc;
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool _isCall = true;
  List<NotificationModel> notifications = [];
  @override
  void initState() {
    super.initState();
    _notificationBloc = NotificationBloc();
    _notificationBloc.getNotificationList(_page);

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page = _page + 1;
        print(_page);
        if (_isCall) {
          List<NotificationModel> tempNotifications =
              await _notificationBloc.loadMoreNotification(_page);
          setState(() {
            notifications.addAll(tempNotifications);
            if (tempNotifications.length < 10) {
              _isCall = false;
            }
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notificationBloc.getNotificationList(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          buildTopBar(context),
          SizedBox(
            height: 30,
          ),
          Consumer<UserLoggedInManager>(
            builder: (context, userLoggedInManager, child) =>
                !userLoggedInManager.isLoggedin
                    ? buildAuthWigdet()
                    : StreamBuilder<BlocState>(
                        stream: _notificationBloc.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data is BlocAuthErrorState) {
                            return buildAuthWigdet();
                          }

                          if (snapshot.data is BlocNotificationDataState){
                            return buildListView();
                          }

                          if (snapshot.data is BlocLoadingState){
                            return Center(child: CircularProgressIndicator());
                          }

                          return Container(child: Text('No Notifications'),);
                        }),
          )
        ]),
      ),
    );
  }

  Expanded buildListView() {
    return Expanded(
      child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) => buildNotificationTile(index)),
    );
  }

  Padding buildNotificationTile(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(notifications[index].msg)),
                  SizedBox(width: 8),
                  Text(notifications[index].createdAt)
                ]),
          ),
          height: 30,
          decoration: BoxDecoration(color: AppColors().kWhiteColor, boxShadow: [
            BoxShadow(
                color: AppColors().kBlackColor54,
                spreadRadius: 0.2,
                blurRadius: 5)
          ])),
    );
  }

  Row buildTopBar(BuildContext context) {
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
              AppLocalizations.of(context).translate('NOTIFICATIONS'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Expanded buildAuthWigdet() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginSignupScreen()));
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error,
                color: AppColors().kPrimaryColor,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "It seem you are not logged in. Please login in.",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
