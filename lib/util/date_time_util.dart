import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class DateTimeUtil {
  _() {}

  static const String _year_pattern1 = "yyyy/MM/dd";

  static const String _time_pattern1 = "HH:mm";

  static const String _time_pattern2 = "hh:mm aa";

  static String toYYYYMMDD(DateTime dateTime) {
    return DateFormat(_year_pattern1).format(dateTime);
  }

  static String toHHMM(DateTime dateTime) {
    String pattern = is24HoursFormat() ? _time_pattern1 : _time_pattern2;
    return DateFormat(pattern).format(dateTime);
  }

  static bool is24HoursFormat() {
    bool is24HoursFormat = MediaQuery.of(Get.context!).alwaysUse24HourFormat;
    return is24HoursFormat;
  }

  static String toHHMMWithTimeOfDayAndDateTime(
      TimeOfDay timeOfDay, DateTime dateTime) {
    DateTime newDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
        timeOfDay.hour, timeOfDay.minute);
    return toHHMM(newDateTime);
  }

  static String toHHMMWithTimeOfDay(TimeOfDay timeOfDay) {
    DateTime dateTime = DateTime.now();
    DateTime newDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
        timeOfDay.hour, timeOfDay.minute);
    return toHHMM(newDateTime);
  }

  static TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static DateTime createADateTimeWithDateAndTime(
      DateTime date, TimeOfDay time) {
    return DateTime(
        date.year, date.month, date.day, time.hour, time.minute, 0, 0);
  }

  static int compareTimeOfDays(TimeOfDay t1, TimeOfDay t2) {
    if (t1.hour > t2.hour) {
      return 1;
    } else if (t1.hour == t2.hour) {
      if (t1.minute == t2.minute) {
        return 0;
      } else if (t1.minute > t2.minute) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }
}
