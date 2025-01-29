import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageDayListItem extends StatefulWidget {
  bool isSelected = false;

  HomePageDayListItem({super.key, this.isSelected = false});

  @override
  State<HomePageDayListItem> createState() => _HomePageDayListItemState();
}

class _HomePageDayListItemState extends State<HomePageDayListItem> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        widget.isSelected ? context.theme.primaryColor : Colors.transparent;
    Color textColor = widget.isSelected ? Colors.white : Colors.black45;

    return Container(
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color:
            widget.isSelected ? context.theme.primaryColor : Colors.transparent,
      ),
      width: 86,
      height: 80,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Jan",
              style: TextStyle(
                  color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
            ),
            Text("19",
                style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
            Text("SUN",
                style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
