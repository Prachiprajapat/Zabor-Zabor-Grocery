import 'package:flutter/foundation.dart';

class GiveRatingProvider extends ChangeNotifier {
  double waiting = 0.0;
  double restroom = 0.0;
  double ambience = 0.0;
  double service = 0.0;
  double food = 0.0;
  double pricing = 0.0;
  double management = 0.0;
  double locality = 0.0;

  List<RatingRowModel> getRatings() {
    return [
      RatingRowModel('Waiting', waiting),
      RatingRowModel('Restrooms', restroom),
      RatingRowModel('Ambience', ambience),
      RatingRowModel('Service', service),
      RatingRowModel('Food', food),
      RatingRowModel('Pricing', pricing),
      RatingRowModel('Management', management),
      RatingRowModel('Locality', locality),
    ];
  }

  void resetRatings(){
   waiting = 0.0;
   restroom = 0.0;
   ambience = 0.0;
   service = 0.0;
   food = 0.0;
   pricing = 0.0;
   management = 0.0;
   locality = 0.0;
  }

  void setRatings(int index, double rating) {
    switch (index) {
      case 0:
        waiting = rating;
        break;
      case 1:
        restroom = rating;
        break;
      case 2:
        ambience = rating;
        break;
      case 3:
        service = rating;
        break;
      case 4:
        food = rating;
        break;
      case 5:
        pricing = rating;
        break;
      case 6:
        management = rating;
        break;
      case 7:
        locality = rating;
        break;
    }
  notifyListeners();
  }
}

class RatingRowModel {
  String ratingType;
  double rating;

  RatingRowModel(this.ratingType, this.rating);
}
