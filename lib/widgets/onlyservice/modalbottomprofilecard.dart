import 'package:beauty_app/providers/currentuser.dart';
import 'package:beauty_app/utilities/constans.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profilephotowithtext.dart';

class ModalBottomProfileCard extends StatelessWidget {
  String userId;
  String eventTitel;
  String appointmentStart;

  ModalBottomProfileCard(this.userId, this.eventTitel, this.appointmentStart);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<CurrentUser>(context, listen: false)
          .fetchUserDataById(userId),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<CurrentUser>(
                  builder: (ctx, anyUser, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ProfilePhotoWithText(anyUser.userdatabyid['username'],
                          eventTitel, anyUser.userdatabyid['userImage']),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text('Send message'),
                            onTap: () {
                              print('Send message');
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Call phone'),
                            onTap: () {
                              print('Call phone');
                            },
                          ),
                        ],
                      ),
                      RaisedButton(
                        child: const Text('Close'),
                        color: niceBlue,
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
    );
  }
}
