import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Repeat {
  const Repeat(this.value);

  static const RepeatInterval Hourly = RepeatInterval.hourly;

  static const RepeatInterval EveryMinute = RepeatInterval.everyMinute;

  static const RepeatInterval Daily = RepeatInterval.daily;

  static const RepeatInterval Weekly = RepeatInterval.weekly;

  /// All the possible values for the [RepeatInterval] enumeration.
  static List<RepeatInterval> get values =>
      [Hourly, Daily, EveryMinute, Weekly];

  final int value;
}

class Time {
  const Time(this.value);

  static int hour = Time.hour;
  static int minute = Time.minute;
  static int seconds = Time.seconds;

  final int value;
}

class Days {
  const Days(this.value);

  static var monday = Day.monday;
  static var tuesday = Day.tuesday;
  static var wednesday = Day.wednesday;
  static var thursday = Day.thursday;
  static var friday = Day.friday;
  static var saturday = Day.saturday;
  static var sunday = Day.sunday;

  final int value;
}
