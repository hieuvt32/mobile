/// Forward hatch pattern bar chart example.
///
/// The second series of bars is rendered with a pattern by defining a
/// fillPatternFn mapping function.
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PatternForwardHatchBarChart extends StatelessWidget {
  final List<IncomingAndSpending> listNoNCC;
  final List<IncomingAndSpending> listKHNo;
  final List<IncomingAndSpending> listIncoming;
  final List<IncomingAndSpending> listSpending;

  const PatternForwardHatchBarChart(
      {Key? key,
      required this.listNoNCC,
      required this.listKHNo,
      required this.listIncoming,
      required this.listSpending})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createData(),
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      vertical: false,
    );
  }

  /// Create series list with multiple series
  List<charts.Series<IncomingAndSpending, String>> _createData() {
    return [
      new charts.Series<IncomingAndSpending, String>(
          id: 'Incoming',
          domainFn: (IncomingAndSpending report, _) => report.date,
          measureFn: (IncomingAndSpending report, _) => report.value,
          data: listIncoming,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault),
      new charts.Series<IncomingAndSpending, String>(
        id: 'Spending',
        domainFn: (IncomingAndSpending report, _) => report.date,
        measureFn: (IncomingAndSpending report, _) => report.value,
        data: listSpending,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      new charts.Series<IncomingAndSpending, String>(
          id: 'NoNhaCungCap',
          domainFn: (IncomingAndSpending report, _) => report.date,
          measureFn: (IncomingAndSpending report, _) => report.value,
          data: listNoNCC,
          colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault),
      new charts.Series<IncomingAndSpending, String>(
        id: 'KHNo',
        domainFn: (IncomingAndSpending report, _) => report.date,
        measureFn: (IncomingAndSpending report, _) => report.value,
        data: listKHNo,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      ),
    ];
  }
}

/// Sample ordinal data type.
class IncomingAndSpending {
  final String date;
  final double value;

  IncomingAndSpending(this.date, this.value);
}
