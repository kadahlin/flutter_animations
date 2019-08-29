import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;

  Carousel(
      {@required this.children,
      this.duration = const Duration(milliseconds: 400)});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  int currentIndex;
  bool reversing = false;
  AnimationController _controller;
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
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(() {
      setState(() {});
    });

    _rightCenterAnimation =
        Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(_controller);
    _centerLeftAnimation =
        Tween(begin: Offset(0.0, 0.0), end: Offset(-1.0, 0.0))
            .animate(_controller);

    _leftCenterAnimation =
        Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(_controller);
    _centerRightAnimation =
        Tween(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0))
            .animate(_controller);

    _growScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _shrinkScaleAnimation = Tween(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onUserSwipe,
      child: AnimatedBuilder(
          animation: _controller,
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
    if (details.primaryVelocity > 0 && currentIndex != 0) {
      //left to right (reverse)
      reversing = true;
      _controller.forward().whenComplete(() {
        setState(() {
          _controller.reset();
          currentIndex -= 1;
        });
      });
    } else if (details.primaryVelocity < 0 &&
        currentIndex != widget.children.length - 1) {
      //right to left
      reversing = false;
      _controller.forward().whenComplete(() {
        setState(() {
          _controller.reset();
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
