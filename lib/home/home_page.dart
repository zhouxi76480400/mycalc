import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:mycalc/route/get_routes.dart';
import 'package:mycalc/util/date_time_util.dart';
import 'package:mycalc/widget/my_app_bar.dart';
import 'package:mycalc/widget/task_list_view.dart';

import '../model/task_model.dart';
import '../service/d_b_service.dart';
import '../util/consts.dart';
import '../util/d_b_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  void _goToAddTaskPage(DateTime value) {
    // Get.to(page)
    Get.toNamed(GetRoutes.addTask, arguments: value);
  }
}

class _HomePageState extends State<HomePage> {
  late Box<TaskModel> box;

  late DatePickerController datePickerController;

  late ValueNotifier<DateTime> valueNotifierDateTime;

  bool canPop = false;

  @override
  void initState() {
    super.initState();
    box = Hive.box<TaskModel>(DBService.kCalName);
    datePickerController = DatePickerController();
    DateTime dateNow = DateTime.now();
    DateTime newDate = DateTime(dateNow.year, dateNow.month, dateNow.day);
    valueNotifierDateTime = ValueNotifier<DateTime>(newDate);
    print("數據條數:${box.length}");

    // box.listenable

    // for (int i = 0; i < box.length; i++) {
    //   TaskModel? taskModel = box.getAt(i);
    //   print(taskModel!.title +
    //       "\n" +
    //       taskModel!.note +
    //       "\n" +
    //       taskModel!.date.toString() +
    //       "\n" +
    //       taskModel!.startTime.toString() +
    //       "\n" +
    //       taskModel!.endTime.toString() +
    //       "\n" +
    //       "${taskModel!.remindMinPos}, ${taskModel!.repeatPos}, ${taskModel!.colorPos}");
    // }
  }

  @override
  void dispose() {
    valueNotifierDateTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets safeArea = MediaQuery.of(context).padding;

    DatePicker datePicker = DatePicker(
      DateTime.now(),
      initialSelectedDate: valueNotifierDateTime.value,
      selectionColor: context.theme.primaryColor,
      width: 75,
      height: 100,
      controller: datePickerController,
      onDateChange: (DateTime dateTime) {
        // 對比不同才刷新
        if (dateTime.compareTo(valueNotifierDateTime.value) != 0) {
          valueNotifierDateTime.value = dateTime;
        }
      },
    );

    var w = Scaffold(
      appBar: MyAppBar(),
      body: Container(
        margin: EdgeInsets.only(
            left: safeArea.left,
            right: safeArea.right,
            bottom: safeArea.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                          left: 16,
                        ),
                        child: Text(
                          "January 23, 2025",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 16, top: 8, bottom: 10, right: 16),
                        child: Text(
                          "Today",
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ],
                )),
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            width: 0, color: context.theme.primaryColor),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: context.theme.primaryColor,
                      ),
                      onPressed: () {
                        widget._goToAddTaskPage(valueNotifierDateTime.value);
                      },
                      child: SizedBox(
                        height: 52,
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 13,
                              color: Colors.white,
                            ),
                            Text(
                              "Add Task",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width, child: datePicker),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: valueNotifierDateTime,
                builder:
                    (BuildContext context, DateTime dateValue, Widget? child) {
                  return ValueListenableBuilder(
                      valueListenable: box.listenable(),
                      builder: (BuildContext context, Box<TaskModel> value,
                          Widget? child) {
                        List<MapEntry<dynamic, TaskModel>> data =
                            DBUtil.getTaskModelsBeforeThisDay(dateValue, box);
                        // print("DateTime ${dateValue.toString()}");
                        return data.isEmpty
                            ? Center(
                                child: Opacity(
                                  opacity: 0.4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.list,
                                        size: 120,
                                        color: context.theme.primaryColor,
                                      ),
                                      Text(
                                        "No Task",
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  MapEntry<dynamic, TaskModel> entry =
                                      data[index];
                                  TaskModel taskModel = entry.value;
                                  Color color = kColorList[taskModel.colorPos];
                                  String tileIntervalStr =
                                      "${DateTimeUtil.toHHMM(taskModel.date.copyWith(hour: taskModel.startTime.hour, minute: taskModel.startTime.minute))}"
                                      " - ${DateTimeUtil.toHHMM(taskModel.date.copyWith(hour: taskModel.endTime.hour, minute: taskModel.endTime.minute))} "
                                      "(${DateTimeUtil.toYYYYMMDD(taskModel.date)})";

                                  return TaskListView(
                                    onTap: () {
                                      onTaskPressed(entry);
                                    },
                                    color: color,
                                    title: taskModel.title,
                                    note: taskModel.note,
                                    timeInterval: tileIntervalStr,
                                    isCompleted: taskModel.isCompleted,
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                  );
                                });
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );

    var popScope = PopScope(
      canPop: canPop,
      child: w,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Do you want to exit the application? "),
                  title: Text("Warning"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            canPop = true;
                          });
                          SystemNavigator.pop();
                        },
                        child: Text("Exit")),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Cancel")),
                  ],
                );
              });
        }
      },
    );

    return popScope;
  }

  void changeState(MapEntry<dynamic, TaskModel> entry) {
    var key = entry.key;
    TaskModel value = entry.value;
    value.isCompleted = true;
    box.put(key, value);
  }

  void deleteDataFromDB(MapEntry<dynamic, TaskModel> entry) {
    var key = entry.key;
    box.delete(key);
  }

  void onTaskPressed(MapEntry<dynamic, TaskModel> entry) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (
          BuildContext context,
        ) {
          bool isCompleted = entry.value.isCompleted;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              print(constraints.maxWidth);
              EdgeInsets safeArea = MediaQuery.of(context).padding;
              double leftRightMargin = 16;
              double buttonHeight = 56;
              double margin1 = 30;
              double margin2 = 10;
              double margin3 = 60;
              if (isCompleted) {
                margin2 = margin3;
                margin3 = 0;
              }
              double topLineHeight = 4;
              double margin4 = 3;
              int buttonCount = 3;
              if (isCompleted) buttonCount = 2;

              double fontSize = 18;
              return Container(
                width: constraints.maxWidth,
                height: buttonHeight * buttonCount +
                    margin1 +
                    margin2 +
                    margin3 +
                    margin4 +
                    topLineHeight,
                margin: EdgeInsets.only(bottom: safeArea.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.black26,
                      ),
                      margin: EdgeInsets.only(
                        top: margin4,
                      ),
                      width: constraints.maxWidth / 4,
                      height: topLineHeight,
                    ),
                    isCompleted
                        ? SizedBox()
                        : Container(
                            height: buttonHeight,
                            width: constraints.maxWidth,
                            margin: EdgeInsets.only(
                                top: margin3,
                                left: leftRightMargin,
                                right: leftRightMargin),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: context.theme.primaryColor,
                                  side: BorderSide(
                                    color: context.theme.primaryColor,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () {
                                  changeState(entry);
                                  Get.back();
                                },
                                child: Text(
                                  "Task Completed",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: fontSize,
                                  ),
                                )),
                          ),
                    Container(
                      height: buttonHeight,
                      width: constraints.maxWidth,
                      margin: EdgeInsets.only(
                          top: margin2,
                          left: leftRightMargin,
                          right: leftRightMargin),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red.shade300,
                            side: BorderSide(
                              color: Colors.red.shade300,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            deleteDataFromDB(entry);
                            Get.back();
                          },
                          child: Text(
                            "Delete Task",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: fontSize,
                            ),
                          )),
                    ),
                    Container(
                      height: buttonHeight,
                      width: constraints.maxWidth,
                      margin: EdgeInsets.only(
                          top: margin1,
                          left: leftRightMargin,
                          right: leftRightMargin),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.black12,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: fontSize,
                            ),
                          )),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
