import 'package:hive_ce/hive.dart';

import '../model/task_model.dart';

class DBUtil {
  static List<MapEntry<dynamic, TaskModel>> getTaskModelsBeforeThisDay(
      DateTime datetime, Box<TaskModel> box) {
    // 這個是截止時間
    DateTime dateEnd = DateTime.fromMillisecondsSinceEpoch(
        datetime.add(Duration(days: 1)).millisecondsSinceEpoch - 1);
    // 找出截止時間前的所有數據
    // print("getTaskModelsBeforeThisDay -> $datetime  to $dateEnd");
    List<MapEntry<dynamic, TaskModel>> results = box.toMap().entries.where((o) {
      TaskModel taskModel = o.value;
      DateTime endDateTime = taskModel.getEndDateTime();
      return endDateTime.millisecondsSinceEpoch <=
          dateEnd.millisecondsSinceEpoch;
    }).toList();
    // 然後排序
    results
        .sort((MapEntry<dynamic, TaskModel> a, MapEntry<dynamic, TaskModel> b) {
      int timeEndA = a.value.getEndDateTime().millisecondsSinceEpoch;
      int timeEndB = b.value.getEndDateTime().millisecondsSinceEpoch;
      return timeEndA.compareTo(timeEndB);
    });
    return results;
  }

  static int getObjectKey(TaskModel taskModel, Box<TaskModel> box) {
    int key = -1;
    try {
      var results = box.toMap().entries.firstWhere(
        (element) {
          TaskModel o = element.value;
          return o.equals(taskModel);
        },
      );
      key = results.key;
    } catch (e) {}
    return key;
  }
}
