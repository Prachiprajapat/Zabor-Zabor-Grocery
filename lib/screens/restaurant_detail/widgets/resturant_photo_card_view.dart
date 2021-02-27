import 'package:flutter/material.dart';

class ResturantPhotoCardView extends StatelessWidget {
  const ResturantPhotoCardView({
    Key key, this.imgURL,
  }) : super(key: key);

  final String imgURL;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 2),
                  spreadRadius: 1,
                  color: Colors.black26,
                  blurRadius: 0.5)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 160,
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imgURL),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Food',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
