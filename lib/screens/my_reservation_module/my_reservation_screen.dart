import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/my_reservation_module/enum_status_button.dart';
import 'package:zabor/screens/my_reservation_module/my_reservation_response_model.dart';
import 'package:zabor/screens/reservation_detail_module/reservation_detail_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';

class MyReservationScreen extends StatefulWidget {
  @override
  _MyReservationScreenState createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> {
  bool _isLoading = false;
  bool _isAuthError = false;
  List<MyReservation> arrMyReservations = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    callMyReservationApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isAuthError
              ? buildAuthWigdet(context)
              : arrMyReservations == null
                  ? Center(
                      child: Text(AppLocalizations.of(context)
                          .translate('No Reservations')),
                    )
                  : buildBody(),
    );
  }

  Padding buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: ListView.builder(
          itemBuilder: (context, index) => buildItemRow(index),
          itemCount: arrMyReservations.length),
    );
  }

  Widget buildItemRow(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReservationDetailModule(
                      myReservation: arrMyReservations[index],
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                          '$baseUrl${arrMyReservations[index].restaurantpic}',
                          height: 50,
                          width: 50),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(arrMyReservations[index].resName ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            Text('For ${arrMyReservations[index].people ?? ""}',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                buildOrderStatus(
                    (arrMyReservations[index].confirmed ?? 0) == 0
                        ? ReservationStatusEnum.waiting
                        : ReservationStatusEnum.approved,
                    index)
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  Column buildOrderStatus(
      ReservationStatusEnum reservationStatusEnum, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(arrMyReservations[index].date,
            style: TextStyle(color: Colors.grey, fontSize: 11)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
              color: reservationStatusEnumToColor(reservationStatusEnum),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.grey[350])),
          child: Center(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: reservationStatusEnumToHorizontalPadding(
                    reservationStatusEnum),
                vertical: 3),
            child: Text(
              reservationStatusEnumToTitle(reservationStatusEnum),
              style: TextStyle(
                  color:
                      reservationStatusEnumToTextColor(reservationStatusEnum),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          )),
        )
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('My Reservations').toUpperCase()),
      backgroundColor: AppColors().kWhiteColor,
      iconTheme: IconThemeData(color: AppColors().kBlackColor),
      textTheme: TextTheme(
          title: TextStyle(
              color: AppColors().kBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w600)),
    );
  }

  callMyReservationApi() async {
    setState(() {
      _isLoading = true;
      _isAuthError = false;
    });

    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();
    ApiResponse<MyReservationResponseModel> apiResponse =
        await K3Webservice.getMethod(
            apisToUrls(Apis.myReservations) + '?user_id=${user.id}',
            {"Authorization": "Bearer $token"});

    setState(() {
      _isLoading = false;
    });

    if (apiResponse.error) {
      showSnackBar(_scaffoldKey, apiResponse.message, null);
      if (apiResponse.message == sessionExpiredText) {
        setState(() {
          _isAuthError = true;
        });
      }
      return;
    } else {
      setState(() {
        arrMyReservations = apiResponse.data.data;
      });
    }
  }

  Widget buildAuthWigdet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
        callMyReservationApi();
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
              sessionExpiredText,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
