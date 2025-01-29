import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends AppBar {
  IconData leadingIconData;

  VoidCallback? onLeadingIconPress;

  VoidCallback? onRightIconPress;

  bool showRightIcon;

  MyAppBar({
    super.key,
    this.leadingIconData = Icons.dark_mode_outlined,
    this.onLeadingIconPress,
    this.onRightIconPress,
    this.showRightIcon = true,
  });

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    const radius1 = Radius.circular(28);
    const borderRadius1 = BorderRadius.only(
      topLeft: radius1,
      topRight: radius1,
      bottomLeft: radius1,
      bottomRight: radius1,
    );

    return AppBar(
      forceMaterialTransparency: true,
      title: Container(),
      leading: InkWell(
          onTap: () {
            if (widget.onLeadingIconPress != null) {
              widget.onLeadingIconPress!();
            }
          },
          borderRadius: borderRadius1,
          child: Icon(
            size: 28,
            widget.leadingIconData,
            color: context.theme.primaryColor,
          )),
      elevation: 0,
      actions: widget.showRightIcon
          ? [
              SizedBox(
                width: 56,
                height: 56,
                child: InkWell(
                  borderRadius: borderRadius1,
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        size: 36,
                        Icons.account_circle,
                        color: context.theme.primaryColor,
                      )),
                  onTap: () {
                    if (widget.onRightIconPress != null) {
                      widget.onRightIconPress!();
                    }
                  },
                ),
              )
            ]
          : [],
    );
  }
}
