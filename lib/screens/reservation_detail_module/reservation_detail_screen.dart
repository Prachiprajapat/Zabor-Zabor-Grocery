import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/my_reservation_module/my_reservation_response_model.dart';

class ReservationDetailModule extends StatefulWidget {
  final MyReservation myReservation;

  const ReservationDetailModule({Key key,@required this.myReservation})
      : super(key: key);
  @override
  _ReservationDetailModuleState createState() =>
      _ReservationDetailModuleState();
}

class _ReservationDetailModuleState extends State<ReservationDetailModule> {
  List<String> _arrTitles = [
    'Restaurant Name',
    'Party Size',
    'Date',
    'Time',
    'Status'
  ];
  List<String> _arrDescription = ['', '', '', '', ''];

  @override
  void initState() {
    super.initState();
    _arrDescription = [
      '${widget.myReservation.resName}',
      'for ${widget.myReservation.people}',
      '${widget.myReservation.date}',
      '${widget.myReservation.time}',
      '${widget.myReservation.confirmed == 0 ? "waiting" : "approved"}'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: ListView.builder(
          itemCount: _arrTitles.length,
          itemBuilder: (context, index) => Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${_arrTitles[index]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${_arrDescription[index]}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAuthWigdet(BuildContext context) {
    return GestureDetector(
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
              sessionExpiredText,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'RESERVATION DETAILS',
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.text(
                  'RESERVATION DETAILS', getShareMessage(), 'text/plain');
            })
      ],
      backgroundColor: AppColors().kWhiteColor,
      iconTheme: IconThemeData(color: AppColors().kBlackColor),
      textTheme: TextTheme(
          title: TextStyle(
              color: AppColors().kBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w600)),
    );
  }

  String getShareMessage() {
    String string = "";
    for (int i = 0; i < _arrTitles.length; i++) {
      string += "${_arrTitles[i]} : ${_arrDescription[i]}\n";
    }
    return string;
  }
}
