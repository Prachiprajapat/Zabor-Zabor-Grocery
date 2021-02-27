import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/home/widgets/restaurant_carview.dart';
import 'package:zabor/screens/restuarant_gallery_screen/bloc/bloc.dart';
import 'package:zabor/utils/bloc_state.dart';

import 'model/model.dart';

class RestaurantGalleryScreen extends StatefulWidget {
  final int restId;
  const RestaurantGalleryScreen({Key key, @required this.restId})
      : super(key: key);
  @override
  _RestaurantGalleryScreenState createState() =>
      _RestaurantGalleryScreenState();
}

class _RestaurantGalleryScreenState extends State<RestaurantGalleryScreen> {
  RestaurantGalleryBloc _restaurantGalleryBloc;
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool _isCall = true;
  List<Gallery> gallery = [];
  @override
  void initState() {
    super.initState();
    _restaurantGalleryBloc = RestaurantGalleryBloc();
    _restaurantGalleryBloc.getGallery(widget.restId, _page);

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page = _page + 1;
        print(_page);
        if (_isCall) {
          List<Gallery> tempGallery = await _restaurantGalleryBloc
              .loadMoreGallery(widget.restId, _page);
          setState(() {
            gallery.addAll(tempGallery);
            if (tempGallery.length < 10) {
              _isCall = false;
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _restaurantGalleryBloc.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                navBar(context),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder<BlocState>(
                    stream: _restaurantGalleryBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data is BlocLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data is GalleryDataState) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          GalleryDataState state = snapshot.data;
                          setState(() {
                            gallery = state.data;
                          });
                        });
                        return buildGallery(gallery);
                      }

                      if (snapshot.data is BlocFailureState) {
                        BlocFailureState state = snapshot.data;
                        return Text(
                            state.message == null ? 'No Data' : state.message);
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded buildGallery(List<Gallery> gallery) {
    return Expanded(
      child: GridView.count(
        controller: _scrollController,
        crossAxisCount: 2,
        children: List.generate(gallery.length + 1, (index) {
          return index == gallery.length ? Center(child: _isCall ? CircularProgressIndicator() : Container()) :
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageDetailScreen(
                          url: baseUrl +
                              (gallery[index].image == null
                                  ? ''
                                  : gallery[index].image),
                          tag: '$index')));
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: '$index',
                    child: CachedNetworkImage(
                      imageUrl: baseUrl +
                          (gallery[index].image == null
                              ? ''
                              : gallery[index].image),
                      placeholder: (context, url) =>
                          new CircularBarIndicatorContainer(
                        height: 160,
                        width: 160,
                      ),
                      errorWidget: (context, url, error) =>
                          new ErrorImageContainer(
                        height: 160,
                        width: 160,
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  spreadRadius: 0.5,
                                  blurRadius: 5)
                            ],
                            image: DecorationImage(
                                fit: BoxFit.cover, image: imageProvider),
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
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
            Text(
              'GALLERY',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Check out photos of restuarant here',
              style: TextStyle(fontSize: 14, color: AppColors().kBlackColor),
            )
          ],
        ),
      ],
    );
  }
}

class ImageDetailScreen extends StatefulWidget {
  final String tag;
  final String url;

  ImageDetailScreen({Key key, @required this.tag, @required this.url})
      : assert(tag != null),
        assert(url != null),
        super(key: key);

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: CachedNetworkImage(
              imageUrl: widget.url,
              placeholder: (context, url) {
                return Center(
                    child: Container(
                        width: 32,
                        height: 32,
                        child: new CircularProgressIndicator()));
              },
              errorWidget: (context, url, error) {
                return Icon(Icons.error);
              },
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
