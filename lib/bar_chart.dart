import 'dart:math';

import 'package:flutter/material.dart';

import 'bar.dart';

class BarChart {
  static const int barCount = 5;

  final List<Bar> bars;

  BarChart(this.bars) {
    assert(bars.length == barCount);
  }

  factory BarChart.empty() {
    return BarChart(List.filled(barCount, Bar(0.0, Colors.transparent)));
  }

  factory BarChart.random() {
    return BarChart(List.generate(
        barCount, (i) => Bar(Random().nextDouble() * 100.0, ColorPalette.random())));
  }

  static BarChart lerp(BarChart begin, BarChart end, double t) {
    return BarChart(List.generate(
      barCount,
      (i) => Bar.lerp(begin.bars[i], end.bars[i], t),
    ));
  }
}

class BarChartTween extends Tween<BarChart> {
  BarChartTween(BarChart begin, BarChart end) : super(begin: begin, end: end);

  @override
  BarChart lerp(double t) => BarChart.lerp(begin, end, t);
}

class ColorPalette {
  static List<Color> colors = [Colors.red, Colors.blue, Colors.green];

  static Color random() {
    var index = Random().nextInt(3);
    return colors[index];
  }
}
