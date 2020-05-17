import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Repeat {
  const Repeat(this.value);

  static const RepeatInterval Hourly = RepeatInterval.Hourly;

  static const RepeatInterval EveryMinute = RepeatInterval.EveryMinute;

  static const RepeatInterval Daily = RepeatInterval.Daily;

  static const RepeatInterval Weekly = RepeatInterval.Weekly;

  /// All the possible values for the [RepeatInterval] enumeration.
  static List<RepeatInterval> get values =>
      [Hourly, Daily, EveryMinute, Weekly];

  final int value;
}
//


class Time {
  const Time(this.value);

  static int hour = Time.hour;
  static int minute = Time.minute;
  static int seconds = Time.seconds;

  final int value;
}

class Days {
  const Days(this.value);

  static var monday = Day.Monday;
  static var tuesday = Day.Tuesday;
  static var wednesday = Day.Wednesday;
  static var thursday = Day.Thursday;
  static var friday = Day.Friday;
  static var saturday = Day.Saturday;
  static var sunday = Day.Sunday;

  final int value;
}
