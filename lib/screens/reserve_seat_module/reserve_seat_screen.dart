import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/enter_card_detail_module/enter_card_detail_screen.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/my_reservation_module/my_reservation_screen.dart';
import 'package:zabor/screens/reserve_seat_module/slot_response_model.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';

class ReserveSeatScreen extends StatefulWidget {
  final int resId;

  const ReserveSeatScreen({Key key, @required this.resId}) : super(key: key);
  @override
  _ReserveSeatScreenState createState() => _ReserveSeatScreenState();
}

class _ReserveSeatScreenState extends State<ReserveSeatScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAuthError = false;
  int _value = -1;
  int _selectedId = -1;
  bool _isSlotLoading = false;
  List<TimeSlot> _arrSlots = [];
  List<TimeSlot> _arrFilterSlots = [];
  int _availableSeat = 0;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    callSlotApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: buildAppBar(),
        body: _isAuthError ? buildAuthWigdet(context) : buildBody(context));
  }

  SingleChildScrollView buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {
                'date': DateTime.now(),
                'time': DateTime.now(),
                'accept_terms': false,
              },
              // autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Date',
                        style: TextStyle(
                            color: AppColors().kBlackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      FormBuilderDateTimePicker(
                        onChanged: (date) {
                          setState(() {
                            selectedDate = date;
                            filterTimeSlot();
                          });
                        },
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 7)),
                        attribute: "date",
                        inputType: InputType.date,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration:
                            InputDecoration(enabledBorder: InputBorder.none),
                      ),
                    ],
                  ),
                  _isSlotLoading
                      ? Center(child: CircularProgressIndicator())
                      : _arrSlots.length == 0
                          ? Center(child: Text('No slots Available'))
                          : Wrap(
                              children: List<Widget>.generate(
                                _arrFilterSlots.length,
                                (int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ChoiceChip(
                                      backgroundColor: Colors.black87,
                                      selectedColor: AppColors().kPrimaryColor,
                                      padding: EdgeInsets.all(8),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      label: Text(
                                          '${_arrFilterSlots[index].fromTimeslot} - ${_arrFilterSlots[index].toTimeslot}'),
                                      selected: _value == index,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          _value = index;
                                          _selectedId = _arrFilterSlots[index].id;
                                          // _availableSeat =
                                          //     _arrSlots[index].availSeat;
                                          // _fbKey.currentState
                                          //     .fields['partySize'].currentState
                                          //     .reset();
                                          // for (int i = 1;
                                          //     i <= _arrSlots[_value].availSeat;
                                          //     i++) {}
                                        });
                                      },
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                  SizedBox(
                    height: 20,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Text(
                  //       'Party Size',
                  //       style: TextStyle(
                  //           color: AppColors().kBlackColor,
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //     SizedBox(width: 5),
                  //     Text(
                  //       '($_availableSeat seats Available)',
                  //       style: TextStyle(fontSize: 12),
                  //     )
                  //   ],
                  // ),
                  // FormBuilderTextField(
                  //   keyboardType: TextInputType.number,
                  //   attribute: "partySize",
                  //   decoration: InputDecoration(labelText: "Party Size"),
                  //   validators: [
                  //     FormBuilderValidators.required(),
                  //     FormBuilderValidators.numeric(),
                  //     FormBuilderValidators.max(_availableSeat),
                  //     FormBuilderValidators.min(1)
                  //   ],
                  // ),
                  Divider(),
                  SizedBox(height: 20),
                  // Text(
                  //   'Payment Mode',
                  //   style: TextStyle(
                  //       color: AppColors().kBlackColor,
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  // FormBuilderDropdown(
                  //   attribute: "paymentmode",
                  //   decoration:
                  //       InputDecoration(enabledBorder: InputBorder.none),
                  //   // initialValue: 'Male',
                  //   hint: Text('Select Payment mode'),
                  //   validators: [FormBuilderValidators.required()],
                  //   items: ['Online', 'Cash on delivery']
                  //       .map((paymentmode) => DropdownMenuItem(
                  //           value: paymentmode, child: Text("$paymentmode")))
                  //       .toList(),
                  // ),
                ],
              ),
            ),
            // Row(
            //   children: <Widget>[
            //     Text('*Reservation will cost \$5'),
            //   ],
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ButtonWidget(
                    title: 'SUBMIT',
                    onPressed: () {
                      // if (_selectedId == -1) {
                      //   showSnackBar(_scaffoldKey, 'Please select time slot', null);
                      //   return;
                      // }


                      Navigator.pop(context, {'selectedId': _selectedId});
                      // if (_fbKey.currentState.saveAndValidate()) {
                      // print(_fbKey.currentState.value);
                      //callReserveASeatApi(_fbKey.currentState.value, context);
                      // }
                    },
                  )
          ],
        ),
      ),
    );
  }

  // callReserveASeatApi(Map<String, dynamic> data, BuildContext context) async {
  //   String stripeToken = await Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => EnterCardDetailScreen()));

  //       if (stripeToken == null) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   dynamic token = await AppUtils.getToken();
  //   User user = await AppUtils.getUser();
  //   if (user == null) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     showSnackBar(
  //         _scaffoldKey,
  //         "It seems you are not logged in. Please login.",
  //         SnackBarAction(
  //           label: "Login",
  //           onPressed: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => LoginSignupScreen()));
  //           },
  //         ));
  //     return;
  //   }
  //   ApiResponse<CommonResponseModel> apiResponse =
  //       await K3Webservice.postMethod(
  //           apisToUrls(Apis.makeReservation),
  //           json.encode({
  //             "res_id": widget.resId,
  //             "user_id": user.id,
  //             "people": data["partySize"].toString(),
  //             "token": stripeToken,
  //             "date":
  //                 DateFormat("yyyy-MM-dd").format(data["date"]).toString() ??
  //                     "",
  //             "time": _arrSlots[_value].slotTime ?? ""
  //           }),
  //           {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json"
  //       });
  //   setState(() {
  //     _isLoading = false;
  //   });

  //   if (apiResponse.error) {
  //     showSnackBar(_scaffoldKey, apiResponse.message, null);
  //     if (apiResponse.message == sessionExpiredText) {
  //       setState(() {
  //         _isAuthError = true;
  //       });
  //     }
  //     return;
  //   } else {
  //     Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => MyReservationScreen()));
  //   }
  // }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'SELECT TIME SLOT',
      ),
      backgroundColor: AppColors().kWhiteColor,
      iconTheme: IconThemeData(color: AppColors().kBlackColor),
      textTheme: TextTheme(
          title: TextStyle(
              color: AppColors().kBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w600)),
    );
  }

  filterTimeSlot() {
    _arrFilterSlots = [];
    for (TimeSlot timeslot in _arrSlots) {
      if (timeslot.date.day == selectedDate.day &&
          timeslot.date.month == selectedDate.month &&
          timeslot.date.year == selectedDate.year) {
        _arrFilterSlots.add(timeslot);
      }
    }
    setState(() {});
  }

  Widget buildAuthWigdet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
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

  callSlotApi() async {
    setState(() {
      _isAuthError = false;
      _isSlotLoading = true;
      _availableSeat = 0;
    });

    dynamic token = await AppUtils.getToken();

    ApiResponse<TimeSlotGroceryResponseModel> apiResponse =
        await K3Webservice.postMethod(
            apisToUrls(Apis.getSlots), json.encode({"res_id": widget.resId}), {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });
    setState(() {
      _isSlotLoading = false;
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
        _arrSlots = apiResponse.data.data;
        filterTimeSlot();
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(3101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
  }
}
