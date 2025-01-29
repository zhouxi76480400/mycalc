import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:mycalc/model/task_model.dart';
import 'package:mycalc/util/date_time_util.dart';
import 'package:mycalc/widget/color_picker_row.dart';
import 'package:mycalc/widget/my_app_bar.dart';
import 'package:get/get.dart';

import '../service/d_b_service.dart';
import '../util/toast_util.dart';
import '../widget/title_view.dart';
import '../util/consts.dart';

class AddTaskPage extends StatefulWidget {
  static const String kRemindTail = "minutes early";

  static const String kTitleStringEmptyHint = "Please input title";

  static const String kNoteStringEmptyHint = "Please input note";

  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TextEditingController _titleController,
      _noteController,
      _dateController,
      _startTimeController,
      _endTimeController,
      _remindController,
      _repeatController;

  late FocusNode _titleFocusNode, _noteFocusNode;

  late Box<TaskModel> box;

  /// add task to db
  void addTask(String title, String note, DateTime date, TimeOfDay startTime,
      TimeOfDay endTime, int remindMinPos, int repeatPos, int colorPos) async {
    int positionOnDB = await box.add(TaskModel(title, note, date, startTime,
        endTime, remindMinPos, repeatPos, colorPos)); // not -1 is ok
    Get.back(result: positionOnDB);
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box<TaskModel>(DBService.kCalName);
    _titleController = TextEditingController();
    _noteController = TextEditingController();
    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _remindController = TextEditingController();
    _repeatController = TextEditingController();
    //
    _titleFocusNode = FocusNode();
    _noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _remindController.dispose();
    _repeatController.dispose();
    //
    _titleFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Future<DateTime?> _showDatePicker(
      BuildContext context, DateTime dateTime) async {
    var lastDate = dateTime.add(Duration(days: kEndYearAfterYear * 365));
    return await showDatePicker(
        context: context, firstDate: dateTime, lastDate: lastDate);
  }

  Future<TimeOfDay?> _showTimePicker(
      BuildContext context, TimeOfDay timeOfDay) async {
    return await showTimePicker(
        context: context,
        initialTime: timeOfDay,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: DateTimeUtil.is24HoursFormat()),
            child: child!,
          );
        });
  }

  Future<TimeOfDay?> changeTimeOfDay(
    TimeOfDay newTimeOfDay,
    TextEditingController timeController,
  ) async {
    TimeOfDay t = newTimeOfDay;
    TimeOfDay? newTimeOfDay_ = await _showTimePicker(context, t);
    if (newTimeOfDay_ != null) {
      timeController.text = DateTimeUtil.toHHMMWithTimeOfDay(newTimeOfDay_);
    }
    return newTimeOfDay_;
  }

  String getRemindString(int remindMinPos) {
    return "${kRemindEarlyMin[remindMinPos]} ${AddTaskPage.kRemindTail}";
  }

  String getRepeatString(int repeatPos) {
    return kRepeatStringList[repeatPos];
  }

  Future<int?> showBottomSheet(
      List<String> itemListString, BuildContext context) async {
    var result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          const double kItemHeight = 64;
          const double kItemDividerHeight = 1;
          return SizedBox(
            height: kItemHeight * itemListString.length +
                MediaQuery.of(context).padding.bottom,
            width: MediaQuery.sizeOf(context).width,
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: itemListString.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.back(result: index);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: kItemHeight + kItemDividerHeight,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 24, right: 24),
                            height: kItemHeight,
                            child: Text(itemListString[index],
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                          Container(
                            height: kItemDividerHeight,
                            color: Colors.black12,
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
    return result;
  }

  DateTime? _newDateTimeYearAndMonth;

  TimeOfDay? _newTimeOfDayStart, _newTimeOfDayEnd;

  int _remindMinPos = 0;

  int _repeatPos = 0;

  int _colorSelectedPos = 0;

  void resetDateTime(DateTime dateTime) {
    String yyyyMmDd = DateTimeUtil.toYYYYMMDD(dateTime);
    _dateController.text = yyyyMmDd;
  }

  void resetStartAndEndTime(DateTime dateTime) {
    _newTimeOfDayStart = DateTimeUtil.dateTimeToTimeOfDay(dateTime);
    _newTimeOfDayEnd = DateTimeUtil.dateTimeToTimeOfDay(
        dateTime.add(Duration(minutes: kEndTimeIntervalMin)));
    _startTimeController.text =
        DateTimeUtil.toHHMMWithTimeOfDay(_newTimeOfDayStart!);
    _endTimeController.text =
        DateTimeUtil.toHHMMWithTimeOfDay(_newTimeOfDayEnd!);
  }

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    _newDateTimeYearAndMonth =
        !(args == null) ? args as DateTime : DateTime.now();
    resetDateTime(_newDateTimeYearAndMonth!);
    resetStartAndEndTime(_newDateTimeYearAndMonth!);

    _remindController.text = getRemindString(_remindMinPos);
    _repeatController.text = getRepeatString(_repeatPos);

    changeDateToNextDay() {
      DateTime dateTimeNow = DateTime.now();
      TimeOfDay timeOfDayNow =
          TimeOfDay(hour: dateTimeNow.hour, minute: dateTimeNow.minute);

      // 小的情況
      if (DateTimeUtil.compareTimeOfDays(_newTimeOfDayStart!, timeOfDayNow) <=
          0) {
        _newDateTimeYearAndMonth =
            _newDateTimeYearAndMonth!.add(Duration(days: 1));
        _dateController.text =
            DateTimeUtil.toYYYYMMDD(_newDateTimeYearAndMonth!);
      }
    }

    onDateTap() async {
      DateTime? newDate = await _showDatePicker(context, DateTime.now());
      if (newDate != null) {
        // 如果選的是同一天 要檢查下面end time的時間， 如果時間已經過了， 那麼把時間重置到今天剛剛選的
        DateTime dateTimeNow = DateTime.now();
        if (dateTimeNow.year == newDate.year &&
            dateTimeNow.month == newDate.month &&
            dateTimeNow.day == newDate.day) {
          DateTime endDateTime = DateTime(
              dateTimeNow.year,
              dateTimeNow.month,
              dateTimeNow.day,
              _newTimeOfDayEnd!.hour,
              _newTimeOfDayEnd!.minute);
          if (endDateTime.isBefore(dateTimeNow)) {
            // 改時間到正常的
            resetStartAndEndTime(dateTimeNow);
          }
        }
        _newDateTimeYearAndMonth = newDate;
        resetDateTime(_newDateTimeYearAndMonth!);
      }
    }

    onStartTimeTap() async {
      TimeOfDay? new_ =
          await changeTimeOfDay(_newTimeOfDayStart!, _startTimeController);
      if (new_ != null) {
        _newTimeOfDayStart = new_;
        if (DateTimeUtil.compareTimeOfDays(
                _newTimeOfDayStart!, _newTimeOfDayEnd!) !=
            -1) {
          _newTimeOfDayEnd = TimeOfDay(
              hour: _newTimeOfDayStart!.hour,
              minute: _newTimeOfDayStart!.minute + kEndTimeIntervalMin);
          _endTimeController.text =
              DateTimeUtil.toHHMMWithTimeOfDay(_newTimeOfDayEnd!);
        }
        // 如果選一個比現在時間小的， 那應該把日期改成明天
        changeDateToNextDay();
      }
    }

    onEndTimeTap() async {
      TimeOfDay? new_ =
          await changeTimeOfDay(_newTimeOfDayEnd!, _endTimeController);
      if (new_ != null) {
        _newTimeOfDayEnd = new_;
        if (DateTimeUtil.compareTimeOfDays(
                _newTimeOfDayStart!, _newTimeOfDayEnd!) >
            -1) {
          DateTime d = DateTime.now();
          DateTime tmpD = DateTime(d.year, d.month, d.day,
              _newTimeOfDayEnd!.hour, _newTimeOfDayEnd!.minute);
          DateTime newD = tmpD.add(Duration(minutes: -kEndTimeIntervalMin));
          _newTimeOfDayStart = TimeOfDay(hour: newD.hour, minute: newD.minute);
          _startTimeController.text =
              DateTimeUtil.toHHMMWithTimeOfDay(_newTimeOfDayStart!);
        }
        changeDateToNextDay();
      }
    }

    onRemindTap() async {
      List<String> l = [];
      for (int i = 0; i < kRemindEarlyMin.length; i++) {
        l.add(getRemindString(i));
      }
      int? result = await showBottomSheet(l, context);
      if (result != null) {
        _remindMinPos = result;
        _remindController.text = getRemindString(_remindMinPos);
      }
    }

    onRepeatTap() async {
      int? result = await showBottomSheet(kRepeatStringList, context);
      if (result != null) {
        _repeatPos = result;
        _repeatController.text = getRepeatString(_repeatPos);
      }
    }

    onColorItemSelected(int index, ColorPickerRow colorPicker) {
      _colorSelectedPos = index;
    }

    ColorPickerRow colorPicker = ColorPickerRow(
      listener: onColorItemSelected,
      size: 30,
      colorList: kColorList,
    );

    /// check
    void checkAllDataAreNoProblem() {
      String title = _titleController.text.trim();
      String note = _noteController.text.trim();
      if (title.isEmpty) {
        _titleFocusNode.requestFocus();
        ToastUtil.toast(AddTaskPage.kTitleStringEmptyHint);
        return;
      }
      if (note.isEmpty) {
        _noteFocusNode.requestFocus();
        ToastUtil.toast(AddTaskPage.kNoteStringEmptyHint);
        return;
      }
      DateTime date = _newDateTimeYearAndMonth!;
      TimeOfDay startTime = _newTimeOfDayStart!;
      TimeOfDay endTime = _newTimeOfDayEnd!;
      int remindMinPos = _remindMinPos;
      int repeatPos = _repeatPos;
      int colorPos = _colorSelectedPos;

      addTask(title, note, date, startTime, endTime, remindMinPos, repeatPos,
          colorPos);
    }

    return Scaffold(
      appBar: MyAppBar(
        showRightIcon: true,
        leadingIconData: Icons.arrow_back_ios_new_sharp,
        onLeadingIconPress: () {
          Get.back();
        },
      ),
      body: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).padding.left,
            right: MediaQuery.of(context).padding.right,
            bottom: MediaQuery.of(context).padding.bottom),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  "Add Task",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      TitleView(
                        focusNode: _titleFocusNode,
                        title: "Title",
                        hintText: "Enter title here.",
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                      ),
                      TitleView(
                        focusNode: _noteFocusNode,
                        title: "Note",
                        hintText: "Enter note here.",
                        controller: _noteController,
                        textInputAction: TextInputAction.done,
                      ),
                      TitleView.pickerView(
                        "Date",
                        iconRight: Icons.calendar_month_outlined,
                        controller: _dateController,
                        enableInteractiveSelection: false,
                        onTextFieldTap: onDateTap,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TitleView.pickerView(
                            "Start Time",
                            iconRight: Icons.access_time,
                            controller: _startTimeController,
                            enableInteractiveSelection: false,
                            onTextFieldTap: onStartTimeTap,
                          )),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: TitleView.pickerView(
                            "End Time",
                            iconRight: Icons.access_time,
                            controller: _endTimeController,
                            enableInteractiveSelection: false,
                            onTextFieldTap: onEndTimeTap,
                          )),
                        ],
                      ),
                      TitleView.pickerView(
                        "Remind",
                        iconRight: Icons.keyboard_arrow_down,
                        controller: _remindController,
                        enableInteractiveSelection: false,
                        onTextFieldTap: onRemindTap,
                      ),
                      TitleView.pickerView(
                        "Repeat",
                        iconRight: Icons.keyboard_arrow_down,
                        controller: _repeatController,
                        enableInteractiveSelection: false,
                        onTextFieldTap: onRepeatTap,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TitleView.customView(
                              "Color",
                              child: colorPicker,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              checkAllDataAreNoProblem();
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  context.theme.primaryColor),
                              shape:
                                  WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: 96,
                              height: 48,
                              child: Text(
                                "Create Task",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
