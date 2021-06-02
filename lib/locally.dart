///  Locally is In-App Messaging package, it extends the flutter_local_notification
/// It is created by Samuel Ezedi to help developers create notification and blots out the hassle of strenuous
/// initialization, you really wouldn't not have to write a lot of code anymore

/// I invite you to clone the repo and make contributions, Thanks.

/// Copyright 2020. All rights reserved.
/// Use of this source code is governed by a BSD-style license that can be
/// found in the LICENSE file.

library locally;

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Imports flutter_local_notification, our dependency package
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Imports timezone, our dependency package
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Locally class created
class Locally {
  /// A key identifier property is needed
  Key? key;

  /// A String title for Notification
  late String title;

  /// A String message
  late String message;

  /// Payload for Navigation
  String payload;

  /// App Icon which is required on initialization
  String appIcon;

  /// Page Route which is also required on Initialization
  MaterialPageRoute pageRoute;

  /// A context is also required
  BuildContext context;

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

  Random random = new Random();

  /// Then we create a construct of Locally
  /// which required a context, pageRoute, appIcon and a payload
  /// It also received ios Parameters which are still in dev
  /// Within the construct,
  /// localNotification settings is initialized with Flutter Local Notification
  /// Setting declared above
  Locally({
    required this.context,
    required this.pageRoute,
    required this.appIcon,
    required this.payload,
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
        android: initializationSettingAndroid, iOS: initializationSettingIos);

    /// localNotificationPlugin is initialized here finally
    localNotificationsPlugin.initialize(initializationSetting,
        onSelectNotification: onSelectNotification);
  }

  Future<void> setup() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(
      tz.getLocation(currentTimeZone),
    );
  }

  ///The instance of Weekday
  // // // tz.TZDateTime _nextInstanceOfWeekday(int hour, int min, int dayOfWeek) {
  // // //   tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, min);
  // // //   switch (dayOfWeek) {
  // // //     case 1:
  // // //       while (scheduledDate.weekday != DateTime.monday) {
  // // //         scheduledDate = scheduledDate.add(const Duration(days: 1));
  // // //       }
  // // //       break;
  // // //     case 2:
  // // //       while (scheduledDate.weekday != DateTime.tuesday) {
  // // //         scheduledDate = scheduledDate.add(const Duration(days: 1));
  // // //       }
  // // //       break;
  // // //     case 3:
  // // //       while (scheduledDate.weekday != DateTime.wednesday) {
  // // //         scheduledDate = scheduledDate.add(const Duration(days: 1));
  // // //       }
  // // //       break;
  // // //     case 4:
  // // //       while (scheduledDate.weekday != DateTime.thursday) {
  // // //         scheduledDate = scheduledDate.add(const Duration(days: 1));
  // // //       }
  // // //       break;
  // // //     case 5:
  // // //       while (scheduledDate.weekday != DateTime.friday) {
  // // //         scheduledDate = scheduledDate.add(const Duration(days: 1));
  // // //       }
  // // //       break;
  // // //     case 6:
  // // //       while (scheduledDate.weekday != DateTime.saturday) {
  // // //         scheduledDate = scheduledDate.add(const Duration(days: 1));
  // // //       }
  // // //       break;
  // // //     case 7:
  // // //       while (scheduledDate.weekday != DateTime.sunday) {
  // // //         scheduledDate = scheduledDate.add(const Duration(days: 1));
  // // //       }
  // // //       break;
  // // //   }
  // // //   return scheduledDate;
  // // // }

  /// The instance of time
  // // // tz.TZDateTime _nextInstanceOfTime(int hour, int min) {
  // // //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  // // //   tz.TZDateTime scheduledDate =
  // // //       tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min);
  // // //   if (scheduledDate.isBefore(now)) {
  // // //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  // // //   }
  // // //   return scheduledDate;
  // // // }

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
  Future<dynamic> onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(context, pageRoute);
  }

  /// onDidReceiveNotification
  /// it required for IOS initialization
  /// it takes in id, title, body and payload
  Future<void> onDidReceiveNotification(id, title, body, payload) async {
    await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
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
      ),
    );
  }

  /// The show Method return a notification to the screen
  /// it takes in a required title, message
  /// channel Name,
  /// channel ID,
  /// channel Description,
  /// importance,
  /// priority
  /// ticker
  Future show(
      {required title,
      required message,
      channelName = 'channel name',
      channelID = 'channel id',
      channelDescription = 'channel description',
      importance = Importance.high,
      priority = Priority.high,
      ticker = 'test ticker'}) async {
    if (title == null && message == null) {
      throw "Missing parameters, title: message";
    } else {
      this.title = title;
      this.message = message;

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelID,
        channelName,
        channelDescription,
        importance: importance,
        priority: priority,
        ticker: ticker,
      );

      var iosPlatformChannelSpecifics = IOSNotificationDetails();

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await localNotificationsPlugin.show(
        0 + random.nextInt(9 - 0),
        title,
        message,
        platformChannelSpecifics,
        payload: payload,
      );
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
  // // // Future schedule({
  // // //   required title,
  // // //   required message,
  // // //   channelName = 'schedule channel name',
  // // //   channelID = 'schedule channel id',
  // // //   channelDescription = 'schedule channel description',
  // // //   importance = Importance.high,
  // // //   priority = Priority.high,
  // // //   ticker = 'test ticker',
  // // //   required int hour,
  // // //   required int min,
  // // //   required int dayOfWeek,
  // // //   androidAllowWhileIdle = false,
  // // // }) async {
  // // //   if (title == null &&
  // // //       message == null &&
  // // //       // ignore: unnecessary_null_comparison
  // // //       hour == null &&
  // // //       // ignore: unnecessary_null_comparison
  // // //       min == null &&
  // // //       // ignore: unnecessary_null_comparison
  // // //       dayOfWeek == null) {
  // // //     throw "Missing parameters, title: message: duration";
  // // //   } else {
  // // //     setup();
  // // //     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  // // //         channelID, channelName, channelDescription);
  // // //     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  // // //     NotificationDetails platformChannelSpecifics = NotificationDetails(
  // // //         android: androidPlatformChannelSpecifics,
  // // //         iOS: iOSPlatformChannelSpecifics);
  // // //     await localNotificationsPlugin.zonedSchedule(
  // // //       10 + random.nextInt(19 - 10),
  // // //       title,
  // // //       message,
  // // //       _nextInstanceOfWeekday(hour, min, dayOfWeek),
  // // //       platformChannelSpecifics,
  // // //       uiLocalNotificationDateInterpretation:
  // // //           UILocalNotificationDateInterpretation.absoluteTime,
  // // //       androidAllowWhileIdle: true,
  // // //       matchDateTimeComponents: DateTimeComponents.time,
  // // //     );
  // // //   }
  // // // }

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
      {required title,
      required message,
      channelName = 'periodically channel name',
      channelID = 'periodically channel id',
      channelDescription = 'periodically channel description',
      importance = Importance.high,
      priority = Priority.high,
      ticker = 'test ticker'}) async {
    if (title == null && message == null) {
      throw "Missing parameters, title: message, repeat interval";
    } else {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await localNotificationsPlugin.periodicallyShow(
          20 + random.nextInt(29 - 20),
          title,
          message,
          RepeatInterval.everyMinute,
          platformChannelSpecifics);
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
      {required title,
      required message,
      channelName = 'daily_at_time channel Name',
      channelID = 'daily_at_time channel id',
      channelDescription = 'daily_at_time channel description',
      importance = Importance.high,
      priority = Priority.high,
      ticker = 'test ticker',
      bool suffixTime = false}) async {
    if (title == null && message == null) {
      throw "Missing parameters, title: message";
    } else {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelID, channelName, channelDescription);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      var time = DateTime.now();
      if (suffixTime) {
        await localNotificationsPlugin.periodicallyShow(
          30 + random.nextInt(39 - 30),
          title,
          message +
              "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}",
          RepeatInterval.daily,
          platformChannelSpecifics,
        );
      } else {
        await localNotificationsPlugin.periodicallyShow(
          30 + random.nextInt(39 - 30),
          title,
          message,
          RepeatInterval.daily,
          platformChannelSpecifics,
        );
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
  /// and a timeDateTime.now()
  /// and Day
  Future showWeeklyAtDayAndTime(
      {required title,
      required message,
      channelName = 'daily_at_time channel Name',
      channelID = 'daily_at_time channel id',
      channelDescription = 'daily_at_time channel description',
      Importance importance = Importance.high,
      Priority priority = Priority.high,
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
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      var time = DateTime.now();
      if (suffixTime) {
        await localNotificationsPlugin.periodicallyShow(
          40 + random.nextInt(59 - 40),
          title,
          message +
              "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}",
          RepeatInterval.weekly,
          platformChannelSpecifics,
        );
      } else {
        await localNotificationsPlugin.periodicallyShow(
          40 + random.nextInt(59 - 40),
          title,
          message,
          RepeatInterval.weekly,
          platformChannelSpecifics,
        );
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
    // ignore: unnecessary_null_comparison
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
