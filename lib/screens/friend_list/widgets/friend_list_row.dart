import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zabor/constants/apis.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/friend_list/friend_list_model/friend_list_model.dart';
import 'package:zabor/screens/friend_list/model/friend_list_model.dart';

class FriendListRow extends StatefulWidget {
  final UserListEntryPoint userListEntryPoint;

  const FriendListRow({
    Key key,
    @required this.userListEntryPoint,@required this.appUser, this.sendRequestButtonPressed, this.unFriendButtonPressed,
  }) : super(key: key);

  final AppUser appUser;
  final Function sendRequestButtonPressed;
  final Function unFriendButtonPressed;
  @override
  _FriendListRowState createState() => _FriendListRowState();
}

class _FriendListRowState extends State<FriendListRow> {

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
              top: 12,
              left: 35,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                                      child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: AppColors().kGreyColor200,
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider(baseUrl + (widget.appUser.profileimage == null ? '' : widget.appUser.profileimage)),
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
                  widget.userListEntryPoint == UserListEntryPoint.profile
                      ? buildFlatButtonFriendUnFriend()
                      : buildFlatButtonSendFriendRequest(widget.sendRequestButtonPressed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlatButton buildFlatButtonFriendUnFriend() {
    return FlatButton(
      child: Text('UNFRIEND'),
      onPressed: widget.unFriendButtonPressed,
      shape: RoundedRectangleBorder(
          side: BorderSide(), borderRadius: BorderRadius.circular(5)),
    );
  }

  FlatButton buildFlatButtonSendFriendRequest(Function sendRequestButtonPressed) {
    return FlatButton(
      child: Text('SEND REQUEST'),
      onPressed: sendRequestButtonPressed,
      shape: RoundedRectangleBorder(
          side: BorderSide(), borderRadius: BorderRadius.circular(5)),
    );
  }
}
