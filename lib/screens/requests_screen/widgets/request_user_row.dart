import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/friend_list/model/friend_list_model.dart';

class FriendRequestListRow extends StatefulWidget {
  const FriendRequestListRow({
    Key key,
    this.appUser, this.acceptedButtonPressed, this.ignoreButtonPressed,
  }) : super(key: key);
  final AppUser appUser;
  final Function acceptedButtonPressed;
  final Function ignoreButtonPressed;
  @override
  _FriendListRowState createState() => _FriendListRowState();
}

class _FriendListRowState extends State<FriendRequestListRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors().kWhiteColor,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Image.asset(
                'assets/images/friend_list_sections.png',
                fit: BoxFit.cover,
              ),
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
            ),
            Positioned(
              top: 5,
              left: 35,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: AppColors().kGreyColor200,
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider(baseUrl +
                              (widget.appUser.profileimage == null
                                  ? ''
                                  : widget.appUser.profileimage)),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            widget.appUser.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // buildFlatButtonFriendUnFriend(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildAccpetRejectButtons(widget.acceptedButtonPressed,widget.ignoreButtonPressed),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildAccpetRejectButtons(Function acceptButtonPressed, Function rejectButtonPressed) {
    return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: acceptButtonPressed,
                                          child: Container(child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                        child: Text('Accept',style: TextStyle(
                          color: AppColors().kWhiteColor
                        ),),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors().kGreenColor,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      ),
                    ),
                    GestureDetector(
                      onTap: rejectButtonPressed,
                                          child: Container(child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                        child: Text('Ignore'),
                      )),
                    )
                  ],
                );
  }

  FlatButton buildFlatButtonFriendUnFriend() {
    return FlatButton(
      child: Text('UNFRIEND'),
      onPressed: () {},
      shape: RoundedRectangleBorder(
          side: BorderSide(), borderRadius: BorderRadius.circular(5)),
    );
  }
}
