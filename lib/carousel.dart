import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> children;

  Carousel({@required this.children});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  int currentIndex;
  bool reversing = false;
  AnimationController controller;
  Animation<Offset> _rightCenterAnimation;
  Animation<Offset> _centerLeftAnimation;
  Animation<Offset> _leftCenterAnimation;
  Animation<Offset> _centerRightAnimation;
  Animation<double> _growScaleAnimation;
  Animation<double> _shrinkScaleAnimation;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    controller.addListener(() {
      setState(() {});
    });

    _rightCenterAnimation =
        Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(controller);
    _centerLeftAnimation =
        Tween(begin: Offset(0.0, 0.0), end: Offset(-1.0, 0.0))
            .animate(controller);

    _leftCenterAnimation =
        Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(controller);
    _centerRightAnimation =
        Tween(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0))
            .animate(controller);

    _growScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);
    _shrinkScaleAnimation = Tween(begin: 1.0, end: 0.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    print('on build the current index is $currentIndex');
    return GestureDetector(
      onHorizontalDragEnd: _onUserSwipe,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            var children = <Widget>[];

            widget.children.asMap().forEach((index, child) {
              var scale = _getScaleOffset(index);
              var transform = _getTranslateOffset(index);

              children.add(FractionalTranslation(
                translation: transform,
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              ));
            });
            return Stack(overflow: Overflow.visible, children: children);
          }),
    );
  }

  void _onUserSwipe(DragEndDetails details) {
    print('the user has done a horizontal drag end');
    if (details.primaryVelocity > 0 && currentIndex != 0) {
      //left to right (reverse)
      reversing = true;
      controller.forward().whenComplete(() {
        setState(() {
          controller.reset();
          currentIndex -= 1;
        });
      });
    } else if (details.primaryVelocity < 0 && currentIndex != widget.children.length - 1) {
      //right to left
      reversing = false;
      controller.forward().whenComplete(() {
        setState(() {
          controller.reset();
          currentIndex += 1;
        });
      });
    }
  }

  double _getScaleOffset(int index) {
    var otherIndex = currentIndex + (reversing ? -1 : 1);

    if (index == currentIndex) {
      return _shrinkScaleAnimation.value;
    } else if (index == otherIndex) {
      return _growScaleAnimation.value;
    } else {
      return 0.0;
    }
  }

  Offset _getTranslateOffset(int index) {
    var otherIndex = currentIndex + (reversing ? -1 : 1);

    if (reversing) {
      if (index == currentIndex) {
        return _centerRightAnimation.value;
      } else if (index == otherIndex) {
        return _leftCenterAnimation.value;
      } else {
        return Offset(0.0, 0.0);
      }
    }

    if (index == currentIndex) {
      return _centerLeftAnimation.value;
    } else if (index == otherIndex) {
      return _rightCenterAnimation.value;
    } else {
      return Offset(0.0, 0.0);
    }
  }
}
