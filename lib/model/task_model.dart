import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mycalc/util/date_time_util.dart';

@HiveType(typeId: TaskModel.kTypeId)
class TaskModel {
  static const kTypeId = 0;

  @HiveField(0)
  String title;
  @HiveField(1)
  String note;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  TimeOfDay startTime;
  @HiveField(4)
  TimeOfDay endTime;
  @HiveField(5)
  int remindMinPos;
  @HiveField(6)
  int repeatPos;
  @HiveField(7)
  int colorPos;
  @HiveField(8, defaultValue: false)
  bool isCompleted;

  TaskModel(this.title, this.note, this.date, this.startTime, this.endTime,
      this.remindMinPos, this.repeatPos, this.colorPos,
      {this.isCompleted = false});

  bool equals(TaskModel o1) {
    return o1.title.compareTo(title) == 0 &&
        o1.note.compareTo(note) == 0 &&
        startTime.compareTo(o1.startTime) == 0 &&
        endTime.compareTo(o1.endTime) == 0 &&
        date.year == o1.date.year &&
        date.month == o1.date.month &&
        date.day == o1.date.day;
  }

  DateTime getEndDateTime() {
    return _getDateTime(date, endTime);
  }

  DateTime _getDateTime(DateTime baseDateTime, TimeOfDay timeOfDay) {
    return DateTime(baseDateTime.year, baseDateTime.month, baseDateTime.day,
        timeOfDay.hour, timeOfDay.minute);
  }
}

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  TaskModel read(BinaryReader reader) {
    String title = reader.readString();
    String note = reader.readString();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    TimeOfDay startTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(reader.readInt()));
    TimeOfDay endTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(reader.readInt()));
    int remindMinPos = reader.readInt();
    int repeatPos = reader.readInt();
    int colorPos = reader.readInt();
    bool isCompleted = reader.readBool();
    return TaskModel(title, note, date, startTime, endTime, remindMinPos,
        repeatPos, colorPos,
        isCompleted: isCompleted);
  }

  @override
  int get typeId => TaskModel.kTypeId;

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.note);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeInt(
        DateTimeUtil.createADateTimeWithDateAndTime(obj.date, obj.startTime)
            .millisecondsSinceEpoch);
    writer.writeInt(
        DateTimeUtil.createADateTimeWithDateAndTime(obj.date, obj.endTime)
            .millisecondsSinceEpoch);
    writer.writeInt(obj.remindMinPos);
    writer.writeInt(obj.repeatPos);
    writer.writeInt(obj.colorPos);
    writer.writeBool(obj.isCompleted);
  }
}
