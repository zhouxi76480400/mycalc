import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String title;

  final String? hintText, text;

  final EdgeInsetsGeometry? margin;

  final IconData? iconRight;

  final bool noBorderLine;

  final bool enableInteractiveSelection;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final TextInputAction? textInputAction;

  final GestureTapCallback? onTextFieldTap;

  final bool pickerMode;

  final bool customMode;

  final Widget? child;

  const TitleView({
    super.key,
    required this.title,
    this.margin = const EdgeInsets.only(top: 14),
    this.noBorderLine = false,
    this.hintText = "",
    this.text = "",
    this.controller,
    this.enableInteractiveSelection = true,
    this.focusNode,
    this.textInputAction,
    this.onTextFieldTap,
    this.iconRight,
    this.child,
    this.pickerMode = false,
    this.customMode = false,
  });

  const TitleView.pickerView(
    this.title, {
    this.margin = const EdgeInsets.only(top: 14),
    super.key,
    this.noBorderLine = false,
    this.hintText = "",
    this.iconRight = Icons.more_horiz,
    this.text = "",
    this.controller,
    this.enableInteractiveSelection = true,
    this.focusNode,
    this.textInputAction,
    this.onTextFieldTap,
    this.child,
    this.pickerMode = true,
    this.customMode = false,
  });

  const TitleView.customView(
    this.title, {
    super.key,
    this.child,
    this.margin = const EdgeInsets.only(top: 14),
    this.hintText = "",
    this.text,
    this.noBorderLine = true,
    this.iconRight,
    this.enableInteractiveSelection = false,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onTextFieldTap,
    this.pickerMode = false,
    this.customMode = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isPickerMode = pickerMode;
    bool isCustomMode = customMode;

    Widget? mainWidget;

    BoxDecoration? borderLineDecoration;

    if (isCustomMode) {
      mainWidget = child;
    } else {
      Color colorBlackLight = Colors.black26;

      borderLineDecoration = noBorderLine
          ? null
          : BoxDecoration(
              border: Border.all(color: colorBlackLight),
              borderRadius: BorderRadius.circular(12),
            );

      InputDecoration inputDecoration = InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: colorBlackLight,
          ));

      Widget? textField = Container(
        margin: EdgeInsets.only(bottom: 8), //看起來不太對
        child: TextField(
          decoration: inputDecoration,
          readOnly: isPickerMode,
          controller: controller,
          enableInteractiveSelection: enableInteractiveSelection,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onTap: onTextFieldTap,
        ),
      );

      Widget? row;

      if (isPickerMode) {
        row = InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            if (onTextFieldTap != null) {
              onTextFieldTap!();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: textField,
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Icon(
                  size: 24,
                  iconRight,
                  color: colorBlackLight,
                ),
              )
            ],
          ),
        );
      }

      mainWidget = isPickerMode ? row! : textField;
    }

    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Container(
            padding: customMode ? null : EdgeInsets.only(left: 12, right: 12),
            margin: EdgeInsets.only(
              top: 4,
            ),
            decoration: borderLineDecoration,
            height: customMode ? null : 48,
            child: mainWidget,
          )
        ],
      ),
    );
  }
}
