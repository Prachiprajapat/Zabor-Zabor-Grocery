import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/utils/k3webservice.dart';
import 'model/static_page_model.dart';

class StaticPageScreen extends StatefulWidget {
  final String title;
  final String description;
  final int id;
  const StaticPageScreen(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.id})
      : super(key: key);
  @override
  _StaticPageScreenState createState() => _StaticPageScreenState();
}

class _StaticPageScreenState extends State<StaticPageScreen> {
  String _content = '';
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    callStaticPageApi();
  }

  callStaticPageApi() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse<StaticPageResponse> apiResponse =
        await K3Webservice.getMethod<StaticPageResponse>(
            '${apisToUrls(Apis.staticPage)}' + '${widget.id}', null);
    setState(() {
      _isLoading = false;
    });
    if (apiResponse.error) {
      return;
    }

    print(apiResponse.data.data.resp.first.content);
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      setState(() {
        _content = apiResponse.data.data.resp.first.content;
      });
    } else {
      if (prefs.getString('language_code') == "es") {
        setState(() {
          _content = apiResponse.data.data.resp.first.content_es ?? apiResponse.data.data.resp.first.content;
        });
      } else {
        setState(() {
          _content = apiResponse.data.data.resp.first.content ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      AppLocalizations.of(context).translate(widget.title),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate(widget.description),
                      style: TextStyle(
                          fontSize: 14, color: AppColors().kBlackColor),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: <Widget>[
                          Html(
                            data: _content,
                            padding: EdgeInsets.all(8.0),
                            onLinkTap: (url) {
                              print("Opening $url...");
                            },
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
