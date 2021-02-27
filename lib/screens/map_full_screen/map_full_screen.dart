import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/restaurant_detail/models/restaurant_details_model.dart';

class MapFullScreen1 extends StatefulWidget {
  final String restName;
  final RestaurantDetailModel restaurantDetailModel;
  const MapFullScreen1(
      {Key key, @required this.restName, this.restaurantDetailModel})
      : super(key: key);
  @override
  _MapFullScreen1State createState() => _MapFullScreen1State();
}

class _MapFullScreen1State extends State<MapFullScreen1> {
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  Completer<GoogleMapController> _controller = Completer();

  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().kPrimaryColor,
        title: Text(widget.restName),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, long),
            zoom: 14.4746,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
          onCameraMove: (postion){
            print(postion);
          },
        ),
      ),
    );
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
}
