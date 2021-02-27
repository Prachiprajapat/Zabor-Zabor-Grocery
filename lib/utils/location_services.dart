import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

Position position;

Future<Position> getCurrentPosition() async {
  try {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  } on PlatformException catch (e) {
    return null;
    //handleLocationException(e);
  }
}

Coordinates getCoordinates(Position position) {
  try {
    final coordinates = new Coordinates(position.latitude, position.longitude);
    return coordinates;
  } on PlatformException catch (e) {
    return null;
    //handleLocationException(e);
  }
}

Future<Address> getAddressFromCoordinates(Coordinates coordinates) async {
  try {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  } on PlatformException catch (e) {
    return null;
    //handleLocationException(e);
  }
}

void handleLocationException(e) {
  if (e.code == 'PERMISSION_DENIED') {}
  if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {}
}
