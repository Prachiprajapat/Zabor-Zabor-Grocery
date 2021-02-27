import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/checkin_screen/services/checkin_services.dart';
import 'package:zabor/screens/home/homescreen.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/screens/share_feedback/share_feedback_screen.dart';

class CheckinScreen extends StatefulWidget {
  final RestaurantDetail restaurantDetail;

  const CheckinScreen({Key key, @required this.restaurantDetail})
      : super(key: key);

  @override
  _CheckinScreenState createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  String _restName = '';
  String _restAddress = '';
  String _comment = '';

  final restNameController = TextEditingController();
  final restAddressController = TextEditingController();
  File _image;
  String _dummyImageName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _restName = widget.restaurantDetail.restaurantName == null
        ? ''
        : widget.restaurantDetail.restaurantName;

    _restAddress = widget.restaurantDetail.address == null
        ? ''
        : widget.restaurantDetail.address;

    restNameController.text = _restName;
    restAddressController.text = _restAddress;
  }

  _btnSubmitPressed() async {
    print('$_restAddress $_restName $_comment');
    if (_comment.length == 0) {
      _showSnackBar(context, 'please enter comment');
      return;
    }

    if (_image == null) {
      _showSnackBar(context, 'please select image');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    CheckinService checkinService = CheckinService();
    User userModel = await AppUtils.getUser();
    int userId = userModel.id;
    int restId = widget.restaurantDetail.id;
    ApiResponse apiResponse =
        await checkinService.postCheckIn(userId, restId, _comment, _image);
    setState(() {
      _isLoading = false;
    });
    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        final _ = await showAlert(context, sessionExpiredText);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()));
        return;
      }
      _showSnackBar(context, apiResponse.message);
      return;
    }

    final _ = await showAlert(context, apiResponse.data);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _showSnackBar(BuildContext context, String errorMessage) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(errorMessage),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'CHECK-IN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Please fill the check-in details below.',
                        style: TextStyle(
                            fontSize: 14, color: AppColors().kBlackColor),
                      )
                    ],
                  ),
                ],
              ),
              RoundedTextField(
                controller: restNameController,
                enabled: false,
                hintText: 'Restaurant Name',
                onTextChanged: (text) {
                  setState(() {
                    _restName = text;
                  });
                },
              ),
              RoundedTextField(
                controller: restAddressController,
                enabled: false,
                hintText: 'Restaurant Address',
                onTextChanged: (text) {
                  setState(() {
                    _restAddress = text;
                  });
                },
              ),
              FeedbackContentWidget(
                  hintText: 'Comment',
                  onTextChanged: (text) {
                    setState(() {
                      _comment = text;
                    });
                  }),
              Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        getImage();
                      },
                      child: Text(_dummyImageName ?? "Select Image")),
                  _image == null
                      ? Container()
                      : IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              _dummyImageName = null;
                              _image = null;
                            });
                          })
                ],
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ButtonWidget(
                      onPressed: () {
                        _btnSubmitPressed();
                      },
                      title: 'SUBMIT',
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text('Choose Options'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: const Text('Camera'),
                    onPressed: () async {
                      Navigator.pop(context);
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.camera);

                      setState(() {
                        _dummyImageName = "${Random().nextInt(9999)}.jpg";
                        _image = image;
                      });
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Gallery'),
                    onPressed: () async {
                      Navigator.pop(context);
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);

                      setState(() {
                        _dummyImageName = "${Random().nextInt(9999)}.jpg";
                        _image = image;
                      });
                    },
                  )
                ]));
  }
}
