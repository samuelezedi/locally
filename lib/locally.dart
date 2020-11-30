///  Locally is In-App Messaging package, it extends the flutter_local_notification
/// It is created by Samuel Ezedi to help developers create notification and blots out the hassle of strenuous
/// initialization, you really wouldn't not have to write a lot of code anymore

/// I invite you to clone the repo and make contributions, Thanks.

/// Copyright 2020. All rights reserved.
/// Use of this source code is governed by a BSD-style license that can be
/// found in the LICENSE file.

library locally;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Imports flutter_local_notification, our dependency package
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Locally class created
class Locally {
  /// A key identifier property is needed
  Key key;

  /// A String title for Notification
  String title;

  /// A String message
  String message;

  /// Payload for Navigation
  String payload;

  /// App Icon which is required on initialization
  String appIcon;

  /// id of each notification, add if you want multiple notifications.
  int id;

  /// called when notification is clicked.
  /// recieves a payload from show method
  Function(String payload) onSelectNotification;

  /// Callback for handling when a notification is triggered while the app is in the foreground
  /// this property is only applicable to iOS versions and older than 10
  /// mostly awaits a Dialog
  /// recieves id, title, body and payload respectively.
  Future<dynamic> Function(int id, String title, String body, String payload)
      onDidReceiveNotification;

  /// IOS Parameters, this is currently not in use but will be implemented in future releases
  bool iosRequestSoundPermission;
  bool iosRequestBadgePermission;
  bool iosRequestAlertPermission;

  /// local notification initialization
  /// initializationSettingAndroid
  /// initializationSettingIos;
  /// initializationSetting;
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingAndroid;
  var initializationSettingIos;
  var initializationSetting;

  /// Then we create a construct of Locally
  /// which required a context, pageRoute, appIcon and a payload
  /// It also received ios Parameters which are still in dev
  /// Within the construct,
  /// localNotification settings is initialized with Flutter Local Notification
  /// Setting declared above
  Locally({
    @required this.appIcon,
    @required this.onSelectNotification,
    @required this.onDidReceiveNotification,
    this.iosRequestSoundPermission = false,
    this.iosRequestBadgePermission = false,
    this.iosRequestAlertPermission = false,
  }) {
    /// initializationSettingAndroid declared above is assigned
    /// to AndroidInitializationSettings.
    initializationSettingAndroid =
        new AndroidInitializationSettings(this.appIcon);

    /// initializationSettingIos declared above is assigned
    /// to IOSInitializationSettings.
    initializationSettingIos = new IOSInitializationSettings(
        requestSoundPermission: iosRequestSoundPermission,
        requestBadgePermission: iosRequestBadgePermission,
        requestAlertPermission: iosRequestAlertPermission,
        onDidReceiveLocalNotification: onDidReceiveNotification);

    /// initializationSetting declared above is here assigned
    /// to InitializationSetting, which comes from flutter_local_notification
    /// package.
    initializationSetting = new InitializationSettings(
        initializationSettingAndroid, initializationSettingIos);

    /// localNotificationPlugin is initialized here finally
    localNotificationsPlugin.initialize(initializationSetting,
        onSelectNotification: onSelectNotification);
  }

  /// requestPermission()
  /// for IOS developers only
  Future requestPermission() async {
    return await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// onSelectNotification
  /// Obtains a string payload
  /// And perform navigation function
  // Future<void> onSelectNotification(String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: ' + payload);
  //   }
  //   await Navigator.push(context, pageRoute);
  // }

  /// onDidReceiveNotification
  /// it required for IOS initialization
  /// it takes in id, title, body and payload
  // Future<void> onDidReceiveNotification(id, title, body, payload) async {
  //   await showDialog(
  //       context: context,
  //       child: CupertinoAlertDialog(
  //         title: title,
  //         content: Text(body),
  //         actions: <Widget>[
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: Text('Ok'),
  //             onPressed: () async {
  //               await Navigator.push(context, pageRoute);
  //             },
  //           )
  //         ],
  //       ));
  // }

  /// The show Method return a notification to the screen
  /// it takes in a required title, message
  /// channel Name,
  /// channel ID,
  /// channel Description,
  /// importance,
  /// priority
  /// ticker
  Future show(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      id = 0,
      payload,
      channelDescription = 'channel Description',
      importance = Importance.High,
      priority = Priority.High,
      ticker = 'test ticker'}) async {
    if (title == null && message == null) {
      throw "Missing parameters, title: message";
    } else {
      this.title = title;
      this.message = message;

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription,
          importance: importance, priority: priority, ticker: ticker);

      var iosPlatformChannelSpecifics = IOSNotificationDetails();

      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);

      await localNotificationsPlugin
          .show(id, title, message, platformChannelSpecifics, payload: payload);
    }
  }

  /// The scheduleMethod return  a notification to the screen
  /// But with this you can schedule a messag to show at a given time
  /// it takes in a required title, message
  /// channel Name,
  /// channel ID,
  /// channel Description,
  /// importance,
  /// priority
  /// ticker
  /// and a Duration class
  Future schedule(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      id = 0,
      payload,
      channelDescription = 'channel Description',
      importance = Importance.High,
      priority = Priority.High,
      ticker = 'test ticker',
      @required Duration duration,
      androidAllowWhileIdle = false}) async {
    if (title == null && message == null && duration == null) {
      throw "Missing parameters, title: message: duration";
    } else {
      var scheduledNotificationDateTime = DateTime.now().add(duration);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await localNotificationsPlugin.schedule(id, title, message,
          scheduledNotificationDateTime, platformChannelSpecifics,
          payload: payload);
    }
  }

  /// The showPeriodicallyd return  a notification to the screen
  /// But with this you can repeat a message to show at a given interval
  /// it takes in a required title, message
  /// channel Name,
  /// channel ID,
  /// channel Description,
  /// importance,
  /// priority
  /// ticker
  /// and a repeat interval
  Future showPeriodically(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      id = 0,
      payload,
      channelDescription = 'channel Description',
      importance = Importance.High,
      priority = Priority.High,
      @required var repeatInterval,
      ticker = 'test ticker'}) async {
    if (title == null && message == null && repeatInterval == null) {
      throw "Missing parameters, title: message, repeat interval";
    } else {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await localNotificationsPlugin.periodicallyShow(
          id, title, message, repeatInterval, platformChannelSpecifics,
          payload: payload);
    }
  }

  /// The showDailyAtTime return a notification to the screen
  /// But with this you can decide to show a message at a given time in the day
  /// it takes in a required title, message
  /// channel Name,
  /// channel ID,
  /// channel Description,
  /// importance,
  /// priority
  /// ticker
  /// and a time
  Future showDailyAtTime(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      id = 0,
      payload,
      channelDescription = 'channel Description',
      importance = Importance.High,
      priority = Priority.High,
      ticker = 'test ticker',
      @required time,
      bool suffixTime = false}) async {
    if (title == null && message == null) {
      throw "Missing parameters, title: message";
    } else {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics,
        iOSPlatformChannelSpecifics,
      );
      if (suffixTime) {
        await localNotificationsPlugin.showDailyAtTime(
            id,
            title,
            message +
                "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}",
            time,
            platformChannelSpecifics,
            payload: payload);
      } else {
        await localNotificationsPlugin.showDailyAtTime(
            0, title, message, time, platformChannelSpecifics,
            payload: payload);
      }
    }
  }

  /// The showWeeklyAtDayAndTime return a notification to the screen
  /// But with this you can decide to show a message at a given day of the week
  /// and at a given time
  /// it takes in a required title, message
  /// channel Name,
  /// channel ID,
  /// channel Description,
  /// importance,
  /// priority
  /// ticker
  /// and a time
  /// and Day
  Future showWeeklyAtDayAndTime(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      id = 0,
      payload,
      channelDescription = 'channel Description',
      Importance importance = Importance.High,
      Priority priority = Priority.High,
      ticker = 'test ticker',
      @required time,
      @required day,
      bool suffixTime = false}) async {
    if (title == null && message == null && time == null && day == null) {
      throw "Missing parameters, title: message : time";
    } else {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      if (suffixTime) {
        await localNotificationsPlugin.showDailyAtTime(
            id,
            title,
            message +
                "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}",
            time,
            platformChannelSpecifics,
            payload: payload);
      } else {
        await localNotificationsPlugin.showWeeklyAtDayAndTime(
            0, title, message, day, time, platformChannelSpecifics,
            payload: payload);
      }
    }
  }

  /// The retrievePendingNotifications return all pending
  /// notification to the screen
  ///
  Future retrievePendingNotifications() async {
    return await localNotificationsPlugin.pendingNotificationRequests();
  }

  /// The cancel method as the name goes
  /// cancels a with a provided index id
  ///
  Future cancel(int index) async {
    if (index == null) {
      throw 'Error: index required';
    } else {
      await localNotificationsPlugin.cancel(index);
    }
  }

  /// The cancelAll method as the name goes
  /// cancels all pending notification
  ///
  Future cancelAll() async {
    localNotificationsPlugin.cancelAll();
  }

  /// The getDetailsIfAppWasLaunchedViaNotification
  /// return details if the app was lauched by a notification
  /// payload
  ///
  Future getDetailsIfAppWasLaunchedViaNotification() async {
    return localNotificationsPlugin.getNotificationAppLaunchDetails();
  }
}
