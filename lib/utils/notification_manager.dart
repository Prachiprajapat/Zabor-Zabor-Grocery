import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
 
  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
    
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

  }

  Future<String> getToken() async{
    return await _firebaseMessaging.getToken();
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
