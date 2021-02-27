import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/timeline_screen/timeline_response_model.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'package:zabor/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Example6 extends StatefulWidget {
  final int orderId;
  const Example6({Key key, @required this.orderId}) : super(key: key);

  @override
  _Example6State createState() => _Example6State();
}

class _Example6State extends State<Example6> {
  bool _isLoading = false;
  bool _isOrderCancelled = false;
  bool _isRecieved = false;
  bool _isDelivered = false;
  bool _isPreparing = false;
  bool _isReady = false;
  bool _isPickup = false;
  String _receivedTime = '';
  String _preparingime = '';
  String _preparedTime = '';
  String _pickupTime = '';
  String _deliveredTime = '';
  String _cancelledTime = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<TimeLineData> _arrTimelineData = [];

  @override
  void initState() {
    super.initState();
    callTimelineApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate('Track Order').toUpperCase(),
        ),
        iconTheme: IconThemeData(color: AppColors().kBlackColor),
        textTheme: TextTheme(
            title: TextStyle(
                color: AppColors().kBlackColor,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              onPressed: () {
                callTimelineApi();
              })
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: TimelineTile(
                          beforeLineStyle: const LineStyle(
                            color: Colors.green,
                          ),
                          afterLineStyle: const LineStyle(
                            color: Colors.green,
                          ),
                          alignment: TimelineAlign.start,
                          isFirst: true,
                          indicatorStyle: IndicatorStyle(
                              width: 25,
                              color: _isRecieved ? Colors.green : Colors.grey),
                          endChild: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 120,
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.print,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate('Order Placed'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'We have received your order'),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text(_receivedTime,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )
                                  ]),
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      _isOrderCancelled
                          ? Container(
                              color: Colors.white,
                              child: TimelineTile(
                                beforeLineStyle: LineStyle(
                                  color:
                                      _isRecieved ? Colors.green : Colors.grey,
                                ),
                                afterLineStyle: LineStyle(
                                  color: Colors.grey,
                                ),
                                alignment: TimelineAlign.start,
                                indicatorStyle: IndicatorStyle(
                                    width: 25,
                                    color: _isOrderCancelled
                                        ? Colors.green
                                        : Colors.grey),
                                endChild: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 120,
                                    ),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FaIcon(
                                              FontAwesomeIcons
                                                  .exclamationTriangle,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    AppLocalizations.of(context)
                                                        .translate('Cancelled'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                                Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Your order has been cancelled'),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                Text(_cancelledTime,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          )
                                        ]),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        color: Colors.white,
                        child: TimelineTile(
                          beforeLineStyle: LineStyle(
                            color: _isOrderCancelled
                                ? Colors.grey
                                : _isRecieved
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                          afterLineStyle: LineStyle(
                            color: _isReady ? Colors.green : Colors.grey,
                          ),
                          alignment: TimelineAlign.start,
                          indicatorStyle: IndicatorStyle(
                              width: 25,
                              color: _isPreparing ? Colors.green : Colors.grey),
                          endChild: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 120,
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.boxOpen,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate('Preparing'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'We are preparing your order'),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text(_preparingime,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )
                                  ]),
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: TimelineTile(
                          beforeLineStyle: LineStyle(
                            color: _isPreparing ? Colors.green : Colors.grey,
                          ),
                          afterLineStyle: LineStyle(
                            color: _isPickup ? Colors.green : Colors.grey,
                          ),
                          alignment: TimelineAlign.start,
                          indicatorStyle: IndicatorStyle(
                              width: 25,
                              color: _isReady ? Colors.green : Colors.grey),
                          endChild: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 120,
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.gift,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate('Prepared'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'Your order is prepared and ready for pickup'),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text(_preparedTime,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )
                                  ]),
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: TimelineTile(
                          beforeLineStyle: LineStyle(
                            color: _isPreparing ? Colors.green : Colors.grey,
                          ),
                          afterLineStyle: LineStyle(
                            color: _isDelivered ? Colors.green : Colors.grey,
                          ),
                          alignment: TimelineAlign.start,
                          indicatorStyle: IndicatorStyle(
                              width: 25,
                              color: _isPickup ? Colors.green : Colors.grey),
                          endChild: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 120,
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.truckPickup,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate('Picked up'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'Your order has been picked up'),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text(_pickupTime,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )
                                  ]),
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: TimelineTile(
                          beforeLineStyle: LineStyle(
                            color: _isPickup ? Colors.green : Colors.grey,
                          ),
                          afterLineStyle: LineStyle(
                            color: _isDelivered ? Colors.green : Colors.grey,
                          ),
                          alignment: TimelineAlign.start,
                          indicatorStyle: IndicatorStyle(
                              width: 25,
                              color: _isDelivered ? Colors.green : Colors.grey),
                          isLast: true,
                          endChild: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 120,
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.checkDouble,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate('Delivered'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'Your order has been delivered'),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text(_deliveredTime,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )
                                  ]),
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> callTimelineApi() async {
    setState(() {
      _isLoading = true;
    });
    dynamic token = await AppUtils.getToken();
    User user = await AppUtils.getUser();
    dynamic lastOrderId = await AppUtils.getLastOrderId();
    ApiResponse<TimeLineRepsonseModel> apiResponse = await K3Webservice.getMethod(
        apisToUrls(Apis.getTimeLine) +
            '?user_id=${user == null ? -1 : user.id}&order_id=${user == null ? lastOrderId : widget.orderId}',
        {"Authorization": "Bearer $token", "Content-Type": "application/json"});
    setState(() {
      _isLoading = false;
    });
    if (apiResponse.error) {
      showSnackBar(_scaffoldKey, apiResponse.message, null);
      return;
    } else {
      setState(() {
        _arrTimelineData = apiResponse.data.data;
        //setTime();
        if (checkIfCancelled()) return;
        if (checkIfDelivered()) return;
        if (checkIfRecieved()) return;
        if (checkIfPreparing()) return;
        if (checkIfisPrepared()) return;
        if (checkIfisPickedup()) return;
      });
    }
  }

  bool checkIfCancelled() {
    for (TimeLineData data in _arrTimelineData) {
      if (data.status.toLowerCase() == "cancelled") {
        setState(() {
          _isRecieved = true;
          _isOrderCancelled = true;
          _isPreparing = false;
          _isReady = false;
          _isPickup = false;
          _isDelivered = false;
        });
        return true;
      }
    }
    return false;
  }

  setTime() {
    for (TimeLineData data in _arrTimelineData) {
      try {
        DateTime date2 = DateFormat("yyyy-MM-dd hh:mm a").parse(
            data.createdDate.toString().split(' ').first +
                ' ' +
                data.createdTime);
        print(date2);
        if (data.status.toLowerCase() == "received" ||
            data.status.toLowerCase() == "recieved") {
          setState(() {
            _receivedTime = timeago.format(date2);
          });
        }

        if (data.status.toLowerCase() == "preparing") {
          setState(() {
            if (data.cookingTime != null)
              _preparingime = "Preparing time: ${data.cookingTime} min";
          });
        }

        if (data.status.toLowerCase() == "ready") {
          setState(() {
            _preparedTime = timeago.format(date2);
          });
        }

        if (data.status.toLowerCase() == "pickup") {
          setState(() {
            _pickupTime = timeago.format(date2);
          });
        }

        if (data.status.toLowerCase() == "delivered") {
          setState(() {
            _deliveredTime = timeago.format(date2);
          });
        }

        if (data.status.toLowerCase() == "cancelled") {
          setState(() {
            _cancelledTime = timeago.format(date2);
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  bool checkIfRecieved() {
    for (TimeLineData data in _arrTimelineData) {
      if (data.status.toLowerCase() == "received" ||
          data.status.toLowerCase() == "recieved") {
        setState(() {
          _isRecieved = true;
          _isOrderCancelled = false;
          _isPreparing = false;
          _isReady = false;
          _isPickup = false;
          _isDelivered = false;
        });
        return true;
      }
    }
    return false;
  }

  bool checkIfPreparing() {
    for (TimeLineData data in _arrTimelineData) {
      if (data.status.toLowerCase() == "preparing") {
        setState(() {
          _isRecieved = true;
          _isOrderCancelled = false;
          _isPreparing = true;
          _isReady = false;
          _isPickup = false;
          _isDelivered = false;
        });
        return true;
      }
    }
    return false;
  }

  bool checkIfisPrepared() {
    for (TimeLineData data in _arrTimelineData) {
      if (data.status.toLowerCase() == "ready") {
        setState(() {
          _isRecieved = true;
          _isOrderCancelled = false;
          _isPreparing = true;
          _isReady = true;
          _isPickup = false;
          _isDelivered = false;
        });
        return true;
      }
    }
    return false;
  }

  bool checkIfisPickedup() {
    for (TimeLineData data in _arrTimelineData) {
      if (data.status.toLowerCase() == "pickup") {
        setState(() {
          _isRecieved = true;
          _isOrderCancelled = false;
          _isPreparing = true;
          _isReady = true;
          _isPickup = true;
          _isDelivered = false;
        });
        return true;
      }
    }
    return false;
  }

  bool checkIfDelivered() {
    for (TimeLineData data in _arrTimelineData) {
      if (data.status.toLowerCase() == "delivered") {
        setState(() {
          _isRecieved = true;
          _isOrderCancelled = false;
          _isPreparing = true;
          _isReady = true;
          _isPickup = true;
          _isDelivered = true;
        });
        return true;
      }
    }
    return false;
  }
}

class Example {
  const Example({this.name, this.description, this.code, this.child});

  final String name;
  final String description;
  final String code;
  final Widget child;
}
