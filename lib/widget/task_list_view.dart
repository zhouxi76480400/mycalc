import 'dart:math';

import 'package:flutter/material.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({
    super.key,
    this.margin = EdgeInsets.zero,
    this.color = Colors.transparent,
    this.isCompleted = false,
    this.title = "Title",
    this.note = "Note",
    this.timeInterval = "",
    this.onTap,
  });

  final GestureTapCallback? onTap;

  final Color color;

  final bool isCompleted;

  final String title, note, timeInterval;

  final EdgeInsets margin;

  final double heightWidthRadio = 3 / 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth - margin.left - margin.right;
        return Container(
          width: width,
          margin: margin,
          child: Material(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: color,
              clipBehavior: Clip.hardEdge,
              elevation: 8,
              child: InkWell(
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          right: 50 + 16, top: 16, left: 16, bottom: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  timeInterval,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            note,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -20,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 90,
                        alignment: Alignment.center,
                        child: OverflowBox(
                          child: IntrinsicWidth(
                            child: IntrinsicHeight(
                              child: Transform.rotate(
                                angle: 270 * pi / 180, // 顺时针旋转 30 度
                                child: Text(
                                  isCompleted ? 'COMPLETED' : 'TODO',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        right: 49.5,
                        child: Container(
                          width: 1,
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          color: Colors.white.withAlpha(90),
                        ))
                  ],
                ),
              )),
        );
      },
    );
  }
}
