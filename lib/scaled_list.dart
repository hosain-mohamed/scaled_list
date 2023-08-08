library scaled_list;

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

/// A Horizontal List view With Lots of modification including the a scaled current
/// item , curved custom painting and a dots indictor below it.
/// it makes the widget of item builder responsive to the device screen's width and height
/// You can also set the  relative width , margin width , height of selected and unselected Card to the entire screen
class ScaledList extends StatefulWidget {
  const ScaledList({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    required this.itemColor,
    this.showDots = true,
    this.cardWidthRatio = 0.6,
    this.marginWidthRatio = 0.1,
    this.selectedCardHeightRatio = 0.4,
    this.unSelectedCardHeightRatio = 0.3,
  })  : assert(cardWidthRatio + marginWidthRatio >= 0.5,
            " Card width + margin width should exceed 0.5 of the screen"),
        assert(selectedCardHeightRatio > unSelectedCardHeightRatio,
            " selectedCardHeight should alwayes excceed the unSelectedCardHeight to show desire effect");

  /// return a widget to build and give you the index of that widget and the selected Index
  /// which appear currently on the screen
  final Widget Function(int index, int selectedIndex) itemBuilder;

  /// the count of your items
  final int itemCount;

  /// the background color for each item

  final Color Function(int index) itemColor;

  /// Weather to show the dots indicator or not

  final bool showDots;

  /// the card width relative to the device screen width or the parent width
  /// the default value is 0.6
  final double cardWidthRatio;

  /// the margin width between cards relative to the device screen width or the parent width
  /// the default value is 0.1
  final double marginWidthRatio;

  /// the selected card height relative to the device screen width or the parent width
  /// the default value is 0.4
  final double selectedCardHeightRatio;

  /// the unSelected card height relative to the device screen width or the parent width
  /// the default value is 0.3
  final double unSelectedCardHeightRatio;

  @override
  _ScaledListState createState() => _ScaledListState();
}

class _ScaledListState extends State<ScaledList> {
  ScrollController? _scrollController;
  int _selectedIndex = 0;

  late double parentWidth;
  double? parentHeight;

  @override
  void initState() {
    _scrollController = ScrollController();
    final double fullCardWidth =
        widget.cardWidthRatio + widget.marginWidthRatio;
    _scrollController!.addListener(() {
      final double offset = _scrollController!.offset;
      double deltaReverse =
          (((_selectedIndex + 2) * fullCardWidth) - 1) * parentWidth;

      double deltaForward =
          (((_selectedIndex - 1) * (fullCardWidth)) + widget.marginWidthRatio) *
              parentWidth;

      if (offset > deltaReverse &&
          _scrollController!.position.userScrollDirection ==
              ScrollDirection.reverse) {
        setState(() {
          _selectedIndex += 1;
        });
      }
      if (offset < deltaForward &&
          _scrollController!.position.userScrollDirection ==
              ScrollDirection.forward) {
        setState(() {
          _selectedIndex -= 1;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        parentWidth = constraints.maxWidth;
        parentHeight = constraints.maxHeight;
        if (parentHeight == double.infinity) {
          final mediaQuery = MediaQuery.of(context);
          parentHeight = mediaQuery.size.height;
        }
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: parentHeight! * 0.45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.itemCount,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        if (index == 0) ...[
                          SizedBox(
                              width: parentWidth * widget.marginWidthRatio),
                        ],
                        Stack(
                          children: [
                            Container(
                              width: parentWidth * widget.cardWidthRatio,
                              height: _selectedIndex == index
                                  ? widget.selectedCardHeightRatio *
                                      parentHeight!
                                  : widget.unSelectedCardHeightRatio *
                                      parentHeight!,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(0, 7),
                                    color: widget
                                        .itemColor(index)
                                        .withOpacity(0.7),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: widget.itemColor(index),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                bottom: 0,
                                top: 0,
                                child: CustomPaint(
                                  size: Size(
                                    parentWidth * widget.cardWidthRatio,
                                    _selectedIndex == index
                                        ? widget.selectedCardHeightRatio *
                                            parentHeight!
                                        : widget.unSelectedCardHeightRatio *
                                            parentHeight!,
                                  ),
                                  painter: CustomCardPainter(
                                      radius: 20,
                                      startColor: widget.itemColor(index),
                                      endColor: widget.itemColor(index)),
                                )),
                            Positioned.fill(
                                child:
                                    widget.itemBuilder(index, _selectedIndex))
                          ],
                        ),
                        SizedBox(width: parentWidth * widget.marginWidthRatio)
                      ],
                    );
                  },
                ),
              ),
              if (widget.showDots) ...[
                SizedBox(height: parentHeight! * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      widget.itemCount, (index) => buildDot(index)),
                ),
              ]
            ],
          ),
        );
      }),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: parentHeight! * 0.01,
      margin: EdgeInsets.all(parentWidth * 0.01),
      width: _selectedIndex == index ? parentWidth * 0.05 : parentWidth * 0.015,
      decoration: BoxDecoration(
          color: index == _selectedIndex
              ? widget.itemColor(index)
              : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(3)),
    );
  }
}

// Custom Card Painter to draw a curved Paint on the card
class CustomCardPainter extends CustomPainter {
  final Color startColor, endColor;
  final double radius;

  CustomCardPainter({
    required this.startColor,
    required this.endColor,
    required this.radius,
  });
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, radius, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}