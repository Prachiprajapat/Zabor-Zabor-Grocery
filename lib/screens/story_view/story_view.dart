import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/screens/home/models/advert_response_model.dart';
import 'package:zabor/screens/home/models/home_screen_response_model.dart';
import 'package:zabor/screens/restaurant_detail/restaurant_detail_screen.dart';

class StoryViewScreen extends StatefulWidget {
  final AdvertData advertData;

  const StoryViewScreen({Key key, @required this.advertData}) : super(key: key);
  @override
  _StoryViewScreenState createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  final storyController = StoryController();
  AdvertData get _advertData => widget.advertData;
  List<StoryItem> storyItems = [];
  StoryItem _onGoingStory;

  @override
  void initState() {
    super.initState();
    populateStoryData();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: <Widget>[
      //     IconButton(icon: Icon(Icons.cancel), onPressed: (){})
      //   ],
      // ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            StoryView(
                storyItems: storyItems,
                onStoryShow: (s) {
                  print("Showing a story");
                  _onGoingStory = s;
                },
                onComplete: () {
                  print("Completed a cycle");
                  Navigator.pop(context);
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                controller: storyController,
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                  if (direction == Direction.up) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantDetailScreen(
                                  restuarantModel: RestaurantModel(
                                      id: _advertData
                                          .data[
                                              storyItems.indexOf(_onGoingStory)]
                                          .restaurantId,
                                      name: _advertData
                                          .data[
                                              storyItems.indexOf(_onGoingStory)]
                                          .name,
                                      address: _advertData
                                          .data[
                                              storyItems.indexOf(_onGoingStory)]
                                          .address,
                                      restaurantpic: _advertData
                                              .data[storyItems
                                                  .indexOf(_onGoingStory)]
                                              .restaurantpic ??
                                          _advertData
                                              .data[storyItems
                                                  .indexOf(_onGoingStory)]
                                              .videoThumb),
                                )));
                  }
                }),
            Positioned.fill(
                child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Swipe Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  populateStoryData() {
    storyItems = [];
    if (_advertData.type == 1) {
      // Video
      for (Advert advert in _advertData.data) {
        storyItems.add(StoryItem.pageVideo(baseUrl + advert.video ?? '',
            controller: storyController));
      }
    } else {
      //image
      for (Advert advert in _advertData.data) {
        storyItems.add(StoryItem.pageImage(
            controller: storyController, url: baseUrl + advert.pic ?? ''));
      }
    }
    setState(() {});
  }
}
