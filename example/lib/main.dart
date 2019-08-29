import 'dart:math';

import 'package:flutter_animations/carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations/animated_single_chart.dart';

void main() => runApp(HomePage());

const lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sed risus non nibh interdum molestie. Quisque et enim eget magna condimentum cursus id at nunc.";

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: SampleAnimatedSingleChart(),
      )),
    );
  }
}

class SampleCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.grey[400],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Carousel(
            children: List.generate(5, (i) => _createSamplePriceTag())),
      ),
    );
  }

  Widget _createSamplePriceTag() {
    var random = Random();
    final dollars = random.nextInt(100).toString();
    final cents = random.nextDouble().toStringAsFixed(2).substring(2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$dollars.$cents",
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        Text(lorem)
      ],
    );
  }
}

class SampleAnimatedSingleChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AnimatedSingleChart(
          values: _getValues(),
          strokeColor: Colors.orange,
          gradientColor: Colors.orange,
        ),
      ),
    );
  }

  List<Chartable> _getValues() {
    var random = Random();
    var numPoints = random.nextInt(4) + 4;
    return List.generate(numPoints, (i) {
      var r = random.nextDouble();
      return SampleChartPoint(50 * r);
    });
  }
}

class SampleChartPoint extends Chartable {
  final double value;

  SampleChartPoint(this.value);

  @override
  double getValue() => value;

  @override
  String getTitle() => value.toString();
}
