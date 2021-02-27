import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/map_full_screen/map_full_screen.dart';
import 'package:zabor/screens/offers_screen/offers_screen.dart';
import 'package:zabor/screens/restaurant_detail/bloc/bloc.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/screens/restuarant_gallery_screen/restuant_gallery_screen.dart';
import 'package:zabor/utils/bloc_state.dart';
import 'dart:async';
import 'detail_restaurant_row.dart';
import 'package:intl/intl.dart';

class RestaurantDetailsTabView extends StatefulWidget {
  const RestaurantDetailsTabView({Key key, this.restaurantDetailModel})
      : super(key: key);

  final RestaurantDetailModel restaurantDetailModel;

  @override
  _RestaurantDetailsTabViewState createState() =>
      _RestaurantDetailsTabViewState();
}

class _RestaurantDetailsTabViewState extends State<RestaurantDetailsTabView> {
  SuggestCategoryBloc _suggestCategoryBloc;
  String _suggestion = '';
  TextEditingController _suggestTextController;
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  double lat = 0.0;
  double long = 0.0;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _suggestCategoryBloc = SuggestCategoryBloc();
    _suggestTextController = TextEditingController();
    lat = widget.restaurantDetailModel.restaurantDetail[0].latitude == null
        ? 0.0
        : widget.restaurantDetailModel.restaurantDetail[0].latitude.toDouble();
    long = widget.restaurantDetailModel.restaurantDetail[0].longitude == null
        ? 0.0
        : widget.restaurantDetailModel.restaurantDetail[0].longitude.toDouble();
    _add();
  }

  @override
  void dispose() {
    super.dispose();
    _suggestCategoryBloc.dispose();
    _suggestTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.restaurantDetailModel.restaurantDetail == null
        ? Center(
            child: Text('No Detail Found'),
          )
        : StreamBuilder<BlocState>(
            stream: _suggestCategoryBloc.stream,
            builder: (context, snapshot) {
              if (snapshot.data is BlocLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data is BlocFailureState) {
                BlocFailureState state = snapshot.data;
                return showMessage(state.message, () {
                  _suggestCategoryBloc.initState();
                }, false);
              }

              if (snapshot.data is BlocSuccessState) {
                BlocSuccessState state = snapshot.data;
                return showMessage(state.message, () {
                  _suggestCategoryBloc.initState();
                }, true);
              }

              if (snapshot.data is BlocAuthErrorState) {
                BlocAuthErrorState state = snapshot.data;
                return showMessage(state.message, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginSignupScreen()));
                }, true);
              }

              if (snapshot.data is BlocInitState) {
                return buildRestaurantDetailWidget(context);
              }

              return buildRestaurantDetailWidget(context);
            });
  }

  void _add() {
    final MarkerId markerId = MarkerId('marker');

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        lat,
        long,
      ),
      //infoWindow: InfoWindow(title: 'marker', snippet: '*'),
      onTap: () {
        print('tappeed');
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  SingleChildScrollView buildRestaurantDetailWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              launch(
                  'tel://${widget.restaurantDetailModel.restaurantDetail[0].contact == null ? '' : widget.restaurantDetailModel.restaurantDetail[0].contact}');
            },
            child: DetailRestaurantRow(
              title: AppLocalizations.of(context).translate('Call'),
              description: widget
                          .restaurantDetailModel.restaurantDetail[0].contact ==
                      null
                  ? ''
                  : widget.restaurantDetailModel.restaurantDetail[0].contact,
            ),
          ),
          DetailRestaurantRow(
            title: AppLocalizations.of(context).translate('Address'),
            description:
                widget.restaurantDetailModel.restaurantDetail[0].address == null
                    ? ''
                    : widget.restaurantDetailModel.restaurantDetail[0].address,
          ),
          // DetailRestaurantRow(
          //     title: AppLocalizations.of(context).translate('Average Cost'),
          //     description: getRateDollarSymbol(
          //         "${widget.restaurantDetailModel.restaurantDetail[0].avgCost == null ? '' : widget.restaurantDetailModel.restaurantDetail[0].avgCost}")),
          buildCategoryRow(context),
          DetailRestaurantRow(
              title: AppLocalizations.of(context)
                  .translate('Opening Closing Time'),
              description: ''),
          buildOpenCloseTimeWidget(),
          
          InkWell(
            onTap: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OffersScreen()));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => RestaurantGalleryScreen(
              //               restId: widget.restaurantDetailModel
              //                   .restaurantDetail.first.id,
              //             )));
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)
                            .translate('View Store Offers'),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors().kBlackColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.arrow_right, color: AppColors().kPrimaryColor),
                    ],
                  ),
                ),
                Divider()
              ],
            ),
          ),
          Column(
            children: getOffers(),
          ),
          //new PhotoViewWidget(),
          Container(
            height: 280,
            decoration: BoxDecoration(color: AppColors().kPrimaryColor),
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, long),
                    zoom: 14.4746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: Set<Marker>.of(markers.values),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapFullScreen1(
                                    restName:
                                        "${widget.restaurantDetailModel.restaurantDetail[0].restaurantName == null ? '' : widget.restaurantDetailModel.restaurantDetail[0].restaurantName}",
                                    restaurantDetailModel:
                                        widget.restaurantDetailModel,
                                  )));
                    },
                    child: Container(
                      color: Colors.transparent,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getOffers() {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.restaurantDetailModel.discounts.length; i++) {
      widgets.add(buildOfferDetailRow(i));
    }
    return widgets;
  }

  Row buildOfferDetailRow(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            FontAwesomeIcons.tags,
            size: 40,
            color: AppColors().kPrimaryColor,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${widget.restaurantDetailModel.discounts[index].userType == "all_users" ? 'All User Offer: ' : 'First User Offer: '} Get flat ${widget.restaurantDetailModel.discounts[index].percentage ?? 0}% OFF on Order of \$${widget.restaurantDetailModel.discounts[index].moa ?? 0} and Above (Max Discount: \$${widget.restaurantDetailModel.discounts[index].mpd ?? 0})',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  showCategoryDialog(BuildContext context) async {
    bool _isUserLoggedIn = await AppUtils.isUserLoggedIn() == null
        ? false
        : await AppUtils.isUserLoggedIn();

    if (!_isUserLoggedIn) {
      ConfirmAction confirmAction = await showAlertWithTwoButton(
          context,
          'To suggest category you need to login.\n\n Do you want to login?',
          'No',
          'Yes');
      if (confirmAction == ConfirmAction.ACCEPT) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
      }
      return;
    }
    _suggestTextController.text = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 230,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SUGGEST CATEGORY',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _suggestTextController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: new OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.2),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        hintText: 'Which category you would like us to add?',
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Container(
                        height: 50,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: AppColors().kPrimaryColor)),
                            onPressed: () {
                              if (_suggestTextController.text.length == 0) {
                                return;
                              }
                              Navigator.pop(context);
                              _suggestCategoryBloc
                                  .suggestCategory(_suggestTextController.text);
                            },
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(color: AppColors().kBlackColor),
                            ),
                            color: AppColors().kPrimaryColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Column buildCategoryRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('Categories'),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors().kBlackColor),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                widget.restaurantDetailModel.restaurantDetail[0].categoryName ==
                        null
                    ? ''
                    : widget
                        .restaurantDetailModel.restaurantDetail[0].categoryName,
                textAlign: TextAlign.end,
              ))
            ],
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: InkWell(
        //         onTap: () {
        //           showCategoryDialog(context);
        //         },
        //         child: Text(
        //             AppLocalizations.of(context).translate('Suggest Category'),
        //             style: TextStyle(
        //                 color: AppColors().kPrimaryColor,
        //                 fontWeight: FontWeight.w600,
        //                 decoration: TextDecoration.underline)),
        //       ),
        //     ),
        //   ],
        // ),
        Divider()
      ],
    );
  }

  Widget buildOpenCloseTimeWidget() {
    if (widget.restaurantDetailModel.openclosetime.length == 0) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Monday'),
              Text(widget.restaurantDetailModel.openclosetime.first
                              .monopenTime ==
                          "" ||
                      widget.restaurantDetailModel.openclosetime.first
                              .monopenTime ==
                          null
                  ? 'closed'
                  : '${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.monopenTime)} - ${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.moncloseTime)}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Tuesday'),
              Text(widget.restaurantDetailModel.openclosetime.first
                              .tueopenTime ==
                          "" ||
                      widget.restaurantDetailModel.openclosetime.first
                              .tueopenTime ==
                          null
                  ? 'closed'
                  : '${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.tueopenTime)} - ${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.tuecloseTime)}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Wednesday'),
              Text(widget.restaurantDetailModel.openclosetime.first
                              .wedopenTime ==
                          "" ||
                      widget.restaurantDetailModel.openclosetime.first
                              .wedopenTime ==
                          null
                  ? 'closed'
                  : '${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.wedopenTime)} - ${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.wedcloseTime)}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Thursday'),
              Text(widget.restaurantDetailModel.openclosetime.first
                              .thuopenTime ==
                          "" ||
                      widget.restaurantDetailModel.openclosetime.first
                              .thuopenTime ==
                          null
                  ? 'closed'
                  : '${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.thuopenTime)} - ${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.thucloseTime)}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Friday'),
              Text(widget.restaurantDetailModel.openclosetime.first
                              .friopenTime ==
                          "" ||
                      widget.restaurantDetailModel.openclosetime.first
                              .friopenTime ==
                          null
                  ? 'closed'
                  : '${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.friopenTime)} - ${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.fricloseTime)}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Saturday'),
              Text(widget.restaurantDetailModel.openclosetime.first
                              .satopenTime ==
                          "" ||
                      widget.restaurantDetailModel.openclosetime.first
                              .satopenTime ==
                          null
                  ? 'closed'
                  : '${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.satopenTime)} - ${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.satcloseTime)}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Sunday'),
              Text(widget.restaurantDetailModel.openclosetime.first
                              .sunopenTime ==
                          "" ||
                      widget.restaurantDetailModel.openclosetime.first
                              .sunopenTime ==
                          null
                  ? 'closed'
                  : '${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.sunopenTime)} - ${get24HourTIme(widget.restaurantDetailModel.openclosetime.first.thucloseTime)}')
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  String getOpenClosidngTimeDayWise(Openclosetime openclosetime) {
    return 'Monday         ${openclosetime.monopenTime} - ${openclosetime.moncloseTime}\nTuesday         ${openclosetime.tueopenTime} - ${openclosetime.tuecloseTime}\nWednesday   ${openclosetime.wedopenTime} - ${openclosetime.wedcloseTime}\nThursday       ${openclosetime.thuopenTime} - ${openclosetime.thucloseTime}\nFriday            ${openclosetime.friopenTime} - ${openclosetime.fricloseTime}\nSaturday       ${openclosetime.satopenTime} - ${openclosetime.satcloseTime}\nSunday           ${openclosetime.sunopenTime} - ${openclosetime.suncloseTime}';
  }

  List<Widget> getOpenClosingTimeDayWise(Openclosetime openclosetime) {
    return [
      Row(
        children: <Widget>[
          Text('Monday'),
          Text('${openclosetime.monopenTime} - ${openclosetime.moncloseTime}')
        ],
      ),
      Row(
        children: <Widget>[
          Text('Monday'),
          Text('${openclosetime.monopenTime} - ${openclosetime.moncloseTime}')
        ],
      ),
      Row(
        children: <Widget>[
          Text('Monday'),
          Text('${openclosetime.monopenTime} - ${openclosetime.moncloseTime}')
        ],
      ),
      Row(
        children: <Widget>[
          Text('Monday'),
          Text('${openclosetime.monopenTime} - ${openclosetime.moncloseTime}')
        ],
      ),
      Row(
        children: <Widget>[
          Text('Monday'),
          Text('${openclosetime.monopenTime} - ${openclosetime.moncloseTime}')
        ],
      ),
      Row(
        children: <Widget>[
          Text('Monday'),
          Text('${openclosetime.monopenTime} - ${openclosetime.moncloseTime}')
        ],
      ),
      Row(
        children: <Widget>[
          Text('Monday'),
          Text('${openclosetime.monopenTime} - ${openclosetime.moncloseTime}')
        ],
      ),
    ];
  }

  String get24HourTIme(String value) {
    DateTime datetime = DateTime(2020, 1, 1, int.parse(value.split(":")[0]),
        int.parse(value.split(":")[1]));
    DateFormat dateFormat = DateFormat('hh:mm a');
    return dateFormat.format(datetime);
  }

  String getRateDollarSymbol(dynamic data) {
    if (data == null) {
      return "\$";
    }

    try {
      var price = int.parse(data);
      if (price <= 10) {
        return "\$";
      } else if (price > 10 && price <= 25) {
        return "\$\$";
      } else if (price > 26 && price <= 50) {
        return "\$\$\$";
      } else {
        return "\$\$\$\$";
      }
    } catch (e) {
      return "\$";
    }
  }
}
