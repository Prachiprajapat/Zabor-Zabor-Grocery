import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/app_utils.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/edit_profile/services/edit_profile_services.dart';
import 'package:zabor/screens/home/widgets/restaurant_carview.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/login_signup/model/model.dart';
import 'package:zabor/screens/place_picker_screen/place_picker_screen.dart';
import 'package:zabor/screens/profile/profile_screen.dart';
import 'package:zabor/utils/utils.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name = '';
  String _email = '';
  String _address = '';
  String _phone = '';
  String _dob = '';
  String _about = '';
  String _prefLang = 'English';
  String _profileImageUrl;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final aboutController = TextEditingController();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  File _image;
  bool _isLoading = false;
  DateTime selectedDate;
  DateTime initialDate = DateTime.now();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bg.png'),
                          fit: BoxFit.cover)),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset('assets/images/back.png'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              'MY DETAILS',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors().kWhiteColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          child: Container(
                            height: 240,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  right: 0,
                                  left: 0,
                                  top: 40,
                                  bottom: 0,
                                  child: Image.asset(
                                    'assets/images/curve.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                _image == null
                                    ? Positioned(
                                        top: 0,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        child: GestureDetector(
                                          onTap: () {
                                            getImage();
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                baseUrl + _profileImageUrl,
                                            placeholder: (context, url) =>
                                                new CircularBarIndicatorContainer(
                                              height: 100,
                                              width: 100,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new ProfileErrorWidget(),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: AppColors()
                                                          .kPrimaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: imageProvider)),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Positioned(
                                        top: 0,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        child: GestureDetector(
                                          onTap: () {
                                            getImage();
                                          },
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: AppColors()
                                                      .kPrimaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  FileImage(_image),
                                            ),
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  top: 110,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15,
                                      ),
                                      new ProfileUserInfoWidget(
                                        nameController: nameController,
                                        phoneController: phoneController,
                                        hintText: 'Enter name here',
                                        nameOnChange: (text) {
                                          _name = text;
                                        },
                                        phoneOnChange: (text) {
                                          _phone = text;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: AppColors().kWhiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ProfileEditRow(
                                title: 'Email Address',
                                enabled: false,
                                initalValue: _email,
                                hintText: 'Enter Email',
                                controller: emailController,
                                onChange: (text) {
                                  _email = text;
                                },
                              ),
                              Divider(),
                              InkWell(
                                onTap: () async {
                                  dynamic data = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlacePickerScreen()));
                                  String place = data['place'];
                                  String city = data['city'];
                                  print(place);
                                  setState(() {
                                    addressController.text = place;
                                    _address = place;
                                    subAdminstrativeArea = city;
                                  });
                                },
                                child: ProfileEditRow(
                                  title: 'Address',
                                  enabled: false,
                                  initalValue: _address,
                                  hintText: 'Enter Address',
                                  controller: addressController,
                                  onChange: (text) {
                                    _address = text;
                                  },
                                ),
                              ),
                              Divider(),
                              InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: ProfileEditRow(
                                  enabled: false,
                                  title: 'Date of Birth',
                                  initalValue: _dob,
                                  hintText: 'Enter Date of Birth',
                                  controller: dobController,
                                  onChange: (text) {
                                    _dob = text;
                                  },
                                ),
                              ),
                              Divider(),
                              ProfileEditRow(
                                title: 'About',
                                initalValue: _about,
                                hintText: 'Enter About something about you',
                                controller: aboutController,
                                onChange: (text) {
                                  _about = text;
                                },
                              ),
                              Divider(),
                              FormBuilder(
                                key: _fbKey,
                                initialValue: {'lang': _prefLang},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 130,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Preferred Language for emails',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors().kBlackColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: FormBuilderDropdown(
                                      attribute: "lang",
                                      // initialValue: 'Male',
                                      hint: Text('Select Language'),
                                      validators: [
                                        FormBuilderValidators.required()
                                      ],
                                      items: ['English', 'Spanish']
                                          .map((lang) => DropdownMenuItem(
                                              value: lang,
                                              child: Text("$lang")))
                                          .toList(),
                                    ))
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: FlatButton(
                                    color: AppColors().kPrimaryColor,
                                    child: Text(
                                      'SUBMIT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    onPressed: () {
                                      if (_fbKey.currentState
                                          .saveAndValidate()) {
                                        print(_fbKey.currentState.value);
                                        _prefLang =
                                            _fbKey.currentState.value['lang'];
                                        callUpdateProfile();
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          color: AppColors().kWhiteColor,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate == null ? initialDate : selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(3101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
        _dob = DateFormat('yyyy-MM-dd').format(selectedDate);
        dobController.text = _dob;
      });
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
                        _image = image;
                      });
                    },
                  )
                ]));
  }

  void callUpdateProfile() async {
    setState(() {
      _isLoading = true;
    });
    UpdateProfileService updateProfileService = UpdateProfileService();
    User userModel = await AppUtils.getUser();
    int userId = userModel.id;
    String prefLang = 'en';

    if (_prefLang.toLowerCase() == 'spanish') {
      prefLang = 'es';
    }
    ApiResponse apiResponse = await updateProfileService.updateProfile(
        _name,
        _email,
        subAdminstrativeArea ?? '',
        _address,
        _dob,
        _about,
        _phone,
        userId,
        _image,
        prefLang);

    setState(() {
      _isLoading = false;
    });

    print(apiResponse);
    if (apiResponse.error) {
      if (apiResponse.message == sessionExpiredText) {
        showSnackBar(
            _scaffoldkey,
            sessionExpiredText,
            SnackBarAction(
              label: 'Login',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginSignupScreen()));
              },
            ));
        return;
      }
      _showSnackbar(context, apiResponse.message);
      return;
    } else {
      AppUtils.saveUser(apiResponse.data);
      print("User Saved");
      _getUserDetails();
      _showSnackbar(context, 'Profile updated successfully');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  _getUserDetails() async {
    User user = await AppUtils.getUser();
    setState(() {
      _name = user.name == null ? '' : user.name;
      _email = user.email == null ? '' : user.email;
      _address = user.address == null ? '' : user.address;
      _dob = user.dob == null ? '' : user.dob.toString().split('T').first;
      _about = user.about == null ? '' : user.about;
      _profileImageUrl = user.profileimage == null ? '' : user.profileimage;
      _phone = user.phone == null ? '' : user.phone;
      nameController.text = _name;
      emailController.text = _email;
      addressController.text = _address;
      dobController.text = _dob;
      aboutController.text = _about;
      phoneController.text = _phone;
      if (user.prefLang != null) {
        if (user.prefLang.contains('en')) {
          _prefLang = 'English';
        }

        if (user.prefLang.contains('es')) {
          _prefLang = 'Spanish';
        }
      }
    });
  }
}

class ProfileEditRow extends StatelessWidget {
  const ProfileEditRow({
    Key key,
    this.title,
    this.initalValue,
    this.hintText,
    this.controller,
    this.onChange,
    this.enabled,
  }) : super(key: key);

  final String title;
  final String initalValue;
  final String hintText;
  final TextEditingController controller;
  final Function onChange;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 130,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors().kBlackColor),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            enabled: enabled,
            controller: controller,
            onChanged: onChange,
            maxLines: null,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
            style: TextStyle(color: AppColors().kBlackColor),
          ),
        )
      ],
    );
  }
}

class ProfileUserInfoWidget extends StatelessWidget {
  const ProfileUserInfoWidget({
    Key key,
    this.hintText,
    @required this.nameController,
    @required this.nameOnChange,
    @required this.phoneController,
    @required this.phoneOnChange,
  }) : super(key: key);

  final String hintText;
  final TextEditingController nameController;
  final Function nameOnChange;
  final TextEditingController phoneController;
  final Function phoneOnChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: TextField(
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            controller: nameController,
            onChanged: nameOnChange,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/map.png'),
            SizedBox(
              width: 10,
            ),
            Text(subAdminstrativeArea),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mobile.png'),
            SizedBox(
              width: 10,
            ),
            Container(
              child: TextField(
                maxLines: 1,
                controller: phoneController,
                onChanged: phoneOnChange,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  counterText: '',
                ),
                keyboardType: TextInputType.phone,
                maxLength: 13,
              ),
              height: 35,
              width: 150,
            ),
          ],
        ),
      ],
    );
  }
}
