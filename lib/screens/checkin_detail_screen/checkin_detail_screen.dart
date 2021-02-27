import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/checkin_detail_screen/bloc/bloc.dart';
import 'package:zabor/screens/home/widgets/restaurant_carview.dart';
import 'package:zabor/screens/login_signup/login_signup.dart';
import 'package:zabor/screens/map_full_screen/map_full_screen.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';
import 'package:zabor/screens/restaurant_detail/widgets/detail_restaurant_row.dart';
import 'package:zabor/screens/restuarant_gallery_screen/restuant_gallery_screen.dart';
import 'package:zabor/utils/bloc_state.dart';

class CheckinDetailScreen extends StatefulWidget {
  final int restId;
  const CheckinDetailScreen({Key key, @required this.restId}) : super(key: key);
  @override
  _CheckinDetailScreenState createState() => _CheckinDetailScreenState();
}

class _CheckinDetailScreenState extends State<CheckinDetailScreen> {
  CheckinDetailBloc _checkinDetailBloc;

   Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

        Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; 

  @override
  void initState() {
    super.initState();
    _checkinDetailBloc = CheckinDetailBloc();
    _checkinDetailBloc.getDetail(widget.restId);
    _add();
  }

  @override
  void dispose() {
    super.dispose();
    _checkinDetailBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BlocState>(
          stream: _checkinDetailBloc.stream,
          builder: (context, snapshot) {
            if (snapshot.data is BlocLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data is BlocAuthErrorState) {
              return showMessage(sessionExpiredText, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginSignupScreen()));
              }, false);
            }

            if (snapshot.data is BlocFailureState) {
              BlocFailureState state = snapshot.data;
              return showMessage(state.message, () {
                _checkinDetailBloc.getDetail(widget.restId);
              }, false);
            }

            if (snapshot.data is RestaurantDetailState) {
              RestaurantDetailState state = snapshot.data;
              if (state.data == null ||
                  state.data.restaurantDetail.length == 0) {
                return Center(
                  child: Text('No detail Found'),
                );
              }
              return buildDetailBody(state.data);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  CustomScrollView buildDetailBody(
      RestaurantDetailModel restaurantDetailModel) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            backgroundColor: AppColors().kPrimaryColor,
            expandedHeight: 250.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 50,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 70,
                  ),
                  Expanded(
                    child: Text(
                        restaurantDetailModel
                                    .restaurantDetail.first.restaurantName ==
                                null
                            ? ''
                            : restaurantDetailModel
                                .restaurantDetail.first.restaurantName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                  ),
                ],
              ),
              background: CachedNetworkImage(
                imageUrl: baseUrl +
                    (restaurantDetailModel
                                .restaurantDetail.first.restaurantpic ==
                            null
                        ? ''
                        : restaurantDetailModel
                            .restaurantDetail.first.restaurantpic),
                placeholder: (context, url) =>
                    new CircularBarIndicatorContainer(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                ),
                errorWidget: (context, url, error) => new ErrorImageContainer(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                ),
                imageBuilder: (context, imageProvider) => Container(
                  height: 250,
                  decoration: BoxDecoration(
                      color: AppColors().kPrimaryColor,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )),
        SliverList(
            delegate: new SliverChildListDelegate(
                _buildDetails(restaurantDetailModel))),
      ],
    );
  }

  List<Widget> _buildDetails(RestaurantDetailModel restaurantDetailModel) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          DetailRestaurantRow(
            title: 'Call',
            description:
                restaurantDetailModel.restaurantDetail.first.contact == null
                    ? ''
                    : restaurantDetailModel.restaurantDetail.first.contact,
          ),
          DetailRestaurantRow(
            title: 'Address',
            description:
                restaurantDetailModel.restaurantDetail.first.address == null
                    ? ''
                    : restaurantDetailModel.restaurantDetail.first.address,
          ),
          DetailRestaurantRow(
            title: 'Average Cost',
            description:
                restaurantDetailModel.restaurantDetail.first.avgCost == null
                    ? ''
                    : '${restaurantDetailModel.restaurantDetail.first.avgCost}',
          ),
          DetailRestaurantRow(title: 'Opening Closing Time', description: ''),
          buildOpenCloseTimeWidget(restaurantDetailModel),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantGalleryScreen(
                            restId:
                                restaurantDetailModel.restaurantDetail.first.id,
                          )));
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
                        'View Restaurant Gallery',
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
          //new PhotoViewWidget(),
          Container(
            height: 280,
            decoration: BoxDecoration(color: AppColors().kPrimaryColor),
            child: Stack(
              children: <Widget>[
                GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: Set<Marker>.of(markers.values),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MapFullScreen1(
                        restName: "${restaurantDetailModel.restaurantDetail.first.restaurantName == null
                    ? ''
                    : restaurantDetailModel.restaurantDetail.first.restaurantName}",
                      )));
                    },
                    child: Container(color: Colors.transparent,))
              ],
            ),
          )
        ],
      ),
    ];
  }

  Widget buildOpenCloseTimeWidget(RestaurantDetailModel restaurantDetailModel) {
    if (restaurantDetailModel.openclosetime.length == 0) {
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
              Text(
                  '${restaurantDetailModel.openclosetime.first.monopenTime} - ${restaurantDetailModel.openclosetime.first.moncloseTime}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Tuesday'),
              Text(
                  '${restaurantDetailModel.openclosetime.first.tueopenTime} - ${restaurantDetailModel.openclosetime.first.tuecloseTime}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Wednesday'),
              Text(
                  '${restaurantDetailModel.openclosetime.first.wedopenTime} - ${restaurantDetailModel.openclosetime.first.wedcloseTime}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Thursday'),
              Text(
                  '${restaurantDetailModel.openclosetime.first.thuopenTime} - ${restaurantDetailModel.openclosetime.first.thucloseTime}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Friday'),
              Text(
                  '${restaurantDetailModel.openclosetime.first.friopenTime} - ${restaurantDetailModel.openclosetime.first.fricloseTime}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Saturday'),
              Text(
                  '${restaurantDetailModel.openclosetime.first.satopenTime} - ${restaurantDetailModel.openclosetime.first.satcloseTime}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Sunday'),
              Text(
                  '${restaurantDetailModel.openclosetime.first.sunopenTime} - ${restaurantDetailModel.openclosetime.first.thucloseTime}')
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
  
    void _add() {
    final MarkerId markerId = MarkerId('marker');

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        37.43296265331129,
        -122.08832357078792,
      ),
      infoWindow: InfoWindow(title: 'marker', snippet: '*'),
      onTap: () {
        print('tappeed');
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }
}
