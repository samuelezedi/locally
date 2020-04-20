library locally;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Locally {

  String title;
  String body;
  String payload = 'test payload';
  ImageProvider image;
  String appIcon = 'ic_launcher';
  MaterialPageRoute pageRoute;
  BuildContext context;

  //local notification initialization
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingAndroid;
  var initializationSettingIos;
  var initializationSetting;

  Locally({this.title, this.body, this.context, this.pageRoute, this.payload, this.image, this.appIcon}) {

    initializationSettingAndroid = new AndroidInitializationSettings(this.appIcon);
    initializationSettingIos = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveNotification
    );
    initializationSetting = new InitializationSettings(initializationSettingAndroid, initializationSettingIos);
    localNotificationsPlugin.initialize(initializationSetting, onSelectNotification: onSelectNotification);

  }

  Future onSelectNotification(String payload) async {
    Navigator.of(context, rootNavigator: true).pop();
      await Navigator.push(context, pageRoute);
  }

  Future onDidReceiveNotification(id, title, body, payload) async {
    await showDialog(context: context,
        child: CupertinoAlertDialog(
          title: title,
          content: Text(body),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(context, pageRoute);
              },
            )
          ],
        )
    );
  }

  show() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.High,
        priority: Priority.High,
        ticker: 'test ticker'
    );

    var IOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, IOSPlatformChannelSpecifics);

    await localNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: payload);
  }

}