import 'package:flutter/material.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/share_feedback/bloc/share_feedback_bloc.dart';

class ShareFeedbackScreen extends StatefulWidget {
  @override
  _ShareFeedbackScreenState createState() => _ShareFeedbackScreenState();
}

class _ShareFeedbackScreenState extends State<ShareFeedbackScreen> {
  String _comment = '';
  String _subject = '';
  ShareFeedBackBloc _shareFeedBackBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _feedBackController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _shareFeedBackBloc = ShareFeedBackBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _shareFeedBackBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: StreamBuilder<ShareFeedBackState>(
            stream: _shareFeedBackBloc.shareFeedBackStream,
            initialData: ShareFeedBackIntState(),
            builder: (context, snapshot) {
              if (snapshot.data is ShareFeedBackIntState) {
                return buildinitWidget(context);
              }

              if (snapshot.data is ShareFeedBackLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data is ShareFeedBackSuccessState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _subjectController.text = '';
                    _feedBackController.text = '';
                  });
                });
                ShareFeedBackSuccessState state = snapshot.data;
                return buildSuccessWidget(state);
              }

              if (snapshot.data is ShareFeedBackFailureState) {
                ShareFeedBackFailureState state = snapshot.data;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showSnackBar(context, state.message, null);
                });
                return buildinitWidget(context);
              }

              if (snapshot.data is ShareFeedBackAuthError) {
                ShareFeedBackAuthError state = snapshot.data;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showSnackBar(
                      context,
                      state.message,
                      SnackBarAction(
                        label: 'Login',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginSignupScreen()));
                        },
                      ));
                });
                return buildinitWidget(context);
              }
            }),
      ),
    );
  }

  SingleChildScrollView buildinitWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          buildInputWidget(context),
          buildButtonWidget(),
        ],
      ),
    );
  }

  Column buildInputWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        navBar(context),
        SizedBox(
          height: 20,
        ),
        RoundedTextField(
          enabled: true,
          hintText: AppLocalizations.of(context).translate('Subject'),
          controller: _subjectController,
          onTextChanged: (text) {
            setState(() {
              _subject = text;
            });
          },
        ),
        FeedbackContentWidget(
          hintText: AppLocalizations.of(context).translate('Write your feedback here'),
          controller: _feedBackController,
          onTextChanged: (text) {
            setState(() {
              _comment = text;
            });
          },
        ),
      ],
    );
  }

  ButtonWidget buildButtonWidget() {
    return ButtonWidget(
      title: AppLocalizations.of(context).translate('SUBMIT'),
      onPressed: () {
        _validate();
      },
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
            Text(AppLocalizations.of(context).translate('SHARE FEEDBACK')
              ,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  void _validate() {
    if (_subject.length == 0) {
      _showSnackBar(context, 'Please enter subject', null);
      return;
    }

    if (_comment.length == 0) {
      _showSnackBar(context, 'Please enter feedback', null);
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    _shareFeedBackBloc.postFeedBack(_subject, _comment);
  }

  void _showSnackBar(BuildContext context, String msg, SnackBarAction action) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(msg),
      action: action,
    ));
  }

  Center buildSuccessWidget(ShareFeedBackSuccessState state) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
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
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key key,
    this.title,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: FlatButton(
          color: AppColors().kPrimaryColor,
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class FeedbackContentWidget extends StatelessWidget {
  const FeedbackContentWidget({
    Key key,
    @required this.hintText,
    @required this.onTextChanged,
    this.controller,
  }) : super(key: key);
  final String hintText;
  final Function onTextChanged;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
            color: AppColors().kWhiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, spreadRadius: 0.5)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            onChanged: onTextChanged,
            expands: true,
            maxLines: null,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
            maxLength: 160,
          ),
        ),
      ),
    );
  }
}

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    Key key,
    @required this.onTextChanged,
    @required this.hintText,
    @required this.enabled,
    this.controller,
  }) : super(key: key);
  final Function onTextChanged;
  final String hintText;
  final bool enabled;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: AppColors().kWhiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, spreadRadius: 0.5)
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              onChanged: onTextChanged,
              enabled: enabled,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: hintText),
            ),
          ),
        ),
      ),
    );
  }
}
