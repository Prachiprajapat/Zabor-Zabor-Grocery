import 'package:flutter/material.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/restaurant_detail/widgets/resturant_photo_card_view.dart';


const images = [
  'assets/images/rest2.jpg',
  'assets/images/rest6.jpg',
  'assets/images/rest7.jpg',
  'assets/images/rest8.jpg'
];

class PhotoViewWidget extends StatelessWidget {
  const PhotoViewWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors().kGreyColor100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Container(
          height: 180,
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Photos',
                style: TextStyle(fontSize: 16, color: AppColors().kBlackColor),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) => ResturantPhotoCardView(
                    imgURL: images[index],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}