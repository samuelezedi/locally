# Locally

[![pub package](https://img.shields.io/badge/pub-0.2.6%2B-8brightgreen)](https://pub.dev/packages/locally)

## flutter local notification

Locally helps developers create local notification with flutter on both Android and IOS platforms, it depends on the flutter_local_notification plugin and tries to make usage more simple and user friendly.

## Screenshots as obtained from flutter_local_notification

| Android | iOS |
| ------------- | ------------- |
| <img height="480" src="https://github.com/MaikuB/flutter_local_notifications/raw/master/images/android_notification.png"> |  <img height="414" src="https://github.com/MaikuB/flutter_local_notifications/raw/master/images/ios_notification.png"> |

## Acknowledgements

* [The Flutter Local Notification contributors](https://pub.dev/packages/flutter_local_notifications) for making this possible

## Usage

### Show basic notification
```dart
//
Locally locally = Locally(
          context: context,
          payload: 'test',
          pageRoute: MaterialPageRoute(builder: (context) => SecondScreen(title: title.text, message: message.text)),
          appIcon: 'mipmap/ic_launcher',
      );

      locally.show(title: title.text, message: message.text);
```

### show notification
```dart

locally.show(title: title.text, message: message.text);
```

### schedule notification
```dart
locally.schedule(title: title.text, message: message.text, duration: Duration(seconds: 5));
```

### Show a notification with a specified interval periodically
```dart
locally.showPeriodically(title: title.text, message: message.text, repeatInterval: Repeat.Hourly);
```

### Show a daily notification at a specific timely
```dart
locally.showDailyAtTime(title: title.text, message: message.text, time: Time.hour);
```

### Show a weekly notification on specific day and time
```dart
locally.showWeeklyAtDayAndTime(title: title.text, message: message.text, time: Time.minute, day: Days.monday);
```

### Retrieve pending notification requests
```dart
locally.retrievePendingNotifications();
```

### Cancelling/deleting a notification
```dart
locally.cancel(0);
```

### Cancelling/deleting all notification
```dart
locally.cancelAll();
```

### Get details on if the app was launched via a notification created by this plugin
```dart
locally.getDetailsIfAppWasLaunchedViaNotification();
```

After installation in `pubspec.yaml`: you will need to carry out the following configuration on both platforms respectively

## Android Configuration
If your application needs the ability to schedule notifications then you need to request permissions to be notified when the phone has been booted as scheduled notifications uses the `AlarmManager` API to determine when notifications should be displayed. However, they are cleared when a phone has been turned off. Requesting permission requires adding the following to the manifest (i.e. your application's `AndroidManifest.xml` file)

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

The following is also needed to ensure scheduled notifications remain scheduled upon a reboot (this is handled by the plugin)

```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"></action>
    </intent-filter>
</receiver>
```

Developers will also need to add the following so that plugin can handle displaying scheduled notifications

```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
```

If the vibration pattern of an Android notification will be customised then add the following

```xml
<uses-permission android:name="android.permission.VIBRATE" />
```
Here's and example of what your `AndroidManifest.xml` should look like [here](https://github.com/samuelezedi/locally/blob/master/example/android/app/src/main/AndroidManifest.xml)

### Release build configuration

When doing a release build of your app, which is the default setting when building an APK or app bundle, you'll likely need to customise your ProGuard configuration file as per this [link](https://developer.android.com/studio/build/shrink-code#keep-code) and add the following line.

```
-keep class com.dexterous.** { *; }
```

After doing so, rules specific to the GSON dependency being used by the plugin will also needed to be added. These rules can be found [here](https://github.com/google/gson/blob/master/examples/android-proguard-example/proguard.cfg). The example app has a consolidated Proguard rules (`proguard-rules.pro`) file that combines these together for reference [here](https://github.com/MaikuB/flutter_local_notifications/blob/master/flutter_local_notifications/example/android/app/proguard-rules.pro).

You will also need to ensure that you have configured the resources that should be kept so that resources like your notification icons aren't discarded by the R8 compiler by following the instructions [here](https://developer.android.com/studio/build/shrink-code#keep-resources). Without doing this, you might not see the icon you've specified in your app's notifications. The configuration used by the example app can be found [here](https://github.com/MaikuB/flutter_local_notifications/blob/master/flutter_local_notifications/example/android/app/src/main/res/raw/keep.xml) where it is specifying that all drawable resources should be kept, as well as the file used to play a custom notification sound (sound file is located [here](https://github.com/MaikuB/flutter_local_notifications/blob/master/flutter_local_notifications/example/android/app/src/main/res/raw/slow_spring_board.mp3)).

## iOS integration

### General setup

Add the following lines to the `didFinishLaunchingWithOptions` method in the AppDelegate.m/AppDelegate.swift file of your iOS project

Objective-C:
```objc
if (@available(iOS 10.0, *)) {
  [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
}
```

Swift:
```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```

By design, iOS applications do not display notifications when they're in the foreground. For iOS 10+, use the presentation options to control the behaviour for when a notification is triggered while the app is in the foreground. For older versions of iOS, you need to handle the callback as part of specifying the method that should be fired to the `onDidReceiveLocalNotification` argument when creating an instance `IOSInitializationSettings` object that is passed to the function for initializing the plugin. A snippet below from the sample app shows how this can be done

If you have set notifications to be periodically shown, then on older iOS versions (< 10), if the application was uninstalled without cancelling all alarms then the next time it's installed you may see the "old" notifications being fired. If this is not the desired behaviour, then you can add code similar to the following to the `didFinishLaunchingWithOptions` method of your `AppDelegate` class.

Objective-C:

```objc
if(![[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"]){
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Notification"];
}
```

Swift:

```swift
if(!UserDefaults.standard.bool(forKey: "Notification")) {
    UIApplication.shared.cancelAllLocalNotifications()
    UserDefaults.standard.set(true, forKey: "Notification")
}
```

### Custom notification sound restrictions

When using custom notification sound, developers should be aware that iOS enforces restrictions on this (e.g. supported file formats). As of this writing, this is documented by Apple at

https://developer.apple.com/documentation/usernotifications/unnotificationsound?language=objc

### Using firebase_messaging with flutter_local_notifications

Previously, there were issue that prevented this plugin working properly with the `firebase_messaging` plugin. This meant that callbacks from each plugin might not be invoked. Version 6.0.13 of `firebase_messaging` should resolve this issue so please bump your `firebase_messaging` dependency and follow the steps covered in `firebase_messaging`'s readme file.

## Testing

As the plugin class is not static, it is possible to mock and verify it's behaviour when writing tests as part of your application. Check the source code for a sample test suite can be found at _test/flutter_local_notifications_test.dart_ that demonstrates how this can be done. If you decide to use the plugin class directly as part of your tests, note that the methods will be mostly a no-op and methods that return data will return default values. Part of this is because the plugin detects if you're running on a supported plugin to determine which platform implementation of the plugin should be used. If it's neither Android or iOS, then it defaults to the aforementioned behaviour to reduce friction when writing tests. If this not desired then consider using mocks. Note there is also a [named constructor](https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/FlutterLocalNotificationsPlugin/FlutterLocalNotificationsPlugin.private.html) that can be used to pass the platform for the plugin to resolve the desired platform-specific implementation.