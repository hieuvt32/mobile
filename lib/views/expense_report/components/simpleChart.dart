/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<TimeSeriesData> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {required this.animate});

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    List<charts.Series<TimeSeriesData, DateTime>> data = [
      new charts.Series<TimeSeriesData, DateTime>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesData sales, _) => sales.time,
          measureFn: (TimeSeriesData sales, _) => sales.amount,
          data: seriesList),
    ];

    return new charts.TimeSeriesChart(
      data,
      animate: true,
      domainAxis: new charts.DateTimeAxisSpec(
          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
              day: new charts.TimeFormatterSpec(
                  format: 'd', transitionFormat: 'MM/dd'))),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}

/// Sample time series data type.
class TimeSeriesData {
  final DateTime time;
  final double amount;

  TimeSeriesData(this.time, this.amount);
}
