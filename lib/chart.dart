import 'dart:math';
import 'dart:ui';

import 'package:charts/bar.dart';
import 'package:charts/bar_chart.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage>
    with SingleTickerProviderStateMixin {
  final random = Random();
  AnimationController controller;
  BarChartTween tween;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);

    tween = BarChartTween(BarChart.empty(), BarChart.random());
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {
      var realChart = BarChart([
        Bar(10.0, Colors.yellow),
        Bar(30.0, Colors.yellow),
        Bar(50.0, Colors.green),
        Bar(70.0, Colors.blue),
        Bar(90.0, Colors.red),
      ]);
      tween = BarChartTween(tween.evaluate(controller), realChart);
      controller.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(200.0, 100.0),
          painter: BarChartPainter(tween.animate(controller)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: changeData,
      ),
    );
  }
}
