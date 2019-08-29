import 'package:flutter/material.dart';

class AnimatedSingleChart<T extends Chartable> extends StatefulWidget {
  final List<T> values;
  final Color strokeColor;
  final Color gradientColor;

  AnimatedSingleChart(
      {@required this.values,
      @required this.strokeColor,
      @required this.gradientColor});

  @override
  _AnimatedSingleChartState createState() => _AnimatedSingleChartState();
}

abstract class Chartable {
  double getValue();

  String getTitle();
}

class _AnimatedSingleChartState extends State<AnimatedSingleChart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() {
            setState(() {});
          })
          ..forward();
    // ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ClipRect(
        clipper: _Clipper(_controller.value),
        child: CustomPaint(
          foregroundPainter: _AnimatedSingleChartPainter(widget.values,
              _controller.value, widget.strokeColor, widget.gradientColor),
        ),
      ),
    );
  }
}

class _AnimatedSingleChartPainter<T extends Chartable> extends CustomPainter {
  double animationValue = 0.0;
  final List<T> values;
  final Color strokeColor;
  final Color gradientColor;
  Paint circlePaint;
  var max = 0.0;

  _AnimatedSingleChartPainter(
      this.values, this.animationValue, this.strokeColor, this.gradientColor) {
    values.forEach((value) {
      if (value.getValue() > max) {
        max = value.getValue();
      }
    });
    circlePaint = Paint()..color = Colors.black;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final adjustedHeight = (size.height - 20);
    var ratio = 0.0;
    if (max != 0.0) {
      ratio = adjustedHeight / max;
    }

    var spaceBetween = (size.width - 20) / (values.length - 1);
    var strokePath = Path();
    for (var i = 0; i < values.length; i++) {
      var startX = i * spaceBetween;
      if (i == 0) {
        startX += 10;
      }

      var current =
          Offset(startX, (adjustedHeight - values[i].getValue() * ratio) + 10);
      if (i == 0) {
        strokePath.moveTo(current.dx, current.dy);
      } else {
        strokePath.lineTo(current.dx, current.dy);
      }
    }

    var gradientPath = Path.from(strokePath);

    gradientPath.lineTo((values.length - 1) * spaceBetween, size.height);
    gradientPath.lineTo(10, size.height);
    gradientPath.close();

    final Gradient gradient = LinearGradient(
      begin: Alignment(0.5, -1.0),
      end: Alignment(0.5, 1.0),
      colors: [gradientColor, gradientColor.withOpacity(0.0)],
    );

    Paint line = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0
      ..shader =
          gradient.createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(gradientPath, line);

    line
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..shader = null;
    canvas.drawPath(strokePath, line);

    for (var i = 0; i < values.length; i++) {
      var startX = i * spaceBetween;
      if (i == 0) {
        startX += 10;
      }
      var current =
          Offset(startX, (adjustedHeight - values[i].getValue() * ratio) + 10);
      if (animationValue == 1 ||
          animationValue * size.width > current.dx + 20) {
        canvas.drawCircle(current, 6, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _Clipper extends CustomClipper<Rect> {
  double portion;

  _Clipper(this.portion);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width * portion, size.height);
  }

  @override
  bool shouldReclip(_Clipper old) {
    return portion != old.portion;
  }
}
