import 'package:flutter/material.dart';

typedef OnColorPickerItemPressedListener = void Function(
    int index, ColorPickerRow picker);

class ColorPickerRow extends StatelessWidget {
  final List<Color> colorList;

  final double size;

  final EdgeInsets? colorItemMargin;

  final OnColorPickerItemPressedListener? listener;

  const ColorPickerRow({
    super.key,
    required this.colorList,
    this.size = 24,
    this.colorItemMargin = const EdgeInsets.all(4),
    this.listener,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> selectedPosNotifier = ValueNotifier<int>(0);

    int count = colorList.length;
    double itemHeight = size + colorItemMargin!.top + colorItemMargin!.bottom;
    double itemWidth = size + colorItemMargin!.left + colorItemMargin!.right;

    return SizedBox(
      width: itemWidth * count,
      height: itemHeight,
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          scrollDirection: Axis.horizontal,
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (listener != null) {
                  listener!(index, this);
                }
                selectedPosNotifier.value = index;
              },
              child: Container(
                width: itemWidth,
                height: itemHeight,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      margin: colorItemMargin,
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                          color: colorList[index],
                          borderRadius: BorderRadius.circular(size / 2.0)),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: selectedPosNotifier,
                      builder: (context, value, child) {
                        return Center(
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: index == value
                                ? Icon(
                                    Icons.check,
                                    size: size / 1.8,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
