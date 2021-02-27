import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/utils/location_services.dart';

class PlacePickerScreen extends StatefulWidget {
  const PlacePickerScreen({
    Key key,
  }) : super(key: key);
  @override
  _PlacePickerScreenState createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  Completer<GoogleMapController> _controller = Completer();

  double lat = 0.0;
  double long = 0.0;
  CameraPosition _placePostion;
  String _address = '';
  String _country = '';
  String _city = '';

  @override
  void initState() {
    super.initState();
    lat = position == null ? 0.0 : position.latitude.toDouble();
    long = position == null ? 0.0 : position.longitude.toDouble();
    _placePostion = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
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
        title: Text('Select Address'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, {
                'place': _address,
                'latlong': _placePostion,
                'country': _country,
                'city': _city
              });
            }),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              //markers: Set<Marker>.of(markers.values),
              onCameraMove: (postion) {
                print(postion);
                getPlaceName(postion);
              },
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 0.2,
                            blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(15))),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: AppColors().kPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 15, right: 15, bottom: 30),
                  child: Text(
                    _address,
                    style:
                        TextStyle(color: AppColors().kWhiteColor, fontSize: 20),
                  ),
                )),
          )
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

  getPlaceName(CameraPosition placePostion) async {
    try {
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          placePostion.target.latitude, placePostion.target.longitude);
      print('subLocality ' + placemark.first.subLocality);
      print('name ' + placemark.first.name);
      print('locality ' + placemark.first.locality);
      print('city ' + placemark.first.subAdministrativeArea);
      String add = '';
      if (placemark.first.subLocality == placemark.first.name) {
        add += placemark.first.name;
      } else {
        add += (placemark.first.name + ' ${placemark.first.subLocality}');
      }

      add += ', ${placemark.first.locality}';
      print(add);

      setState(() {
        _address = add;
        _placePostion = placePostion;
        _country = placemark.first.country;
        _city = placemark.first.subAdministrativeArea;
      });
    } catch (e) {
      print(e);
    }
  }
}
