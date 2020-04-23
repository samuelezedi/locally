
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

class Priority {
  const Priority(this.value);

  static const Min = Priority(-2);
  static const Low = Priority(-1);
  static const Default = Priority(0);
  static const High = Priority(1);
  static const Max = Priority(2);

  /// All the possible values for the [Priority] enumeration.
  static List<Priority> get values => [Min, Low, Default, High, Max];

  final int value;
}

class Importance {
  const Importance(this.value);

  static const Unspecified = Importance(-1000);
  static const None = Importance(0);
  static const Min = Importance(1);
  static const Low = Importance(2);
  static const Default = Importance(3);
  static const High = Importance(4);
  static const Max = Importance(5);

  /// All the possible values for the [Importance] enumeration.
  static List<Importance> get values =>
      [Unspecified, None, Min, Low, Default, High, Max];

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

  static var monday = Day.Monday;
  static var tuesday = Day.Tuesday;
  static var wednesday = Day.Wednesday;
  static var thursday = Day.Thursday;
  static var friday = Day.Friday;
  static var saturday = Day.Saturday;
  static var sunday = Day.Sunday;

  final int value;
}
