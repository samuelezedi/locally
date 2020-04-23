/*
Locally is In-App Messaging package, it extends the flutter_local_notification
It is created by Samuel Ezedi to help developers create notification and blots out the hassle of strenuous
initialization, you really wouldn't not have to write a lot of code anymore

I invite you to clone the repo and make contributions, Thanks
*
* */

library locally;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Locally {
  Key key;
  String title;
  String message;
  String payload;
  String appIcon;
  MaterialPageRoute pageRoute;
  BuildContext context;
  bool iosRequestSoundPermission;
  bool iosRequestBadgePermission;
  bool iosRequestAlertPermission;

  //local notification initialization
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingAndroid;
  var initializationSettingIos;
  var initializationSetting;

  Locally({
    @required this.context,
    @required this.pageRoute,
    @required this.appIcon,
    @required this.payload,
    this.iosRequestSoundPermission,
    this.iosRequestBadgePermission,
    this.iosRequestAlertPermission,
  }) {
    initializationSettingAndroid =
        new AndroidInitializationSettings(this.appIcon);

    initializationSettingIos = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveNotification);

    initializationSetting = new InitializationSettings(
        initializationSettingAndroid, initializationSettingIos);

    localNotificationsPlugin.initialize(initializationSetting,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(context, pageRoute);
  }

  Future onDidReceiveNotification(id, title, body, payload) async {
    await showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: title,
          content: Text(body),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                await Navigator.push(context, pageRoute);
              },
            )
          ],
        ));
  }

  Future show(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      channelDescription = 'channel Description',
      Importance importance = Importance.High,
      Priority priority = Priority.High,
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
          .show(0, title, message, platformChannelSpecifics, payload: payload);
    }
  }

  schedule(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      channelDescription = 'channel Description',
      Importance importance = Importance.High,
      Priority priority = Priority.High,
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
      await localNotificationsPlugin.schedule(0, title, message,
          scheduledNotificationDateTime, platformChannelSpecifics);
    }
  }

  showPeriodically(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      channelDescription = 'channel Description',
      Importance importance = Importance.High,
      Priority priority = Priority.High,
      ticker = 'test ticker'}) async {
    if (title == null && message == null) {
      throw "Missing parameters, title: message";
    } else {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await localNotificationsPlugin.periodicallyShow(0, title, message,
          RepeatInterval.EveryMinute, platformChannelSpecifics);
    }
  }

  showDailyAtTime(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      channelDescription = 'channel Description',
      Importance importance = Importance.High,
      Priority priority = Priority.High,
      ticker = 'test ticker',
      @required Time time,
      bool suffixTime = false}) async {
    if (title == null && message == null) {
      throw "Missing parameters, title: message";
    } else {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      if (suffixTime) {
        await localNotificationsPlugin.showDailyAtTime(
            0,
            title,
            message +
                "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}",
            time,
            platformChannelSpecifics);
      } else {
        await localNotificationsPlugin.showDailyAtTime(
            0, title, message, time, platformChannelSpecifics);
      }
    }
  }

  showWeeklyAtDayAndTime(
      {@required title,
      @required message,
      channelName = 'channel Name',
      channelID = 'channelID',
      channelDescription = 'channel Description',
      Importance importance = Importance.High,
      Priority priority = Priority.High,
      ticker = 'test ticker',
      @required Time time,
      Day day,
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
            0,
            title,
            message +
                "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}",
            time,
            platformChannelSpecifics);
      } else {
        await localNotificationsPlugin.showWeeklyAtDayAndTime(
            0, title, message, day, time, platformChannelSpecifics);
      }
    }
  }

  retrievePendingNotifications() async {
    return await localNotificationsPlugin.pendingNotificationRequests();
  }

  //Android Grouping alone
  group(
      {@required title,
      @required message,
      groupKey = 'com.android.example.WORK_EMAIL',
      groupChannelId = 'grouped channel id',
      groupChannelName = 'grouped channel name',
      groupChannelDescription = 'grouped channel description',
      Importance importance = Importance.High,
      Priority priority = Priority.High,
      ticker = 'test ticker',
      @required Time time,
      Day day,
      bool suffixTime = false}) async {
    AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(
            groupChannelId, groupChannelName, groupChannelDescription,
            importance: importance, priority: priority, groupKey: groupKey);
    NotificationDetails firstNotificationPlatformSpecifics =
        NotificationDetails(firstNotificationAndroidSpecifics, null);
    await localNotificationsPlugin.show(
        1, title, message, firstNotificationPlatformSpecifics);

    AndroidNotificationDetails secondNotificationAndroidSpecifics =
        AndroidNotificationDetails(
            groupChannelId, groupChannelName, groupChannelDescription,
            importance: Importance.Max,
            priority: Priority.High,
            groupKey: groupKey);
    NotificationDetails secondNotificationPlatformSpecifics =
        NotificationDetails(secondNotificationAndroidSpecifics, null);
    await localNotificationsPlugin.show(
        2, title, message, secondNotificationPlatformSpecifics);

// create the summary notification required for older devices that pre-date Android 7.0 (API level 24)
    List<String> lines = List<String>();
    lines.add('Alex Faarborg  Check this out');
    lines.add('Jeff Chang    Launch Party');
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
        contentTitle: '2 new messages', summaryText: 'janedoe@example.com');
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            groupChannelId, groupChannelName, groupChannelDescription,
            styleInformation: inboxStyleInformation,
            groupKey: groupKey,
            setAsGroupSummary: true);
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await localNotificationsPlugin.show(
        3, 'Attention', 'Two new messages', platformChannelSpecifics);
  }

  cancel(index) async {
    if (index == null) {
      throw 'Error: index required';
    } else {
      await localNotificationsPlugin.cancel(index);
    }
  }

  cancelAll() async {
    localNotificationsPlugin.cancelAll();
  }

  getDetailsIfAppWasLaunchedViaNotification() async {
    return localNotificationsPlugin.getNotificationAppLaunchDetails();
  }
}
